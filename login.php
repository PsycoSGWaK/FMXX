<div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
        <div class="modal-header border-0">
            <div class="d-flex align-items-center gap-2">
                <img src="assets/pictures/fmxx_logo.png" alt="" height="28" style="object-fit:contain;">
                <h5 class="modal-title mb-0"><?= $t['nav_login'] ?></h5>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <?php
            $loginError    = $_GET['error'] ?? '';
            $unverifiedMail = $_SESSION['unverified_mail'] ?? '';
            unset($_SESSION['unverified_mail']);
            ?>
            <?php if ($loginError === 'login'): ?>
                <div class="alert alert-danger alert-dismissible fade show py-2"><?= $t['alert_login_error'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php elseif ($loginError === 'form'): ?>
                <div class="alert alert-danger alert-dismissible fade show py-2"><?= $t['alert_login_missing'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php elseif ($loginError === 'session_expired'): ?>
                <div class="alert alert-warning alert-dismissible fade show py-2"><?= $t['alert_session_expired'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php elseif ($loginError === 'too_many_attempts'): ?>
                <div class="alert alert-danger alert-dismissible fade show py-2"><?= $t['alert_login_ratelimited'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php elseif ($loginError === 'unverified'): ?>
                <div class="alert alert-warning py-2">
                    <?= $t['alert_login_unverified'] ?>
                    <form action="resend_confirmation_post.php" method="post" class="mt-2">
                        <?= csrf_field() ?>
                        <input type="hidden" name="mail" value="<?= htmlspecialchars($unverifiedMail) ?>">
                        <button type="submit" class="btn btn-sm btn-outline-secondary"><?= $t['login_resend_confirmation'] ?></button>
                    </form>
                </div>
            <?php elseif ($loginError === 'confirm_invalid'): ?>
                <div class="alert alert-danger alert-dismissible fade show py-2"><?= $t['alert_confirm_invalid'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php endif; ?>
            <?php if (($_GET['confirmed'] ?? '') === 'ok'): ?>
                <div class="alert alert-success alert-dismissible fade show py-2"><?= $t['alert_email_confirmed'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php endif; ?>
            <?php if (($_GET['resend'] ?? '') === 'ok'): ?>
                <div class="alert alert-success alert-dismissible fade show py-2"><?= $t['alert_resend_sent'] ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <?php endif; ?>
            <form class="form-login" action="login_post.php" method="post">
                <?= csrf_field() ?>
                <div class="mb-3">
                    <label for="mail" class="form-label"><?= $t['login_email'] ?></label>
                    <input type="email" class="form-control" id="mail" name="mail">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label"><?= $t['login_password'] ?></label>
                    <input type="password" class="form-control" id="password" name="password">
                </div>
                <div class="mb-3">
                    <span class="form-label"><?= $t['login_no_account'] ?></span>
                    <a role="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#SignupModal"><?= $t['login_register'] ?></a>
                </div>
                <button type="submit" class="btn btn-primary"><?= $t['login_submit'] ?></button>
            </form>
        </div>
    </div>
</div>
