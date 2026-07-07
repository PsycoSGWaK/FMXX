<?php
/**
 * Aide à trouver les league.id de l'API-Football SANS dépenser de call.
 *
 * Pré-requis : sauvegarder la réponse complète de
 *   GET https://v3.football.api-sports.io/leagues?season=2024&type=league
 * dans le fichier  sql/api_dumps/_leagues.json
 *
 * Ce script lit ce fichier et affiche, pour chacun des 15 pays cibles,
 * la liste des ligues (id — nom) afin d'identifier les bons IDs à l'œil
 * (les noms sponsorisés type "Sky Bet League One" n'existent pas côté API,
 * et plusieurs pays ont une "Premier League" : le filtrage par pays évite
 * toute confusion). Lancement : php find_league_ids.php
 */

// Pays cibles : nom(s) possibles côté API + code ISO, pour un matching tolérant.
$PAYS_CIBLES = [
    'Angleterre'     => ['names' => ['England'],            'code' => 'GB'],
    'Espagne'        => ['names' => ['Spain'],              'code' => 'ES'],
    'Allemagne'      => ['names' => ['Germany'],            'code' => 'DE'],
    'Italie'         => ['names' => ['Italy'],              'code' => 'IT'],
    'France'         => ['names' => ['France'],             'code' => 'FR'],
    'USA'            => ['names' => ['USA', 'United-States','United States'], 'code' => 'US'],
    'Japon'          => ['names' => ['Japan'],              'code' => 'JP'],
    'Pays de Galles' => ['names' => ['Wales'],              'code' => 'WL'],
    'Suède'          => ['names' => ['Sweden'],             'code' => 'SE'],
    'Autriche'       => ['names' => ['Austria'],            'code' => 'AT'],
    'Belgique'       => ['names' => ['Belgium'],            'code' => 'BE'],
    'Brésil'         => ['names' => ['Brazil'],             'code' => 'BR'],
    'Pays-Bas'       => ['names' => ['Netherlands'],        'code' => 'NL'],
    'Portugal'       => ['names' => ['Portugal'],           'code' => 'PT'],
    'Turquie'        => ['names' => ['Turkey', 'Türkiye', 'Turkiye'], 'code' => 'TR'],
];

$path = __DIR__ . '/api_dumps/_leagues.json';
$isCli = (php_sapi_name() === 'cli');
function out(string $s, bool $cli): void { echo $cli ? $s."\n" : htmlspecialchars($s)."<br>\n"; }

if (!is_file($path)) {
    out("Fichier introuvable : $path", $isCli);
    out("→ Sauvegarde d'abord la réponse de /leagues?season=2024&type=league dedans.", $isCli);
    exit;
}

$data = json_decode(file_get_contents($path), true);
if (!is_array($data) || empty($data['response'])) {
    out("JSON illisible ou champ 'response' vide.", $isCli);
    exit;
}

// Regroupe toutes les ligues par nom de pays normalisé.
$parPays = []; // nomPaysLower => [ ['id'=>, 'name'=>, 'country'=>, 'code'=>] ]
foreach ($data['response'] as $item) {
    $lg = $item['league'] ?? null;
    $co = $item['country'] ?? null;
    if (!$lg || !$co) continue;
    $cname = trim((string)($co['name'] ?? ''));
    $parPays[mb_strtolower($cname)][] = [
        'id'      => $lg['id'] ?? '?',
        'name'    => $lg['name'] ?? '?',
        'country' => $cname,
        'code'    => $co['code'] ?? '',
    ];
}

if (!$isCli) echo "<pre style='font:13px monospace'>";
foreach ($PAYS_CIBLES as $label => $cfg) {
    $found = [];
    foreach ($cfg['names'] as $n) {
        $key = mb_strtolower($n);
        if (isset($parPays[$key])) $found = array_merge($found, $parPays[$key]);
    }
    out("================ $label ({$cfg['code']}) ================", $isCli);
    if (!$found) {
        out("  (aucune ligue trouvée — vérifier le nom du pays côté API)", $isCli);
        out("", $isCli);
        continue;
    }
    usort($found, fn($a, $b) => strcmp($a['name'], $b['name']));
    foreach ($found as $f) {
        out(sprintf("  %-7s  %s", $f['id'], $f['name']), $isCli);
    }
    out("", $isCli);
}
if (!$isCli) echo "</pre>";
