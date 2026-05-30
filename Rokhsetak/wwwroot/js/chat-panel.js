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
        urlUnread: root.dataset.urlUnread,
        urlNewThread: root.dataset.urlNewthread,
        urlCreate: root.dataset.urlCreate,
        urlUpdatePersona: root.dataset.urlUpdatepersona
    };
    const token = () => root.querySelector('input[name="__RequestVerificationToken"]')?.value ?? '';

    // Reads data-page-key from <body> — set this in your Razor layout per page.
    // e.g. <body data-page-key="dashboard"> or <body data-page-key="modules">
    const pageKey = () => document.body.dataset.pageKey ?? '';

    const drawer = document.getElementById('rkChatDrawer');
    const listEl = document.getElementById('rkChatList');
    const threadEl = document.getElementById('rkChatThread');
    const badge = document.getElementById('rkChatBadge');
    const tabs = Array.from(document.querySelectorAll('.rkchat-tab'));

    // Persona used when a chat is created straight from the "new chat" button.
    const DEFAULT_PERSONA = 'tutor';

    let activeProvider = tabs[0]?.dataset.provider ?? 'human';
    let activeThreadId = null;
    let lastMessageId = 0;
    let pollTimer = null;
    let unreadTimer = null;
    const POLL_MS = 4000;
    const UNREAD_MS = 20000;

    async function getPartial(url) {
        const r = await fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
    }
    function scrollBottom() { const m = document.getElementById('rkThreadMessages'); if (m) m.scrollTop = m.scrollHeight; }
    function highestId() {
        let max = 0;
        document.querySelectorAll('#rkThreadMessages .msg[data-id]').forEach(el => {
            const id = parseInt(el.dataset.id, 10); if (id > max) max = id;
        });
        return max;
    }
    function tabSupportsList(p) {
        return document.querySelector(`.rkchat-tab[data-provider="${p}"]`)?.dataset.threadList === 'true';
    }
    function showListPane() { drawer.classList.remove('rkchat--thread-open'); }
    function showThreadPane() { drawer.classList.add('rkchat--thread-open'); }

    function openDrawer() {
        drawer.classList.add('is-open'); drawer.setAttribute('aria-hidden', 'false'); switchTab(activeProvider);
    }
    function closeDrawer() {
        drawer.classList.remove('is-open'); drawer.setAttribute('aria-hidden', 'true'); stopPolling();
    }

    async function switchTab(provider) {
        activeProvider = provider;
        tabs.forEach(t => t.classList.toggle('is-active', t.dataset.provider === provider));
        showListPane(); stopPolling();
        listEl.innerHTML = '<div class="rkchat-loading">Loading…</div>';
        try {
            listEl.innerHTML = await getPartial(`${cfg.urlThreads}?provider=${provider}`);
            if (!tabSupportsList(provider)) {
                const first = listEl.querySelector('.rkchat-thread-item');
                if (first) openThread(provider, parseInt(first.dataset.threadId, 10));
            }
        } catch { listEl.innerHTML = '<div class="conv-empty"><p>Failed to load.</p></div>'; }
    }

    // shared post-render wiring for any thread partial
    function afterThreadRender(provider) {
        activeProvider = provider;
        activeThreadId = parseInt(threadEl.querySelector('#rkThreadMessages')?.dataset.threadId, 10) || activeThreadId;
        lastMessageId = highestId();
        bindCompose();
        bindThreadPersona();
        scrollBottom();
        refreshBadge();
        if (provider === 'human') startPolling();
    }

    async function openThread(provider, threadId) {
        showThreadPane(); stopPolling();
        threadEl.innerHTML = '<div class="rkchat-loading">Loading…</div>';
        try {
            threadEl.innerHTML = await getPartial(`${cfg.urlOpen}?provider=${provider}&id=${threadId}`);
            afterThreadRender(provider);
        } catch { threadEl.innerHTML = '<div class="chat-empty-state"><p>Failed to load conversation.</p></div>'; }
    }

    // Create a new thread immediately with the default persona, no form step.
    async function createDefaultThread(provider) {
        showThreadPane(); stopPolling();
        threadEl.innerHTML = '<div class="rkchat-loading">Loading…</div>';
        try {
            const resp = await fetch(cfg.urlCreate, {
                method: 'POST',
                headers: {
                    'RequestVerificationToken': token(),
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-Page-Key': pageKey()                 // ← added
                },
                body: new URLSearchParams({ provider, optionKey: DEFAULT_PERSONA })
            });
            if (!resp.ok) { const j = await resp.json().catch(() => ({})); alert(j.error ?? 'Failed to create chat.'); return; }
            threadEl.innerHTML = await resp.text();
            afterThreadRender(provider);
        } catch { threadEl.innerHTML = '<div class="chat-empty-state"><p>Failed to create chat.</p></div>'; }
    }

    function bindThreadPersona() {
        const wrap = threadEl.querySelector('.rkchat-persona');
        if (!wrap) return;
        const select = wrap.querySelector('[data-role="thread-persona"]');
        const customWrap = wrap.querySelector('[data-role="thread-custom"]');
        const applyBtn = wrap.querySelector('[data-action="apply-persona"]');
        const provider = wrap.dataset.provider, threadId = wrap.dataset.threadId;

        select?.addEventListener('change', async () => {
            if (select.value === 'custom') { if (customWrap) customWrap.style.display = ''; return; }
            if (customWrap) customWrap.style.display = 'none';
            await updatePersona(provider, threadId, select.value, null);
        });
        applyBtn?.addEventListener('click', async () => {
            const txt = wrap.querySelector('[data-role="thread-custom-text"]')?.value ?? '';
            await updatePersona(provider, threadId, 'custom', txt);
        });
    }

    async function updatePersona(provider, threadId, optionKey, customPrompt) {
        const body = new URLSearchParams({ provider, threadId, optionKey });
        if (customPrompt != null) body.append('customPrompt', customPrompt);
        try {
            const resp = await fetch(cfg.urlUpdatePersona, {
                method: 'POST',
                headers: { 'RequestVerificationToken': token(), 'X-Requested-With': 'XMLHttpRequest' },
                body
            });
            if (!resp.ok) { alert('Could not update personality.'); return; }
            threadEl.innerHTML = await resp.text();
            afterThreadRender(provider);
        } catch { alert('Network error.'); }
    }

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
                form.requestSubmit();
            }
        });
        fileInput?.addEventListener('change', () => {
            const f = fileInput.files[0]; if (!f) return;
            if (f.size > 10 * 1024 * 1024) { alert('Max 10 MB.'); fileInput.value = ''; return; }
            previewName.textContent = f.name; preview.style.display = 'flex';
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
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-Page-Key': pageKey()             // ← added
                    },
                    body: new FormData(form)
                });
                if (!resp.ok) { const j = await resp.json().catch(() => ({})); alert(j.error ?? 'Failed to send.'); return; }
                threadEl.innerHTML = await resp.text();
                afterThreadRender(form.dataset.provider);
            } catch { alert('Network error.'); }
            finally {
                sendBtn?.classList.remove('sending');
                if (sendBtn) sendBtn.disabled = false;
            }
        });
    }

    function startPolling() {
        stopPolling();
        if (!activeThreadId || document.hidden || activeProvider !== 'human') return;
        pollTimer = setInterval(async () => {
            try {
                const r = await fetch(`${cfg.urlPoll}?provider=${activeProvider}&threadId=${activeThreadId}&lastId=${lastMessageId}`,
                    { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
                if (!r.ok) return;
                const { hasNew, latestId } = await r.json();
                if (!hasNew) return;
                threadEl.innerHTML = await getPartial(`${cfg.urlOpen}?provider=${activeProvider}&id=${activeThreadId}`);
                lastMessageId = latestId;
                bindCompose(); bindThreadPersona(); scrollBottom(); refreshBadge();
            } catch { /* ignore */ }
        }, POLL_MS);
    }
    function stopPolling() { clearInterval(pollTimer); pollTimer = null; }

    async function refreshBadge() {
        try {
            const r = await fetch(cfg.urlUnread, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
            if (!r.ok) return;
            const { count } = await r.json();
            if (count > 0) { badge.textContent = count; badge.style.display = ''; } else { badge.style.display = 'none'; }
        } catch { /* ignore */ }
    }

    window.rkOpenImage = function (src) {
        const m = document.getElementById('rkImgModal');
        document.getElementById('rkImgModalSrc').src = src; m.style.display = 'flex';
    };
    document.getElementById('rkImgModal')?.addEventListener('click', function () { this.style.display = 'none'; });

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

    document.getElementById('rkChatLauncher').addEventListener('click', () =>
        drawer.classList.contains('is-open') ? closeDrawer() : openDrawer());
    document.getElementById('rkChatClose').addEventListener('click', closeDrawer);
    tabs.forEach(t => t.addEventListener('click', () => switchTab(t.dataset.provider)));

    listEl.addEventListener('click', e => {
        if (e.target.closest('.rkchat-newchat-btn')) { createDefaultThread(activeProvider); return; }
        const item = e.target.closest('.rkchat-thread-item');
        if (item) openThread(item.dataset.provider, parseInt(item.dataset.threadId, 10));
    });
    threadEl.addEventListener('click', e => {
        if (e.target.closest('[data-action="back"]')) { stopPolling(); showListPane(); switchTab(activeProvider); }
    });
    document.addEventListener('keydown', e => { if (e.key === 'Escape' && drawer.classList.contains('is-open')) closeDrawer(); });
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) { stopPolling(); clearInterval(unreadTimer); }
        else { if (drawer.classList.contains('is-open')) startPolling(); unreadTimer = setInterval(refreshBadge, UNREAD_MS); }
    });

    unreadTimer = setInterval(refreshBadge, UNREAD_MS);
})();