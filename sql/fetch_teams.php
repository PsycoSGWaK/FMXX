<?php
/**
 * Récupère automatiquement les dumps /teams de l'API-Football pour toutes
 * les ligues listées, et les sauvegarde dans api_dumps/<fichier>.json.
 *
 * À LANCER EN CLI :  php fetch_teams.php
 *
 * - Saute les dumps déjà présents (ne re-consomme jamais un appel réussi).
 * - Respecte la limite du plan gratuit (10 req/min) via une pause entre appels.
 * - S'arrête proprement si l'API renvoie une erreur de quota.
 *
 * La clé API est lue HORS du webroot (non téléchargeable depuis le navigateur) :
 *   - via la variable d'environnement FMXX_API_KEY_FILE si définie, sinon
 *   - dans C:/wamp64/fmxx_secrets/api_key.txt (une ligne, la clé seule).
 * NE PAS remettre la clé sous www/ : elle serait servie par Apache.
 */

$SEASON   = 2024;
$dumpDir  = __DIR__ . '/api_dumps';
$keyFile  = getenv('FMXX_API_KEY_FILE') ?: 'C:/wamp64/fmxx_secrets/api_key.txt';
$host     = 'v3.football.api-sports.io';      // hôte direct API-Sports
$pauseSec = 7;                                 // ~9 req/min, sous la limite de 10

// [ fichier, league.id ]  — mêmes fichiers que import_teams_from_dumps.php
$LEAGUES = [
    // Femmes
    ['de_frauen_bundesliga.json', 82],
    ['gb_wsl.json',               44],
    ['gb_wsl2.json',              699],
    ['es_liga_f.json',            142],
    ['us_nwsl.json',              254],
    ['fr_d1_feminine.json',       64],
    ['it_serie_a_women.json',     139],
    ['jp_we_league.json',         854],
    ['se_damallsvenskan.json',    549],
    ['se_elitettan.json',         736],
    // Hommes
    ['de_bundesliga.json',        78],
    ['de_2_bundesliga.json',      79],
    ['gb_premier_league.json',    39],
    ['gb_championship.json',      40],
    ['gb_league_one.json',        41],
    ['at_bundesliga.json',        218],
    ['be_pro_league.json',        144],
    ['be_challenger_pro.json',    145],
    ['br_serie_a.json',           71],
    ['br_serie_b.json',           72],
    ['es_la_liga.json',           140],
    ['es_la_liga_2.json',         141],
    ['us_mls.json',               253],
    ['fr_ligue_1.json',           61],
    ['fr_ligue_2.json',           62],
    ['fr_national.json',          63],
    ['fr_national_2_a.json',      67],
    ['fr_national_2_b.json',      68],
    ['fr_national_2_c.json',      69],
    ['it_serie_a.json',           135],
    ['it_serie_b.json',           136],
    ['jp_j1.json',                98],
    ['jp_j2.json',                99],
    ['wl_cymru_premier.json',     110],
    ['wl_faw_championship.json',  111],
    ['nl_eredivisie.json',        88],
    ['nl_eerste_divisie.json',    89],
    ['pt_primeira_liga.json',     94],
    ['pt_liga_portugal_2.json',   95],
    ['tr_super_lig.json',         203],
    ['tr_1_lig.json',             204],
    ['se_allsvenskan.json',       113],
];

if (php_sapi_name() !== 'cli') {
    exit("À lancer en ligne de commande : php fetch_teams.php\n");
}
if (!is_file($keyFile)) {
    exit("Clé API manquante. Crée le fichier $keyFile avec ta clé API-Football dedans.\n");
}
$apiKey = trim(file_get_contents($keyFile));
if ($apiKey === '') exit("Le fichier api_key.txt est vide.\n");

$done = 0; $skipped = 0; $failed = 0;

foreach ($LEAGUES as [$file, $leagueId]) {
    $path = $dumpDir . '/' . $file;
    if (is_file($path)) {
        echo "[SKIP] $file déjà présent.\n";
        $skipped++;
        continue;
    }

    $url = "https://$host/teams?league=$leagueId&season=$SEASON";
    $ch  = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER     => ["x-apisports-key: $apiKey"],
        CURLOPT_TIMEOUT        => 30,
        // WAMP local sans bundle CA : on désactive la vérif du certificat.
        // Acceptable pour un usage perso local ; à ne pas faire en prod.
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_SSL_VERIFYHOST => 0,
    ]);
    $resp = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $err  = curl_error($ch);
    // curl_close() est inutile depuis PHP 8.0 (déprécié en 8.5) — on l'omet.

    if ($resp === false || $code !== 200) {
        echo "[ERREUR] $file (league=$leagueId) : HTTP $code $err\n";
        $failed++;
        // Si quota dépassé, l'API renvoie souvent 429 → on stoppe pour ne pas boucler.
        if ($code === 429) { echo "Quota atteint, arrêt.\n"; break; }
        sleep($pauseSec);
        continue;
    }

    $data = json_decode($resp, true);
    if (isset($data['errors']) && !empty($data['errors'])) {
        echo "[ERREUR API] $file : " . json_encode($data['errors'], JSON_UNESCAPED_UNICODE) . "\n";
        $failed++;
        // Erreur de quota/abonnement dans le corps JSON → on stoppe.
        $errStr = strtolower(json_encode($data['errors']));
        if (strpos($errStr, 'limit') !== false || strpos($errStr, 'plan') !== false) {
            echo "Limite de plan atteinte, arrêt.\n"; break;
        }
        sleep($pauseSec);
        continue;
    }

    file_put_contents($path, $resp);
    $nb = isset($data['response']) ? count($data['response']) : 0;
    echo "[OK]   $file (league=$leagueId) → $nb équipes\n";
    $done++;

    sleep($pauseSec); // pause anti rate-limit
}

echo "\nTerminé : $done récupéré(s), $skipped déjà présent(s), $failed échec(s).\n";
echo "Lance ensuite : php import_teams_from_dumps.php\n";
