/**
 * chat.js — Rokhsetak in-app messaging (v2)
 *
 * Polling strategy (two-phase):
 *   Phase 1 — lightweight "check" every 4 s:
 *     GET /Area/Messaging/Poll?conversationId=X&lastId=Y
 *     → returns { hasNew: bool, latestId: int }
 *     → costs ~1 ms DB query, no rendering
 *
 *   Phase 2 — only if hasNew == true:
 *     AJAX-load the thread partial (replaces only #chatMain)
 *     → marks messages as read server-side
 *
 * Result: feels near-real-time (~4 s max delay),
 *         zero unnecessary HTML generation or data transfer.
 *         No page refresh. No need to close the chat pane.
 */

(function () {
    'use strict';

    /* ── State ───────────────────────────────────────────────────────────── */
    let activeConvId = null;
    let lastMessageId = 0;          // tracks highest known MessageId
    let pollTimer = null;
    const POLL_INTERVAL_MS = 4000;  // 4 seconds — fast enough to feel live

    /* ── DOM refs ────────────────────────────────────────────────────────── */
    const chatMain = document.getElementById('chatMain');
    const convList = document.getElementById('convList');
    const convSearch = document.getElementById('convSearch');

    // Detect which area we're in from the current URL path
    const area = window.location.pathname.split('/')[1] ?? '';   // "Mentor" | "Trainee"
    const pollBase = `/${area}/Messaging/Poll`;
    const openBase = `/${area}/Messaging/Open`;

    /* ── Bootstrap ───────────────────────────────────────────────────────── */
    document.addEventListener('DOMContentLoaded', () => {
        const thread = document.getElementById('threadMessages');
        if (thread) {
            activeConvId = parseInt(thread.dataset.convId, 10) || null;
            lastMessageId = readHighestMessageId();
            scrollToBottom();
            startPolling();
        }

        bindConvLinks();
        bindSearch();
        bindCompose();
    });

    /* ── Conversation switching ──────────────────────────────────────────── */
    function bindConvLinks() {
        if (!convList) return;
        convList.addEventListener('click', async (e) => {
            const link = e.target.closest('.conv-link');
            if (!link) return;
            e.preventDefault();

            const convId = parseInt(link.dataset.convId, 10);
            if (convId === activeConvId) return;

            await openConversation(convId, link);
        });
    }

    async function openConversation(convId, linkEl) {
        chatMain.classList.add('loading');
        stopPolling();

        document.querySelectorAll('.conv-item').forEach(li => li.classList.remove('active'));
        linkEl?.closest('.conv-item')?.classList.add('active');

        try {
            const html = await fetchPartial(`${openBase}/${convId}`);
            chatMain.innerHTML = html;
            activeConvId = convId;
            lastMessageId = readHighestMessageId();

            clearUnreadBadge(convId);
            bindCompose();
            scrollToBottom();
            startPolling();
        } catch (err) {
            chatMain.innerHTML =
                '<div class="chat-empty-state"><p>Failed to load conversation.</p></div>';
            console.error('Open conversation error:', err);
        } finally {
            chatMain.classList.remove('loading');
        }
    }

    /* ── Smart two-phase polling ─────────────────────────────────────────── */
    function startPolling() {
        stopPolling();
        if (!activeConvId) return;

        pollTimer = setInterval(checkForNewMessages, POLL_INTERVAL_MS);
    }

    function stopPolling() {
        clearInterval(pollTimer);
        pollTimer = null;
    }

    async function checkForNewMessages() {
        if (!activeConvId) return;

        try {
            // ── Phase 1: cheap check (no HTML, no rendering) ──────────────
            const resp = await fetch(
                `${pollBase}?conversationId=${activeConvId}&lastId=${lastMessageId}`,
                { headers: { 'X-Requested-With': 'XMLHttpRequest' } }
            );
            if (!resp.ok) return;

            const { hasNew, latestId } = await resp.json();

            if (!hasNew) return;  // nothing to do — skips Phase 2 entirely

            // ── Phase 2: load updated thread (only fires when needed) ─────
            const html = await fetchPartial(`${openBase}/${activeConvId}`);
            chatMain.innerHTML = html;
            lastMessageId = latestId;

            bindCompose();       // re-bind events on new DOM
            scrollToBottom();
            clearUnreadBadge(activeConvId);
            refreshSidebarLastMessage(activeConvId);
        } catch {
            // Silently ignore network errors during background polling
        }
    }

    /* ── Read the highest MessageId from rendered messages ──────────────── */
    function readHighestMessageId() {
        const msgs = document.querySelectorAll('.msg[data-id]');
        let max = 0;
        msgs.forEach(m => {
            const id = parseInt(m.dataset.id, 10);
            if (id > max) max = id;
        });
        return max;
    }

    /* ── Compose bar ─────────────────────────────────────────────────────── */
    function bindCompose() {
        const form = document.getElementById('composeForm');
        const textarea = document.getElementById('composeText');
        const fileInput = document.getElementById('fileInput');
        const filePreview = document.getElementById('filePreview');
        const filePreviewName = document.getElementById('filePreviewName');
        const clearFileBtn = document.getElementById('clearFile');
        const sendBtn = form?.querySelector('.compose-send-btn');

        if (!form) return;

        // Auto-grow textarea
        textarea?.addEventListener('input', () => {
            textarea.style.height = 'auto';
            textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
        });

        // Ctrl+Enter / Cmd+Enter sends
        textarea?.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                e.preventDefault();
                form.dispatchEvent(new Event('submit', { bubbles: true, cancelable: true }));
            }
        });

        // File selection → preview
        fileInput?.addEventListener('change', () => {
            const f = fileInput.files[0];
            if (!f) return;

            if (!isAllowedType(f)) {
                alert('Only PDF, PNG, JPG, JPEG, and WEBP files are allowed.');
                fileInput.value = '';
                return;
            }
            if (f.size > 10 * 1024 * 1024) {
                alert('File is too large. Maximum size is 10 MB.');
                fileInput.value = '';
                return;
            }
            filePreviewName.textContent = f.name;
            filePreview.style.display = 'flex';
        });

        // Clear file
        clearFileBtn?.addEventListener('click', () => {
            fileInput.value = '';
            filePreview.style.display = 'none';
        });

        // Submit → AJAX
        form.addEventListener('submit', async (e) => {
            e.preventDefault();

            const text = textarea?.value.trim() ?? '';
            const hasFile = fileInput?.files?.length > 0;
            if (!text && !hasFile) return;

            stopPolling();  // pause polling during send to avoid race
            sendBtn?.classList.add('sending');
            if (sendBtn) sendBtn.disabled = true;

            try {
                const resp = await fetch(form.action, {
                    method: 'POST',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    body: new FormData(form)
                });

                if (!resp.ok) {
                    const json = await resp.json().catch(() => ({}));
                    alert(json.error ?? 'Failed to send message.');
                    return;
                }

                const html = await resp.text();
                chatMain.innerHTML = html;
                activeConvId = parseInt(form.dataset.convId, 10) || activeConvId;
                lastMessageId = readHighestMessageId();

                refreshSidebarLastMessage(activeConvId, text || '📎 Attachment');
                bindCompose();
                scrollToBottom();
            } catch (err) {
                alert('Network error. Please check your connection.');
                console.error('Send error:', err);
            } finally {
                sendBtn?.classList.remove('sending');
                if (sendBtn) sendBtn.disabled = false;
                startPolling();  // resume polling
            }
        });
    }

    /* ── Sidebar helpers ─────────────────────────────────────────────────── */
    function clearUnreadBadge(convId) {
        const item = convList?.querySelector(`.conv-item[data-id="${convId}"]`);
        item?.querySelector('.badge-unread')?.remove();

        // Recalculate total-unread badge in sidebar header
        const total = Array.from(convList?.querySelectorAll('.badge-unread') ?? [])
            .reduce((sum, el) => sum + (parseInt(el.textContent, 10) || 0), 0);
        const totalBadge = document.querySelector('.badge-total');
        if (totalBadge) {
            if (total > 0) { totalBadge.textContent = total; }
            else { totalBadge.remove(); }
        }
    }

    function refreshSidebarLastMessage(convId, previewText) {
        if (!previewText) return;
        const item = convList?.querySelector(`.conv-item[data-id="${convId}"]`);
        const preview = item?.querySelector('.conv-preview');
        const time = item?.querySelector('.conv-time');
        if (preview) preview.textContent = previewText.length > 55 ? previewText.slice(0, 55) + '…' : previewText;
        if (time) time.textContent = formatTime(new Date());
        if (item) convList.prepend(item);  // float to top
    }

    /* ── Search ──────────────────────────────────────────────────────────── */
    function bindSearch() {
        if (!convSearch || !convList) return;
        convSearch.addEventListener('input', () => {
            const q = convSearch.value.trim().toLowerCase();
            convList.querySelectorAll('.conv-item').forEach(li => {
                li.style.display = (li.dataset.name ?? '').includes(q) ? '' : 'none';
            });
        });
    }

    /* ── Image lightbox ──────────────────────────────────────────────────── */
    window.openImageModal = function (src) {
        const modal = document.getElementById('imgModal');
        const img = document.getElementById('imgModalSrc');
        if (!modal || !img) return;
        img.src = src;
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    };

    window.closeImageModal = function () {
        const modal = document.getElementById('imgModal');
        if (modal) modal.style.display = 'none';
        document.body.style.overflow = '';
    };

    document.addEventListener('keydown', e => { if (e.key === 'Escape') window.closeImageModal(); });

    /* ── Utilities ───────────────────────────────────────────────────────── */
    function scrollToBottom() {
        const msgs = document.getElementById('threadMessages');
        if (msgs) msgs.scrollTop = msgs.scrollHeight;
    }

    async function fetchPartial(url) {
        const resp = await fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
        if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
        return resp.text();
    }

    function isAllowedType(file) {
        const allowed = ['application/pdf', 'image/png', 'image/jpeg', 'image/webp'];
        const allowedExt = ['pdf', 'png', 'jpg', 'jpeg', 'webp'];
        const ext = file.name.split('.').pop()?.toLowerCase();
        return allowed.includes(file.type) || allowedExt.includes(ext);
    }

    function formatTime(dt) {
        const now = new Date();
        if (dt.toDateString() === now.toDateString())
            return dt.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        if ((now - dt) / 86400000 < 7)
            return dt.toLocaleDateString([], { weekday: 'short' });
        return dt.toLocaleDateString([], { day: '2-digit', month: 'short' });
    }

})();
