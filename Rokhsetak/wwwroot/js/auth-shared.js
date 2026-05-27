/**
 * auth-shared.js
 * UI-only utilities shared across all pages.
 * No business logic, no backend simulation, no hardcoded data.
 */
window.AuthShared = (() => {

    function initFloatingLabels(scope = document) {
        scope.querySelectorAll('.auth-input, .auth-textarea').forEach((input) => {
            const field = input.closest('.auth-field');
            if (!field) return;
            const sync = () => field.classList.toggle('is-filled', (input.value || '').trim().length > 0);
            input.addEventListener('input', sync);
            input.addEventListener('blur', sync);
            sync();
        });
    }

    function initPasswordToggle(scope = document) {
        scope.querySelectorAll('[data-password-toggle]').forEach((btn) => {
            const input = scope.querySelector('#' + btn.getAttribute('data-target'));
            if (!input) return;
            btn.addEventListener('click', () => {
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';
                btn.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
                btn.innerHTML = isPassword
                    ? '<i class="fa-solid fa-eye-slash" aria-hidden="true"></i>'
                    : '<i class="fa-solid fa-eye" aria-hidden="true"></i>';
            });
        });
    }

    function shake(el) {
        if (!el) return;
        el.classList.remove('auth-shake');
        void el.offsetWidth;
        el.classList.add('auth-shake');
    }

    function toFileSize(bytes) {
        if (bytes < 1024) return `${bytes} B`;
        if (bytes < 1_048_576) return `${(bytes / 1024).toFixed(1)} KB`;
        return `${(bytes / 1_048_576).toFixed(2)} MB`;
    }

    /**
     * Wire a drag-and-drop / click-to-upload dropzone.
     * @param {string} zoneSelector  e.g. '#certDropzone'
     * @param {string} inputSelector e.g. '#certFileInput'
     */
    function wireDropzone(zoneSelector, inputSelector) {
        const zone  = document.querySelector(zoneSelector);
        const input = document.querySelector(inputSelector);
        if (!zone || !input) return;

        const meta      = zone.querySelector('.register-dropzone__meta');
        const metaName  = zone.querySelector('[data-file-name]');
        const metaSize  = zone.querySelector('[data-file-size]');
        const removeBtn = zone.querySelector('.register-dropzone__remove');
        const errorEl   = zone.querySelector('[data-file-error]');
        const allowed   = ['application/pdf', 'image/jpeg', 'image/png'];

        const clearFile = () => {
            input.value = '';
            meta?.classList.remove('is-visible');
            if (errorEl) { errorEl.textContent = ''; errorEl.style.display = 'none'; }
            zone.removeAttribute('data-has-file');
        };

        const applyFile = (file) => {
            if (!allowed.includes(file.type)) {
                if (errorEl) { errorEl.textContent = 'Invalid file type. Only PDF, JPG, and PNG are accepted.'; errorEl.style.display = 'flex'; }
                clearFile(); return;
            }
            if (file.size > 5 * 1_048_576) {
                if (errorEl) { errorEl.textContent = 'File exceeds the 5 MB maximum size.'; errorEl.style.display = 'flex'; }
                clearFile(); return;
            }
            if (metaName) metaName.textContent = file.name;
            if (metaSize) metaSize.textContent = toFileSize(file.size);
            meta?.classList.add('is-visible');
            if (errorEl) { errorEl.textContent = ''; errorEl.style.display = 'none'; }
            zone.setAttribute('data-has-file', 'true');
        };

        zone.addEventListener('click',     (e) => { if (e.target !== removeBtn) input.click(); });
        zone.addEventListener('dragover',  (e) => { e.preventDefault(); zone.classList.add('is-dragover'); });
        zone.addEventListener('dragleave', ()  => zone.classList.remove('is-dragover'));
        zone.addEventListener('drop',      (e) => {
            e.preventDefault(); zone.classList.remove('is-dragover');
            const file = e.dataTransfer?.files?.[0];
            if (!file) return;
            const dt = new DataTransfer(); dt.items.add(file); input.files = dt.files;
            applyFile(file);
        });
        input.addEventListener('change', () => { if (input.files?.[0]) applyFile(input.files[0]); });
        removeBtn?.addEventListener('click', (e) => { e.stopPropagation(); clearFile(); });
    }
    function wireDependentCityDropdown(
        provinceSelector,
        citySelector
    ) {
        const provinceSelect = document.querySelector(provinceSelector);
        const citySelect = document.querySelector(citySelector);

        if (!provinceSelect || !citySelect) return;

        function filterCities() {

            const selectedProvinceId = provinceSelect.value;

            citySelect.querySelectorAll('option').forEach(option => {

                // Keep placeholder visible
                if (!option.value) {
                    option.hidden = false;
                    return;
                }

                const provinceId = option.dataset.provinceId;

                option.hidden = provinceId !== selectedProvinceId;
            });

            // Reset invalid selected city
            const selectedCity = citySelect.selectedOptions[0];

            if (
                selectedCity &&
                selectedCity.value &&
                selectedCity.dataset.provinceId !== selectedProvinceId
            ) {
                citySelect.value = '';
            }
        }

        provinceSelect.addEventListener('change', filterCities);

        // Initial filtering for pre-selected values
        filterCities();
    }

    document.addEventListener('DOMContentLoaded', () => {
        initFloatingLabels();
        initPasswordToggle();
    });

    return {
        initFloatingLabels,
        initPasswordToggle,
        shake,
        toFileSize,
        wireDropzone,
        wireDependentCityDropdown
    };
})();
