/**
 * index.js
 * Scroll-reveal animation for the landing page feature cards.
 */
document.addEventListener('DOMContentLoaded', () => {
    const items = document.querySelectorAll('.reveal-on-scroll');
    if (!items.length) return;

    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (!entry.isIntersecting) return;
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
        });
    }, { threshold: 0.18 });

    items.forEach((item) => observer.observe(item));
});
