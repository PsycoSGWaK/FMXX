<div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title"><?= $t['nav_login'] ?></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
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
