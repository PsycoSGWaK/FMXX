<?php
/**
 * Génère sql/equipe_insert.sql à partir des dumps JSON de l'API-Football
 * (endpoint GET /teams), un dump par ligue, posés dans sql/api_dumps/.
 *
 * Ce script NE touche PAS à la base : il produit un fichier .sql à relire
 * puis injecter manuellement. Lancement : php import_teams_from_dumps.php
 * (ou via le navigateur). Voir api_dumps/README.md pour le workflow complet.
 *
 * Les INSERT utilisent une sous-requête (SELECT idPays FROM pays WHERE paysA2C=...)
 * pour résoudre le pays, donc le .sql reste valable quels que soient les
 * AUTO_INCREMENT de la table pays.
 */

// ---------------------------------------------------------------------------
// Configuration : 1 ligne par fichier JSON attendu dans api_dumps/.
// [ fichier, paysA2C, genre ('M'|'F'), division ('D1'..'D4') ]
// Les codes paysA2C doivent exister dans la table `pays` (cf. migration).
// ---------------------------------------------------------------------------
$DUMPS = [
    // ---- FEMMES (genre F) ----  (league.id API entre parenthèses)
    ['de_frauen_bundesliga.json', 'DE', 'F', 'D1'], // 82  Frauen Bundesliga
    ['gb_wsl.json',               'GB', 'F', 'D1'], // 44  FA WSL
    ['gb_wsl2.json',              'GB', 'F', 'D2'], // 699 Women's Championship
    ['es_liga_f.json',            'ES', 'F', 'D1'], // 142 Liga F (D2 fém. absente API)
    ['us_nwsl.json',              'US', 'F', 'D1'], // 254 NWSL Women
    ['fr_d1_feminine.json',       'FR', 'F', 'D1'], // 64  Feminine Division 1
    ['it_serie_a_women.json',     'IT', 'F', 'D1'], // 139 Serie A Women
    ['jp_we_league.json',         'JP', 'F', 'D1'], // 854 WE League
    ['se_damallsvenskan.json',    'SE', 'F', 'D1'], // 549 Damallsvenskan
    ['se_elitettan.json',         'SE', 'F', 'D2'], // 736 Elitettan
    // ⚠ Adran Premier (WL F D1) absente de l'API 2024 → ajout manuel admin.

    // ---- HOMMES (genre M) ----
    ['de_bundesliga.json',        'DE', 'M', 'D1'], // 78  Bundesliga
    ['de_2_bundesliga.json',      'DE', 'M', 'D2'], // 79  2. Bundesliga
    ['gb_premier_league.json',    'GB', 'M', 'D1'], // 39  Premier League
    ['gb_championship.json',      'GB', 'M', 'D2'], // 40  Championship
    ['gb_league_one.json',        'GB', 'M', 'D3'], // 41  League One
    ['at_bundesliga.json',        'AT', 'M', 'D1'], // 218 Bundesliga (Autriche)
    ['be_pro_league.json',        'BE', 'M', 'D1'], // 144 Jupiler Pro League
    ['be_challenger_pro.json',    'BE', 'M', 'D2'], // 145 Challenger Pro League
    ['br_serie_a.json',           'BR', 'M', 'D1'], // 71  Serie A (Brésil)
    ['br_serie_b.json',           'BR', 'M', 'D2'], // 72  Serie B
    ['es_la_liga.json',           'ES', 'M', 'D1'], // 140 La Liga
    ['es_la_liga_2.json',         'ES', 'M', 'D2'], // 141 Segunda División
    ['us_mls.json',               'US', 'M', 'D1'], // 253 Major League Soccer
    ['fr_ligue_1.json',           'FR', 'M', 'D1'], // 61  Ligue 1
    ['fr_ligue_2.json',           'FR', 'M', 'D2'], // 62  Ligue 2
    ['fr_national.json',          'FR', 'M', 'D3'], // 63  National 1
    ['fr_national_2_a.json',      'FR', 'M', 'D4'], // 67  National 2 - Group A
    ['fr_national_2_b.json',      'FR', 'M', 'D4'], // 68  National 2 - Group B
    ['fr_national_2_c.json',      'FR', 'M', 'D4'], // 69  National 2 - Group C
    ['it_serie_a.json',           'IT', 'M', 'D1'], // 135 Serie A
    ['it_serie_b.json',           'IT', 'M', 'D2'], // 136 Serie B
    ['jp_j1.json',                'JP', 'M', 'D1'], // 98  J1 League
    ['jp_j2.json',                'JP', 'M', 'D2'], // 99  J2 League
    ['wl_cymru_premier.json',     'WL', 'M', 'D1'], // 110 Premier League (Cymru)
    ['wl_faw_championship.json',  'WL', 'M', 'D2'], // 111 FAW Championship
    // ⚠ Cymru North/South (WL M D2) absents de l'API 2024 → ajout manuel admin.
    ['nl_eredivisie.json',        'NL', 'M', 'D1'], // 88  Eredivisie
    ['nl_eerste_divisie.json',    'NL', 'M', 'D2'], // 89  Eerste Divisie
    ['pt_primeira_liga.json',     'PT', 'M', 'D1'], // 94  Primeira Liga
    ['pt_liga_portugal_2.json',   'PT', 'M', 'D2'], // 95  Segunda Liga
    ['tr_super_lig.json',         'TR', 'M', 'D1'], // 203 Süper Lig
    ['tr_1_lig.json',             'TR', 'M', 'D2'], // 204 1. Lig
    ['se_allsvenskan.json',       'SE', 'M', 'D1'], // 113 Allsvenskan
];

// ---------------------------------------------------------------------------
$dumpDir = __DIR__ . '/api_dumps';
$outFile = __DIR__ . '/equipe_insert.sql';
$eol     = "\n";

// Détection CLI vs navigateur pour la mise en forme des logs
$isCli = (php_sapi_name() === 'cli');
function logLine(string $msg, bool $isCli): void {
    echo $isCli ? $msg . "\n" : htmlspecialchars($msg) . "<br>\n";
}

$sql = [];
$sql[] = "-- Généré par import_teams_from_dumps.php le " . date('Y-m-d H:i:s');
$sql[] = "-- Vérifier ce fichier avant de l'injecter en base.";
$sql[] = "";

$totalTeams = 0;
$totalFilesOk = 0;
$missing = [];

foreach ($DUMPS as [$file, $a2c, $genre, $division]) {
    $path = $dumpDir . '/' . $file;

    if (!is_file($path)) {
        $missing[] = $file;
        continue; // dump pas encore récupéré : on saute sans bloquer
    }

    $raw = file_get_contents($path);
    $data = json_decode($raw, true);

    if (!is_array($data)) {
        logLine("[ERREUR] JSON illisible : $file", $isCli);
        continue;
    }
    if (!empty($data['errors'])) {
        logLine("[IGNORÉ] $file contient des erreurs API : "
            . json_encode($data['errors'], JSON_UNESCAPED_UNICODE), $isCli);
        continue;
    }
    if (empty($data['response']) || !is_array($data['response'])) {
        logLine("[VIDE] $file : aucune équipe dans 'response'", $isCli);
        continue;
    }

    $sql[] = "-- $file  ($a2c / $genre / $division)  — " . count($data['response']) . " équipes";

    $seen = []; // dédoublonnage intra-fichier sur le nom
    $count = 0;
    foreach ($data['response'] as $item) {
        $name = $item['team']['name'] ?? null;
        if (!$name) continue;
        $name = trim($name);
        $key = mb_strtolower($name);
        if (isset($seen[$key])) continue;
        $seen[$key] = true;

        $nameSql  = "'" . str_replace("'", "''", $name) . "'";
        $a2cSql   = "'" . str_replace("'", "''", $a2c) . "'";
        $genreSql = "'" . $genre . "'";
        $divSql   = "'" . $division . "'";

        $sql[] = "INSERT INTO equipe (nomEquipe, idPays, genre, division) "
            . "VALUES ($nameSql, (SELECT idPays FROM pays WHERE paysA2C = $a2cSql LIMIT 1), $genreSql, $divSql);";
        $count++;
    }
    $sql[] = "";
    $totalTeams += $count;
    $totalFilesOk++;
    logLine("[OK] $file → $count équipes ($a2c/$genre/$division)", $isCli);
}

file_put_contents($outFile, implode($eol, $sql) . $eol);

logLine("", $isCli);
logLine("Terminé : $totalFilesOk fichier(s) traité(s), $totalTeams équipe(s) générée(s).", $isCli);
logLine("Fichier SQL écrit : " . $outFile, $isCli);
if ($missing) {
    logLine("Dumps manquants (" . count($missing) . ") — pas encore récupérés via l'API :", $isCli);
    foreach ($missing as $m) logLine("   - $m", $isCli);
}
