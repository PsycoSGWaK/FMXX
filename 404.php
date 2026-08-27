<?php
session_start();
http_response_code(404);
require_once("db.php");
require_once("head.php");
require_once("navbar.php");

$homeHref = isset($_SESSION['mail']) ? "hub.php" : "index.php";
?>
<div class="container py-5 text-center" style="max-width:480px;">
    <div class="display-1 fw-bold text-brand mb-2">404</div>
    <h1 class="fw-bold mb-3"><?= $t['page404_title'] ?></h1>
    <p class="text-muted mb-4"><?= $t['page404_text'] ?></p>
    <a href="<?= $homeHref ?>" class="btn btn-primary px-4"><?= $t['page404_home'] ?></a>
</div>
<?php require_once("footer.php"); ?>
