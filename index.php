<?php
session_start();
require_once("db.php");
require_once("country_flags.php");
require_once("head.php");
require_once("navbar.php");

if (!isset($_SESSION['mail'])) {
    ?>
    <div class="hero-dark">
        <div class="container py-5">
            <div class="row align-items-center g-4 g-lg-5">

                <!-- Texte + CTA + features -->
                <div class="col-lg-6">
                    <img src="assets/pictures/fmxx_logo.png" alt="iDev Compagnon" height="72" style="object-fit:contain;" class="mb-4">
                    <h1 class="display-4 fw-bold mb-3" style="color:#fff;">
                        iDev <span class="text-brand">Compagnon</span>
                    </h1>
                    <p class="lead mb-4" style="color:#a8c0e8; max-width:480px;">
                        <?= $t['landing_tagline'] ?>
                    </p>
                    <div class="d-grid d-sm-flex gap-3 mb-5">
                        <button class="btn btn-lg btn-primary px-4 fw-semibold"
                                data-bs-toggle="modal" data-bs-target="#LoginModal">
                            <?= $t['landing_login'] ?>
                        </button>
                        <button class="btn btn-lg px-4 fw-semibold btn-outline-light"
                                data-bs-toggle="modal" data-bs-target="#SignupModal">
                            <?= $t['landing_signup'] ?>
                        </button>
                    </div>

                    <div class="hero-feature-list">
                        <div class="hero-feature-item">
                            <span class="hero-feature-icon">🎯</span>
                            <div>
                                <h6 class="fw-bold mb-1"><?= $t['landing_feat1_title'] ?></h6>
                                <p class="mb-0 small"><?= $t['landing_feat1_text'] ?></p>
                            </div>
                        </div>
                        <div class="hero-feature-item">
                            <span class="hero-feature-icon">🗂️</span>
                            <div>
                                <h6 class="fw-bold mb-1"><?= $t['landing_feat2_title'] ?></h6>
                                <p class="mb-0 small"><?= $t['landing_feat2_text'] ?></p>
                            </div>
                        </div>
                        <div class="hero-feature-item">
                            <span class="hero-feature-icon">📋</span>
                            <div>
                                <h6 class="fw-bold mb-1"><?= $t['landing_feat3_title'] ?></h6>
                                <p class="mb-0 small"><?= $t['landing_feat3_text'] ?></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Visuel : plan tactique -->
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="pitch-panel">
                        <svg viewBox="0 0 260 380" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                            <rect x="6" y="6" width="248" height="368" rx="10" class="pitch-line"/>
                            <line x1="6" y1="190" x2="254" y2="190" class="pitch-line"/>
                            <circle cx="130" cy="190" r="38" class="pitch-line"/>
                            <rect x="65" y="6" width="130" height="55" class="pitch-line"/>
                            <rect x="65" y="319" width="130" height="55" class="pitch-line"/>
                            <rect x="100" y="6" width="60" height="22" class="pitch-line"/>
                            <rect x="100" y="352" width="60" height="22" class="pitch-line"/>
                            <circle cx="130" cy="350" r="7" class="pitch-dot-gk"/>
                            <circle cx="40" cy="290" r="7" class="pitch-dot"/>
                            <circle cx="100" cy="300" r="7" class="pitch-dot"/>
                            <circle cx="160" cy="300" r="7" class="pitch-dot"/>
                            <circle cx="220" cy="290" r="7" class="pitch-dot"/>
                            <circle cx="70" cy="210" r="7" class="pitch-dot"/>
                            <circle cx="130" cy="220" r="7" class="pitch-dot"/>
                            <circle cx="190" cy="210" r="7" class="pitch-dot"/>
                            <circle cx="60" cy="110" r="7" class="pitch-dot"/>
                            <circle cx="130" cy="90" r="7" class="pitch-dot"/>
                            <circle cx="200" cy="110" r="7" class="pitch-dot"/>
                        </svg>
                        <div class="text-center mt-2">
                            <span class="badge bg-secondary">4-3-3</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <?php
    require_once("footer.php");
    exit;
}

// Au-delà d'ici : utilisateur connecté uniquement (restaure la session via cookie si besoin).
require_once("auth_check.php");
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

$paysNom = null;
if ($idPays) {
    $pNomStmt = $pdo->prepare("SELECT nomPays FROM pays WHERE idPays = :id");
    $pNomStmt->execute(['id' => $idPays]);
    $paysNom = $pNomStmt->fetchColumn() ?: null;
}

// Budgets
$bStmt = $pdo->prepare("SELECT budget_transfert, budget_salaires FROM user WHERE idUser = :id");
$bStmt->execute(['id' => $idUser]);
$budgets = $bStmt->fetch();
$budgetTransfert = $budgets['budget_transfert'];
$budgetSalaires  = $budgets['budget_salaires'];

// Masse salariale utilisée = somme des salaires importés (colonne "Salaire" FM),
// en % du budget salaires. Ignore les joueurs déjà en partance (mercato).
$masseSalariale = array_sum(array_column($joueursDispo, 'salaire'));
$pctMasseSalariale = ($budgetSalaires !== null && (int)$budgetSalaires > 0)
    ? round($masseSalariale / $budgetSalaires * 100)
    : null;

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

// Compétition européenne forcée (paramètres) ou déduite du résultat du championnat de la saison précédente
// (la qualification européenne d'une saison se décide sur le classement déjà joué la saison d'avant, jamais sur l'objectif de la saison en cours)
$overrideStmt = $pdo->prepare("SELECT comp_europe_override FROM user WHERE idUser = :id");
$overrideStmt->execute(['id' => $idUser]);
$compEuropeOverride = $overrideStmt->fetchColumn();

[$saisonDebut, $saisonFinBrute] = explode('/', $saison);
$saisonPrecedente = ((int)$saisonDebut - 1) . '/' . ((int)$saisonFinBrute - 1);

$prevChampStmt = $pdo->prepare("
    SELECT o.resultat
    FROM objectif o
    JOIN competition c ON c.idCompetition = o.idCompetition
    WHERE o.idUser = :idUser AND o.saison = :saisonPrecedente AND c.typeCompetition = 'Championnat'
    LIMIT 1
");
$prevChampStmt->execute(['idUser' => $idUser, 'saisonPrecedente' => $saisonPrecedente]);
$prevChampResultat = $prevChampStmt->fetchColumn();
$champRank = $prevChampResultat ? ($ranking[$prevChampResultat] ?? null) : null;
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
}
?>
<div class="main-content">

    <?php if (isset($_GET['account']) && $_GET['account'] === 'deleted'): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_account_deleted'] ?>
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
    <?php if (isset($_GET['backup_restored'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_backup_restored'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    <?php if (isset($_GET['backup_error'])): ?>
        <div class="alert alert-danger alert-dismissible fade show">
            <?= $t['alert_backup_error'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <!-- CONTEXTE -->
    <div class="context-bar">
        <div class="context-left">
            <div>
                <div class="context-title"><?= $nomClub ? htmlspecialchars($nomClub) : $t['setting_title'] ?></div>
                <div class="context-meta">
                    <?= htmlspecialchars(implode(' · ', array_filter([$division, $paysNom, $genre === 'F' ? $t['setting_female'] : $t['setting_male']]))) ?>
                </div>
            </div>
        </div>
        <div class="context-right">
            <span class="pill"><?= htmlspecialchars($saison) ?></span>
            <?php if ($pct !== null): ?>
                <span class="pill <?= $pct >= 50 ? 'pill-success' : '' ?>">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                    <?= $pct ?>% <?= $t['obj_success_rate'] ?>
                </span>
            <?php endif; ?>
            <button class="btn-ghost" data-bs-toggle="modal" data-bs-target="#settingModal"><?= $t['btn_settings'] ?></button>
        </div>
    </div>

    <!-- NAV TABS -->
    <div class="segmented">
        <a class="<?= $activeTab === 'objectifs' ? 'active' : '' ?>" href="?tab=objectifs">
            <?= $t['tab_objectives'] ?>
            <?php if ($pct !== null): ?><span class="count"><?= $pct ?>%</span><?php endif; ?>
        </a>
        <a class="<?= $activeTab === 'effectif' ? 'active' : '' ?>" href="?tab=effectif">
            <?= $t['tab_squad'] ?>
            <?php if (count($joueurs) > 0): ?><span class="count"><?= count($joueurs) ?></span><?php endif; ?>
        </a>
        <a class="<?= $activeTab === 'tactic' ? 'active' : '' ?>" href="?tab=tactic">
            <?= $t['tab_tactic'] ?>
            <span class="count"><?= htmlspecialchars($formation) ?></span>
        </a>
    </div>

    <div class="tab-content">

        <!-- ===================== ONGLET OBJECTIFS ===================== -->
        <div class="tab-pane <?= $activeTab === 'objectifs' ? 'show active' : '' ?>" id="pane-objectifs">
            <?php if (!$idPays || !$division): ?>
                <p class="text-muted mb-3"><?= $t['obj_no_config'] ?> <a href="#" data-bs-toggle="modal" data-bs-target="#settingModal"><ion-icon name="open-outline"></ion-icon></a></p>
            <?php elseif (empty($competitions)): ?>
                <p class="text-muted mb-3"><?= $t['obj_no_competitions'] ?></p>
            <?php else: ?>
                <?php
                $typeLabels = [
                    'Championnat'  => $t['obj_type_league'],
                    'Ligue'        => $t['obj_type_cup_league'],
                    'Nationale'    => $t['obj_type_cup_national'],
                    'Continentale' => $t['obj_type_cup_continental'],
                ];
                ?>
                <form action="objectif_post.php" method="post">
                    <input type="hidden" name="saison" value="<?= htmlspecialchars($saison) ?>">
                    <?= csrf_field() ?>
                    <div class="objectives">
                        <?php foreach ($competitions as $c):
                            $type  = $c['typeCompetition'];
                            $label = $typeLabels[$type] ?? $type;
                            $opts  = $optionsParType[$type] ?? $optionsParType['Nationale'];
                            $rObj  = $ranking[$c['objectif']] ?? null;
                            $rRes  = $ranking[$c['resultat']] ?? null;
                            if ($rObj && $rRes) {
                                $statusClass = $rRes <= $rObj ? 'status-success' : 'status-danger';
                                $statusLabel = $rRes <= $rObj ? ($rRes < $rObj ? $t['obj_status_exceeded'] : $t['obj_status_success']) : $t['obj_status_failed'];
                            } else {
                                $statusClass = 'status-pending';
                                $statusLabel = $t['obj_status_pending'];
                            }
                        ?>
                        <div class="objective-row">
                            <div class="objective-comp">
                                <span class="objective-type"><?= $label ?></span>
                                <span class="objective-name"><?= htmlspecialchars($c['nomCompetition']) ?></span>
                            </div>
                            <div>
                                <div class="field-label"><?= $t['obj_target'] ?></div>
                                <select class="obj-select" name="objectif[<?= $c['idCompetition'] ?>]">
                                    <?php foreach ($opts as $optLabel => $rank): ?>
                                        <option value="<?= $optLabel ?>" <?= $c['objectif'] === $optLabel ? 'selected' : '' ?>>
                                            <?= $optLabel ?: $t['obj_placeholder'] ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div>
                                <div class="field-label"><?= $t['obj_result'] ?></div>
                                <select class="obj-select" name="resultat[<?= $c['idCompetition'] ?>]">
                                    <?php foreach ($opts as $optLabel => $rank): ?>
                                        <option value="<?= $optLabel ?>" <?= ($c['resultat'] ?? '') === $optLabel ? 'selected' : '' ?>>
                                            <?= $optLabel ?: $t['obj_result_placeholder'] ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <span class="status-chip <?= $statusClass ?>">
                                <?php if ($statusClass === 'status-success'): ?>
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                                <?php endif; ?>
                                <?= $statusLabel ?>
                            </span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button type="submit" class="btn-brand"><?= $t['btn_save'] ?></button>
                        <a href="saison_next.php" class="btn-ghost"
                           data-confirm="<?= htmlspecialchars($t['confirm_next_season'], ENT_QUOTES) ?>"
                           data-confirm-variant="warning">
                            <?= $t['btn_next_season'] ?>
                        </a>
                    </div>
                </form>
            <?php endif; ?>

            <!-- BUDGET -->
            <div class="budget-strip mt-3">
                <form class="budget-field" action="budget_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="budget_salaires" value="<?= $budgetSalaires !== null ? $budgetSalaires : '' ?>">
                    <span class="budget-label"><?= $t['budget_transfer'] ?></span>
                    <div class="budget-input-row">
                        <input type="number" name="budget_transfert" class="budget-input"
                               value="<?= $budgetTransfert !== null ? $budgetTransfert : '' ?>"
                               placeholder="0" min="0">
                        <span>€</span>
                    </div>
                    <button type="submit" class="btn-brand"><?= $t['btn_save'] ?></button>
                </form>
                <form class="budget-field" action="budget_post.php" method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="budget_transfert" value="<?= $budgetTransfert !== null ? $budgetTransfert : '' ?>">
                    <span class="budget-label"><?= $t['budget_wages'] ?></span>
                    <div class="budget-input-row">
                        <input type="number" name="budget_salaires" class="budget-input"
                               value="<?= $budgetSalaires !== null ? $budgetSalaires : '' ?>"
                               placeholder="0" min="0">
                        <span>€</span>
                    </div>
                    <button type="submit" class="btn-brand"><?= $t['btn_save'] ?></button>
                </form>
                <div class="budget-field">
                    <span class="budget-label"><?= $t['budget_wage_used'] ?></span>
                    <div class="budget-value">
                        <?= $pctMasseSalariale !== null ? $pctMasseSalariale . '<small>%</small>' : '—' ?>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===================== ONGLET EFFECTIF ===================== -->
        <div class="tab-pane <?= $activeTab === 'effectif' ? 'show active' : '' ?>" id="pane-effectif">

            <?php if (count($joueurs) > 0): ?>
            <?php
            $expiresUrgent = array_filter($joueurs, function($j) use ($saisonFin) {
                if (!$j['expireContrat']) return false;
                $parts = explode('/', $j['expireContrat']);
                return (int)end($parts) === $saisonFin;
            });
            $enVente = count(array_filter($joueurs, fn($j) => $j['mercato_status'] === 'sell'));
            ?>
            <!-- Stats rapides -->
            <div class="table-panel mb-3">
                <div class="stat-bar">
                    <div class="stat-item">
                        <div class="stat-value"><?= count($joueurs) ?></div>
                        <div class="stat-label"><?= $t['squad_stat_count'] ?></div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><?= $ageMoyen ?? '—' ?></div>
                        <div class="stat-label"><?= $t['squad_stat_avg_age'] ?></div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value <?= count($expiresUrgent) > 0 ? 'text-warning' : '' ?>"><?= count($expiresUrgent) ?></div>
                        <div class="stat-label"><?= $t['squad_stat_expiring'] ?></div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value <?= $enVente > 0 ? 'text-danger' : '' ?>"><?= $enVente ?></div>
                        <div class="stat-label"><?= $t['squad_stat_selling'] ?></div>
                    </div>
                </div>
            </div>
            <!-- Graphiques -->
            <?php
            $posteTotal = array_sum($parCategorie);
            $posteColors = ['Gardien' => 'var(--chart-1)', 'Défense' => 'var(--chart-2)', 'Milieu' => 'var(--chart-3)', 'Attaque' => 'var(--chart-4)'];
            $posteLabels = [
                'Gardien' => $t['squad_pos_goalkeeper'],
                'Défense' => $t['squad_pos_defense'],
                'Milieu'  => $t['squad_pos_midfield'],
                'Attaque' => $t['squad_pos_attack'],
            ];
            ?>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="card h-100">
                        <div class="card-body">
                            <h6 class="fw-bold text-muted mb-3"><?= $t['squad_chart_by_position'] ?></h6>
                            <?php if ($posteTotal > 0): ?>
                            <div class="poste-bar">
                                <?php foreach ($parCategorie as $cat => $n): if ($n === 0) continue; ?>
                                    <div class="poste-seg" style="width:<?= round($n / $posteTotal * 100, 2) ?>%; background:<?= $posteColors[$cat] ?>"></div>
                                <?php endforeach; ?>
                            </div>
                            <div class="poste-legend">
                                <?php foreach ($parCategorie as $cat => $n): ?>
                                    <span class="poste-legend-item">
                                        <span class="poste-legend-dot" style="background:<?= $posteColors[$cat] ?>"></span>
                                        <?= htmlspecialchars($posteLabels[$cat]) ?>
                                        <span class="poste-legend-count"><?= $n ?> (<?= round($n / $posteTotal * 100) ?>%)</span>
                                    </span>
                                <?php endforeach; ?>
                            </div>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
            <?php endif; ?>

            <!-- Tableau effectif -->
            <div class="table-panel">
                <div class="table-panel-head">
                    <span class="section-title"><span style="color:var(--heading)"><?= $t['card_squad'] ?></span></span>
                    <?php if (count($joueurs) > 0): ?>
                        <form action="deleteData.php" method="post"
                              data-confirm="<?= htmlspecialchars($t['confirm_clear_squad'], ENT_QUOTES) ?>"
                              data-confirm-variant="danger">
                            <?= csrf_field() ?>
                            <button type="submit" class="btn-danger-ghost"><?= $t['btn_clear'] ?></button>
                        </form>
                    <?php else: ?>
                        <button class="btn-ghost" data-bs-toggle="modal" data-bs-target="#uploadModal"><?= $t['btn_import'] ?></button>
                    <?php endif; ?>
                </div>
                    <?php if (count($joueurs) > 0): ?>
                        <?php if (!empty($expiresUrgent)): ?>
                        <div class="alert alert-danger mb-0 rounded-0 border-0 border-bottom py-2 px-3">
                            <strong><ion-icon name="warning-outline"></ion-icon> <?= $t['squad_contract_alert'] ?> (<?= $saisonFin ?>) :</strong>
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
                        <div class="table-toolbar">
                            <div class="search-field">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input type="text" id="filterNom" placeholder="<?= htmlspecialchars($t['squad_filter_name']) ?>">
                            </div>
                            <select id="filterPoste" class="btn-ghost">
                                <option value=""><?= $t['squad_filter_position'] ?></option>
                                <?php foreach ($postes as $p): ?>
                                    <option><?= htmlspecialchars($p) ?></option>
                                <?php endforeach; ?>
                            </select>
                            <select id="filterExpire" class="btn-ghost">
                                <option value=""><?= $t['squad_filter_expiry'] ?></option>
                                <?php foreach ($annees as $a): ?>
                                    <option><?= htmlspecialchars($a) ?></option>
                                <?php endforeach; ?>
                            </select>
                            <select id="filterStatut" class="btn-ghost">
                                <option value=""><?= $t['squad_filter_status'] ?></option>
                                <option value="sell"><?= $t['squad_status_sell'] ?></option>
                                <option value="loan"><?= $t['squad_status_loan'] ?></option>
                                <option value="free"><?= $t['squad_status_free'] ?></option>
                            </select>
                            <button class="btn-ghost" onclick="resetFilters()"><?= $t['btn_reset_filters'] ?></button>
                            <span id="filterCount" class="text-muted small ms-1"></span>
                        </div>
                        <div class="table-scroll">
                            <table class="table table-sm table-hover table-striped mb-0 data-table" id="effectifTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th data-sort="text" data-col="1" style="cursor:pointer"><?= $t['squad_col_name'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th class="text-end" data-sort="num"  data-col="2" style="cursor:pointer"><?= $t['squad_col_age'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th data-sort="text" data-col="3" style="cursor:pointer"><?= $t['squad_col_position'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th class="text-end" data-sort="num"  data-col="4"  style="cursor:pointer"><?= $t['squad_col_apps'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th class="text-end" data-sort="num"  data-col="5"  style="cursor:pointer"><?= $t['squad_col_assists'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th class="text-end" data-sort="num"  data-col="6"  style="cursor:pointer"><?= $t['squad_col_goals'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th class="text-end" data-sort="num"  data-col="7" style="cursor:pointer"><?= $t['squad_col_rating'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th class="text-end" data-sort="num"  data-col="8" style="cursor:pointer"><?= $t['squad_col_value'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th data-sort="num"  data-col="9" style="cursor:pointer"><?= $t['squad_col_expiry'] ?> <ion-icon name="swap-vertical-outline" class="sort-icon text-muted"></ion-icon></th>
                                        <th><?= $t['squad_col_status'] ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($joueurs as $i => $j): ?>
                                        <?php
                                        $expireYear = '';
                                        if ($j['expireContrat']) {
                                            $parts = explode('/', $j['expireContrat']);
                                            $expireYear = end($parts);
                                        }
                                        if ($j['mercato_status'] === 'sell') {
                                            $statutChip = '<span class="status-chip status-danger">' . htmlspecialchars($t['squad_status_sell']) . '</span>';
                                        } elseif ($j['mercato_status'] === 'loan') {
                                            $statutChip = '<span class="status-chip status-info">' . htmlspecialchars($t['squad_status_loan']) . '</span>';
                                        } elseif ($j['mercato_status'] === 'free') {
                                            $statutChip = '<span class="status-chip status-danger">' . htmlspecialchars($t['squad_status_free']) . '</span>';
                                        } elseif ($expireYear !== '' && (int)$expireYear === $saisonFin) {
                                            $statutChip = '<span class="status-chip status-danger">' . htmlspecialchars($t['squad_badge_expiry_this']) . '</span>';
                                        } elseif ($expireYear !== '' && (int)$expireYear === $saisonFinNext) {
                                            $statutChip = '<span class="status-chip status-warning">' . htmlspecialchars($t['squad_badge_expiry_next']) . '</span>';
                                        } else {
                                            $statutChip = '<span class="text-muted">—</span>';
                                        }
                                        ?>
                                        <tr data-nom="<?= htmlspecialchars(mb_strtolower($j['nom'] ?? '')) ?>"
                                            data-poste="<?= htmlspecialchars($j['poste'] ?? '') ?>"
                                            data-expire="<?= $expireYear ?>"
                                            data-statut="<?= $j['mercato_status'] ?? '' ?>">
                                            <td><?= $i + 1 ?></td>
                                            <td>
                                                <div class="player-cell">
                                                    <span class="player-avatar"><?= htmlspecialchars($j['numero'] ?? '') ?></span>
                                                    <div>
                                                        <a href="joueur.php?id=<?= $j['idJoueur'] ?>" class="player-name text-decoration-none fw-semibold"><?= htmlspecialchars($j['nom'] ?? '') ?></a>
                                                        <div class="player-nat"><?= fmxx_flag_emoji($j['nat'] ?? null) ?> <?= htmlspecialchars($j['nat'] ?? '') ?></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-end"><?= $j['age'] ?? '' ?></td>
                                            <td><?= htmlspecialchars($j['poste'] ?? '') ?></td>
                                            <td class="text-end"><?= $j['app'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['pDec'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['buts'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['noteMoy'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['prixDemande'] !== null ? number_format((int)$j['prixDemande'], 0, ',', ' ') . ' €' : '' ?></td>
                                            <td><?= htmlspecialchars($j['expireContrat'] ?? '') ?></td>
                                            <td><?= $statutChip ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                                <tfoot class="table-secondary fw-bold">
                                    <tr>
                                        <td colspan="2"><?= count($joueurs) ?> <?= $t['squad_players'] ?></td>
                                        <td><?= $ageMoyen ?> <?= $t['squad_avg_age'] ?></td>
                                        <td colspan="8"></td>
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
                            document.querySelectorAll('#effectifTable .sort-icon').forEach(s => s.setAttribute('name', 'swap-vertical-outline'));
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
                                document.querySelectorAll('#effectifTable .sort-icon').forEach(s => s.setAttribute('name', 'swap-vertical-outline'));
                                th.querySelector('.sort-icon').setAttribute('name', sortAsc ? 'arrow-up-outline' : 'arrow-down-outline');
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

        <!-- ===================== ONGLET TACTIC SUB ===================== -->
        <div class="tab-pane <?= $activeTab === 'tactic' ? 'show active' : '' ?>" id="pane-tactic">
            <div class="table-panel">
                <div class="table-panel-head">
                    <span class="section-title"><span style="color:var(--heading)"><?= $t['card_tactic'] ?></span></span>
                    <div class="segmented" style="align-self:auto;">
                        <?php foreach (['4-3-3','4-4-2','4-2-3-1','3-5-2','5-3-2','4-1-2-1-2'] as $f): ?>
                            <form action="formation_post.php" method="post" style="display:contents">
                                <input type="hidden" name="formation" value="<?= $f ?>">
                                <input type="hidden" name="redirect" value="index.php?tab=tactic">
                                <button type="submit" class="<?= $formation === $f ? 'active' : '' ?>" style="text-transform:none; font-size:.8rem; padding:.35rem .7rem;">
                                    <?= $f ?>
                                </button>
                            </form>
                        <?php endforeach; ?>
                    </div>
                </div>
                    <?php if (count($joueurs) === 0): ?>
                        <p class="text-muted p-3 mb-0"><?= $t['tactic_no_squad'] ?></p>
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
                            <div class="table-scroll">
                                <table class="table table-sm align-middle mb-0 data-table">
                                    <thead>
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
                                                <td><span class="pos-tag"><?= $positions[$i-1] ?></span></td>
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
                            <div class="p-3">
                                <button type="submit" class="btn-brand"><?= $t['btn_save'] ?></button>
                            </div>
                        </form>
                    <?php endif; ?>
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
