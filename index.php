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

function formatBudget(int $val): string {
    return number_format($val, 0, ',', ' ') . ' €';
}

// Mercato (fusionné depuis l'ex-page mercato.php) : statuts de l'effectif + arrivées
$mercatoSells    = array_filter($joueurs, fn($j) => $j['mercato_status'] === 'sell');
$mercatoLoans    = array_filter($joueurs, fn($j) => $j['mercato_status'] === 'loan');
$mercatoRecettes = array_sum(array_map(fn($j) => (int)$j['prixDemande'], $mercatoSells));

$arrStmt = $pdo->prepare("SELECT * FROM mercato_arrivee WHERE idUser = :idUser ORDER BY statut, nom");
$arrStmt->execute(['idUser' => $idUser]);
$arrivees = $arrStmt->fetchAll();
$nbCibles        = count(array_filter($arrivees, fn($a) => $a['statut'] === 'cible'));
$nbSignes        = count(array_filter($arrivees, fn($a) => $a['statut'] === 'signe'));
$mercatoDepenses = array_sum(array_map(fn($a) => (int)$a['prix'], $arrivees));
$mercatoSolde    = $mercatoRecettes - $mercatoDepenses;

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
    // Dictionnaire explicite FR + EN (codes FM). Les qualificatifs de côté
    // entre parenthèses ("D (C)", "MO (DGC)"...) sont retirés avant le
    // découpage : seul le rôle de base (avant la parenthèse) est classé.
    $posteMap = [
        // Gardien
        'GB' => 'Gardien', 'GK' => 'Gardien',
        // Défense
        'D' => 'Défense', 'DC' => 'Défense', 'DD' => 'Défense', 'DG' => 'Défense',
        'PD' => 'Défense', 'PG' => 'Défense', 'LIB' => 'Défense',
        'CB' => 'Défense', 'RB' => 'Défense', 'LB' => 'Défense',
        'RWB' => 'Défense', 'LWB' => 'Défense', 'WB' => 'Défense', 'SW' => 'Défense',
        // Milieu
        'M' => 'Milieu', 'MD' => 'Milieu', 'MC' => 'Milieu', 'MOC' => 'Milieu',
        'MO' => 'Milieu', 'MG' => 'Milieu',
        'CDM' => 'Milieu', 'DM' => 'Milieu', 'CM' => 'Milieu', 'CAM' => 'Milieu',
        'AM' => 'Milieu', 'RM' => 'Milieu', 'LM' => 'Milieu',
        // Attaque
        'AD' => 'Attaque', 'AG' => 'Attaque', 'AL' => 'Attaque',
        'BU' => 'Attaque', 'BT' => 'Attaque', 'ATT' => 'Attaque',
        'RW' => 'Attaque', 'LW' => 'Attaque', 'ST' => 'Attaque', 'FW' => 'Attaque',
    ];
    $rankOrder = ['Gardien' => 0, 'Défense' => 1, 'Milieu' => 2, 'Attaque' => 3];
    $catPoste = function(string $poste) use ($posteMap, $rankOrder): string {
        $clean  = preg_replace('/\([^)]*\)/', '', strtoupper(trim($poste)));
        $tokens = array_filter(preg_split('/[\s,\/\-]+/', $clean));
        $best = 99; $result = 'Autre';
        foreach ($tokens as $tok) {
            if (!isset($posteMap[$tok])) continue;
            $rank = $rankOrder[$posteMap[$tok]];
            if ($rank < $best) { $best = $rank; $result = $posteMap[$tok]; }
        }
        return $result;
    };
    // Affichage simplifié de la colonne "Poste" : un seul rôle principal
    // (même priorité Gardien>Défense>Milieu>Attaque que pour le graphique),
    // traduit en abréviation EN. Les lettres de côté FR (C/D/G = Centre/
    // Droite/Gauche) et EN (C/L/R) ne se chevauchent jamais caractère par
    // caractère : D et G n'existent qu'en FR, L n'existe qu'en EN — donc la
    // traduction lettre à lettre est sans ambiguïté quelle que soit la
    // langue d'import.
    $roleEnMap = [
        'GB' => ['GK', null], 'GK' => ['GK', null],
        'D'  => ['D', null],
        'DC' => ['D', 'C'], 'DD' => ['D', 'R'], 'DG' => ['D', 'L'],
        'CB' => ['D', 'C'], 'RB' => ['D', 'R'], 'LB' => ['D', 'L'],
        'PD' => ['WB', 'R'], 'PG' => ['WB', 'L'],
        'RWB' => ['WB', 'R'], 'LWB' => ['WB', 'L'], 'WB' => ['WB', null],
        'LIB' => ['SW', null], 'SW' => ['SW', null],
        'M'  => ['M', null],
        'MC' => ['M', 'C'], 'CM' => ['M', 'C'],
        'MD' => ['CDM', null], 'CDM' => ['CDM', null], 'DM' => ['CDM', null],
        'MOC' => ['AM', 'C'], 'CAM' => ['AM', 'C'],
        'MO' => ['AM', null], 'AM' => ['AM', null],
        'MG' => ['M', 'L'], 'LM' => ['M', 'L'], 'RM' => ['M', 'R'],
        'AD' => ['W', 'R'], 'RW' => ['W', 'R'],
        'AG' => ['W', 'L'], 'LW' => ['W', 'L'],
        'AL' => ['W', null],
        'BU' => ['ST', null], 'BT' => ['ST', null], 'ST' => ['ST', null],
        'ATT' => ['FW', null], 'FW' => ['FW', null],
    ];
    $sideCharMap = ['D' => 'R', 'G' => 'L', 'C' => 'C', 'L' => 'L', 'R' => 'R'];
    // Détection commune : le rôle (token + côté brut) le plus prioritaire
    // d'un poste importé, réutilisée par l'affichage libre ($simplifyPoste)
    // et par la pré-sélection contrainte à la liste fermée ($suggestRoleMatch).
    $findBestRoleToken = function(string $poste) use ($posteMap, $rankOrder): array {
        $groups = array_filter(array_map('trim', explode(',', $poste)));
        $bestRank = 100; $bestRole = null; $bestSide = '';
        foreach ($groups as $group) {
            $sideRaw = '';
            if (preg_match('/\(([^)]*)\)/', $group, $m)) {
                $sideRaw = strtoupper($m[1]);
            }
            $rolePart = trim(preg_replace('/\([^)]*\)/', '', $group));
            if ($rolePart === '') continue;
            foreach (explode('/', $rolePart) as $tok) {
                $tok = strtoupper(trim($tok));
                if ($tok === '' || !isset($posteMap[$tok])) continue;
                $rank = $rankOrder[$posteMap[$tok]];
                if ($rank < $bestRank) {
                    $bestRank = $rank;
                    $bestRole = $tok;
                    $bestSide = $sideRaw;
                }
            }
        }
        return [$bestRole, $bestSide];
    };
    $simplifyPoste = function(string $poste) use ($findBestRoleToken, $roleEnMap, $sideCharMap): string {
        [$bestRole, $bestSide] = $findBestRoleToken($poste);
        if ($bestRole === null) return $poste;
        [$enRole, $impliedSide] = $roleEnMap[$bestRole] ?? [$bestRole, null];
        $side = '';
        if ($bestSide !== '') {
            $side = implode('', array_map(fn($c) => $sideCharMap[$c] ?? $c, str_split($bestSide)));
        } elseif ($impliedSide) {
            $side = $impliedSide;
        }
        return $side !== '' ? "$enRole ($side)" : $enRole;
    };

    // Les 16 rôles "utilisés en match" proposés dans le sélecteur (codes
    // courts EN de la liste FR/EN/ES fournie par Guillaume, 2026-08-29 —
    // le code est toujours stocké en EN, l'abréviation affichée dans le
    // sélecteur et le glossaire est traduite via $t['role_abbr_XXX']).
    // Liste fermée : un seul rôle par combinaison rôle+côté.
    $roleOptions = ['GK', 'CB', 'RB', 'LB', 'RWB', 'LWB', 'SW', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'RW', 'LW', 'ST', 'FW'];
    $roleCategory = [
        'GK' => 'Gardien',
        'CB' => 'Défense', 'RB' => 'Défense', 'LB' => 'Défense',
        'RWB' => 'Défense', 'LWB' => 'Défense', 'SW' => 'Défense',
        'CDM' => 'Milieu', 'CM' => 'Milieu', 'CAM' => 'Milieu', 'RM' => 'Milieu', 'LM' => 'Milieu',
        'RW' => 'Attaque', 'LW' => 'Attaque', 'ST' => 'Attaque', 'FW' => 'Attaque',
    ];
    // enRole (issu de $roleEnMap) + côté -> code final de la liste fermée.
    $finalRoleMap = [
        'GK|' => 'GK',
        'D|C' => 'CB', 'D|R' => 'RB', 'D|L' => 'LB',
        'WB|R' => 'RWB', 'WB|L' => 'LWB',
        'SW|' => 'SW',
        'CDM|' => 'CDM',
        'M|C' => 'CM', 'M|R' => 'RM', 'M|L' => 'LM',
        'AM|C' => 'CAM',
        'W|R' => 'RW', 'W|L' => 'LW',
        'ST|' => 'ST',
        'FW|' => 'FW',
    ];
    $suggestRoleMatch = function(string $poste) use ($findBestRoleToken, $roleEnMap, $sideCharMap, $finalRoleMap): string {
        [$bestRole, $bestSide] = $findBestRoleToken($poste);
        if ($bestRole === null) return 'CM';
        [$enRole, $impliedSide] = $roleEnMap[$bestRole] ?? ['M', null];
        // AM n'a que la variante centrale (CAM) dans la liste actée.
        if ($enRole === 'AM') return 'CAM';
        if (in_array($enRole, ['GK', 'SW', 'CDM', 'ST', 'FW'], true)) {
            return $finalRoleMap["$enRole|"] ?? 'CM';
        }
        $side = '';
        if ($bestSide !== '') {
            $translated = array_map(fn($c) => $sideCharMap[$c] ?? $c, str_split($bestSide));
            // Un seul côté autorisé dans la liste fermée : priorité Centre > Droite > Gauche.
            if (in_array('C', $translated, true)) $side = 'C';
            elseif (in_array('R', $translated, true)) $side = 'R';
            elseif (in_array('L', $translated, true)) $side = 'L';
        } elseif ($impliedSide) {
            $side = $impliedSide;
        }
        if ($side === '') {
            $side = ($enRole === 'W' || $enRole === 'WB') ? 'R' : 'C';
        }
        return $finalRoleMap["$enRole|$side"] ?? 'CM';
    };
    // Rôle effectif : le choix manuel de l'utilisateur (role_match) prime
    // sur la suggestion déduite de l'import.
    $effectiveRole = function(array $j) use ($suggestRoleMatch): string {
        return !empty($j['role_match']) ? $j['role_match'] : $suggestRoleMatch($j['poste'] ?? '');
    };
    $parCategorie = ['Gardien' => 0, 'Défense' => 0, 'Milieu' => 0, 'Attaque' => 0];
    foreach ($joueurs as $j) {
        $cat = $roleCategory[$effectiveRole($j)] ?? $catPoste($j['poste'] ?? '');
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
    <?php if (isset($_GET['mercato_saved'])): ?>
        <div class="alert alert-success alert-dismissible fade show">
            <?= $t['alert_mercato_saved'] ?>
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
            $enVente = count($mercatoSells);
            $enPret  = count($mercatoLoans);
            ?>
            <!-- Stats rapides (effectif + mercato fusionnés) -->
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
                        <div class="stat-value <?= $enVente > 0 ? 'text-danger' : '' ?>" id="stat-en-vente"><?= $enVente ?></div>
                        <div class="stat-label"><?= $t['squad_stat_selling'] ?></div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value text-primary" id="stat-en-pret"><?= $enPret ?></div>
                        <div class="stat-label"><?= $t['mercato_loan'] ?></div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value text-warning"><?= $nbCibles ?></div>
                        <div class="stat-label"><?= $t['mercato_arr_targets'] ?></div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value text-success"><?= $nbSignes ?></div>
                        <div class="stat-label"><?= $t['mercato_arr_signed'] ?></div>
                    </div>
                    <div class="stat-item" data-mercato-depenses="<?= $mercatoDepenses ?>">
                        <div class="stat-value <?= $mercatoSolde >= 0 ? 'text-success' : 'text-danger' ?>" id="stat-mercato-solde">
                            <?= $mercatoSolde > 0 ? '+' : '' ?><?= formatBudget($mercatoSolde) ?>
                        </div>
                        <div class="stat-label"><?= $t['mercato_revenue'] ?></div>
                        <?php if ($mercatoDepenses > 0): ?>
                            <div class="stat-sub" id="stat-mercato-sub">+<?= formatBudget($mercatoRecettes) ?> / −<?= formatBudget($mercatoDepenses) ?></div>
                        <?php endif; ?>
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
            <?php if ($posteTotal > 0): ?>
            <div class="table-panel mb-4">
                <div class="table-panel-head">
                    <span class="section-title"><span style="color:var(--heading)"><?= $t['squad_chart_by_position'] ?></span></span>
                    <div class="poste-legend" id="poste-legend" style="margin-top:0">
                        <?php foreach ($parCategorie as $cat => $n): ?>
                            <span class="poste-legend-item">
                                <span class="poste-legend-dot" style="background:<?= $posteColors[$cat] ?>"></span>
                                <?= htmlspecialchars($posteLabels[$cat]) ?>
                                <span class="poste-legend-count"><?= $n ?> (<?= round($n / $posteTotal * 100) ?>%)</span>
                            </span>
                        <?php endforeach; ?>
                    </div>
                </div>
                <div class="p-3">
                    <div class="poste-bar" id="poste-bar">
                        <?php foreach ($parCategorie as $cat => $n): if ($n === 0) continue; ?>
                            <div class="poste-seg" style="width:<?= round($n / $posteTotal * 100, 2) ?>%; background:<?= $posteColors[$cat] ?>"></div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
            <?php endif; ?>
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
                                        $expireYear  = '';
                                        $expireClass = '';
                                        if ($j['expireContrat']) {
                                            $parts = explode('/', $j['expireContrat']);
                                            $expireYear = end($parts);
                                            if ((int)$expireYear === $saisonFin) {
                                                $expireClass = 'expire-this';
                                            } elseif ((int)$expireYear === $saisonFinNext) {
                                                $expireClass = 'expire-next';
                                            }
                                        }
                                        $status = $j['mercato_status'];
                                        ?>
                                        <tr data-nom="<?= htmlspecialchars(mb_strtolower($j['nom'] ?? '')) ?>"
                                            data-poste="<?= htmlspecialchars($j['poste'] ?? '') ?>"
                                            data-expire="<?= $expireYear ?>"
                                            data-statut="<?= $j['mercato_status'] ?? '' ?>"
                                            data-prix="<?= (int)($j['prixDemande'] ?? 0) ?>">
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
                                            <td>
                                                <?php $curRole = $effectiveRole($j); ?>
                                                <select class="role-select form-select form-select-sm" data-id="<?= $j['idJoueur'] ?>">
                                                    <?php foreach ($roleOptions as $opt): ?>
                                                        <option value="<?= htmlspecialchars($opt) ?>" <?= $opt === $curRole ? 'selected' : '' ?>><?= htmlspecialchars($t['role_abbr_' . $opt] ?? $opt) ?></option>
                                                    <?php endforeach; ?>
                                                </select>
                                            </td>
                                            <td class="text-end"><?= $j['app'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['pDec'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['buts'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['noteMoy'] ?? '' ?></td>
                                            <td class="text-end"><?= $j['prixDemande'] !== null ? number_format((int)$j['prixDemande'], 0, ',', ' ') . ' €' : '' ?></td>
                                            <td>
                                                <span class="<?= $expireClass ?>"><?= htmlspecialchars($j['expireContrat'] ?? '') ?></span>
                                            </td>
                                            <td>
                                                <div class="mercato-status-toggle" data-id="<?= $j['idJoueur'] ?>">
                                                    <button type="button" class="ms-opt ms-none <?= $status === null   ? 'active' : '' ?>" data-status="">—</button>
                                                    <button type="button" class="ms-opt ms-sell <?= $status === 'sell' ? 'active' : '' ?>" data-status="sell"><?= $t['squad_status_sell'] ?></button>
                                                    <button type="button" class="ms-opt ms-loan <?= $status === 'loan' ? 'active' : '' ?>" data-status="loan"><?= $t['squad_status_loan'] ?></button>
                                                    <button type="button" class="ms-opt ms-free <?= $status === 'free' ? 'active' : '' ?>" data-status="free"><?= $t['squad_status_free'] ?></button>
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                                <tfoot class="table-secondary">
                                    <tr>
                                        <td colspan="11">
                                            <div class="role-legend">
                                                <?php foreach ($roleOptions as $code): ?>
                                                    <span class="role-legend-item"><strong><?= htmlspecialchars($t['role_abbr_' . $code] ?? $code) ?></strong> = <?= htmlspecialchars($t['role_' . $code] ?? $code) ?></span>
                                                <?php endforeach; ?>
                                            </div>
                                            <hr class="role-legend-sep">
                                            <div class="poste-legend" style="margin-top:0">
                                                <span class="poste-legend-item">
                                                    <span class="poste-legend-dot" style="background:var(--brand)"></span>
                                                    <?= htmlspecialchars($t['squad_badge_expiry_this']) ?>
                                                </span>
                                                <span class="poste-legend-item">
                                                    <span class="poste-legend-dot" style="background:#e0a030"></span>
                                                    <?= htmlspecialchars($t['squad_badge_expiry_next']) ?>
                                                </span>
                                            </div>
                                        </td>
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
                        <script>
                        function formatBudgetJs(val) {
                            return val.toLocaleString('fr-FR') + ' €';
                        }
                        function refreshMercatoStats() {
                            const rows = document.querySelectorAll('#effectifTable tbody tr');
                            let enVente = 0, enPret = 0, recettes = 0;
                            rows.forEach(function (row) {
                                const prix = parseInt(row.dataset.prix, 10) || 0;
                                if (row.dataset.statut === 'sell') { enVente++; recettes += prix; }
                                if (row.dataset.statut === 'loan') { enPret++; }
                            });
                            const venteEl = document.getElementById('stat-en-vente');
                            if (venteEl) {
                                venteEl.textContent = enVente;
                                venteEl.classList.toggle('text-danger', enVente > 0);
                            }
                            const pretEl = document.getElementById('stat-en-pret');
                            if (pretEl) pretEl.textContent = enPret;
                            const soldeEl = document.getElementById('stat-mercato-solde');
                            const subEl   = document.getElementById('stat-mercato-sub');
                            if (soldeEl) {
                                const depenses = parseInt(soldeEl.closest('.stat-item').dataset.mercatoDepenses, 10) || 0;
                                const solde = recettes - depenses;
                                soldeEl.textContent = (solde > 0 ? '+' : '') + formatBudgetJs(solde);
                                soldeEl.classList.toggle('text-success', solde >= 0);
                                soldeEl.classList.toggle('text-danger', solde < 0);
                                if (subEl) subEl.textContent = '+' + formatBudgetJs(recettes) + ' / −' + formatBudgetJs(depenses);
                            }
                        }
                        document.querySelectorAll('.mercato-status-toggle').forEach(function (toggle) {
                            toggle.querySelectorAll('.ms-opt').forEach(function (btn) {
                                btn.addEventListener('click', function () {
                                    if (btn.classList.contains('active')) return;
                                    const tr = toggle.closest('tr');
                                    const status = btn.dataset.status;
                                    fetch('mercato_status_post.php', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: new URLSearchParams({
                                            idJoueur: toggle.dataset.id,
                                            status: status,
                                            csrf_token: <?= json_encode(csrf_token()) ?>
                                        })
                                    }).then(r => r.json()).then(function (data) {
                                        if (!data.ok) return;
                                        tr.dataset.statut = status;
                                        toggle.querySelectorAll('.ms-opt').forEach(b => b.classList.remove('active'));
                                        btn.classList.add('active');
                                        btn.classList.add('mercato-status-saved');
                                        setTimeout(() => btn.classList.remove('mercato-status-saved'), 900);
                                        refreshMercatoStats();
                                    });
                                });
                            });
                        });
                        </script>
                        <script>
                        const ROLE_CATEGORY = <?= json_encode($roleCategory ?? []) ?>;
                        const POSTE_COLORS  = <?= json_encode($posteColors ?? []) ?>;
                        const POSTE_LABELS  = <?= json_encode($posteLabels ?? []) ?>;
                        const POSTE_ORDER   = ['Gardien', 'Défense', 'Milieu', 'Attaque'];
                        function refreshPosteStats() {
                            const barEl = document.getElementById('poste-bar');
                            const legendEl = document.getElementById('poste-legend');
                            if (!barEl || !legendEl) return;
                            const counts = { 'Gardien': 0, 'Défense': 0, 'Milieu': 0, 'Attaque': 0 };
                            document.querySelectorAll('#effectifTable tbody .role-select').forEach(function (sel) {
                                const cat = ROLE_CATEGORY[sel.value];
                                if (cat) counts[cat]++;
                            });
                            const total = POSTE_ORDER.reduce((sum, cat) => sum + counts[cat], 0);
                            if (total === 0) return;
                            barEl.innerHTML = '';
                            legendEl.innerHTML = '';
                            POSTE_ORDER.forEach(function (cat) {
                                const n = counts[cat];
                                const pct = Math.round(n / total * 100);
                                if (n > 0) {
                                    const seg = document.createElement('div');
                                    seg.className = 'poste-seg';
                                    seg.style.width = (n / total * 100) + '%';
                                    seg.style.background = POSTE_COLORS[cat];
                                    barEl.appendChild(seg);
                                }
                                const item = document.createElement('span');
                                item.className = 'poste-legend-item';
                                item.innerHTML = '<span class="poste-legend-dot" style="background:' + POSTE_COLORS[cat] + '"></span>'
                                    + POSTE_LABELS[cat]
                                    + ' <span class="poste-legend-count">' + n + ' (' + pct + '%)</span>';
                                legendEl.appendChild(item);
                            });
                        }
                        document.querySelectorAll('#effectifTable .role-select').forEach(function (sel) {
                            sel.addEventListener('change', function () {
                                fetch('role_match_post.php', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: new URLSearchParams({
                                        idJoueur: sel.dataset.id,
                                        role: sel.value,
                                        csrf_token: <?= json_encode(csrf_token()) ?>
                                    })
                                }).then(r => r.json()).then(function (data) {
                                    if (!data.ok) return;
                                    refreshPosteStats();
                                });
                            });
                        });
                        </script>
                    <?php else: ?>
                        <div class="p-4 text-center text-muted">
                            <?= $t['squad_empty'] ?> <a href="#" data-bs-toggle="modal" data-bs-target="#uploadModal"><?= $t['squad_import_link'] ?></a>
                        </div>
                    <?php endif; ?>
            </div>

            <!-- Arrivées mercato (fusionné depuis l'ex-page mercato.php) -->
            <div class="table-panel mt-4">
                <div class="table-panel-head">
                    <span class="section-title"><span style="color:var(--heading)"><?= $t['mercato_arr_title'] ?></span></span>
                    <?php if (!empty($arrivees)): ?>
                        <form action="mercato_arrivee_post.php" method="post"
                              data-confirm="<?= htmlspecialchars($t['mercato_arr_delete_all_confirm'], ENT_QUOTES) ?>"
                              data-confirm-variant="danger">
                            <?= csrf_field() ?>
                            <input type="hidden" name="delete_all" value="1">
                            <button type="submit" class="btn-danger-ghost">
                                <ion-icon name="trash-outline"></ion-icon> <?= $t['mercato_arr_delete_all'] ?>
                            </button>
                        </form>
                    <?php endif; ?>
                </div>
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
                    <div class="table-scroll">
                        <table class="table table-sm table-hover align-middle mb-0 data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th><?= $t['mercato_arr_col_name'] ?></th>
                                    <th><?= $t['mercato_arr_col_pos'] ?></th>
                                    <th class="text-end"><?= $t['mercato_arr_col_price'] ?></th>
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
                                        <td class="text-end"><?= $a['prix'] !== null ? formatBudget((int)$a['prix']) : '—' ?></td>
                                        <td><span class="badge bg-<?= $statutColors[$a['statut']] ?? 'secondary' ?>"><?= $statutLabels[$a['statut']] ?? $a['statut'] ?></span></td>
                                        <td>
                                        <div class="d-flex gap-1 align-items-center">
                                            <button class="btn btn-sm btn-outline-primary" title="Modifier" aria-label="Modifier"
                                                    data-bs-toggle="modal" data-bs-target="#editArriveeModal"
                                                    data-id="<?= $a['idArrivee'] ?>"
                                                    data-nom="<?= htmlspecialchars($a['nom'], ENT_QUOTES) ?>"
                                                    data-poste="<?= htmlspecialchars($a['poste'] ?? '', ENT_QUOTES) ?>"
                                                    data-prix="<?= $a['prix'] ?? '' ?>"
                                                    data-statut="<?= $a['statut'] ?>">
                                                <ion-icon name="pencil-outline"></ion-icon>
                                            </button>
                                            <form action="mercato_arrivee_post.php" method="post" style="display:contents"
                                                  data-confirm="Supprimer ?" data-confirm-variant="danger">
                                                <?= csrf_field() ?>
                                                <input type="hidden" name="delete_id" value="<?= $a['idArrivee'] ?>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Supprimer" aria-label="Supprimer">
                                                    <ion-icon name="trash-outline"></ion-icon>
                                                </button>
                                            </form>
                                        </div>
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
                        <button type="submit" class="btn-brand btn-sm"><?= $t['mercato_arr_add'] ?></button>
                    </div>
                </form>
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
