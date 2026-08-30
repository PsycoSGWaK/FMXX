<?php
/**
 * Récupère le référentiel complet des ligues SportMonks (avec leur pays) et
 * le sauvegarde dans api_dumps_sportmonks/leagues.json. Sert de base pour
 * retrouver les league_id sans refaire de requêtes de recherche à l'aveugle
 * (voir sportmonks_league_map.php).
 *
 * À LANCER EN CLI :  php sportmonks_fetch_leagues.php
 *
 * La clé API est lue HORS du webroot (non téléchargeable depuis le navigateur) :
 *   - via la variable d'environnement FMXX_SPORTMONKS_KEY_FILE si définie, sinon
 *   - dans C:/wamp64/fmxx_secrets/sportmonks_api_key.txt (une ligne, la clé seule).
 * NE PAS remettre la clé sous www/ : elle serait servie par Apache.
 */

$dumpDir = __DIR__ . '/api_dumps_sportmonks';
$keyFile = getenv('FMXX_SPORTMONKS_KEY_FILE') ?: 'C:/wamp64/fmxx_secrets/sportmonks_api_key.txt';
$outFile = $dumpDir . '/leagues.json';

if (php_sapi_name() !== 'cli') {
    exit("À lancer en ligne de commande : php sportmonks_fetch_leagues.php\n");
}
if (!is_file($keyFile)) {
    exit("Clé API manquante. Crée le fichier $keyFile avec ta clé SportMonks dedans.\n");
}
$apiKey = trim(file_get_contents($keyFile));
if ($apiKey === '') exit("Le fichier sportmonks_api_key.txt est vide.\n");
if (!is_dir($dumpDir)) mkdir($dumpDir, 0777, true);

$all = [];
$page = 1;
do {
    $url = "https://api.sportmonks.com/v3/football/leagues"
        . "?api_token=" . urlencode($apiKey)
        . "&include=country&per_page=100&page=" . $page;

    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 30,
        // WAMP local sans bundle CA : on désactive la vérif du certificat.
        // Acceptable pour un usage perso local ; à ne pas faire en prod.
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_SSL_VERIFYHOST => 0,
    ]);
    $resp = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $err  = curl_error($ch);

    if ($resp === false || $code !== 200) {
        echo "[ERREUR] page $page : HTTP $code $err\n";
        break;
    }

    $data = json_decode($resp, true);
    if (!empty($data['message']) && empty($data['data'])) {
        echo "[STOP] page $page : " . $data['message'] . "\n";
        break;
    }

    $batch = $data['data'] ?? [];
    foreach ($batch as $l) $all[] = $l;
    echo "[OK] page $page → " . count($batch) . " ligues (total: " . count($all) . ")\n";

    $hasMore = $data['pagination']['has_more'] ?? false;
    $page++;
    if ($hasMore) usleep(300000); // pause polie entre pages
} while ($hasMore);

file_put_contents($outFile, json_encode($all, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

echo "\nTerminé : " . count($all) . " ligues écrites dans $outFile\n";
echo "Lance ensuite : php sportmonks_league_map.php (à créer/completer) puis sportmonks_fetch_teams.php\n";
