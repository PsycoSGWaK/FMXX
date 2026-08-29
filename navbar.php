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
    ?>
<body>
<div class="app-shell">
    <aside class="sidebar">
        <a class="sidebar-brand" href="hub.php">
            <img src="assets/pictures/fmxx_logo.png" alt="iDev Compagnon">
            <span class="sidebar-brand-name">iDev <em>Compagnon</em></span>
        </a>
        <div class="sidebar-module">Football Manager</div>

        <nav class="sidebar-nav">
            <a class="side-link <?= navActive('index.php', $currentPage) ?>" href="index.php">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 11.5 12 4l9 7.5"/><path d="M5 10v9a1 1 0 0 0 1 1h4v-6h4v6h4a1 1 0 0 0 1-1v-9"/></svg>
                <span><?= $t['nav_home'] ?></span>
            </a>
            <?php if ($isAdmin): ?>
            <a class="side-link admin-link <?= navActive('admin.php', $currentPage) ?>" href="admin.php">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3 4.5 6v6c0 4.5 3.2 7.7 7.5 9 4.3-1.3 7.5-4.5 7.5-9V6L12 3Z"/></svg>
                <span><?= $t['nav_admin'] ?></span>
            </a>
            <?php endif; ?>
        </nav>

        <div class="sidebar-foot">
            <div class="btn-group btn-group-sm" role="group">
                <a href="lang_post.php?lang=fr" class="btn <?= $currentLang === 'fr' ? 'btn-secondary' : 'btn-outline-secondary' ?>">FR</a>
                <a href="lang_post.php?lang=en" class="btn <?= $currentLang === 'en' ? 'btn-secondary' : 'btn-outline-secondary' ?>">EN</a>
                <a href="lang_post.php?lang=es" class="btn <?= $currentLang === 'es' ? 'btn-secondary' : 'btn-outline-secondary' ?>">ES</a>
            </div>
            <button type="button" class="theme-btn" id="themeToggle" aria-label="<?= $t['nav_theme_toggle'] ?>"
                    data-label-dark="<?= htmlspecialchars($t['nav_theme_dark']) ?>" data-label-light="<?= htmlspecialchars($t['nav_theme_light']) ?>">
                <svg id="themeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></svg>
                <span><?= $t['nav_theme_dark'] ?></span>
            </button>
            <div class="dropdown">
                <button type="button" class="user-chip w-100" data-bs-toggle="dropdown" style="background:none; border:none; cursor:pointer;">
                    <div class="user-avatar"><?= htmlspecialchars($initials) ?></div>
                    <div class="text-start">
                        <div class="user-name"><?= htmlspecialchars($_SESSION['username'] ?? '') ?></div>
                        <div class="user-role"><?= $isAdmin ? 'Admin' : '' ?></div>
                    </div>
                </button>
                <ul class="dropdown-menu">
                    <li>
                        <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">
                            <?= $t['dropdown_edit_profile'] ?>
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="export_data.php"><?= $t['dropdown_export'] ?></a></li>
                    <li><a class="dropdown-item" href="backup_export.php"><?= $t['dropdown_backup'] ?></a></li>
                    <li>
                        <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#restoreBackupModal">
                            <?= $t['dropdown_restore_backup'] ?>
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-danger" href="#" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                            <?= $t['dropdown_delete_account'] ?>
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="logout.php"><?= $t['nav_logout'] ?></a></li>
                </ul>
            </div>
        </div>
    </aside>

    <main class="main">
<?php } else { ?>
<body>
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2" href="index.php">
                <img src="assets/pictures/fmxx_logo.png" alt="iDev Compagnon" height="36" style="object-fit:contain;">
                iDev <span class="text-brand">Compagnon</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link <?= navActive('index.php', $currentPage) ?>" href="index.php"><?= $t['nav_home'] ?></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <?= navActive('about.php', $currentPage) ?>" href="about.php"><?= $t['nav_about'] ?></a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <!-- Switcher de langue -->
                    <div class="btn-group btn-group-sm" role="group">
                        <?php $currentLang = $_SESSION['lang'] ?? 'fr'; ?>
                        <a href="lang_post.php?lang=fr" class="btn <?= $currentLang === 'fr' ? 'btn-secondary' : 'btn-outline-secondary' ?>">FR</a>
                        <a href="lang_post.php?lang=en" class="btn <?= $currentLang === 'en' ? 'btn-secondary' : 'btn-outline-secondary' ?>">EN</a>
                        <a href="lang_post.php?lang=es" class="btn <?= $currentLang === 'es' ? 'btn-secondary' : 'btn-outline-secondary' ?>">ES</a>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="themeToggle" aria-label="<?= $t['nav_theme_toggle'] ?>">
                        <ion-icon name="moon-outline"></ion-icon>
                    </button>
                </div>
            </div>
        </div>
    </nav>
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
                    <div class="alert alert-danger py-2"><?= htmlspecialchars(validation_message($profileErrorCode, $t)) ?></div>
                <?php elseif ($profileErrCode === 'profile_conflict'): ?>
                    <div class="alert alert-danger py-2"><?= $t['profile_error_conflict'] ?></div>
                <?php elseif ($profileErrCode === 'profile_missing'): ?>
                    <div class="alert alert-danger py-2"><?= $t['profile_error_missing'] ?></div>
                <?php endif; ?>
                <?php if (($_GET['profile'] ?? '') === 'ok'): ?>
                    <div class="alert alert-success py-2"><?= $t['profile_ok'] ?></div>
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
