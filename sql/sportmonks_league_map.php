<?php
/**
 * Mapping (pays, genre, division) -> league_id SportMonks, verifie a la main
 * ligne par ligne contre api_dumps_sportmonks/leagues.json (voir
 * sportmonks_fetch_leagues.php) et le catalogue `competition` existant.
 *
 * Chaque ligne : [paysA2C, genre, division, league_id, commentaire]
 * Un meme (paysA2C, genre, division) peut avoir PLUSIEURS league_id (ex.
 * France D4 = 3 groupes regionaux, Pays de Galles D2 = Nord + Sud) : tous
 * les clubs sont fusionnes dans la meme division, comme le faisait deja
 * l'ancien pipeline API-Football (fr_national_2_a/b/c).
 *
 * Volontairement absents de ce mapping (laisses inchanges, donnees deja
 * presentes via l'import API-Football d'origine, pas de correspondance
 * fiable trouvee cote SportMonks dans la selection actuelle) :
 * Allemagne D3 (3. Liga) + F D2, Italie D3 (Serie C) + F D2 (Serie B
 * Femminile), Espagne D3 (Primera Federacion).
 *
 * France M D3 : confirme par Guillaume (2026-08-30) que "Ligue 3" (313)
 * est bien le nouveau nom 2026-27 de l'ancienne "National" (D3) -- cf
 * migration_fix_france_d3_d4_names.sql.
 */

return [
    // ---- Deja en base, refresh des clubs ----
    ['AU', 'M', 'D1', [1356], 'A-League Men'],
    ['AT', 'M', 'D1', [181],  'Admiral Bundesliga'],
    ['AT', 'M', 'D2', [184],  '2. Liga'],
    ['BE', 'M', 'D1', [208],  'Pro League'],
    ['BE', 'M', 'D2', [211],  'Challenger Pro League'],
    ['BR', 'M', 'D1', [648],  'Serie A'],
    ['BR', 'M', 'D2', [651],  'Serie B'],
    ['DK', 'M', 'D1', [271],  'Superliga'],
    ['DK', 'M', 'D2', [274],  'First Division'],
    ['FR', 'M', 'D1', [301],  'Ligue 1'],
    ['FR', 'M', 'D2', [304],  'Ligue 2'],
    ['FR', 'M', 'D3', [313],  'Ligue 3 (= ex-National)'],
    ['FR', 'M', 'D4', [1177, 1178, 1179], 'CFA Group A/B/C = National 2 (3 groupes)'],
    ['FR', 'F', 'D1', [1575], 'Premiere Ligue Women'],
    ['DE', 'M', 'D1', [82],   'Bundesliga'],
    ['DE', 'M', 'D2', [85],   '2. Bundesliga'],
    ['DE', 'F', 'D1', [1740], 'Google Pixel Frauen-Bundesliga (sponsor, ignore pour le nom)'],
    ['IE', 'M', 'D1', [360],  'Premier Division'],
    ['IE', 'M', 'D2', [363],  'First Division'],
    ['IT', 'M', 'D1', [384],  'Serie A'],
    ['IT', 'M', 'D2', [387],  'Serie B'],
    ['IT', 'F', 'D1', [1578], 'Serie A Women'],
    ['JP', 'M', 'D1', [968],  'J1 League'],
    ['JP', 'M', 'D2', [1022], 'J2-League'],
    ['JP', 'F', 'D1', [3023], 'WE League'],
    ['NL', 'M', 'D1', [72],   'Eredivisie'],
    ['NL', 'M', 'D2', [74],   'Eerste Divisie'],
    ['NI', 'M', 'D1', [438],  'Premiership'],
    ['NI', 'M', 'D2', [441],  'Championship'],
    ['PT', 'M', 'D1', [462],  'Liga Portugal'],
    ['PT', 'M', 'D2', [465],  'Liga Portugal 2'],
    ['SC', 'M', 'D1', [501],  'Premiership'],
    ['SC', 'M', 'D2', [504],  'Championship'],
    ['ES', 'M', 'D1', [564],  'La Liga'],
    ['ES', 'M', 'D2', [567],  'La Liga 2'],
    ['ES', 'F', 'D1', [1568], 'Primera Division Women'],
    ['ES', 'F', 'D2', [2344], 'Segunda Division Femenina (nom SportMonks != nom Guillaume, non applique ici)'],
    ['SE', 'M', 'D1', [573],  'Allsvenskan'],
    ['SE', 'M', 'D2', [579],  'Superettan'],
    ['SE', 'F', 'D1', [576],  'Damallsvenskan'],
    ['SE', 'F', 'D2', [1548], 'Elitettan Women'],
    ['TR', 'M', 'D1', [600],  'Super Lig'],
    ['TR', 'M', 'D2', [603],  '1. Lig'],
    ['GB', 'M', 'D1', [8],    'Premier League'],
    ['GB', 'M', 'D2', [9],    'Championship'],
    ['GB', 'M', 'D3', [12],   'League One'],
    ['GB', 'F', 'D1', [45],   "Women's Super League"],
    ['GB', 'F', 'D2', [44],   'WSL 2'],
    ['US', 'M', 'D1', [779],  'Major League Soccer'],
    ['US', 'F', 'D1', [2328], 'NWSL'],

    // ---- Nouveau : Pays de Galles, jamais eu de ligne `competition` ----
    ['WL', 'M', 'D1', [624],        'Premier League (= Cymru Premier)'],
    ['WL', 'M', 'D2', [1738, 3499], 'Cymru Championship North + South'],
    ['WL', 'F', 'D1', [2868],       "Welsh Premier Women's League (= Adran Premier)"],

    // ---- Nouveau : championnats feminins manquants ----
    ['DK', 'F', 'D1', [1573], 'Elitedivisionen Women'],
    ['AU', 'F', 'D1', [1583], 'A-League Women'],
];
