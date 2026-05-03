/**
 * register.js
 * UI-only enhancements for CompleteMentor.cshtml.
 *
 * Wires the certification file dropzone UI.
 * All form submission and validation is handled server-side.
 */
document.addEventListener('DOMContentLoaded', () => {
    // Wire the certification document dropzone (CompleteMentor only)
    window.AuthShared?.wireDropzone('#certDropzone', '#certFileInput');

    // Reveal the server-returned validation summary if errors exist
    const card              = document.querySelector('.auth-card');
    const validationSummary = document.querySelector('[data-valmsg-summary]');

    if (validationSummary && validationSummary.querySelector('li')) {
        validationSummary.style.display = 'flex';
        window.AuthShared?.shake(card);
    }
});
