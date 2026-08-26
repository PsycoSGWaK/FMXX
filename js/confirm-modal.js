/**
 * Remplace window.confirm() par une modale Bootstrap stylée.
 * Usage : ajouter data-confirm="message" (+ data-confirm-variant="danger|warning|primary")
 * sur un <form> (intercepte le submit) ou un <a href="..."> (intercepte le clic).
 */
(function () {
    document.addEventListener('DOMContentLoaded', function () {
        var modalEl = document.getElementById('confirmModal');
        if (!modalEl || typeof bootstrap === 'undefined') return;

        var bsModal  = new bootstrap.Modal(modalEl);
        var bodyEl   = document.getElementById('confirmModalBody');
        var okBtn    = document.getElementById('confirmModalOk');
        var pendingForm = null;
        var pendingLink = null;

        function showConfirm(message, variant) {
            bodyEl.textContent = message;
            okBtn.className = 'btn btn-' + (variant || 'primary');
            bsModal.show();
        }

        document.addEventListener('submit', function (e) {
            var form = e.target.closest ? e.target.closest('form[data-confirm]') : null;
            if (!form) return;
            e.preventDefault();
            pendingForm = form;
            pendingLink = null;
            showConfirm(form.dataset.confirm, form.dataset.confirmVariant);
        }, true);

        document.addEventListener('click', function (e) {
            var link = e.target.closest ? e.target.closest('a[data-confirm]') : null;
            if (!link) return;
            e.preventDefault();
            pendingLink = link;
            pendingForm = null;
            showConfirm(link.dataset.confirm, link.dataset.confirmVariant);
        }, true);

        okBtn.addEventListener('click', function () {
            bsModal.hide();
            if (pendingForm) {
                var form = pendingForm;
                pendingForm = null;
                form.submit();
            } else if (pendingLink) {
                var href = pendingLink.href;
                pendingLink = null;
                window.location.href = href;
            }
        });
    });
})();
