/**
 * Indicateur de robustesse de mot de passe + vérification de concordance.
 * Réutilisé par le formulaire d'inscription et le modal de profil.
 *
 * Usage :
 *   FMXXInitPasswordStrength({
 *     password: 'idChampMdp',
 *     confirm:  'idChampConfirmation',   // optionnel
 *     wrap:     'idConteneurBarre',
 *     bar:      'idBarre',
 *     text:     'idTexteAide',
 *     min:      14,
 *     labels:   { weak: '...', medium: '...', strong: '...' }
 *   });
 */
(function () {
    function init(opts) {
        var pwd = document.getElementById(opts.password);
        if (!pwd || pwd.dataset.strengthBound) return; // évite un double binding
        pwd.dataset.strengthBound = '1';

        var confirm = opts.confirm ? document.getElementById(opts.confirm) : null;
        var wrap    = document.getElementById(opts.wrap);
        var bar     = document.getElementById(opts.bar);
        var text    = document.getElementById(opts.text);
        var policyText = text ? text.textContent : '';
        var MIN     = opts.min || 14;
        var labels  = opts.labels || { weak: '', medium: '', strong: '' };

        function score(v) {
            var s = 0;
            if (v.length >= MIN)        s++;
            if (/[a-z]/.test(v))        s++;
            if (/[A-Z]/.test(v))        s++;
            if (/[0-9]/.test(v))        s++;
            if (/[^a-zA-Z0-9]/.test(v)) s++;
            return s;
        }

        pwd.addEventListener('input', function () {
            var v = pwd.value;
            if (v === '') {
                if (wrap) wrap.style.display = 'none';
                if (text) { text.textContent = policyText; text.className = 'form-text'; }
                return;
            }
            if (wrap) wrap.style.display = '';
            var s = score(v); // 0..5
            if (bar) bar.style.width = (s / 5 * 100) + '%';
            var cls, label;
            if (s <= 2)      { cls = 'bg-danger';  label = labels.weak; }
            else if (s <= 4) { cls = 'bg-warning'; label = labels.medium; }
            else             { cls = 'bg-success'; label = labels.strong; }
            if (bar) bar.className = 'progress-bar ' + cls;
            if (text) {
                // Tant que les 5 critères ne sont pas remplis, on rappelle la règle
                text.textContent = s === 5 ? label : policyText;
                text.className = 'form-text' + (s === 5 ? ' text-success' : '');
            }
        });

        function checkMatch() {
            if (!confirm) return;
            if (confirm.value !== '' && confirm.value !== pwd.value) {
                confirm.classList.add('is-invalid');
            } else {
                confirm.classList.remove('is-invalid');
            }
        }
        if (confirm) {
            confirm.addEventListener('input', checkMatch);
            pwd.addEventListener('input', checkMatch);
        }
    }

    window.FMXXInitPasswordStrength = init;
})();
