// ============================================================
//  Ro5setkom — Mentor Availability
//  Dialog control + client-side time validation (no libraries)
// ============================================================
(function () {
    "use strict";

    document.addEventListener("DOMContentLoaded", function () {
        var dialog = document.getElementById("editDialog");

        // ── Open edit dialog, pre-fill from the button's data-* ──
        document.querySelectorAll(".js-edit-slot").forEach(function (btn) {
            btn.addEventListener("click", function () {
                if (!dialog) return;

                document.getElementById("edit-slot-id").value = btn.dataset.slotId || "";
                document.getElementById("edit-start").value = btn.dataset.start || "";
                document.getElementById("edit-end").value = btn.dataset.end || "";

                var daySelect = document.getElementById("edit-day");
                if (daySelect && btn.dataset.day) {
                    daySelect.value = btn.dataset.day;
                }

                if (typeof dialog.showModal === "function") {
                    dialog.showModal();
                } else {
                    dialog.setAttribute("open", "");
                }
            });
        });

        // ── Close buttons ──
        document.querySelectorAll(".js-dialog-close").forEach(function (el) {
            el.addEventListener("click", function () {
                if (!dialog) return;
                if (typeof dialog.close === "function") {
                    dialog.close();
                } else {
                    dialog.removeAttribute("open");
                }
            });
        });

        // ── Click on backdrop closes the dialog ──
        if (dialog) {
            dialog.addEventListener("click", function (e) {
                if (e.target === dialog) {
                    dialog.close();
                }
            });
        }

        // ── Confirm before destructive POSTs ──
        document.querySelectorAll(".js-confirm").forEach(function (form) {
            form.addEventListener("submit", function (e) {
                var msg = form.dataset.confirm || "Are you sure?";
                if (!window.confirm(msg)) {
                    e.preventDefault();
                }
            });
        });

        // ── End-after-start validation on any time form ──
        document.querySelectorAll(".js-time-form").forEach(function (form) {
            form.addEventListener("submit", function (e) {
                var start = form.querySelector('input[name="StartTime"]');
                var end = form.querySelector('input[name="EndTime"]');
                if (start && end && start.value && end.value && end.value <= start.value) {
                    e.preventDefault();
                    end.setCustomValidity("End time must be after start time.");
                    end.reportValidity();
                } else if (end) {
                    end.setCustomValidity("");
                }
            });
        });
    });
})();
