/* ============================================================
   Ro5setkom / Rokhsetak — Quiz UI
   Shared script for Take, MockExam, and Result views.
   Handles:
     - Visual selected-state for radio options
     - Submit lock (prevents double-submit, shows spinner text)
     - Mock-exam countdown (reads duration from data-* attributes)
   No inline scripts in views — everything is delegated here.
   ============================================================ */

(function () {
    'use strict';

    /* ----------------------------------------------------------
       1. Option selection — visual state mirrors the radio input.
       ---------------------------------------------------------- */
    function bindOptionSelection() {
        const options = document.querySelectorAll('.quiz-option');
        if (!options.length) return;

        options.forEach(function (opt) {
            const input = opt.querySelector('.quiz-option__input');
            if (!input) return;

            // Make the whole row keyboard-focusable through the input itself
            opt.addEventListener('click', function (e) {
                // clicking the label already toggles the input; we just sync class
                if (e.target.tagName !== 'INPUT') {
                    input.checked = true;
                    input.dispatchEvent(new Event('change', { bubbles: true }));
                }
            });

            input.addEventListener('change', function () {
                if (!input.checked) return;
                const name = input.name;
                // clear siblings in the same group
                document
                    .querySelectorAll('input[name="' + CSS.escape(name) + '"]')
                    .forEach(function (sibling) {
                        const card = sibling.closest('.quiz-option');
                        if (card) card.classList.remove('is-selected');
                    });
                opt.classList.add('is-selected');
            });

            // Initial state (in case the page was reloaded with a value)
            if (input.checked) opt.classList.add('is-selected');
        });
    }

    /* ----------------------------------------------------------
       2. Submit lock — prevent accidental double-submit and
          surface a clear "Submitting..." state on the CTA.
       ---------------------------------------------------------- */
    function bindSubmitLock() {
        const forms = document.querySelectorAll('[data-quiz-form]');
        forms.forEach(function (form) {
            form.addEventListener('submit', function () {
                const btn = form.querySelector('[data-quiz-submit]');
                if (!btn) return;
                btn.disabled = true;
                btn.classList.add('is-loading');
                const labelEl = btn.querySelector('[data-quiz-submit-label]');
                if (labelEl) {
                    labelEl.textContent = labelEl.dataset.loadingText || 'Submitting…';
                }
            });
        });
    }

    /* ----------------------------------------------------------
       3. Mock-exam countdown.
          The timer element carries data-quiz-timer="<seconds>".
          When time runs out, the form auto-submits.
       ---------------------------------------------------------- */
    function bindCountdown() {
        const timer = document.querySelector('[data-quiz-timer]');
        if (!timer) return;

        const totalSeconds = parseInt(timer.dataset.quizTimer, 10);
        if (!totalSeconds || totalSeconds <= 0) return;

        const valueEl = timer.querySelector('[data-quiz-timer-value]');
        const barEl = document.querySelector('[data-quiz-timer-bar]');
        const form = document.querySelector('[data-quiz-form]');
        const btn = form ? form.querySelector('[data-quiz-submit]') : null;

        let remaining = totalSeconds;

        function format(s) {
            const m = Math.floor(s / 60);
            const r = s % 60;
            return m + ':' + (r < 10 ? '0' + r : r);
        }

        function tick() {
            if (remaining <= 0) {
                if (valueEl) valueEl.textContent = '0:00';
                if (barEl) barEl.style.width = '0%';
                if (btn) {
                    btn.disabled = true;
                    const lbl = btn.querySelector('[data-quiz-submit-label]');
                    if (lbl) lbl.textContent = 'Time up — submitting…';
                }
                if (form) form.submit();
                clearInterval(interval);
                return;
            }
            if (valueEl) valueEl.textContent = format(remaining);
            if (barEl) {
                const pct = (remaining / totalSeconds) * 100;
                barEl.style.width = pct + '%';
            }
            // visual warnings at five-minute and one-minute marks
            timer.classList.toggle('is-warning', remaining <= 300 && remaining > 60);
            timer.classList.toggle('is-critical', remaining <= 60);

            remaining--;
        }

        tick();
        const interval = setInterval(tick, 1000);

        // Warn before leaving the page mid-exam
        window.addEventListener('beforeunload', function (e) {
            if (remaining > 0 && !form.dataset.submitted) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
        form && form.addEventListener('submit', function () {
            form.dataset.submitted = 'true';
        });
    }

    /* ----------------------------------------------------------
       4. Score ring — animate the conic gradient on the result
          page from 0% up to the actual score for a satisfying
          reveal. Reads target from data-quiz-score.
       ---------------------------------------------------------- */
    function animateScoreRing() {
        const ring = document.querySelector('[data-quiz-score]');
        if (!ring) return;
        const target = parseInt(ring.dataset.quizScore, 10);
        if (isNaN(target)) return;

        // respect reduced motion
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            ring.style.setProperty('--pct', target);
            return;
        }

        let current = 0;
        const duration = 900;
        const start = performance.now();
        function step(now) {
            const elapsed = now - start;
            const progress = Math.min(elapsed / duration, 1);
            // ease-out cubic
            const eased = 1 - Math.pow(1 - progress, 3);
            current = Math.round(eased * target);
            ring.style.setProperty('--pct', current);
            if (progress < 1) requestAnimationFrame(step);
            else ring.style.setProperty('--pct', target);
        }
        requestAnimationFrame(step);
    }

    /* ---------- Init ---------- */
    function init() {
        bindOptionSelection();
        bindSubmitLock();
        bindCountdown();
        animateScoreRing();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
