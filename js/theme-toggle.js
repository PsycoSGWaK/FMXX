document.addEventListener('DOMContentLoaded', function () {
    var btn = document.getElementById('themeToggle');
    if (!btn) return;
    var icon = btn.querySelector('ion-icon');

    function sync() {
        var current = document.documentElement.getAttribute('data-bs-theme') || 'light';
        icon.setAttribute('name', current === 'dark' ? 'sunny-outline' : 'moon-outline');
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
