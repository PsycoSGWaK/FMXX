<?php
require_once(__DIR__ . "/validation.php");
// Code d'erreur détaillé (flash) et valeurs saisies, posés par signup_post.php
$signupErrorCode = $_SESSION['signup_error_code'] ?? null;
$signupOld       = $_SESSION['signup_old'] ?? ['username' => '', 'mail' => ''];
unset($_SESSION['signup_error_code'], $_SESSION['signup_old']);
$signupErrCode = $_GET['error'] ?? '';
?>
<div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title"><?= $t['nav_signup'] ?></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <?php if ($signupErrorCode): ?>
                <div class="alert alert-danger py-2"><?= htmlspecialchars(validation_message($signupErrorCode, $t)) ?></div>
            <?php elseif ($signupErrCode === 'signup_username'): ?>
                <div class="alert alert-danger py-2"><?= $t['signup_err_username'] ?></div>
            <?php elseif ($signupErrCode === 'signup_mail'): ?>
                <div class="alert alert-danger py-2"><?= $t['signup_err_mail'] ?></div>
            <?php elseif ($signupErrCode === 'signup_missing'): ?>
                <div class="alert alert-danger py-2"><?= $t['signup_err_missing'] ?></div>
            <?php endif; ?>
            <?php if (($_GET['signup'] ?? '') === 'ok'): ?>
                <div class="alert alert-success py-2"><?= $t['signup_ok'] ?></div>
            <?php endif; ?>
            <form class="form-login" action="signup_post.php" method="post">
                <?= csrf_field() ?>
                <div class="mb-3">
                    <label for="username" class="form-label"><?= $t['signup_username'] ?></label>
                    <input type="text" class="form-control <?= $signupErrCode === 'signup_username' ? 'is-invalid' : '' ?>"
                           id="username" name="username" value="<?= htmlspecialchars($signupOld['username']) ?>">
                </div>
                <div class="mb-3">
                    <label for="mail" class="form-label"><?= $t['signup_email'] ?></label>
                    <input type="email" class="form-control <?= in_array($signupErrCode, ['signup_mail', 'signup_mail_invalid'], true) ? 'is-invalid' : '' ?>"
                           id="mail" name="mail" value="<?= htmlspecialchars($signupOld['mail']) ?>">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label"><?= $t['signup_password'] ?></label>
                    <input type="password" class="form-control <?= $signupErrCode === 'signup_pwd' ? 'is-invalid' : '' ?>"
                           id="password" name="password" minlength="<?= PASSWORD_MIN_LEN ?>" autocomplete="new-password">
                    <!-- Indicateur de robustesse -->
                    <div class="progress mt-2" style="height:6px; display:none;" id="pwdStrengthWrap">
                        <div class="progress-bar" id="pwdStrengthBar" role="progressbar" style="width:0%"></div>
                    </div>
                    <div class="form-text" id="pwdStrengthText"><?= htmlspecialchars(password_policy_text($t)) ?></div>
                </div>
                <div class="mb-3">
                    <label for="password_confirm" class="form-label"><?= $t['signup_password_confirm'] ?></label>
                    <input type="password" class="form-control" id="password_confirm" name="password_confirm"
                           minlength="<?= PASSWORD_MIN_LEN ?>" autocomplete="new-password">
                    <div class="invalid-feedback" id="pwdMatchMsg"><?= $t['val_pwd_mismatch'] ?></div>
                </div>
                <div class="mb-3">
                    <span class="form-label"><?= $t['signup_already_member'] ?></span>
                    <a role="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#LoginModal"><?= $t['signup_login'] ?></a>
                </div>
                <button type="submit" class="btn btn-primary"><?= $t['signup_submit'] ?></button>
            </form>
        </div>
    </div>
</div>

<script>
FMXXInitPasswordStrength({
    password: 'password',
    confirm:  'password_confirm',
    wrap:     'pwdStrengthWrap',
    bar:      'pwdStrengthBar',
    text:     'pwdStrengthText',
    min:      <?= PASSWORD_MIN_LEN ?>,
    labels: {
        weak:   <?= json_encode($t['pwd_strength_weak'], JSON_UNESCAPED_UNICODE) ?>,
        medium: <?= json_encode($t['pwd_strength_medium'], JSON_UNESCAPED_UNICODE) ?>,
        strong: <?= json_encode($t['pwd_strength_strong'], JSON_UNESCAPED_UNICODE) ?>
    }
});
</script>

<?php
// Ouvrir automatiquement le modal si on revient avec une erreur ou un succès signup
$signupTrigger = in_array($signupErrCode, ['signup_username', 'signup_mail', 'signup_missing', 'signup_mail_invalid', 'signup_pwd'], true)
              || ($_GET['signup'] ?? '') === 'ok';
if ($signupTrigger): ?>
<script>
document.addEventListener('DOMContentLoaded', function () {
    new bootstrap.Modal(document.getElementById('SignupModal')).show();
});
</script>
<?php endif; ?>
