<?php if (isset($_SESSION['mail'])) { ?>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2" href="hub.php">
                <img src="assets/pictures/fmxx_logo.png" alt="iDev Compagnon" height="36" style="object-fit:contain;">
                iDev <span style="color:#d52228;">Compagnon</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.php"><?= $t['nav_home'] ?></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="mercato.php"><?= $t['nav_mercato'] ?></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="palmares.php"><?= $t['nav_palmares'] ?></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about.php"><?= $t['nav_about'] ?></a>
                    </li>
                    <?php
                    if (!isset($_SESSION['_admin_type'])) {
                        $stmtAdmin = $pdo->prepare("SELECT type FROM user WHERE idUser = :id");
                        $stmtAdmin->execute(['id' => $_SESSION['idUser']]);
                        $_SESSION['_admin_type'] = $stmtAdmin->fetchColumn();
                    }
                    if ($_SESSION['_admin_type'] === '1'): ?>
                    <li class="nav-item">
                        <a class="nav-link text-danger fw-bold" href="admin.php"><?= $t['nav_admin'] ?></a>
                    </li>
                    <?php endif; ?>
                </ul>
                <div class="d-flex align-items-center gap-3 ms-auto">
                    <div class="dropdown">
                        <a href="#" class="fw-semibold text-decoration-none text-dark dropdown-toggle" data-bs-toggle="dropdown">
                            👤 <?= htmlspecialchars($_SESSION['username'] ?? '') ?>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">
                                    <?= $t['dropdown_edit_profile'] ?>
                                </a>
                            </li>
                            <li><a class="dropdown-item" href="export_data.php"><?= $t['dropdown_export'] ?></a></li>
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
                    <!-- Switcher de langue -->
                    <div class="btn-group btn-group-sm ms-3" role="group">
                        <?php $currentLang = $_SESSION['lang'] ?? 'fr'; ?>
                        <a href="lang_post.php?lang=fr" class="btn <?= $currentLang === 'fr' ? 'btn-secondary' : 'btn-outline-secondary' ?>">FR</a>
                        <a href="lang_post.php?lang=en" class="btn <?= $currentLang === 'en' ? 'btn-secondary' : 'btn-outline-secondary' ?>">EN</a>
                        <a href="lang_post.php?lang=es" class="btn <?= $currentLang === 'es' ? 'btn-secondary' : 'btn-outline-secondary' ?>">ES</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>
<?php } else { ?>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2" href="index.php">
                <img src="assets/pictures/fmxx_logo.png" alt="iDev Compagnon" height="36" style="object-fit:contain;">
                iDev <span style="color:#d52228;">Compagnon</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.php"><?= $t['nav_home'] ?></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about.php"><?= $t['nav_about'] ?></a>
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

<div class="modal" tabindex="-1" id="LoginModal" aria-hidden="true">
    <?php require_once("login.php"); ?>
</div>

<div class="modal" tabindex="-1" id="SignupModal" aria-hidden="true">
    <?php require_once("signup.php"); ?>
</div>
