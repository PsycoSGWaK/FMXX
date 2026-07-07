<?php
session_start();
require_once("db.php");
require_once("head.php");
require_once("navbar.php");
require_once("auth_check.php");

if (!isset($_SESSION['mail'])) {
    require_once("footer.php");
    exit;
}

$idUser = $_SESSION['idUser'];
$idJoueur = (int)($_GET['id'] ?? 0);

if (!$idJoueur) {
    header("Location: index.php?tab=effectif");
    exit;
}

$stmt = $pdo->prepare("SELECT * FROM joueur WHERE idJoueur = :id AND idUser = :idUser");
$stmt->execute(['id' => $idJoueur, 'idUser' => $idUser]);
$j = $stmt->fetch();

if (!$j) {
    header("Location: index.php?tab=effectif");
    exit;
}

$saved = isset($_GET['saved']);
?>
<body>
<div class="container-fluid px-4 py-3">

    <div class="mb-3">
        <a href="index.php?tab=effectif" class="btn btn-sm btn-outline-secondary"><?= $t['player_back'] ?></a>
    </div>

    <?php if ($saved): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_player_saved'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <div class="card mb-4">
        <div class="card-header py-2 d-flex justify-content-between align-items-center" style="background:#091c3e; color:#16ffd0;">
            <span class="fs-4 fw-bold"><?= htmlspecialchars($j['nom'] ?? '—') ?></span>
            <?php
            $badgeClass = match($j['mercato_status']) {
                'sell' => 'bg-danger',
                'loan' => 'bg-primary',
                'free' => 'bg-danger',
                default => 'bg-secondary'
            };
            $badgeLabel = match($j['mercato_status']) {
                'sell' => $t['player_status_sell'],
                'loan' => $t['player_status_loan'],
                'free' => $t['player_status_free'],
                default => $t['player_status_squad']
            };
            ?>
            <span class="badge <?= $badgeClass ?>"><?= $badgeLabel ?></span>
        </div>
        <div class="card-body">

            <!-- Stats (lecture seule) -->
            <h6 class="text-muted fw-semibold mb-3 text-uppercase" style="font-size:.75rem; letter-spacing:.08em;"><?= $t['player_stats'] ?></h6>
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-2">
                    <div class="border rounded p-2 text-center">
                        <div class="fs-4 fw-bold"><?= $j['app'] ?? '—' ?></div>
                        <div class="small text-muted"><?= $t['player_apps'] ?></div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="border rounded p-2 text-center">
                        <div class="fs-4 fw-bold"><?= $j['buts'] ?? '—' ?></div>
                        <div class="small text-muted"><?= $t['player_goals'] ?></div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="border rounded p-2 text-center">
                        <div class="fs-4 fw-bold"><?= $j['pDec'] ?? '—' ?></div>
                        <div class="small text-muted"><?= $t['player_assists'] ?></div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="border rounded p-2 text-center">
                        <div class="fs-4 fw-bold"><?= $j['noteMoy'] ?? '—' ?></div>
                        <div class="small text-muted"><?= $t['player_rating'] ?></div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="border rounded p-2 text-center">
                        <div class="fs-4 fw-bold" style="font-size:1rem !important;">
                            <?= $j['prixDemande'] !== null ? number_format((int)$j['prixDemande'], 0, ',', ' ') . ' €' : '—' ?>
                        </div>
                        <div class="small text-muted"><?= $t['player_value'] ?></div>
                    </div>
                </div>
            </div>

            <!-- Formulaire d'édition -->
            <h6 class="text-muted fw-semibold mb-3 text-uppercase" style="font-size:.75rem; letter-spacing:.08em;"><?= $t['player_info'] ?></h6>
            <form action="joueur_post.php" method="post">
                <?= csrf_field() ?>
                <input type="hidden" name="idJoueur" value="<?= $j['idJoueur'] ?>">
                <div class="row g-3">
                    <div class="col-md-3 col-sm-6">
                        <label class="form-label small text-muted mb-1"><?= $t['player_name'] ?></label>
                        <input type="text" name="nom" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['nom'] ?? '') ?>">
                    </div>
                    <div class="col-md-1 col-sm-3">
                        <label class="form-label small text-muted mb-1"><?= $t['player_age'] ?></label>
                        <input type="number" name="age" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['age'] ?? '') ?>" min="15" max="45">
                    </div>
                    <div class="col-md-1 col-sm-3">
                        <label class="form-label small text-muted mb-1"><?= $t['player_number'] ?></label>
                        <input type="number" name="numero" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['numero'] ?? '') ?>" min="1" max="99">
                    </div>
                    <div class="col-md-2 col-sm-4">
                        <label class="form-label small text-muted mb-1"><?= $t['player_nat'] ?></label>
                        <input type="text" name="nat" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['nat'] ?? '') ?>">
                    </div>
                    <div class="col-md-2 col-sm-4">
                        <label class="form-label small text-muted mb-1"><?= $t['player_pob'] ?></label>
                        <input type="text" name="pdn" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['pdn'] ?? '') ?>">
                    </div>
                    <div class="col-md-3 col-sm-4">
                        <label class="form-label small text-muted mb-1"><?= $t['player_position'] ?></label>
                        <input type="text" name="poste" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['poste'] ?? '') ?>">
                    </div>
                    <div class="col-md-2 col-sm-6">
                        <label class="form-label small text-muted mb-1"><?= $t['player_expiry'] ?></label>
                        <input type="text" name="expireContrat" class="form-control form-control-sm"
                               value="<?= htmlspecialchars($j['expireContrat'] ?? '') ?>"
                               placeholder="ex : 01/06/2026">
                    </div>
                    <div class="col-md-2 col-sm-6">
                        <label class="form-label small text-muted mb-1"><?= $t['player_mercato'] ?></label>
                        <select name="mercato_status" class="form-select form-select-sm">
                            <option value="" <?= $j['mercato_status'] === null ? 'selected' : '' ?>><?= $t['player_status_squad'] ?></option>
                            <option value="sell" <?= $j['mercato_status'] === 'sell' ? 'selected' : '' ?>><?= $t['player_status_sell'] ?></option>
                            <option value="loan" <?= $j['mercato_status'] === 'loan' ? 'selected' : '' ?>><?= $t['player_status_loan'] ?></option>
                            <option value="free" <?= $j['mercato_status'] === 'free' ? 'selected' : '' ?>><?= $t['player_status_free'] ?></option>
                        </select>
                    </div>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-sm btn-primary"><?= $t['btn_save'] ?></button>
                </div>
            </form>
        </div>
    </div>

</div>
<?php require_once("footer.php"); ?>
</body>
