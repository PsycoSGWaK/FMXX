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

// Vérification admin
$stmtType = $pdo->prepare("SELECT type FROM user WHERE idUser = :id");
$stmtType->execute(['id' => $_SESSION['idUser']]);
$userType = $stmtType->fetchColumn();

if ($userType !== '1') {
    echo '<div class="container py-5"><div class="alert alert-danger">Accès refusé.</div></div>';
    require_once("footer.php");
    exit;
}

$tab = $_GET['tab'] ?? 'users';
?>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<body>
<div class="container-fluid px-4 py-3">
    <h2 class="fw-bold mb-3" style="color:#091c3e;">Administration</h2>

    <?php if (isset($_GET['msg'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= htmlspecialchars($_GET['msg']) ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['err'])): ?>
        <div class="alert alert-danger alert-dismissible fade show">
            <?= htmlspecialchars($_GET['err']) ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <ul class="nav nav-tabs mb-4">
        <li class="nav-item"><a class="nav-link <?= $tab === 'users'        ? 'active' : '' ?>" href="admin.php?tab=users">Utilisateurs</a></li>
        <li class="nav-item"><a class="nav-link <?= $tab === 'competitions' ? 'active' : '' ?>" href="admin.php?tab=competitions">Compétitions</a></li>
        <li class="nav-item"><a class="nav-link <?= $tab === 'clubs'        ? 'active' : '' ?>" href="admin.php?tab=clubs">Clubs</a></li>
        <li class="nav-item"><a class="nav-link <?= $tab === 'pays'         ? 'active' : '' ?>" href="admin.php?tab=pays">Pays</a></li>
        <li class="nav-item"><a class="nav-link <?= $tab === 'stats'        ? 'active' : '' ?>" href="admin.php?tab=stats">Stats</a></li>
    </ul>

    <?php if ($tab === 'users'): ?>
    <!-- ===================== UTILISATEURS ===================== -->
    <?php
    $users = $pdo->query("SELECT idUser, username, mail, type, saison_active, club, division, genre FROM user ORDER BY idUser")->fetchAll();
    ?>
    <div class="card">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">
            Utilisateurs (<?= count($users) ?>)
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-sm table-hover table-striped mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Nom</th>
                            <th>Email</th>
                            <th>Type</th>
                            <th>Saison</th>
                            <th>Club</th>
                            <th>Genre</th>
                            <th>Division</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($users as $u): ?>
                        <tr>
                            <td><?= $u['idUser'] ?></td>
                            <td><?= htmlspecialchars($u['username']) ?></td>
                            <td><?= htmlspecialchars($u['mail']) ?></td>
                            <td>
                                <span class="badge <?= $u['type'] === '1' ? 'bg-danger' : 'bg-secondary' ?>">
                                    <?= $u['type'] === '1' ? 'Admin' : 'User' ?>
                                </span>
                            </td>
                            <td><?= htmlspecialchars($u['saison_active'] ?? '—') ?></td>
                            <td><?= htmlspecialchars($u['club'] ?? '—') ?></td>
                            <td><?= htmlspecialchars($u['genre'] ?? '—') ?></td>
                            <td><?= htmlspecialchars($u['division'] ?? '—') ?></td>
                            <td class="d-flex gap-1 align-items-center">
                                <button class="btn btn-sm btn-warning" title="Réinitialiser le mot de passe"
                                    data-bs-toggle="modal" data-bs-target="#modalResetPwd"
                                    data-id="<?= $u['idUser'] ?>"
                                    data-name="<?= htmlspecialchars($u['username']) ?>">
                                    <ion-icon name="key-outline"></ion-icon>
                                </button>
                                <?php if ($u['idUser'] != $_SESSION['idUser']): ?>
                                <form action="admin_post.php" method="post" style="display:contents"
                                      onsubmit="return confirm('Changer le type de <?= htmlspecialchars($u['username'], ENT_QUOTES) ?> en <?= $u['type'] === '1' ? 'User' : 'Admin' ?> ?')">
                                    <?= csrf_field() ?>
                                    <input type="hidden" name="action" value="toggle_user_type">
                                    <input type="hidden" name="idUser" value="<?= $u['idUser'] ?>">
                                    <button class="btn btn-sm <?= $u['type'] === '1' ? 'btn-outline-secondary' : 'btn-outline-success' ?>"
                                            title="<?= $u['type'] === '1' ? 'Rétrograder en User' : 'Promouvoir en Admin' ?>">
                                        <ion-icon name="<?= $u['type'] === '1' ? 'arrow-down-outline' : 'arrow-up-outline' ?>"></ion-icon>
                                    </button>
                                </form>
                                <form action="admin_post.php" method="post" style="display:contents"
                                      onsubmit="return confirm('Supprimer cet utilisateur et toutes ses données ?')">
                                    <?= csrf_field() ?>
                                    <input type="hidden" name="action" value="delete_user">
                                    <input type="hidden" name="idUser" value="<?= $u['idUser'] ?>">
                                    <button class="btn btn-sm btn-outline-danger" title="Supprimer">
                                        <ion-icon name="trash-outline"></ion-icon>
                                    </button>
                                </form>
                                <?php else: ?>
                                <span class="text-muted small">Vous</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal reset password -->
    <div class="modal fade" id="modalResetPwd" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Réinitialiser le mot de passe</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="reset_password">
                    <input type="hidden" name="idUser" id="resetPwdId">
                    <div class="modal-body">
                        <p class="text-muted small mb-3">Utilisateur : <strong id="resetPwdName"></strong></p>
                        <div class="mb-3">
                            <label class="form-label">Nouveau mot de passe</label>
                            <input type="password" name="new_password" class="form-control" required minlength="6">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Confirmer</label>
                            <input type="password" name="confirm_password" class="form-control" required minlength="6">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-warning">Réinitialiser</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
    document.getElementById('modalResetPwd').addEventListener('show.bs.modal', function(e) {
        const btn = e.relatedTarget;
        document.getElementById('resetPwdId').value   = btn.dataset.id;
        document.getElementById('resetPwdName').textContent = btn.dataset.name;
    });
    </script>

    <?php elseif ($tab === 'competitions'): ?>
    <!-- ===================== COMPÉTITIONS ===================== -->
    <?php
    $pays_list = $pdo->query("SELECT idPays, nomPays FROM pays ORDER BY nomPays")->fetchAll();
    $pays_json = json_encode(array_column($pays_list, 'nomPays', 'idPays'));
    $comps = $pdo->query("
        SELECT c.*, p.nomPays
        FROM competition c
        LEFT JOIN pays p ON p.idPays = c.idPays
        ORDER BY p.nomPays, c.genre, c.typeCompetition, c.division
    ")->fetchAll();
    ?>
    <div class="card mb-4">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">
            Ajouter une compétition
        </div>
        <div class="card-body">
            <form action="admin_post.php" method="post" class="row g-2">
                <?= csrf_field() ?>
                <input type="hidden" name="action" value="add_competition">
                <div class="col-md-3">
                    <input type="text" name="nomCompetition" class="form-control form-control-sm" placeholder="Nom" required>
                </div>
                <div class="col-md-2">
                    <select name="typeCompetition" class="form-select form-select-sm" required>
                        <option value="">Type…</option>
                        <option>Championnat</option><option>Ligue</option>
                        <option>Nationale</option><option>Continentale</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="idPays" class="form-select form-select-sm" required>
                        <option value="">Pays…</option>
                        <?php foreach ($pays_list as $p): ?>
                            <option value="<?= $p['idPays'] ?>"><?= htmlspecialchars($p['nomPays']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="col-md-1">
                    <select name="division" class="form-select form-select-sm">
                        <option value="">Div…</option>
                        <option>D1</option><option>D2</option><option>D3</option>
                    </select>
                </div>
                <div class="col-md-1">
                    <select name="genre" class="form-select form-select-sm" required>
                        <option value="">Genre</option>
                        <option value="M">M</option><option value="F">F</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-primary">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
    <div class="card">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">
            Compétitions (<?= count($comps) ?>)
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-sm table-hover table-striped mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th><th>Nom</th><th>Type</th><th>Pays</th>
                            <th>Division</th><th>Genre</th><th>Qualif.</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($comps as $c): ?>
                        <tr>
                            <td><?= $c['idCompetition'] ?></td>
                            <td><?= htmlspecialchars($c['nomCompetition']) ?></td>
                            <td><span class="badge bg-secondary"><?= $c['typeCompetition'] ?></span></td>
                            <td><?= htmlspecialchars($c['nomPays'] ?? '—') ?></td>
                            <td><?= htmlspecialchars($c['division'] ?? '—') ?></td>
                            <td><?= $c['genre'] ?></td>
                            <td class="text-muted small">
                                <?php if ($c['qualif_rang_min'] !== null): ?>
                                    <?= $c['qualif_rang_min'] ?>–<?= $c['qualif_rang_max'] ?>
                                <?php else: ?>—<?php endif; ?>
                            </td>
                            <td class="d-flex gap-1 align-items-center">
                                <button class="btn btn-sm btn-outline-primary" title="Modifier"
                                    data-bs-toggle="modal" data-bs-target="#modalEditComp"
                                    data-id="<?= $c['idCompetition'] ?>"
                                    data-nom="<?= htmlspecialchars($c['nomCompetition']) ?>"
                                    data-type="<?= $c['typeCompetition'] ?>"
                                    data-pays="<?= $c['idPays'] ?>"
                                    data-division="<?= $c['division'] ?? '' ?>"
                                    data-genre="<?= $c['genre'] ?>"
                                    data-qualifmin="<?= $c['qualif_rang_min'] ?? '' ?>"
                                    data-qualifmax="<?= $c['qualif_rang_max'] ?? '' ?>">
                                    <ion-icon name="pencil-outline"></ion-icon>
                                </button>
                                <form action="admin_post.php" method="post" style="display:contents"
                                      onsubmit="return confirm('Supprimer cette compétition ?')">
                                    <?= csrf_field() ?>
                                    <input type="hidden" name="action" value="delete_competition">
                                    <input type="hidden" name="idCompetition" value="<?= $c['idCompetition'] ?>">
                                    <button class="btn btn-sm btn-outline-danger" title="Supprimer">
                                        <ion-icon name="trash-outline"></ion-icon>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal edit compétition -->
    <div class="modal fade" id="modalEditComp" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier la compétition</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="edit_competition">
                    <input type="hidden" name="idCompetition" id="editCompId">
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nomCompetition" id="editCompNom" class="form-control" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Type</label>
                            <select name="typeCompetition" id="editCompType" class="form-select" required>
                                <option>Championnat</option><option>Ligue</option>
                                <option>Nationale</option><option>Continentale</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Pays</label>
                            <select name="idPays" id="editCompPays" class="form-select" required>
                                <?php foreach ($pays_list as $p): ?>
                                    <option value="<?= $p['idPays'] ?>"><?= htmlspecialchars($p['nomPays']) ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Division</label>
                            <select name="division" id="editCompDiv" class="form-select">
                                <option value="">—</option>
                                <option>D1</option><option>D2</option><option>D3</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Genre</label>
                            <select name="genre" id="editCompGenre" class="form-select" required>
                                <option value="M">M</option><option value="F">F</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Qualif. rang min</label>
                            <input type="number" name="qualif_rang_min" id="editCompQualifMin" class="form-control" min="1" max="20" placeholder="ex: 1">
                        </div>
                        <div class="col-6">
                            <label class="form-label">Qualif. rang max</label>
                            <input type="number" name="qualif_rang_max" id="editCompQualifMax" class="form-control" min="1" max="20" placeholder="ex: 3">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
    document.getElementById('modalEditComp').addEventListener('show.bs.modal', function(e) {
        const b = e.relatedTarget;
        document.getElementById('editCompId').value       = b.dataset.id;
        document.getElementById('editCompNom').value      = b.dataset.nom;
        document.getElementById('editCompType').value     = b.dataset.type;
        document.getElementById('editCompPays').value     = b.dataset.pays;
        document.getElementById('editCompDiv').value      = b.dataset.division;
        document.getElementById('editCompGenre').value    = b.dataset.genre;
        document.getElementById('editCompQualifMin').value = b.dataset.qualifmin || '';
        document.getElementById('editCompQualifMax').value = b.dataset.qualifmax || '';
    });
    </script>

    <?php elseif ($tab === 'clubs'): ?>
    <!-- ===================== CLUBS ===================== -->
    <?php
    $pays_list = $pdo->query("SELECT idPays, nomPays FROM pays ORDER BY nomPays")->fetchAll();
    $clubs = $pdo->query("
        SELECT e.*, p.nomPays
        FROM equipe e
        LEFT JOIN pays p ON p.idPays = e.idPays
        ORDER BY p.nomPays, e.genre, e.division, e.nomEquipe
    ")->fetchAll();
    ?>
    <div class="card mb-4">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">
            Ajouter un club
        </div>
        <div class="card-body">
            <form action="admin_post.php" method="post" class="row g-2">
                <?= csrf_field() ?>
                <input type="hidden" name="action" value="add_club">
                <div class="col-md-3">
                    <input type="text" name="nomEquipe" class="form-control form-control-sm" placeholder="Nom du club" required>
                </div>
                <div class="col-md-2">
                    <select name="idPays" class="form-select form-select-sm" required>
                        <option value="">Pays…</option>
                        <?php foreach ($pays_list as $p): ?>
                            <option value="<?= $p['idPays'] ?>"><?= htmlspecialchars($p['nomPays']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="col-md-1">
                    <select name="genre" class="form-select form-select-sm" required>
                        <option value="">Genre</option>
                        <option value="M">M</option><option value="F">F</option>
                    </select>
                </div>
                <div class="col-md-1">
                    <select name="division" class="form-select form-select-sm" required>
                        <option value="">Div…</option>
                        <option>D1</option><option>D2</option><option>D3</option><option>D4</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-sm btn-primary">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center fw-bold" style="background:#091c3e; color:#fff;">
            <span>Clubs (<?= count($clubs) ?>)</span>
            <input type="text" id="filterClub" class="form-control form-control-sm ms-3" placeholder="Rechercher…" style="max-width:200px; color:#000;">
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-sm table-hover table-striped mb-0" id="clubTable">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th><th>Nom</th><th>Pays</th><th>Genre</th>
                            <th>Division</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($clubs as $e): ?>
                        <tr>
                            <td><?= $e['idEquipe'] ?></td>
                            <td><?= htmlspecialchars($e['nomEquipe']) ?></td>
                            <td><?= htmlspecialchars($e['nomPays'] ?? '—') ?></td>
                            <td><?= $e['genre'] ?></td>
                            <td><?= $e['division'] ?></td>
                            <td class="d-flex gap-1 align-items-center">
                                <button class="btn btn-sm btn-outline-primary" title="Modifier"
                                    data-bs-toggle="modal" data-bs-target="#modalEditClub"
                                    data-id="<?= $e['idEquipe'] ?>"
                                    data-nom="<?= htmlspecialchars($e['nomEquipe']) ?>"
                                    data-pays="<?= $e['idPays'] ?>"
                                    data-genre="<?= $e['genre'] ?>"
                                    data-division="<?= $e['division'] ?>">
                                    <ion-icon name="pencil-outline"></ion-icon>
                                </button>
                                <form action="admin_post.php" method="post" style="display:contents"
                                      onsubmit="return confirm('Supprimer ce club ?')">
                                    <?= csrf_field() ?>
                                    <input type="hidden" name="action" value="delete_club">
                                    <input type="hidden" name="idEquipe" value="<?= $e['idEquipe'] ?>">
                                    <button class="btn btn-sm btn-outline-danger" title="Supprimer">
                                        <ion-icon name="trash-outline"></ion-icon>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
    document.getElementById('filterClub').addEventListener('input', function() {
        const q = this.value.toLowerCase();
        document.querySelectorAll('#clubTable tbody tr').forEach(tr => {
            tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    });
    </script>

    <!-- Modal edit club -->
    <div class="modal fade" id="modalEditClub" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier le club</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="edit_club">
                    <input type="hidden" name="idEquipe" id="editClubId">
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label">Nom du club</label>
                            <input type="text" name="nomEquipe" id="editClubNom" class="form-control" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Pays</label>
                            <select name="idPays" id="editClubPays" class="form-select" required>
                                <?php foreach ($pays_list as $p): ?>
                                    <option value="<?= $p['idPays'] ?>"><?= htmlspecialchars($p['nomPays']) ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="col-3">
                            <label class="form-label">Genre</label>
                            <select name="genre" id="editClubGenre" class="form-select" required>
                                <option value="M">M</option><option value="F">F</option>
                            </select>
                        </div>
                        <div class="col-3">
                            <label class="form-label">Division</label>
                            <select name="division" id="editClubDiv" class="form-select" required>
                                <option>D1</option><option>D2</option><option>D3</option><option>D4</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
    document.getElementById('modalEditClub').addEventListener('show.bs.modal', function(e) {
        const b = e.relatedTarget;
        document.getElementById('editClubId').value       = b.dataset.id;
        document.getElementById('editClubNom').value      = b.dataset.nom;
        document.getElementById('editClubPays').value     = b.dataset.pays;
        document.getElementById('editClubGenre').value    = b.dataset.genre;
        document.getElementById('editClubDiv').value      = b.dataset.division;
    });
    </script>

    <?php elseif ($tab === 'pays'): ?>
    <!-- ===================== PAYS ===================== -->
    <?php
    $paysList = $pdo->query("SELECT * FROM pays ORDER BY nomPays")->fetchAll();
    ?>
    <div class="card mb-4">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">
            Ajouter un pays
        </div>
        <div class="card-body">
            <form action="admin_post.php" method="post" class="row g-2">
                <?= csrf_field() ?>
                <input type="hidden" name="action" value="add_pays">
                <div class="col-md-3">
                    <input type="text" name="nomPays" class="form-control form-control-sm" placeholder="Nom du pays" required>
                </div>
                <div class="col-md-2">
                    <input type="text" name="paysA2C" class="form-control form-control-sm" placeholder="Code A2 (ex: FR)" maxlength="2" required>
                </div>
                <div class="col-md-2">
                    <input type="text" name="paysA3C" class="form-control form-control-sm" placeholder="Code A3 (ex: FRA)" maxlength="3">
                </div>
                <div class="col-md-2">
                    <input type="number" name="paysNum" class="form-control form-control-sm" placeholder="Code numérique">
                </div>
                <div class="col-md-1">
                    <button type="submit" class="btn btn-sm btn-primary">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
    <div class="card">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">
            Pays (<?= count($paysList) ?>)
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-sm table-hover table-striped mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th><th>Nom</th><th>A2</th><th>A3</th><th>Num</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($paysList as $p): ?>
                        <tr>
                            <td><?= $p['idPays'] ?></td>
                            <td><?= htmlspecialchars($p['nomPays']) ?></td>
                            <td><?= htmlspecialchars($p['paysA2C'] ?? '') ?></td>
                            <td><?= htmlspecialchars($p['paysA3C'] ?? '') ?></td>
                            <td><?= $p['paysNum'] ?? '' ?></td>
                            <td class="d-flex gap-1 align-items-center">
                                <button class="btn btn-sm btn-outline-primary" title="Modifier"
                                    data-bs-toggle="modal" data-bs-target="#modalEditPays"
                                    data-id="<?= $p['idPays'] ?>"
                                    data-nom="<?= htmlspecialchars($p['nomPays']) ?>"
                                    data-a2="<?= htmlspecialchars($p['paysA2C'] ?? '') ?>"
                                    data-a3="<?= htmlspecialchars($p['paysA3C'] ?? '') ?>"
                                    data-num="<?= $p['paysNum'] ?? '' ?>">
                                    <ion-icon name="pencil-outline"></ion-icon>
                                </button>
                                <form action="admin_post.php" method="post" style="display:contents"
                                      onsubmit="return confirm('Supprimer ce pays ? Cela peut affecter les clubs et compétitions liés.')">
                                    <?= csrf_field() ?>
                                    <input type="hidden" name="action" value="delete_pays">
                                    <input type="hidden" name="idPays" value="<?= $p['idPays'] ?>">
                                    <button class="btn btn-sm btn-outline-danger" title="Supprimer">
                                        <ion-icon name="trash-outline"></ion-icon>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal edit pays -->
    <div class="modal fade" id="modalEditPays" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier le pays</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="edit_pays">
                    <input type="hidden" name="idPays" id="editPaysId">
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nomPays" id="editPaysNom" class="form-control" required>
                        </div>
                        <div class="col-4">
                            <label class="form-label">Code A2</label>
                            <input type="text" name="paysA2C" id="editPaysA2" class="form-control" maxlength="2" required>
                        </div>
                        <div class="col-4">
                            <label class="form-label">Code A3</label>
                            <input type="text" name="paysA3C" id="editPaysA3" class="form-control" maxlength="3">
                        </div>
                        <div class="col-4">
                            <label class="form-label">Code numérique</label>
                            <input type="number" name="paysNum" id="editPaysNum" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
    document.getElementById('modalEditPays').addEventListener('show.bs.modal', function(e) {
        const b = e.relatedTarget;
        document.getElementById('editPaysId').value  = b.dataset.id;
        document.getElementById('editPaysNom').value = b.dataset.nom;
        document.getElementById('editPaysA2').value  = b.dataset.a2;
        document.getElementById('editPaysA3').value  = b.dataset.a3;
        document.getElementById('editPaysNum').value = b.dataset.num;
    });
    </script>

    <?php elseif ($tab === 'stats'): ?>
    <!-- ===================== STATS GLOBALES ===================== -->
    <?php
    $nbUsers     = $pdo->query("SELECT COUNT(*) FROM user")->fetchColumn();
    $nbJoueurs   = $pdo->query("SELECT COUNT(*) FROM joueur")->fetchColumn();
    $nbClubs     = $pdo->query("SELECT COUNT(*) FROM equipe")->fetchColumn();
    $nbComps     = $pdo->query("SELECT COUNT(*) FROM competition")->fetchColumn();
    $nbPays      = $pdo->query("SELECT COUNT(*) FROM pays")->fetchColumn();
    $nbSaisons   = $pdo->query("SELECT COUNT(*) FROM saison_meta")->fetchColumn();
    $nbObjectifs = $pdo->query("SELECT COUNT(*) FROM objectif")->fetchColumn();
    $statsParUser = $pdo->query("
        SELECT u.username, u.mail, COUNT(j.idJoueur) as nb_joueurs
        FROM user u
        LEFT JOIN joueur j ON j.idUser = u.idUser
        GROUP BY u.idUser
        ORDER BY nb_joueurs DESC
    ")->fetchAll();
    ?>
    <div class="row g-3 mb-4">
        <?php
        $cards = [
            ['Utilisateurs',     $nbUsers,     'primary'],
            ['Joueurs importés', $nbJoueurs,   'info'],
            ['Clubs',            $nbClubs,     'secondary'],
            ['Compétitions',     $nbComps,     'warning'],
            ['Pays',             $nbPays,      'dark'],
            ['Saisons jouées',   $nbSaisons,   'success'],
            ['Objectifs',        $nbObjectifs, 'danger'],
        ];
        foreach ($cards as [$label, $val, $color]):
        ?>
        <div class="col-6 col-md-3">
            <div class="card border-<?= $color ?> text-center">
                <div class="card-body py-3">
                    <div class="fs-1 fw-bold text-<?= $color ?>"><?= $val ?></div>
                    <div class="small text-muted"><?= $label ?></div>
                </div>
            </div>
        </div>
        <?php endforeach; ?>
    </div>
    <div class="card">
        <div class="card-header fw-bold" style="background:#091c3e; color:#fff;">Effectifs par utilisateur</div>
        <div class="card-body p-0">
            <table class="table table-sm table-striped mb-0">
                <thead class="table-dark">
                    <tr><th>Utilisateur</th><th>Email</th><th>Joueurs importés</th></tr>
                </thead>
                <tbody>
                    <?php foreach ($statsParUser as $s): ?>
                    <tr>
                        <td><?= htmlspecialchars($s['username']) ?></td>
                        <td><?= htmlspecialchars($s['mail']) ?></td>
                        <td><?= $s['nb_joueurs'] ?></td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
    <?php endif; ?>

</div>
<?php require_once("footer.php"); ?>
</body>
