<?php
$currentPage = basename($_SERVER['SCRIPT_NAME'] ?? '');
function navActive(string $page, string $current): string {
    return $page === $current ? 'active' : '';
}
?>
<?php if (isset($_SESSION['mail'])) {
    if (!isset($_SESSION['_admin_type'])) {
        $stmtAdmin = $pdo->prepare("SELECT type FROM user WHERE idUser = :id");
        $stmtAdmin->execute(['id' => $_SESSION['idUser']]);
        $_SESSION['_admin_type'] = $stmtAdmin->fetchColumn();
    }
    $isAdmin = $_SESSION['_admin_type'] === '1';
    $currentLang = $_SESSION['lang'] ?? 'fr';
    $initials = mb_strtoupper(mb_substr($_SESSION['username'] ?? '?', 0, 2));
    // Plus de barre de nav globale : chaque page compose son propre header
    // (context-bar) et y inclut usermenu.php (langue/thème/menu utilisateur)
    // à l'endroit qui lui convient.
    ?>
<body>
<?php } else {
    // Pas de barre de nav pour le visiteur : la landing (index.php) compose
    // son propre en-tête (logo/langue/thème) directement dans le hero.
    $currentLang = $_SESSION['lang'] ?? 'fr';
    // La landing ne passe pas par .main-content (flex:1) : sans cette classe,
    // le footer (sticky via margin-top:auto) se collerait au bas du viewport
    // et laisserait un vide sous le contenu sur les écrans hauts.
    $bodyClass = $currentPage === 'index.php' ? ' class="visitor-page"' : '';
    ?>
<body<?= $bodyClass ?>>
<?php } ?>
<!-- Modal profil -->
<div class="modal fade" tabindex="-1" id="profileModal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><?= $t['profile_title'] ?></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <?php
                require_once(__DIR__ . "/validation.php");
                $profileErrorCode = $_SESSION['profile_error_code'] ?? null;
                unset($_SESSION['profile_error_code']);
                $profileErrCode = $_GET['error'] ?? '';
                ?>
                <?php if ($profileErrorCode): ?>
                    <div class="alert alert-danger alert-dismissible fade show py-2"><?= htmlspecialchars(validation_message($profileErrorCode, $t)) ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                <?php elseif ($profileErrCode === 'profile_conflict'): ?>
                    <div class="alert alert-danger alert-dismissible fade show py-2"><?= $t['profile_error_conflict'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                <?php elseif ($profileErrCode === 'profile_missing'): ?>
                    <div class="alert alert-danger alert-dismissible fade show py-2"><?= $t['profile_error_missing'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                <?php endif; ?>
                <?php if (($_GET['profile'] ?? '') === 'ok'): ?>
                    <div class="alert alert-success alert-dismissible fade show py-2"><?= $t['profile_ok'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                <?php endif; ?>
                <form action="profile_post.php" method="post">
                    <?= csrf_field() ?>
                    <div class="mb-3">
                        <label class="form-label"><?= $t['profile_username'] ?></label>
                        <input type="text" name="username" class="form-control"
                               value="<?= htmlspecialchars($_SESSION['username'] ?? '') ?>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><?= $t['profile_email'] ?></label>
                        <input type="email" name="mail" class="form-control"
                               value="<?= htmlspecialchars($_SESSION['mail'] ?? '') ?>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><?= $t['profile_password'] ?> <span class="text-muted small">(<?= $t['profile_password_hint'] ?>)</span></label>
                        <input type="password" name="password" id="profilePassword"
                               class="form-control <?= $profileErrCode === 'profile_pwd' ? 'is-invalid' : '' ?>"
                               minlength="<?= PASSWORD_MIN_LEN ?>" autocomplete="new-password">
                        <div class="progress mt-2" style="height:6px; display:none;" id="profilePwdWrap">
                            <div class="progress-bar" id="profilePwdBar" role="progressbar" style="width:0%"></div>
                        </div>
                        <div class="form-text" id="profilePwdText"><?= htmlspecialchars(password_policy_text($t)) ?></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><?= $t['signup_password_confirm'] ?></label>
                        <input type="password" name="password_confirm" id="profilePasswordConfirm"
                               class="form-control" minlength="<?= PASSWORD_MIN_LEN ?>" autocomplete="new-password">
                        <div class="invalid-feedback"><?= $t['val_pwd_mismatch'] ?></div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100"><?= $t['profile_save'] ?></button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
FMXXInitPasswordStrength({
    password: 'profilePassword',
    confirm:  'profilePasswordConfirm',
    wrap:     'profilePwdWrap',
    bar:      'profilePwdBar',
    text:     'profilePwdText',
    min:      <?= PASSWORD_MIN_LEN ?>,
    labels: {
        weak:   <?= json_encode($t['pwd_strength_weak'], JSON_UNESCAPED_UNICODE) ?>,
        medium: <?= json_encode($t['pwd_strength_medium'], JSON_UNESCAPED_UNICODE) ?>,
        strong: <?= json_encode($t['pwd_strength_strong'], JSON_UNESCAPED_UNICODE) ?>
    }
});
</script>

<?php
$profileTrigger = in_array($_GET['error'] ?? '', ['profile_conflict','profile_missing','profile_mail_invalid','profile_pwd'])
               || ($_GET['profile'] ?? '') === 'ok';
if ($profileTrigger): ?>
<script>
document.addEventListener('DOMContentLoaded', function () {
    new bootstrap.Modal(document.getElementById('profileModal')).show();
});
</script>
<?php endif; ?>

<!-- Modal suppression compte -->
<div class="modal fade" tabindex="-1" id="deleteAccountModal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-danger"><?= $t['delete_account_title'] ?></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><?= $t['delete_account_warning'] ?></p>
                <form action="delete_account.php" method="post">
                    <?= csrf_field() ?>
                    <button type="submit" class="btn btn-danger w-100"><?= $t['delete_account_confirm'] ?></button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal restauration sauvegarde -->
<div class="modal fade" tabindex="-1" id="restoreBackupModal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><?= $t['restore_backup_title'] ?></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="small text-muted"><?= $t['restore_backup_info'] ?></p>
                <div class="alert alert-warning small py-2"><?= $t['restore_backup_warning'] ?></div>
                <form action="backup_import.php" method="post" enctype="multipart/form-data"
                      data-confirm="<?= htmlspecialchars($t['restore_backup_confirm_dialog'], ENT_QUOTES) ?>"
                      data-confirm-variant="danger">
                    <?= csrf_field() ?>
                    <div class="mb-3">
                        <label class="form-label"><?= $t['restore_backup_label'] ?></label>
                        <input type="file" name="backup_file" accept=".json,application/json" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100"><?= $t['restore_backup_confirm'] ?></button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal" tabindex="-1" id="LoginModal" aria-hidden="true">
    <?php require_once("login.php"); ?>
</div>

<?php if (in_array($_GET['error'] ?? '', ['login', 'form', 'session_expired', 'too_many_attempts', 'unverified', 'confirm_invalid'], true)
       || ($_GET['confirmed'] ?? '') === 'ok'
       || ($_GET['resend'] ?? '') === 'ok'): ?>
<script>
document.addEventListener('DOMContentLoaded', function () {
    new bootstrap.Modal(document.getElementById('LoginModal')).show();
});
</script>
<?php endif; ?>

<div class="modal" tabindex="-1" id="SignupModal" aria-hidden="true">
    <?php require_once("signup.php"); ?>
</div>

<!-- Modal de confirmation générique (remplace window.confirm) -->
<div class="modal fade" tabindex="-1" id="confirmModal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><?= $t['confirm_title'] ?></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="confirmModalBody"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><?= $t['confirm_cancel'] ?></button>
                <button type="button" class="btn btn-primary" id="confirmModalOk"><?= $t['confirm_ok'] ?></button>
            </div>
        </div>
    </div>
</div>
