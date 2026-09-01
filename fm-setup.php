<?php
session_start();
require_once("head.php");
require_once("navbar.php");
?>
<div class="container py-5" style="max-width:760px">

    <?php if (isset($_SESSION['mail'])): ?>
    <div class="brand-block-center">
        <?php require("brand_block.php"); ?>
    </div>
    <div class="d-flex justify-content-between align-items-center mb-1">
        <h1 class="fw-bold mb-0"><?= $t['fmsetup_title'] ?></h1>
        <a href="index.php" class="btn-ghost"><?= $t['nav_back_index'] ?></a>
    </div>
    <?php else: ?>
    <h1 class="fw-bold mb-1"><?= $t['fmsetup_title'] ?></h1>
    <?php endif; ?>
    <p class="text-muted mb-4"><?= $t['fmsetup_intro'] ?></p>

    <div class="table-panel mb-4">
        <div class="table-panel-head">
            <span class="section-title"><span style="color:var(--heading)"><?= $t['fmsetup_step1_title'] ?></span></span>
        </div>
        <div class="p-3">
            <p class="mb-2"><?= $t['fmsetup_step1_text'] ?></p>
            <a href="https://builds.bepinex.dev/projects/bepinex_be" target="_blank" rel="noopener" class="btn-brand">
                <ion-icon name="download-outline"></ion-icon> <?= $t['fmsetup_step1_cta'] ?>
            </a>
        </div>
    </div>

    <div class="table-panel mb-4">
        <div class="table-panel-head">
            <span class="section-title"><span style="color:var(--heading)"><?= $t['fmsetup_step2_title'] ?></span></span>
        </div>
        <div class="p-3">
            <p class="mb-2"><?= $t['fmsetup_step2_text'] ?></p>
            <a href="https://www.fmscout.com/a-fm26-player-csv-export.html" target="_blank" rel="noopener" class="btn-brand">
                <ion-icon name="download-outline"></ion-icon> <?= $t['fmsetup_step2_cta'] ?>
            </a>
        </div>
    </div>

    <div class="table-panel mb-4">
        <div class="table-panel-head">
            <span class="section-title"><span style="color:var(--heading)"><?= $t['fmsetup_step3_title'] ?></span></span>
        </div>
        <div class="p-3">
            <p class="mb-2"><?= $t['fmsetup_step3_text'] ?></p>
            <a href="assets/downloads/FMXX.fmf" download class="btn-brand">
                <ion-icon name="download-outline"></ion-icon> <?= $t['fmsetup_step3_cta'] ?>
            </a>
        </div>
    </div>

    <div class="table-panel mb-4">
        <div class="table-panel-head">
            <span class="section-title"><span style="color:var(--heading)"><?= $t['fmsetup_step4_title'] ?></span></span>
        </div>
        <div class="p-3">
            <p class="mb-0"><?= $t['fmsetup_step4_text'] ?></p>
        </div>
    </div>

    <div class="table-panel mb-4">
        <div class="table-panel-head">
            <span class="section-title"><span style="color:var(--heading)"><?= $t['fmsetup_step5_title'] ?></span></span>
        </div>
        <div class="p-3">
            <p class="mb-2"><?= $t['fmsetup_step5_text'] ?></p>
            <?php if (isset($_SESSION['mail'])): ?>
                <a href="index.php?tab=effectif" class="btn-brand"><?= $t['fmsetup_step5_cta'] ?></a>
            <?php endif; ?>
        </div>
    </div>

</div>
<?php require_once("footer.php"); ?>
