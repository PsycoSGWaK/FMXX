<?php
/**
 * Pour chaque entree de sportmonks_league_map.php : resout la saison en
 * cours de chaque league_id, recupere les clubs de cette saison, et
 * sauvegarde le resultat dans api_dumps_sportmonks/<paysA2C>_<genre><division>.json.
 *
 * Une entree avec plusieurs league_id (ex. Pays de Galles D2 Nord+Sud,
 * France D4 = 3 groupes) fusionne les clubs des saisons correspondantes
 * dans le meme fichier de dump.
 *
 * À LANCER EN CLI :  php sportmonks_fetch_teams.php
 *
 * Idempotent : saute les dumps deja presents. Clé lue comme
 * sportmonks_fetch_leagues.php (hors webroot).
 */

$dumpDir = __DIR__ . '/api_dumps_sportmonks';
$keyFile = getenv('FMXX_SPORTMONKS_KEY_FILE') ?: 'C:/wamp64/fmxx_secrets/sportmonks_api_key.txt';
$map     = require __DIR__ . '/sportmonks_league_map.php';

if (php_sapi_name() !== 'cli') {
    exit("À lancer en ligne de commande : php sportmonks_fetch_teams.php\n");
}
if (!is_file($keyFile)) {
    exit("Clé API manquante : $keyFile\n");
}
$apiKey = trim(file_get_contents($keyFile));
if ($apiKey === '') exit("Le fichier sportmonks_api_key.txt est vide.\n");
if (!is_dir($dumpDir)) mkdir($dumpDir, 0777, true);

function smGet(string $url): ?array {
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 30,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_SSL_VERIFYHOST => 0,
    ]);
    $resp = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if ($resp === false || $code !== 200) {
        echo "  [ERREUR HTTP $code] $url\n";
        return null;
    }
    $data = json_decode($resp, true);
    if (!empty($data['message']) && empty($data['data'])) {
        echo "  [ERREUR API] " . $data['message'] . "\n";
        return null;
    }
    return $data;
}

$done = 0; $skipped = 0; $failed = 0;

foreach ($map as [$a2c, $genre, $division, $leagueIds, $label]) {
    $file = strtolower($a2c) . '_' . $genre . $division . '.json';
    $path = $dumpDir . '/' . $file;

    if (is_file($path)) {
        echo "[SKIP] $file déjà présent.\n";
        $skipped++;
        continue;
    }

    echo "[...] $file ($label)\n";
    $teams = [];
    $seen = [];
    $ok = true;

    foreach ($leagueIds as $leagueId) {
        $detail = smGet("https://api.sportmonks.com/v3/football/leagues/$leagueId?api_token="
            . urlencode($apiKey) . "&include=currentSeason");
        usleep(200000);
        $seasonId = $detail['data']['currentseason']['id'] ?? null;
        if (!$seasonId) {
            echo "  [ERREUR] league $leagueId : pas de saison en cours trouvée.\n";
            $ok = false;
            continue;
        }

        $teamsResp = smGet("https://api.sportmonks.com/v3/football/teams/seasons/$seasonId?api_token="
            . urlencode($apiKey));
        usleep(200000);
        foreach (($teamsResp['data'] ?? []) as $t) {
            $name = trim($t['name'] ?? '');
            if ($name === '') continue;
            $key = mb_strtolower($name);
            if (isset($seen[$key])) continue;
            $seen[$key] = true;
            $teams[] = $name;
        }
    }

    if (!$ok && empty($teams)) {
        echo "  [ECHEC] $file : aucune équipe récupérée.\n";
        $failed++;
        continue;
    }

    file_put_contents($path, json_encode($teams, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    echo "  [OK] $file → " . count($teams) . " équipes\n";
    $done++;
}

echo "\nTerminé : $done récupéré(s), $skipped déjà présent(s), $failed échec(s).\n";
echo "Lance ensuite : php sportmonks_import_teams.php\n";
