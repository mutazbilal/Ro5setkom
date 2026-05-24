/* dashboard.js
 * Lightweight progressive enhancement for the Trainee Dashboard.
 *
 * Handles:
 *   1. Dismissible alerts — <button data-alert-dismiss> removes its closest .alert
 *      (replaces the Bootstrap data-bs-dismiss attribute, since the project
 *      forbids the Bootstrap JS bundle)
 *   2. Animated progress bars — the overall progress bar and each per-track
 *      progress bar start at 0% and tween to their target value once the page
 *      has rendered, so the user sees the fill animate in.
 */
(function () {
    'use strict';

    // ---------- 1. Alert dismissal ----------
    document.addEventListener('click', function (e) {
        var btn = e.target.closest && e.target.closest('[data-alert-dismiss]');
        if (!btn) return;
        var alert = btn.closest('.alert');
        if (alert && alert.parentNode) {
            alert.parentNode.removeChild(alert);
        }
    });

    // ---------- 2. Animated progress fills ----------
    // Two custom-property hooks are used in the markup:
    //   --progress-value   on .progress-card__bar-fill   (overall)
    //   --track-progress   on .track-card__progress-fill (per track)
    // We capture each element's target value, reset it to 0, then restore it on
    // the next animation frame so the existing CSS `transition: width` runs.
    function animateProgressFills() {
        var targets = [
            { sel: '.progress-card__bar-fill',   varName: '--progress-value' },
            { sel: '.track-card__progress-fill', varName: '--track-progress' }
        ];

        targets.forEach(function (t) {
            var els = document.querySelectorAll(t.sel);
            els.forEach(function (el) {
                var finalValue = el.style.getPropertyValue(t.varName).trim();
                if (!finalValue) return;
                el.style.setProperty(t.varName, '0%');
                // Force a layout flush so the browser picks up the 0% start,
                // then restore the target value on the next frame.
                void el.offsetWidth;
                requestAnimationFrame(function () {
                    el.style.setProperty(t.varName, finalValue);
                });
            });
        });
    }

    // Respect reduced-motion: skip the 0%→target tween entirely.
    var prefersReducedMotion =
        window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () {
            if (!prefersReducedMotion) animateProgressFills();
        });
    } else {
        if (!prefersReducedMotion) animateProgressFills();
    }
})();
