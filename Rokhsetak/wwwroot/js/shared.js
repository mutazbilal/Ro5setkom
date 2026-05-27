document.addEventListener("click", function (e) {
    const btn = e.target.closest("[data-alert-dismiss]");
    if (!btn) return;

    const alert = btn.closest(".alert");
    if (alert) {
        alert.remove();
    }
});