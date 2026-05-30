/* chat-panel.js — embedded, provider-aware sliding chat panel. */
(function () {
    'use strict';

    const root = document.getElementById('rkChatPanel');
    if (!root) return;

    const cfg = {
        urlThreads: root.dataset.urlThreads,
        urlOpen: root.dataset.urlOpen,
        urlSend: root.dataset.urlSend,
        urlPoll: root.dataset.urlPoll,
        urlUnread: root.dataset.urlUnread
    };
    const token = () => root.querySelector('input[name="__RequestVerificationToken"]')?.value ?? '';

    const drawer = document.getElementById('rkChatDrawer');
    const listEl = document.getElementById('rkChatList');
    const threadEl = document.getElementById('rkChatThread');
    const badge = document.getElementById('rkChatBadge');
    const tabs = Array.from(document.querySelectorAll('.rkchat-tab'));

    let activeProvider = tabs[0]?.dataset.provider ?? 'human';
    let activeThreadId = null;
    let lastMessageId = 0;
    let pollTimer = null;
    let unreadTimer = null;
    const POLL_MS = 4000;
    const UNREAD_MS = 20000;

    /* ── helpers ── */
    async function getPartial(url) {
        const r = await fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
    }
    function scrollBottom() {
        const m = document.getElementById('rkThreadMessages');
        if (m) m.scrollTop = m.scrollHeight;
    }
    function highestId() {
        let max = 0;
        document.querySelectorAll('#rkThreadMessages .msg[data-id]').forEach(el => {
            const id = parseInt(el.dataset.id, 10);
            if (id > max) max = id;
        });
        return max;
    }
    function tabSupportsList(provider) {
        return document.querySelector(`.rkchat-tab[data-provider="${provider}"]`)?.dataset.threadList === 'true';
    }

    /* ── open/close drawer ── */
    function openDrawer() {
        drawer.classList.add('is-open');
        drawer.setAttribute('aria-hidden', 'false');
        switchTab(activeProvider);
    }
    function closeDrawer() {
        drawer.classList.remove('is-open');
        drawer.setAttribute('aria-hidden', 'true');
        stopPolling();
    }

    /* ── tabs / list ── */
    async function switchTab(provider) {
        activeProvider = provider;
        tabs.forEach(t => t.classList.toggle('is-active', t.dataset.provider === provider));
        showListPane();
        stopPolling();
        listEl.innerHTML = '<div class="rkchat-loading">Loading…</div>';
        try {
            listEl.innerHTML = await getPartial(`${cfg.urlThreads}?provider=${provider}`);
            if (!tabSupportsList(provider)) {
                const first = listEl.querySelector('.rkchat-thread-item');
                if (first) openThread(provider, parseInt(first.dataset.threadId, 10));
            }
        } catch {
            listEl.innerHTML = '<div class="conv-empty"><p>Failed to load.</p></div>';
        }
    }

    function showListPane() { drawer.classList.remove('rkchat--thread-open'); }
    function showThreadPane() { drawer.classList.add('rkchat--thread-open'); }

    /* ── open a thread ── */
    async function openThread(provider, threadId) {
        showThreadPane();
        stopPolling();
        threadEl.innerHTML = '<div class="rkchat-loading">Loading…</div>';
        try {
            threadEl.innerHTML = await getPartial(`${cfg.urlOpen}?provider=${provider}&id=${threadId}`);
            activeProvider = provider;
            activeThreadId = parseInt(threadEl.querySelector('#rkThreadMessages')?.dataset.threadId, 10) || threadId;
            lastMessageId = highestId();
            bindCompose();
            scrollBottom();
            refreshBadge();
            if (provider === 'human') startPolling();   // AI replies arrive in the send response
        } catch {
            threadEl.innerHTML = '<div class="chat-empty-state"><p>Failed to load conversation.</p></div>';
        }
    }

    /* ── compose ── */
    function bindCompose() {
        const form = document.getElementById('rkComposeForm');
        if (!form) return;
        const textarea = document.getElementById('rkComposeText');
        const fileInput = document.getElementById('rkFileInput');
        const preview = document.getElementById('rkFilePreview');
        const previewName = document.getElementById('rkFilePreviewName');
        const clearBtn = document.getElementById('rkClearFile');
        const sendBtn = form.querySelector('.compose-send-btn');

        textarea?.addEventListener('input', () => {
            textarea.style.height = 'auto';
            textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
        });
        textarea?.addEventListener('keydown', e => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                form.requestSubmit(); // triggers your existing submit handler
            }
        });
        fileInput?.addEventListener('change', () => {
            const f = fileInput.files[0];
            if (!f) return;
            if (f.size > 10 * 1024 * 1024) { alert('Max 10 MB.'); fileInput.value = ''; return; }
            previewName.textContent = f.name;
            preview.style.display = 'flex';
        });
        clearBtn?.addEventListener('click', () => { fileInput.value = ''; preview.style.display = 'none'; });

        form.addEventListener('submit', async e => {
            e.preventDefault();
            const text = textarea?.value.trim() ?? '';
            const hasFile = fileInput?.files?.length > 0;
            if (!text && !hasFile) return;

            stopPolling();
            sendBtn?.classList.add('sending');
            if (sendBtn) sendBtn.disabled = true;
            try {
                const resp = await fetch(cfg.urlSend, {
                    method: 'POST',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    body: new FormData(form)
                });
                if (!resp.ok) {
                    const j = await resp.json().catch(() => ({}));
                    alert(j.error ?? 'Failed to send.');
                    return;
                }
                threadEl.innerHTML = await resp.text();
                activeThreadId = parseInt(threadEl.querySelector('#rkThreadMessages')?.dataset.threadId, 10) || activeThreadId;
                lastMessageId = highestId();
                bindCompose();
                scrollBottom();
                refreshBadge();
            } catch {
                alert('Network error.');
            } finally {
                sendBtn?.classList.remove('sending');
                if (sendBtn) sendBtn.disabled = false;
                if (activeProvider === 'human') startPolling();
            }
        });
    }

    /* ── polling ── */
    function startPolling() {
        stopPolling();
        if (!activeThreadId || document.hidden) return;
        pollTimer = setInterval(async () => {
            try {
                const r = await fetch(`${cfg.urlPoll}?provider=${activeProvider}&threadId=${activeThreadId}&lastId=${lastMessageId}`,
                    { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
                if (!r.ok) return;
                const { hasNew, latestId } = await r.json();
                if (!hasNew) return;
                threadEl.innerHTML = await getPartial(`${cfg.urlOpen}?provider=${activeProvider}&id=${activeThreadId}`);
                lastMessageId = latestId;
                bindCompose();
                scrollBottom();
                refreshBadge();
            } catch { /* ignore */ }
        }, POLL_MS);
    }
    function stopPolling() { clearInterval(pollTimer); pollTimer = null; }

    /* ── unread badge ── */
    async function refreshBadge() {
        try {
            const r = await fetch(cfg.urlUnread, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
            if (!r.ok) return;
            const { count } = await r.json();
            if (count > 0) { badge.textContent = count; badge.style.display = ''; }
            else { badge.style.display = 'none'; }
        } catch { /* ignore */ }
    }

    /* ── image lightbox ── */
    window.rkOpenImage = function (src) {
        const m = document.getElementById('rkImgModal');
        document.getElementById('rkImgModalSrc').src = src;
        m.style.display = 'flex';
    };
    document.getElementById('rkImgModal')?.addEventListener('click', function () { this.style.display = 'none'; });

    /* ── public API for other pages (Browse Mentors) ── */
    window.RkChat = {
        open: openDrawer,
        openThread: (provider, id) => { openDrawer(); openThread(provider, id); },
        async startWithMentor(mentorId, url) {
            try {
                const resp = await fetch(url, {
                    method: 'POST',
                    headers: { 'RequestVerificationToken': token(), 'X-Requested-With': 'XMLHttpRequest' },
                    body: new URLSearchParams({ mentorId })
                });
                if (!resp.ok) { alert('Could not start conversation.'); return; }
                const { conversationId } = await resp.json();
                openDrawer();
                switchTab('human').then(() => openThread('human', conversationId));
            } catch { alert('Network error.'); }
        }
    };

    /* ── wiring ── */
    document.getElementById('rkChatLauncher').addEventListener('click', () =>
        drawer.classList.contains('is-open') ? closeDrawer() : openDrawer());
    document.getElementById('rkChatClose').addEventListener('click', closeDrawer);
    tabs.forEach(t => t.addEventListener('click', () => switchTab(t.dataset.provider)));
    listEl.addEventListener('click', e => {
        const item = e.target.closest('.rkchat-thread-item');
        if (item) openThread(item.dataset.provider, parseInt(item.dataset.threadId, 10));
    });
    threadEl.addEventListener('click', e => {
        if (e.target.closest('[data-action="back"]')) { stopPolling(); showListPane(); switchTab(activeProvider); }
    });
    document.addEventListener('keydown', e => { if (e.key === 'Escape' && drawer.classList.contains('is-open')) closeDrawer(); });
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) { stopPolling(); clearInterval(unreadTimer); }
        else { if (drawer.classList.contains('is-open') && activeProvider === 'human') startPolling(); unreadTimer = setInterval(refreshBadge, UNREAD_MS); }
    });

    unreadTimer = setInterval(refreshBadge, UNREAD_MS);
})();