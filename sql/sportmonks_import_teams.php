<?php
/**
 * Genere sql/equipe_insert_sportmonks.sql a partir des dumps JSON de
 * sportmonks_fetch_teams.php. NE touche PAS la base directement : produit
 * un fichier .sql a relire puis injecter manuellement (meme principe que
 * import_teams_from_dumps.php pour API-Football).
 *
 * Pour chaque (pays, genre, division) traite : DELETE cible (seulement ces
 * lignes-la, pas un TRUNCATE global) puis reinsertion fraiche. Les
 * combinaisons non couvertes par le mapping restent intactes.
 *
 * Lancement : php sportmonks_import_teams.php
 */

$dumpDir = __DIR__ . '/api_dumps_sportmonks';
$outFile = __DIR__ . '/equipe_insert_sportmonks.sql';
$map     = require __DIR__ . '/sportmonks_league_map.php';

// Exclusions decidees apres verification manuelle des dumps (voir memoire) :
// - ES F D2 : le league_id SportMonks "Segunda Division Femenina" agrege
//   plusieurs groupes regionaux + equipes reserve (42 clubs, incoherent
//   avec les 16 deja en base sous "Primera Federacion FutFem"). Exclu tant
//   que non clarifie.
$EXCLUDE = [
    'ES_F_D2',
];

$isCli = (php_sapi_name() === 'cli');
function logLine(string $msg, bool $isCli): void {
    echo $isCli ? $msg . "\n" : htmlspecialchars($msg) . "<br>\n";
}

$sql = [];
$sql[] = "-- Genere par sportmonks_import_teams.php le " . date('Y-m-d H:i:s');
$sql[] = "-- Verifier ce fichier avant de l'injecter en base.";
$sql[] = "-- A executer en production (phpMyAdmin o2switch) en plus du local.";
$sql[] = "";

$totalTeams = 0;
$totalCombos = 0;
$missing = [];
$excluded = [];

foreach ($map as [$a2c, $genre, $division, $leagueIds, $label]) {
    $comboKey = "{$a2c}_{$genre}_{$division}";
    if (in_array($comboKey, $EXCLUDE, true)) {
        $excluded[] = "$comboKey ($label)";
        continue;
    }

    $file = strtolower($a2c) . '_' . $genre . $division . '.json';
    $path = $dumpDir . '/' . $file;
    if (!is_file($path)) {
        $missing[] = $file;
        continue;
    }

    $teams = json_decode(file_get_contents($path), true);
    if (!is_array($teams) || empty($teams)) {
        logLine("[VIDE] $file", $isCli);
        continue;
    }

    $a2cSql = "'" . str_replace("'", "''", $a2c) . "'";
    $genreSql = "'" . $genre . "'";
    $divSql = "'" . $division . "'";

    $sql[] = "-- $file ($label) - " . count($teams) . " equipes";
    $sql[] = "DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = $a2cSql LIMIT 1) AND genre = $genreSql AND division = $divSql;";

    $seen = [];
    $count = 0;
    foreach ($teams as $name) {
        $name = trim($name);
        // SportMonks ajoute systematiquement " W" aux equipes feminines.
        if ($genre === 'F' && str_ends_with($name, ' W')) {
            $name = substr($name, 0, -2);
        }
        $key = mb_strtolower($name);
        if (isset($seen[$key])) continue;
        $seen[$key] = true;

        $nameSql = "'" . str_replace("'", "''", $name) . "'";
        $sql[] = "INSERT INTO equipe (nomEquipe, idPays, genre, division) "
            . "VALUES ($nameSql, (SELECT idPays FROM pays WHERE paysA2C = $a2cSql LIMIT 1), $genreSql, $divSql);";
        $count++;
    }
    $sql[] = "";
    $totalTeams += $count;
    $totalCombos++;
    logLine("[OK] $file -> $count equipes ($a2c/$genre/$division)", $isCli);
}

file_put_contents($outFile, implode("\n", $sql) . "\n");

logLine("", $isCli);
logLine("Termine : $totalCombos combinaison(s) traitee(s), $totalTeams equipe(s) generee(s).", $isCli);
logLine("Fichier SQL ecrit : $outFile", $isCli);
if ($excluded) {
    logLine("Exclu(s) volontairement (" . count($excluded) . ") :", $isCli);
    foreach ($excluded as $e) logLine("   - $e", $isCli);
}
if ($missing) {
    logLine("Dumps manquants (" . count($missing) . ") :", $isCli);
    foreach ($missing as $m) logLine("   - $m", $isCli);
}
