/**
 * Rokhsetak — Notification panel
 * Handles: open/close toggle, outside-click + Escape dismiss,
 *          mark-as-read fetch, badge count decrement.
 * No dependencies. Runs once DOMContentLoaded fires.
 */
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {

        var wrapper = document.getElementById('rk-notif');
        if (!wrapper) return;

        var btn   = document.getElementById('rk-notif-btn');
        var panel = document.getElementById('rk-notif-panel');
        if (!btn || !panel) return;

        /* ---- Toggle open / close ---- */
        function openPanel() {
            panel.hidden = false;
            btn.setAttribute('aria-expanded', 'true');
            panel.focus && panel.focus();
        }

        function closePanel() {
            panel.hidden = true;
            btn.setAttribute('aria-expanded', 'false');
        }

        function isOpen() {
            return !panel.hidden;
        }

        btn.addEventListener('click', function (e) {
            e.stopPropagation();
            isOpen() ? closePanel() : openPanel();
        });

        /* ---- Close on outside click ---- */
        document.addEventListener('click', function (e) {
            if (isOpen() && !wrapper.contains(e.target)) {
                closePanel();
            }
        });

        /* ---- Close on Escape ---- */
        document.addEventListener('keydown', function (e) {
            if (isOpen() && (e.key === 'Escape' || e.key === 'Esc')) {
                closePanel();
                btn.focus();
            }
        });

        /* ---- Mark-as-read ---- */
        panel.addEventListener('click', function (e) {
            var markBtn = e.target.closest('[data-notification-id]');
            if (!markBtn) return;

            var id = markBtn.dataset.notificationId;

            fetch('/Notification/MarkAsRead', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + encodeURIComponent(id)
            })
            .then(function (res) {
                if (!res.ok) throw new Error('Failed');

                /* Remove the item visually without a full reload */
                var item = markBtn.closest('.notif__item');
                if (item) {
                    item.classList.remove('notif__item--unread');
                    item.classList.add('notif__item--read');
                    markBtn.remove();
                    var dot = item.querySelector('.notif__dot');
                    if (dot) dot.remove();
                }

                /* Decrement badge count */
                var badge = btn.querySelector('.notif__badge');
                if (badge) {
                    var count = parseInt(badge.textContent, 10);
                    if (isNaN(count) || count <= 1) {
                        badge.remove();
                        /* Also remove head count pill */
                        var headCount = panel.querySelector('.notif__head-count');
                        if (headCount) headCount.remove();
                    } else {
                        var next = count - 1;
                        badge.textContent = next > 9 ? '9+' : String(next);
                        var headCount = panel.querySelector('.notif__head-count');
                        if (headCount) headCount.textContent = String(next);
                    }
                }
            })
            .catch(function (err) {
                console.error('Notification mark-as-read error:', err);
            });
        });
    });
}());
