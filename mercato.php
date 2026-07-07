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

$stmt = $pdo->prepare("SELECT * FROM joueur WHERE idUser = :idUser ORDER BY poste, nom");
$stmt->execute(['idUser' => $idUser]);
$joueurs = $stmt->fetchAll();

$sells = array_filter($joueurs, fn($j) => $j['mercato_status'] === 'sell');
$loans = array_filter($joueurs, fn($j) => $j['mercato_status'] === 'loan');
$frees = array_filter($joueurs, fn($j) => $j['mercato_status'] === 'free');

$recettes = array_sum(array_map(fn($j) => (int)$j['prixDemande'], $sells));

$arrStmt = $pdo->prepare("SELECT * FROM mercato_arrivee WHERE idUser = :idUser ORDER BY statut, nom");
$arrStmt->execute(['idUser' => $idUser]);
$arrivees = $arrStmt->fetchAll();
$nbCibles  = count(array_filter($arrivees, fn($a) => $a['statut'] === 'cible'));
$nbSignes  = count(array_filter($arrivees, fn($a) => $a['statut'] === 'signe'));
$depenses  = array_sum(array_map(fn($a) => (int)$a['prix'], $arrivees));
$solde     = $recettes - $depenses;

function formatBudget(int $val): string {
    return number_format($val, 0, ',', ' ') . ' €';
}
?>
<body>
<div class="container-fluid px-4 py-3">

    <?php if (isset($_GET['saved'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_mercato_saved'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <!-- Résumé -->
    <div class="row mb-3 g-2">
        <div class="col">
            <div class="card text-center border-danger h-100">
                <div class="card-body py-2">
                    <div class="fs-4 fw-bold text-danger"><?= count($sells) ?></div>
                    <div class="text-muted small"><?= $t['mercato_sell'] ?></div>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-center border-primary h-100">
                <div class="card-body py-2">
                    <div class="fs-4 fw-bold text-primary"><?= count($loans) ?></div>
                    <div class="text-muted small"><?= $t['mercato_loan'] ?></div>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-center border-secondary h-100">
                <div class="card-body py-2">
                    <div class="fs-4 fw-bold"><?= count($joueurs) - count($sells) - count($loans) - count($frees) ?></div>
                    <div class="text-muted small"><?= $t['mercato_kept'] ?></div>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-center border-warning h-100">
                <div class="card-body py-2">
                    <div class="fs-4 fw-bold text-warning"><?= $nbCibles ?></div>
                    <div class="text-muted small"><?= $t['mercato_arr_targets'] ?></div>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-center border-success h-100">
                <div class="card-body py-2">
                    <div class="fs-4 fw-bold text-success"><?= $nbSignes ?></div>
                    <div class="text-muted small"><?= $t['mercato_arr_signed'] ?></div>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-center h-100 <?= $solde >= 0 ? 'border-success' : 'border-danger' ?>">
                <div class="card-body py-2">
                    <div class="fs-5 fw-bold <?= $solde >= 0 ? 'text-success' : 'text-danger' ?>">
                        <?= $solde > 0 ? '+' : '' ?><?= formatBudget($solde) ?>
                    </div>
                    <div class="text-muted small"><?= $t['mercato_revenue'] ?></div>
                    <?php if ($depenses > 0): ?>
                        <div class="text-muted" style="font-size:.7rem;">
                            +<?= formatBudget($recettes) ?> / −<?= formatBudget($depenses) ?>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableau mercato -->
    <div class="card">
        <div class="card-header py-2" style="background:#091c3e; color:#16ffd0;">
            <span class="fs-4 fw-bold"><?= $t['mercato_title'] ?></span>
        </div>
        <div class="card-body p-0">
            <?php if (count($joueurs) === 0): ?>
                <div class="p-4 text-center text-muted">
                    <?= $t['mercato_empty'] ?> <a href="index.php"><?= $t['mercato_import_link'] ?></a>
                </div>
            <?php else: ?>
                <form action="mercato_post.php" method="post">
                    <?= csrf_field() ?>
                    <div class="table-responsive">
                        <table class="table table-sm table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th><?= $t['mercato_col_name'] ?></th>
                                    <th><?= $t['mercato_col_age'] ?></th>
                                    <th><?= $t['mercato_col_pos'] ?></th>
                                    <th><?= $t['mercato_col_apps'] ?></th>
                                    <th><?= $t['mercato_col_rating'] ?></th>
                                    <th><?= $t['mercato_col_value'] ?></th>
                                    <th><?= $t['mercato_col_status'] ?></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($joueurs as $i => $j): ?>
                                    <?php
                                    $status = $j['mercato_status'];
                                    $rowClass = match($status) {
                                        'sell' => 'table-danger',
                                        'loan' => 'table-primary',
                                        'free' => 'table-danger',
                                        default => ''
                                    };
                                    ?>
                                    <tr class="<?= $rowClass ?>">
                                        <td><?= $i + 1 ?></td>
                                        <td class="fw-semibold"><?= htmlspecialchars($j['nom'] ?? '') ?></td>
                                        <td><?= $j['age'] ?? '' ?></td>
                                        <td><?= htmlspecialchars($j['poste'] ?? '') ?></td>
                                        <td><?= $j['app'] ?? '' ?></td>
                                        <td><?= $j['noteMoy'] ?? '' ?></td>
                                        <td><?= $j['prixDemande'] !== null ? formatBudget((int)$j['prixDemande']) : '—' ?></td>
                                        <td>
                                            <select class="form-select form-select-sm" name="status[<?= $j['idJoueur'] ?>]" style="min-width:100px">
                                                <option value=""     <?= $status === null   ? 'selected' : '' ?>>—</option>
                                                <option value="sell" <?= $status === 'sell' ? 'selected' : '' ?>><?= $t['mercato_opt_sell'] ?></option>
                                                <option value="loan" <?= $status === 'loan' ? 'selected' : '' ?>><?= $t['mercato_opt_loan'] ?></option>
                                                <option value="free" <?= $status === 'free' ? 'selected' : '' ?>><?= $t['mercato_opt_free'] ?></option>
                                            </select>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-3">
                        <button type="submit" class="btn btn-primary"><?= $t['btn_save'] ?></button>
                    </div>
                </form>
            <?php endif; ?>
        </div>
    </div>

    <!-- Section Arrivées -->
<div class="card mt-4">
    <div class="card-header py-2" style="background:#091c3e; color:#cdfb0a;">
        <span class="fs-4 fw-bold"><?= $t['mercato_arr_title'] ?></span>
    </div>
    <div class="card-body p-0">
        <?php
        $statutColors = ['cible' => 'warning', 'nego' => 'info', 'signe' => 'success'];
        $statutLabels = [
            'cible' => $t['mercato_arr_opt_cible'],
            'nego'  => $t['mercato_arr_opt_nego'],
            'signe' => $t['mercato_arr_opt_signe'],
        ];
        ?>
        <?php if (empty($arrivees)): ?>
            <div class="p-3 text-muted small"><?= $t['mercato_arr_empty'] ?></div>
        <?php else: ?>
            <div class="table-responsive">
                <table class="table table-sm table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th><?= $t['mercato_arr_col_name'] ?></th>
                            <th><?= $t['mercato_arr_col_pos'] ?></th>
                            <th><?= $t['mercato_arr_col_price'] ?></th>
                            <th><?= $t['mercato_arr_col_status'] ?></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($arrivees as $i => $a): ?>
                            <tr>
                                <td><?= $i + 1 ?></td>
                                <td class="fw-semibold"><?= htmlspecialchars($a['nom']) ?></td>
                                <td><?= htmlspecialchars($a['poste'] ?? '—') ?></td>
                                <td><?= $a['prix'] !== null ? formatBudget((int)$a['prix']) : '—' ?></td>
                                <td><span class="badge bg-<?= $statutColors[$a['statut']] ?? 'secondary' ?>"><?= $statutLabels[$a['statut']] ?? $a['statut'] ?></span></td>
                                <td class="d-flex gap-1 align-items-center">
                                    <button class="btn btn-sm btn-outline-primary" title="Modifier"
                                            data-bs-toggle="modal" data-bs-target="#editArriveeModal"
                                            data-id="<?= $a['idArrivee'] ?>"
                                            data-nom="<?= htmlspecialchars($a['nom'], ENT_QUOTES) ?>"
                                            data-poste="<?= htmlspecialchars($a['poste'] ?? '', ENT_QUOTES) ?>"
                                            data-prix="<?= $a['prix'] ?? '' ?>"
                                            data-statut="<?= $a['statut'] ?>">
                                        <ion-icon name="pencil-outline"></ion-icon>
                                    </button>
                                    <form action="mercato_arrivee_post.php" method="post" style="display:contents"
                                          onsubmit="return confirm('Supprimer ?')">
                                        <?= csrf_field() ?>
                                        <input type="hidden" name="delete_id" value="<?= $a['idArrivee'] ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Supprimer">
                                            <ion-icon name="trash-outline"></ion-icon>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>

        <!-- Formulaire ajout -->
        <form action="mercato_arrivee_post.php" method="post" class="p-3 border-top d-flex flex-wrap gap-2 align-items-end">
            <?= csrf_field() ?>
            <div>
                <label class="form-label small text-muted mb-1"><?= $t['mercato_arr_col_name'] ?> *</label>
                <input type="text" name="nom" class="form-control form-control-sm" style="min-width:150px" required>
            </div>
            <div>
                <label class="form-label small text-muted mb-1"><?= $t['mercato_arr_col_pos'] ?></label>
                <input type="text" name="poste" class="form-control form-control-sm" style="max-width:100px">
            </div>
            <div>
                <label class="form-label small text-muted mb-1"><?= $t['mercato_arr_col_price'] ?> (€)</label>
                <input type="number" name="prix" class="form-control form-control-sm" min="0" style="max-width:130px">
            </div>
            <div>
                <label class="form-label small text-muted mb-1"><?= $t['mercato_arr_col_status'] ?></label>
                <select name="statut" class="form-select form-select-sm">
                    <option value="cible"><?= $t['mercato_arr_opt_cible'] ?></option>
                    <option value="nego"><?= $t['mercato_arr_opt_nego'] ?></option>
                    <option value="signe"><?= $t['mercato_arr_opt_signe'] ?></option>
                </select>
            </div>
            <div>
                <button type="submit" class="btn btn-sm btn-primary"><?= $t['mercato_arr_add'] ?></button>
            </div>
        </form>
    </div>
</div>

</div>

<!-- Modal édition arrivée -->
<div class="modal fade" id="editArriveeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><?= $t['mercato_arr_title'] ?></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="mercato_arrivee_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="edit_id" id="edit_id">
                    <div class="mb-3">
                        <label class="form-label small"><?= $t['mercato_arr_col_name'] ?> *</label>
                        <input type="text" name="nom" id="edit_nom" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small"><?= $t['mercato_arr_col_pos'] ?></label>
                        <input type="text" name="poste" id="edit_poste" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small"><?= $t['mercato_arr_col_price'] ?> (€)</label>
                        <input type="number" name="prix" id="edit_prix" class="form-control" min="0">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small"><?= $t['mercato_arr_col_status'] ?></label>
                        <select name="statut" id="edit_statut" class="form-select">
                            <option value="cible"><?= $t['mercato_arr_opt_cible'] ?></option>
                            <option value="nego"><?= $t['mercato_arr_opt_nego'] ?></option>
                            <option value="signe"><?= $t['mercato_arr_opt_signe'] ?></option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary w-100"><?= $t['btn_save'] ?></button>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
document.getElementById('editArriveeModal').addEventListener('show.bs.modal', function (e) {
    const btn = e.relatedTarget;
    document.getElementById('edit_id').value    = btn.dataset.id;
    document.getElementById('edit_nom').value   = btn.dataset.nom;
    document.getElementById('edit_poste').value = btn.dataset.poste;
    document.getElementById('edit_prix').value  = btn.dataset.prix;
    document.getElementById('edit_statut').value = btn.dataset.statut;
});
</script>

<?php require_once("footer.php"); ?>
</body>
