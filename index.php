<?php
session_start();
require_once("db.php");
require_once("head.php");
require_once("navbar.php");
require_once("auth_check.php");

if (!isset($_SESSION['mail'])) {
    ?>
    <div style="background:linear-gradient(135deg,#091c3e 0%,#0d2a5e 60%,#091c3e 100%); min-height:calc(100vh - 120px); display:flex; align-items:center;">
        <div class="container py-5">

            <!-- Hero -->
            <div class="text-center mb-5">
                <div class="mb-3">
                    <img src="assets/pictures/fmxx_logo.png" alt="FMXX Logo" height="100" style="object-fit:contain;">
                </div>
                <h1 class="display-4 fw-bold mb-2" style="color:#fff; letter-spacing:-1px;">
                    FM<span style="color:#d52228;">XX</span> Tools
                </h1>
                <p class="lead mb-4" style="color:#a8c0e8; max-width:520px; margin:0 auto;">
                    <?= $t['landing_tagline'] ?>
                </p>
                <div class="d-flex gap-3 justify-content-center">
                    <button class="btn btn-lg px-4 fw-semibold" style="background:#d52228; border:none; color:#fff;"
                            data-bs-toggle="modal" data-bs-target="#LoginModal">
                        <?= $t['landing_login'] ?>
                    </button>
                    <button class="btn btn-lg px-4 fw-semibold btn-outline-light"
                            data-bs-toggle="modal" data-bs-target="#SignupModal">
                        <?= $t['landing_signup'] ?>
                    </button>
                </div>
            </div>

            <!-- Feature cards -->
            <div class="row g-4 justify-content-center">
                <div class="col-md-4">
                    <div class="rounded-3 p-4 h-100" style="background:rgba(255,255,255,.07); border:1px solid rgba(255,255,255,.12);">
                        <div class="fs-2 mb-2">🎯</div>
                        <h5 class="fw-bold mb-1" style="color:#16ffd0;"><?= $t['landing_feat1_title'] ?></h5>
                        <p class="mb-0 small" style="color:#a8c0e8;"><?= $t['landing_feat1_text'] ?></p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="rounded-3 p-4 h-100" style="background:rgba(255,255,255,.07); border:1px solid rgba(255,255,255,.12);">
                        <div class="fs-2 mb-2">🗂️</div>
                        <h5 class="fw-bold mb-1" style="color:#16ffd0;"><?= $t['landing_feat2_title'] ?></h5>
                        <p class="mb-0 small" style="color:#a8c0e8;"><?= $t['landing_feat2_text'] ?></p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="rounded-3 p-4 h-100" style="background:rgba(255,255,255,.07); border:1px solid rgba(255,255,255,.12);">
                        <div class="fs-2 mb-2">📋</div>
                        <h5 class="fw-bold mb-1" style="color:#16ffd0;"><?= $t['landing_feat3_title'] ?></h5>
                        <p class="mb-0 small" style="color:#a8c0e8;"><?= $t['landing_feat3_text'] ?></p>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <?php
    require_once("footer.php");
    exit;
}

$idUser = $_SESSION['idUser'];

// Formations disponibles → positions pour la Tactic Sub
const FORMATIONS = [
    '4-3-3'     => ['GK','DC','DC','DL','DR','MC','MC','MC','AL','AR','BU'],
    '4-4-2'     => ['GK','DC','DC','DL','DR','MG','MC','MC','MD','BU','BU'],
    '4-2-3-1'   => ['GK','DC','DC','DL','DR','MC','MC','MO','AL','AR','BU'],
    '3-5-2'     => ['GK','DC','DC','DC','MG','MC','MC','MC','MD','BU','BU'],
    '5-3-2'     => ['GK','DC','DC','DC','DL','DR','MC','MC','MC','BU','BU'],
    '4-1-2-1-2' => ['GK','DC','DC','DL','DR','MC','MG','MD','MO','BU','BU'],
];

// Charger la formation depuis la session ou la BDD
if (empty($_SESSION['formation'])) {
    $r = $pdo->prepare("SELECT formation FROM user WHERE idUser = :id");
    $r->execute(['id' => $idUser]);
    $_SESSION['formation'] = $r->fetchColumn() ?: '4-3-3';
}
$formation = $_SESSION['formation'];
$positions = FORMATIONS[$formation] ?? FORMATIONS['4-3-3'];

// Chargement effectif
$stmt = $pdo->prepare("SELECT * FROM joueur WHERE idUser = :idUser ORDER BY poste, nom");
$stmt->execute(['idUser' => $idUser]);
$joueurs = $stmt->fetchAll();

$joueursDispo = array_filter($joueurs, fn($j) => $j['mercato_status'] === null);

// Calcul âge moyen
$ages = array_column($joueurs, 'age');
$ageMoyen = count($ages) > 0 ? round(array_sum($ages) / count($ages), 1) : null;

// Charger les paramètres user depuis la session ou la BDD
if (empty($_SESSION['idPays'])) {
    $u = $pdo->prepare("SELECT club, idPays, genre, division FROM user WHERE idUser = :id");
    $u->execute(['id' => $idUser]);
    $uRow = $u->fetch();
    $_SESSION['club']     = $uRow['club']     ?? '';
    $_SESSION['idPays']   = $uRow['idPays']   ?? null;
    $_SESSION['genre']    = $uRow['genre']    ?? 'M';
    $_SESSION['division'] = $uRow['division'] ?? null;
}
$nomClub  = $_SESSION['club']     ?? '';
$idPays   = $_SESSION['idPays']   ?? null;
$genre    = $_SESSION['genre']    ?? 'M';
$division = $_SESSION['division'] ?? null;

// Budgets
$bStmt = $pdo->prepare("SELECT budget_transfert, budget_salaires FROM user WHERE idUser = :id");
$bStmt->execute(['id' => $idUser]);
$budgets = $bStmt->fetch();
$budgetTransfert = $budgets['budget_transfert'];
$budgetSalaires  = $budgets['budget_salaires'];

// Saison active
if (empty($_SESSION['saison_active'])) {
    $r = $pdo->prepare("SELECT saison_active FROM user WHERE idUser = :id");
    $r->execute(['id' => $idUser]);
    $_SESSION['saison_active'] = $r->fetchColumn() ?: date('Y') . '/' . (date('Y') + 1);
}
$saison        = $_SESSION['saison_active'];
$saisonFin     = (int)(explode('/', $saison)[1] ?? date('Y') + 1);
$saisonFinNext = $saisonFin + 1;

// Compétitions applicables + objectifs sauvegardés
$competitions = [];
if ($idPays && $division) {
    $cStmt = $pdo->prepare("
        SELECT c.*, COALESCE(o.objectif, '') as objectif, o.resultat
        FROM competition c
        LEFT JOIN objectif o ON o.idCompetition = c.idCompetition AND o.idUser = :idUser AND o.saison = :saison
        WHERE c.genre = :genre
          AND (
            (c.typeCompetition = 'Championnat' AND c.idPays = :idPays1 AND c.division = :division1)
            OR (c.typeCompetition IN ('Nationale','Ligue') AND c.idPays = :idPays2)
            OR (c.typeCompetition = 'Continentale' AND :division2 = 'D1')
          )
        ORDER BY FIELD(c.typeCompetition,'Championnat','Ligue','Nationale','Continentale'),c.qualif_rang_min
    ");
    $cStmt->execute([
        'idUser'    => $idUser,
        'saison'    => $saison,
        'genre'     => $genre,
        'idPays1'   => $idPays,
        'idPays2'   => $idPays,
        'division1' => $division,
        'division2' => $division,
    ]);
    $competitions = $cStmt->fetchAll();
}

// Onglet actif : détecté depuis l'URL ou les paramètres de retour
if (isset($_GET['tab'])) {
    $activeTab = $_GET['tab'];
} elseif (isset($_GET['success']) || isset($_GET['error'])) {
    $activeTab = 'effectif';
} elseif (isset($_GET['objectifs'])) {
    $activeTab = 'objectifs';
} elseif (isset($_GET['tactic'])) {
    $activeTab = 'tactic';
} else {
    $activeTab = 'objectifs';
}

// Options par type de compétition
$optionsParType = [
    'Championnat' => array_merge(
        ['' => '— Objectif —'],
        array_combine(
            array_map(fn($i) => $i === 1 ? '1er' : $i . 'ème', range(1, 20)),
            range(1, 20)
        )
    ),
    'Ligue' => [
        '' => '— Objectif —',
        'Gagner'          => 1,
        'Finale'          => 2,
        'Demi-finale'     => 3,
        'Quarts'          => 4,
        '8ème de finale'  => 5,
        '16ème de finale' => 6,
    ],
    'Nationale' => [
        '' => '— Objectif —',
        'Gagner'          => 1,
        'Finale'          => 2,
        'Demi-finale'     => 3,
        'Quarts'          => 4,
        '8ème de finale'  => 5,
        '16ème de finale' => 6,
    ],
    'Continentale' => [
        '' => '— Objectif —',
        'Gagner'           => 1,
        'Finale'           => 2,
        'Demi-finale'      => 3,
        'Quarts'           => 4,
        '8ème de finale'   => 5,
        'Phase de groupes' => 6,
    ],
];

$ranking = [];
foreach ($optionsParType as $opts) {
    foreach ($opts as $label => $rank) {
        if ($label !== '') $ranking[$label] = $rank;
    }
}

// Compétition européenne forcée (paramètres) ou déduite du rang championnat
$overrideStmt = $pdo->prepare("SELECT comp_europe_override FROM user WHERE idUser = :id");
$overrideStmt->execute(['id' => $idUser]);
$compEuropeOverride = $overrideStmt->fetchColumn();

$champRank = null;
foreach ($competitions as $c) {
    if ($c['typeCompetition'] === 'Championnat' && $c['objectif'] !== '') {
        $champRank = $ranking[$c['objectif']] ?? null;
        break;
    }
}
$competitions = array_values(array_filter($competitions, function($c) use ($champRank, $compEuropeOverride) {
    if ($c['typeCompetition'] !== 'Continentale') return true;
    if ($compEuropeOverride) return (int)$c['idCompetition'] === (int)$compEuropeOverride;
    if ($champRank === null) return false;
    $min = $c['qualif_rang_min'];
    $max = $c['qualif_rang_max'];
    return $min !== null && $max !== null && $champRank >= (int)$min && $champRank <= (int)$max;
}));

$totalAvecObjectif = 0; $reussites = 0;
foreach ($competitions as $c) {
    if ($c['objectif'] && $c['resultat']) {
        $totalAvecObjectif++;
        $rObj = $ranking[$c['objectif']] ?? 99;
        $rRes = $ranking[$c['resultat']] ?? 99;
        if ($rRes <= $rObj) $reussites++;
    }
}
$pct      = $totalAvecObjectif > 0 ? round($reussites / $totalAvecObjectif * 100) : null;
$pctColor = $pct === null ? 'secondary' : ($pct >= 75 ? 'success' : ($pct >= 50 ? 'warning' : 'danger'));

// Graphiques effectif
if (count($joueurs) > 0) {
    $catPoste = function(string $poste): string {
        $tokens = array_filter(preg_split('/[\s,\/\-]+/', strtoupper(trim($poste))));
        $best = 99; $result = 'Autre';
        foreach ($tokens as $t) {
            if (preg_match('/^(GK|GB|TW|PO|GL|GR|P)$/', $t))
                [$rank, $cat] = [0, 'Gardien'];
            elseif (preg_match('/^(DC|DL|DR|DG|DD|DI|WBL|WBR|WB|SW|CB|LB|RB|IV|ZV|LAT|TS|TD|TI|LCD|RCD)$/', $t))
                [$rank, $cat] = [1, 'Défense'];
            elseif (preg_match('/^(MC|ML|MR|MG|MD|MO|MDC|MOC|MLC|MRC|DM|DML|DMR|AM|AML|AMR|AMC|ZM|OM|LM|RM|CC|TRQ|VOL|PIV|INI|CAI|CAO)$/', $t))
                [$rank, $cat] = [2, 'Milieu'];
            elseif (preg_match('/^(ST|STC|STL|STR|BU|AL|AR|IF|AG|AD|EI|ED|PC|FW|ATT|AK|SP)$/', $t))
                [$rank, $cat] = [3, 'Attaque'];
            else
                [$rank, $cat] = [99, 'Autre'];
            if ($rank < $best) { $best = $rank; $result = $cat; }
        }
        return $result;
    };
    $parCategorie = ['Gardien' => 0, 'Défense' => 0, 'Milieu' => 0, 'Attaque' => 0];
    foreach ($joueurs as $j) {
        $cat = $catPoste($j['poste'] ?? '');
        if (isset($parCategorie[$cat])) $parCategorie[$cat]++;
    }
    $parAge = array_count_values(array_filter(array_column($joueurs, 'age')));
    ksort($parAge);
}
?>
<body>
<div class="container-fluid px-4 py-3">

    <?php if (isset($_GET['account']) && $_GET['account'] === 'deleted'): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_account_deleted'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['error']) && $_GET['error'] === 'login'): ?>
        <div class="alert alert-danger alert-dismissible fade show">
            <?= $t['alert_login_error'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['success'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_squad_imported'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['error']) && $_GET['error'] === 'format'): ?>
        <div class="alert alert-danger alert-dismissible fade show">
            <?= $t['alert_format_error'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['objectifs'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_objectives_saved'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['tactic'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_tactic_saved'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['budget'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_budget_saved'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <!-- NAV TABS -->
    <ul class="nav nav-tabs mb-0" id="mainTabs">
        <li class="nav-item">
            <a class="nav-link <?= $activeTab === 'objectifs' ? 'active' : '' ?>"
               href="?tab=objectifs">
                <?= $t['tab_objectives'] ?>
                <?php if ($pct !== null): ?>
                    <span class="badge bg-<?= $pctColor ?> ms-1"><?= $pct ?> %</span>
                <?php endif; ?>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <?= $activeTab === 'effectif' ? 'active' : '' ?>"
               href="?tab=effectif">
                <?= $t['tab_squad'] ?>
                <?php if (count($joueurs) > 0): ?>
                    <span class="badge bg-secondary ms-1"><?= count($joueurs) ?></span>
                <?php endif; ?>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <?= $activeTab === 'tactic' ? 'active' : '' ?>"
               href="?tab=tactic">
                <?= $t['tab_tactic'] ?>
                <span class="badge bg-warning text-dark ms-1"><?= htmlspecialchars($formation) ?></span>
            </a>
        </li>
    </ul>

    <div class="tab-content border border-top-0 rounded-bottom p-3 mb-4 bg-white">

        <!-- ===================== ONGLET OBJECTIFS ===================== -->
        <div class="tab-pane <?= $activeTab === 'objectifs' ? 'show active' : '' ?>" id="pane-objectifs">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center py-2" style="background:#091c3e; color:#d52228;">
                    <div class="d-flex align-items-center gap-3 flex-wrap">
                        <span class="fs-4 fw-bold"><?= $t['card_objectives'] ?></span>
                        <span class="badge bg-light text-dark fw-bold fs-6"><?= htmlspecialchars($saison) ?></span>
                        <?php if ($nomClub): ?>
                            <span class="badge bg-secondary"><?= htmlspecialchars($nomClub) ?></span>
                        <?php endif; ?>
                        <?php if ($pct !== null): ?>
                            <span class="badge bg-<?= $pctColor ?> fs-6"><?= $pct ?> <?= $t['obj_success_rate'] ?></span>
                        <?php endif; ?>
                    </div>
                    <button class="btn btn-sm btn-outline-warning" data-bs-toggle="modal" data-bs-target="#settingModal"><?= $t['btn_settings'] ?></button>
                </div>
                <div class="card-body">
                    <?php if (!$idPays || !$division): ?>
                        <p class="text-muted mb-3"><?= $t['obj_no_config'] ?> <a href="#" data-bs-toggle="modal" data-bs-target="#settingModal">↗</a></p>
                    <?php elseif (empty($competitions)): ?>
                        <p class="text-muted mb-3"><?= $t['obj_no_competitions'] ?></p>
                    <?php else: ?>
                        <?php
                        $typeLabels = [
                            'Championnat'  => ['label' => $t['obj_type_league'],           'color' => 'primary'],
                            'Ligue'        => ['label' => $t['obj_type_cup_league'],        'color' => 'info'],
                            'Nationale'    => ['label' => $t['obj_type_cup_national'],      'color' => 'warning'],
                            'Continentale' => ['label' => $t['obj_type_cup_continental'],   'color' => 'success'],
                        ];
                        ?>
                        <form action="objectif_post.php" method="post">
                            <input type="hidden" name="saison" value="<?= htmlspecialchars($saison) ?>">
                            <?= csrf_field() ?>
                            <div class="row g-3">
                                <?php foreach ($competitions as $c):
                                    $type       = $c['typeCompetition'];
                                    $meta       = $typeLabels[$type] ?? ['label' => $type, 'color' => 'secondary'];
                                    $opts       = $optionsParType[$type] ?? $optionsParType['Nationale'];
                                    $rObj       = $ranking[$c['objectif']] ?? null;
                                    $rRes       = $ranking[$c['resultat']] ?? null;
                                    $cardBorder = $meta['color'];
                                    if ($rObj && $rRes) {
                                        $cardBorder = $rRes <= $rObj ? 'success' : 'danger';
                                    }
                                ?>
                                <div class="col-md-3 col-sm-6">
                                    <div class="card h-100 border-<?= $cardBorder ?>">
                                        <div class="card-body p-3">
                                            <div class="small text-<?= $meta['color'] ?> fw-semibold mb-1"><?= $meta['label'] ?></div>
                                            <div class="fw-bold mb-2"><?= htmlspecialchars($c['nomCompetition']) ?></div>
                                            <label class="form-label small text-muted mb-1"><?= $t['obj_target'] ?></label>
                                            <select class="form-select form-select-sm mb-2" name="objectif[<?= $c['idCompetition'] ?>]">
                                                <?php foreach ($opts as $label => $rank): ?>
                                                    <option value="<?= $label ?>" <?= $c['objectif'] === $label ? 'selected' : '' ?>>
                                                        <?= $label ?: $t['obj_placeholder'] ?>
                                                    </option>
                                                <?php endforeach; ?>
                                            </select>
                                            <label class="form-label small text-muted mb-1"><?= $t['obj_result'] ?></label>
                                            <select class="form-select form-select-sm" name="resultat[<?= $c['idCompetition'] ?>]">
                                                <?php foreach ($opts as $label => $rank): ?>
                                                    <option value="<?= $label ?>" <?= ($c['resultat'] ?? '') === $label ? 'selected' : '' ?>>
                                                        <?= $label ?: $t['obj_result_placeholder'] ?>
                                                    </option>
                                                <?php endforeach; ?>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <?php endforeach; ?>
                            </div>
                            <div class="mt-3 d-flex gap-2">
                                <button type="submit" class="btn btn-sm btn-primary"><?= $t['btn_save'] ?></button>
                                <a href="saison_next.php" class="btn btn-sm btn-outline-secondary"
                                   onclick="return confirm(<?= htmlspecialchars(json_encode($t['confirm_next_season'])) ?>)">
                                    <?= $t['btn_next_season'] ?>
                                </a>
                            </div>
                        </form>
                    <?php endif; ?>
                </div>
            </div>

            <!-- BUDGET -->
            <div class="card mt-3">
                <div class="card-header py-2" style="background:#091c3e; color:#f0c040;">
                    <span class="fs-4 fw-bold"><?= $t['card_budget'] ?></span>
                </div>
                <div class="card-body">
                    <form action="budget_post.php" method="post" class="row g-3 align-items-end">
                        <?= csrf_field() ?>
                        <div class="col-md-3 col-sm-6">
                            <label class="form-label small text-muted mb-1"><?= $t['budget_transfer'] ?></label>
                            <div class="input-group input-group-sm">
                                <input type="number" name="budget_transfert" class="form-control"
                                       value="<?= $budgetTransfert !== null ? $budgetTransfert : '' ?>"
                                       placeholder="ex : 5000000" min="0">
                                <span class="input-group-text">€</span>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <label class="form-label small text-muted mb-1"><?= $t['budget_wages'] ?></label>
                            <div class="input-group input-group-sm">
                                <input type="number" name="budget_salaires" class="form-control"
                                       value="<?= $budgetSalaires !== null ? $budgetSalaires : '' ?>"
                                       placeholder="ex : 200000" min="0">
                                <span class="input-group-text">€</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-sm btn-primary"><?= $t['btn_save'] ?></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- ===================== ONGLET EFFECTIF ===================== -->
        <div class="tab-pane <?= $activeTab === 'effectif' ? 'show active' : '' ?>" id="pane-effectif">

            <?php if (count($joueurs) > 0): ?>
            <!-- Graphiques -->
            <div class="row g-3 mb-4">
                <div class="col-md-5">
                    <div class="card h-100">
                        <div class="card-body">
                            <h6 class="fw-bold text-muted mb-3"><?= $t['squad_chart_by_position'] ?></h6>
                            <canvas id="chartPostes" style="max-height:220px"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="card h-100">
                        <div class="card-body">
                            <h6 class="fw-bold text-muted mb-3"><?= $t['squad_chart_age_dist'] ?></h6>
                            <canvas id="chartAges" height="65"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <script>
            new Chart(document.getElementById('chartPostes'), {
                type: 'doughnut',
                data: {
                    labels: <?= json_encode(array_keys($parCategorie)) ?>,
                    datasets: [{
                        data: <?= json_encode(array_values($parCategorie)) ?>,
                        backgroundColor: ['#0d6efd','#198754','#ffc107','#dc3545'],
                        borderWidth: 2,
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'right', labels: { boxWidth: 12, font: { size: 11 } } } }
                }
            });
            new Chart(document.getElementById('chartAges'), {
                type: 'bar',
                data: {
                    labels: <?= json_encode(array_map('strval', array_keys($parAge))) ?>,
                    datasets: [{
                        label: 'Joueurs',
                        data: <?= json_encode(array_values($parAge)) ?>,
                        backgroundColor: '#0d6efd',
                        borderRadius: 3,
                    }]
                },
                options: {
                    scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } },
                    plugins: { legend: { display: false } }
                }
            });
            </script>
            <?php endif; ?>

            <!-- Tableau effectif -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center py-2" style="background:#091c3e; color:#16ffd0;">
                    <span class="fs-4 fw-bold"><?= $t['card_squad'] ?></span>
                    <div class="d-flex gap-2">
                        <?php if (count($joueurs) > 0): ?>
                            <form action="deleteData.php" method="post" style="display:contents" onsubmit="return confirm(<?= htmlspecialchars(json_encode($t['confirm_clear_squad'])) ?>)">
                                <?= csrf_field() ?>
                                <button type="submit" class="btn btn-sm btn-outline-danger"><?= $t['btn_clear'] ?></button>
                            </form>
                        <?php else: ?>
                            <button class="btn btn-sm btn-outline-light" data-bs-toggle="modal" data-bs-target="#uploadModal"><?= $t['btn_import'] ?></button>
                        <?php endif; ?>
                    </div>
                </div>
                <div class="card-body p-0">
                    <?php if (count($joueurs) > 0): ?>
                        <?php
                        $expiresUrgent = array_filter($joueurs, function($j) use ($saisonFin) {
                            if (!$j['expireContrat']) return false;
                            $parts = explode('/', $j['expireContrat']);
                            return (int)end($parts) === $saisonFin;
                        });
                        ?>
                        <?php if (!empty($expiresUrgent)): ?>
                        <div class="alert alert-danger mb-0 rounded-0 border-0 border-bottom py-2 px-3">
                            <strong>⚠ <?= $t['squad_contract_alert'] ?> (<?= $saisonFin ?>) :</strong>
                            <?= implode(', ', array_map(fn($j) => htmlspecialchars($j['nom']), $expiresUrgent)) ?>
                        </div>
                        <?php endif; ?>
                        <?php
                        $postes = array_unique(array_filter(array_column($joueurs, 'poste')));
                        sort($postes);
                        $annees = array_unique(array_filter(array_map(function($j) {
                            if (!$j['expireContrat']) return null;
                            $parts = explode('/', $j['expireContrat']);
                            return end($parts);
                        }, $joueurs)));
                        sort($annees);
                        ?>
                        <div class="p-2 border-bottom d-flex flex-wrap gap-2 align-items-center">
                            <input type="text" id="filterNom" class="form-control form-control-sm" placeholder="<?= htmlspecialchars($t['squad_filter_name']) ?>" style="max-width:180px">
                            <select id="filterPoste" class="form-select form-select-sm" style="max-width:160px">
                                <option value=""><?= $t['squad_filter_position'] ?></option>
                                <?php foreach ($postes as $p): ?>
                                    <option><?= htmlspecialchars($p) ?></option>
                                <?php endforeach; ?>
                            </select>
                            <select id="filterExpire" class="form-select form-select-sm" style="max-width:160px">
                                <option value=""><?= $t['squad_filter_expiry'] ?></option>
                                <?php foreach ($annees as $a): ?>
                                    <option><?= htmlspecialchars($a) ?></option>
                                <?php endforeach; ?>
                            </select>
                            <select id="filterStatut" class="form-select form-select-sm" style="max-width:160px">
                                <option value=""><?= $t['squad_filter_status'] ?></option>
                                <option value="sell"><?= $t['squad_status_sell'] ?></option>
                                <option value="loan"><?= $t['squad_status_loan'] ?></option>
                                <option value="free"><?= $t['squad_status_free'] ?></option>
                            </select>
                            <button class="btn btn-sm btn-outline-secondary" onclick="resetFilters()"><?= $t['btn_reset_filters'] ?></button>
                            <span id="filterCount" class="text-muted small ms-1"></span>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-sm table-hover table-striped mb-0" id="effectifTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>#</th>
                                        <th data-sort="text" data-col="1" style="cursor:pointer"><?= $t['squad_col_name'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="2" style="cursor:pointer"><?= $t['squad_col_age'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th><?= $t['squad_col_number'] ?></th>
                                        <th><?= $t['squad_col_nat'] ?></th>
                                        <th><?= $t['squad_col_pob'] ?></th>
                                        <th data-sort="text" data-col="6" style="cursor:pointer"><?= $t['squad_col_position'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="7"  style="cursor:pointer"><?= $t['squad_col_apps'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="8"  style="cursor:pointer"><?= $t['squad_col_assists'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="9"  style="cursor:pointer"><?= $t['squad_col_goals'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="10" style="cursor:pointer"><?= $t['squad_col_rating'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="11" style="cursor:pointer"><?= $t['squad_col_value'] ?> <span class="sort-icon text-muted">↕</span></th>
                                        <th data-sort="num"  data-col="12" style="cursor:pointer"><?= $t['squad_col_expiry'] ?> <span class="sort-icon text-muted">↕</span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($joueurs as $i => $j): ?>
                                        <?php
                                        $rowClass = match($j['mercato_status']) {
                                            'sell' => 'table-danger',
                                            'loan' => 'table-primary',
                                            'free' => 'table-danger',
                                            default => ''
                                        };
                                        $expireYear  = '';
                                        $expireBadge = '';
                                        if ($j['expireContrat']) {
                                            $parts = explode('/', $j['expireContrat']);
                                            $expireYear = end($parts);
                                            if ((int)$expireYear === $saisonFin)
                                                $expireBadge = '<span class="badge bg-danger ms-3">⚠ ' . htmlspecialchars($t['squad_badge_expiry_this']) . '</span>';
                                            elseif ((int)$expireYear === $saisonFinNext)
                                                $expireBadge = '<span class="badge bg-warning text-dark ms-3">↗ ' . htmlspecialchars($t['squad_badge_expiry_next']) . '</span>';
                                        }
                                        ?>
                                        <tr class="<?= $rowClass ?>"
                                            data-nom="<?= htmlspecialchars(mb_strtolower($j['nom'] ?? '')) ?>"
                                            data-poste="<?= htmlspecialchars($j['poste'] ?? '') ?>"
                                            data-expire="<?= $expireYear ?>"
                                            data-statut="<?= $j['mercato_status'] ?? '' ?>">
                                            <td><?= $i + 1 ?></td>
                                            <td><a href="joueur.php?id=<?= $j['idJoueur'] ?>" class="text-decoration-none fw-semibold"><?= htmlspecialchars($j['nom'] ?? '') ?></a></td>
                                            <td><?= $j['age'] ?? '' ?></td>
                                            <td><?= $j['numero'] ?? '' ?></td>
                                            <td><?= htmlspecialchars($j['nat'] ?? '') ?></td>
                                            <td><?= htmlspecialchars($j['pdn'] ?? '') ?></td>
                                            <td><?= htmlspecialchars($j['poste'] ?? '') ?></td>
                                            <td><?= $j['app'] ?? '' ?></td>
                                            <td><?= $j['pDec'] ?? '' ?></td>
                                            <td><?= $j['buts'] ?? '' ?></td>
                                            <td><?= $j['noteMoy'] ?? '' ?></td>
                                            <td><?= $j['prixDemande'] !== null ? number_format((int)$j['prixDemande'], 0, ',', ' ') . ' €' : '' ?></td>
                                            <td><?= htmlspecialchars($j['expireContrat'] ?? '') ?><?= $expireBadge ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                                <tfoot class="table-secondary fw-bold">
                                    <tr>
                                        <td colspan="2"><?= count($joueurs) ?> <?= $t['squad_players'] ?></td>
                                        <td><?= $ageMoyen ?> <?= $t['squad_avg_age'] ?></td>
                                        <td colspan="10"></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        <script>
                        const rows = Array.from(document.querySelectorAll('#effectifTable tbody tr'));

                        function applyFilters() {
                            const nom    = document.getElementById('filterNom').value.toLowerCase().trim();
                            const poste  = document.getElementById('filterPoste').value;
                            const expire = document.getElementById('filterExpire').value;
                            const statut = document.getElementById('filterStatut').value;
                            let visible  = 0;
                            rows.forEach(row => {
                                const match =
                                    (!nom    || row.dataset.nom.includes(nom)) &&
                                    (!poste  || row.dataset.poste === poste) &&
                                    (!expire || row.dataset.expire === expire) &&
                                    (!statut || row.dataset.statut === statut);
                                row.style.display = match ? '' : 'none';
                                if (match) visible++;
                            });
                            const total = rows.length;
                            document.getElementById('filterCount').textContent =
                                visible < total ? `${visible} / ${total} joueurs` : '';
                        }

                        function resetFilters() {
                            ['filterNom','filterPoste','filterExpire','filterStatut'].forEach(id => {
                                document.getElementById(id).value = '';
                            });
                            sortCol = null; sortAsc = true;
                            document.querySelectorAll('#effectifTable .sort-icon').forEach(s => s.textContent = '↕');
                            Array.from(tbody.querySelectorAll('tr'))
                                .sort((a, b) => parseInt(a.cells[0].textContent) - parseInt(b.cells[0].textContent))
                                .forEach(r => tbody.appendChild(r));
                            applyFilters();
                        }

                        document.getElementById('filterNom').addEventListener('input', applyFilters);
                        document.getElementById('filterPoste').addEventListener('change', applyFilters);
                        document.getElementById('filterExpire').addEventListener('change', applyFilters);
                        document.getElementById('filterStatut').addEventListener('change', applyFilters);

                        let sortCol = null, sortAsc = true;
                        const tbody = document.querySelector('#effectifTable tbody');

                        document.querySelectorAll('#effectifTable thead th[data-sort]').forEach(th => {
                            th.addEventListener('click', () => {
                                const col  = parseInt(th.dataset.col);
                                const type = th.dataset.sort;
                                if (sortCol === col) sortAsc = !sortAsc;
                                else { sortCol = col; sortAsc = true; }
                                document.querySelectorAll('#effectifTable .sort-icon').forEach(s => s.textContent = '↕');
                                th.querySelector('.sort-icon').textContent = sortAsc ? '↑' : '↓';
                                const allRows = Array.from(tbody.querySelectorAll('tr'));
                                allRows.sort((a, b) => {
                                    let va = a.cells[col]?.textContent.trim() ?? '';
                                    let vb = b.cells[col]?.textContent.trim() ?? '';
                                    if (type === 'num') {
                                        if (col === 12) {
                                            const ya = parseInt(va.split('/').pop()) || 0;
                                            const yb = parseInt(vb.split('/').pop()) || 0;
                                            return sortAsc ? ya - yb : yb - ya;
                                        }
                                        const na = parseFloat(va.replace(/[^\d.]/g, '')) || 0;
                                        const nb = parseFloat(vb.replace(/[^\d.]/g, '')) || 0;
                                        return sortAsc ? na - nb : nb - na;
                                    }
                                    return sortAsc ? va.localeCompare(vb, 'fr') : vb.localeCompare(va, 'fr');
                                });
                                allRows.forEach(r => tbody.appendChild(r));
                            });
                        });
                        </script>
                    <?php else: ?>
                        <div class="p-4 text-center text-muted">
                            <?= $t['squad_empty'] ?> <a href="#" data-bs-toggle="modal" data-bs-target="#uploadModal"><?= $t['squad_import_link'] ?></a>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <!-- ===================== ONGLET TACTIC SUB ===================== -->
        <div class="tab-pane <?= $activeTab === 'tactic' ? 'show active' : '' ?>" id="pane-tactic">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center py-2" style="background:#091c3e; color:#cdfb0a;">
                    <span class="fs-4 fw-bold"><?= $t['card_tactic'] ?></span>
                    <div class="d-flex gap-1">
                        <?php foreach (['4-3-3','4-4-2','4-2-3-1','3-5-2','5-3-2','4-1-2-1-2'] as $f): ?>
                            <form action="formation_post.php" method="post" style="display:contents">
                                <input type="hidden" name="formation" value="<?= $f ?>">
                                <input type="hidden" name="redirect" value="index.php?tab=tactic">
                                <button type="submit"
                                    class="btn btn-xs <?= $formation === $f ? 'btn-warning' : 'btn-outline-light' ?>"
                                    style="font-size:.75rem; padding:2px 7px;">
                                    <?= $f ?>
                                </button>
                            </form>
                        <?php endforeach; ?>
                    </div>
                </div>
                <div class="card-body">
                    <?php if (count($joueurs) === 0): ?>
                        <p class="text-muted"><?= $t['tactic_no_squad'] ?></p>
                    <?php else: ?>
                        <?php
                        $tacticsStmt = $pdo->prepare("SELECT * FROM tactic WHERE idUser = :idUser ORDER BY position");
                        $tacticsStmt->execute(['idUser' => $idUser]);
                        $tactics = [];
                        foreach ($tacticsStmt->fetchAll() as $tacticRow) {
                            $tactics[$tacticRow['position']] = $tacticRow;
                        }
                        ?>
                        <form action="tactic_post.php" method="post">
                            <?= csrf_field() ?>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle">
                                    <thead class="table-dark">
                                        <tr>
                                            <th style="width:60px"><?= $t['tactic_position'] ?></th>
                                            <th><?= $t['tactic_starter'] ?></th>
                                            <th><?= $t['tactic_sub'] ?></th>
                                            <th><?= $t['tactic_supersub'] ?></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php for ($i = 1; $i <= 11; $i++): ?>
                                            <tr>
                                                <td><span class="badge bg-secondary"><?= $positions[$i-1] ?></span></td>
                                                <?php foreach (['titulaire','remplacant','supersub'] as $role): ?>
                                                    <td>
                                                        <select class="form-select form-select-sm" name="line_<?= $i ?>_<?= $role ?>">
                                                            <option value="">—</option>
                                                            <?php foreach ($joueursDispo as $j): ?>
                                                                <?php $selected = isset($tactics[$i]) && $tactics[$i][$role] == $j['idJoueur'] ? 'selected' : ''; ?>
                                                                <option value="<?= $j['idJoueur'] ?>" <?= $selected ?>>
                                                                    <?= htmlspecialchars($j['nom']) ?> (<?= htmlspecialchars($j['poste']) ?>)
                                                                </option>
                                                            <?php endforeach; ?>
                                                        </select>
                                                    </td>
                                                <?php endforeach; ?>
                                            </tr>
                                        <?php endfor; ?>
                                    </tbody>
                                </table>
                            </div>
                            <button type="submit" class="btn btn-primary"><?= $t['btn_save'] ?></button>
                        </form>
                    <?php endif; ?>
                </div>
            </div>
        </div>

    </div><!-- /tab-content -->

</div>

<!-- Modal import -->
<div class="modal fade" id="uploadModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><?= $t['squad_import_title'] ?></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="text-muted small"><?= $t['squad_import_hint'] ?></p>
                <form action="upload.php" method="post" enctype="multipart/form-data">
                    <?= csrf_field() ?>
                    <div class="mb-3">
                        <input type="file" name="playerFile" id="playerFile" class="form-control" accept=".html,.htm,.csv">
                    </div>
                    <button type="submit" class="btn btn-primary"><?= $t['btn_import'] ?></button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal settings -->
<div class="modal fade" tabindex="-1" id="settingModal" aria-hidden="true">
    <?php require_once("setting.php"); ?>
</div>

<?php require_once("footer.php"); ?>
</body>
