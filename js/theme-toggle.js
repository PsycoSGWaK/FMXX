document.addEventListener('DOMContentLoaded', function () {
    var btn = document.getElementById('themeToggle');
    if (!btn) return;

    var ionIcon = btn.querySelector('ion-icon');
    var svgIcon = document.getElementById('themeIcon');
    var label = btn.querySelector('span');

    var sunPath = '<path d="M12 4V2M12 22v-2M4.9 4.9 3.5 3.5M20.5 20.5l-1.4-1.4M4 12H2M22 12h-2M4.9 19.1 3.5 20.5M20.5 3.5l-1.4 1.4"/><circle cx="12" cy="12" r="4.5"/>';
    var moonPath = '<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/>';

    function sync() {
        var current = document.documentElement.getAttribute('data-bs-theme') || 'light';
        if (ionIcon) ionIcon.setAttribute('name', current === 'dark' ? 'sunny-outline' : 'moon-outline');
        if (svgIcon) svgIcon.innerHTML = current === 'dark' ? sunPath : moonPath;
        if (label) label.textContent = current === 'dark' ? btn.dataset.labelLight : btn.dataset.labelDark;
    }

    sync();

    btn.addEventListener('click', function () {
        var current = document.documentElement.getAttribute('data-bs-theme') || 'light';
        var next = current === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-bs-theme', next);
        try { localStorage.setItem('idev-theme', next); } catch (e) {}
        sync();
    });
});
