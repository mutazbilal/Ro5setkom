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
            // Position before un-hiding so getBoundingClientRect is accurate
            positionPanel();
            panel.hidden = false;
            btn.setAttribute('aria-expanded', 'true');
        }
        function positionPanel() {
            var btnRect = btn.getBoundingClientRect();
            var panelWidth = 340;
            var gap = 12; // px gap between trigger and panel edge

            // Align panel top with the trigger's top
            var top = btnRect.top;

            // Place panel to the right of the sidebar trigger by default,
            // fall back to left if it would overflow the viewport
            var leftOfBtn = btnRect.left - panelWidth - gap;
            var rightOfBtn = btnRect.right + gap;

            var left;
            if (rightOfBtn + panelWidth <= window.innerWidth - 8) {
                left = rightOfBtn;               // open to the right
            } else if (leftOfBtn >= 8) {
                left = leftOfBtn;                // open to the left
            } else {
                // Last resort: centre under the button
                left = Math.max(8, btnRect.left + btnRect.width / 2 - panelWidth / 2);
            }

            // Clamp vertically so it never goes below the viewport
            var maxTop = window.innerHeight - 420 - 8;
            if (top > maxTop) top = maxTop;
            if (top < 8) top = 8;

            panel.style.top = top + 'px';
            panel.style.left = left + 'px';
            // Clear any inline inset-* that CSS might have set
            panel.style.insetInlineEnd = 'auto';
            panel.style.insetInlineStart = 'auto';
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
