/**
 * login.js
 * UI-only enhancements for Login.cshtml.
 *
 * When the server returns ModelState errors (wrong credentials, locked account, etc.)
 * ASP.NET re-renders the page with the validation summary populated.
 * This script makes the banner visible and shakes the card to draw attention.
 *
 * Lockout, attempt counting, and credential validation are handled by the backend.
 */
document.addEventListener('DOMContentLoaded', () => {
    const card              = document.querySelector('.auth-card');
    const validationSummary = document.querySelector('[data-valmsg-summary]');

    if (validationSummary && validationSummary.querySelector('li')) {
        validationSummary.style.display = 'flex';
        window.AuthShared?.shake(card);
    }
});
