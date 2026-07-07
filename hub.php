<?php
session_start();

// Garde d'authentification AVANT tout affichage (sinon header() échoue).
// Le hub est réservé aux utilisateurs connectés ; sinon retour à la landing.
if (!isset($_SESSION['mail'])) {
    header('Location: index.php');
    exit;
}

require_once("db.php");
require_once("head.php");
require_once("navbar.php");
?>
<div class="container py-5">

    <div class="text-center mb-5">
        <img src="assets/pictures/fmxx_logo.png" alt="iDev Compagnon" height="72" style="object-fit:contain;" class="mb-3">
        <h1 class="fw-bold mb-1">iDev <span style="color:#d52228;">Compagnon</span></h1>
        <p class="text-muted"><?= $t['hub_subtitle'] ?></p>
    </div>

    <div class="row g-4 justify-content-center">

        <!-- Module Football (actif) -->
        <div class="col-md-5 col-lg-4">
            <a href="index.php" class="text-decoration-none">
                <div class="card h-100 shadow-sm border-0 hub-card">
                    <div class="card-body text-center p-4">
                        <div class="display-4 mb-3">⚽</div>
                        <h4 class="fw-bold text-dark mb-2"><?= $t['hub_football_title'] ?></h4>
                        <p class="text-muted small mb-3"><?= $t['hub_football_desc'] ?></p>
                        <span class="btn btn-sm px-4 fw-semibold" style="background:#d52228; border:none; color:#fff;"><?= $t['hub_open'] ?></span>
                    </div>
                </div>
            </a>
        </div>

        <!-- Module F1 Manager (à venir) -->
        <div class="col-md-5 col-lg-4">
            <div class="card h-100 shadow-sm border-0" style="opacity:.55;">
                <div class="card-body text-center p-4">
                    <div class="display-4 mb-3">🏎️</div>
                    <h4 class="fw-bold text-dark mb-2"><?= $t['hub_f1_title'] ?></h4>
                    <p class="text-muted small mb-3"><?= $t['hub_f1_desc'] ?></p>
                    <span class="badge bg-secondary"><?= $t['hub_soon'] ?></span>
                </div>
            </div>
        </div>

                
        <div class="col-md-5 col-lg-4">
            <div class="card h-100 shadow-sm border-0" style="opacity:.55;">
                <div class="card-body text-center p-4">
                    <div class="display-4 mb-3">🚜</div>
                    <h4 class="fw-bold text-dark mb-2"><?= $t['hub_fs_title'] ?></h4>
                    <p class="text-muted small mb-3"><?= $t['hub_fs_desc'] ?></p>
                    <span class="badge bg-secondary"><?= $t['hub_soon'] ?></span>
                </div>
            </div>
        </div>
    </div>
</div>


<style>
.hub-card { transition: transform .15s ease, box-shadow .15s ease; cursor: pointer; }
.hub-card:hover { transform: translateY(-4px); box-shadow: 0 .5rem 1.5rem rgba(0,0,0,.12) !important; }
</style>

<?php require_once("footer.php"); ?>
