/* booking-shared.js
 * Lightweight progressive enhancement for the Booking views.
 *
 * Handles:
 *   1. <form data-confirm="message"> → window.confirm() before submit
 *      (replaces the inline onclick="return confirm(...)" pattern)
 *   2. <button data-alert-dismiss> inside an .alert → removes the alert
 */
(function () {
    'use strict';

    // 1. Confirm-before-submit
    document.addEventListener('submit', function (e) {
        var form = e.target;
        if (!form || !form.matches) return;
        if (form.matches('[data-confirm]')) {
            var message = form.getAttribute('data-confirm');
            if (message && !window.confirm(message)) {
                e.preventDefault();
            }
        }
    });

    // 2. Dismissible alerts
    document.addEventListener('click', function (e) {
        var btn = e.target.closest && e.target.closest('[data-alert-dismiss]');
        if (!btn) return;
        var alert = btn.closest('.alert');
        if (alert && alert.parentNode) {
            alert.parentNode.removeChild(alert);
        }
    });
})();
