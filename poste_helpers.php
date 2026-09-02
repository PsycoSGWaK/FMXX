<?php
/**
 * Dictionnaires de correspondance postes (codes bruts FM importés, FR/EN/ES)
 * -> code canonique de la liste fermée des 16 rôles "utilisés en match".
 * Partagé entre index.php (affichage effectif/tactique) et role_match_post.php
 * (validation AJAX) pour éviter la duplication de $roleOptions.
 */

// Dictionnaire explicite FR + EN + ES (codes FM). Les qualificatifs de côté
// entre parenthèses ("D (C)", "MO (DGC)"...) sont retirés avant le
// découpage : seul le rôle de base (avant la parenthèse) est classé.
$posteMap = [
    // Gardien
    'GB' => 'Gardien', 'GK' => 'Gardien', 'POR' => 'Gardien',
    // Défense
    'D' => 'Défense', 'DC' => 'Défense', 'DD' => 'Défense', 'DG' => 'Défense',
    'DR' => 'Défense', 'DL' => 'Défense',
    'ALD' => 'Défense', 'ALG' => 'Défense', 'WBR' => 'Défense', 'WBL' => 'Défense',
    'CB' => 'Défense', 'RB' => 'Défense', 'LB' => 'Défense',
    'RWB' => 'Défense', 'LWB' => 'Défense', 'WB' => 'Défense', 'SW' => 'Défense',
    'DFD' => 'Défense', 'DFI' => 'Défense', 'DFC' => 'Défense', 'CRD' => 'Défense', 'CRI' => 'Défense',
    // Milieu
    'M' => 'Milieu', 'MD' => 'Milieu', 'MDC' => 'Milieu', 'MC' => 'Milieu', 'MOC' => 'Milieu',
    'MO' => 'Milieu', 'MG' => 'Milieu', 'MR' => 'Milieu', 'ML' => 'Milieu',
    'CDM' => 'Milieu', 'DM' => 'Milieu', 'CM' => 'Milieu', 'CAM' => 'Milieu', 'AMC' => 'Milieu',
    'AM' => 'Milieu', 'RM' => 'Milieu', 'LM' => 'Milieu',
    'MED' => 'Milieu', 'MEI' => 'Milieu', 'MEC' => 'Milieu', 'MPC' => 'Milieu',
    // Attaque
    'MOD' => 'Attaque', 'MOG' => 'Attaque', 'AL' => 'Attaque', 'AMR' => 'Attaque', 'AML' => 'Attaque',
    'BTC' => 'Attaque', 'BT' => 'Attaque', 'STC' => 'Attaque', 'DLC' => 'Attaque',
    'RW' => 'Attaque', 'LW' => 'Attaque', 'ST' => 'Attaque', 'FW' => 'Attaque',
    'MPD' => 'Attaque', 'MPI' => 'Attaque',
];
$rankOrder = ['Gardien' => 0, 'Défense' => 1, 'Milieu' => 2, 'Attaque' => 3];
// Catégorie d'un poste brut (fallback de sécurité si un code ne fait pas
// partie de la liste fermée des 16 rôles).
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
// Traduction rôle brut -> [rôle interne EN, côté implicite]. Les lettres de
// côté FR (C/D/G = Centre/Droite/Gauche) et EN (C/L/R) ne se chevauchent
// jamais caractère par caractère : D et G n'existent qu'en FR, L n'existe
// qu'en EN — donc la traduction lettre à lettre est sans ambiguïté quelle
// que soit la langue d'import.
$roleEnMap = [
    'GB' => ['GK', null], 'GK' => ['GK', null], 'POR' => ['GK', null],
    'D'  => ['D', null],
    'DC' => ['D', 'C'], 'DD' => ['D', 'R'], 'DG' => ['D', 'L'],
    'DR' => ['D', 'R'], 'DL' => ['D', 'L'],
    'CB' => ['D', 'C'], 'RB' => ['D', 'R'], 'LB' => ['D', 'L'],
    'DFD' => ['D', 'R'], 'DFI' => ['D', 'L'], 'DFC' => ['D', 'C'],
    'ALD' => ['WB', 'R'], 'ALG' => ['WB', 'L'], 'WBR' => ['WB', 'R'], 'WBL' => ['WB', 'L'],
    'RWB' => ['WB', 'R'], 'LWB' => ['WB', 'L'], 'WB' => ['WB', null],
    'CRD' => ['WB', 'R'], 'CRI' => ['WB', 'L'],
    'SW' => ['SW', null],
    'M'  => ['M', null],
    'MC' => ['M', 'C'], 'CM' => ['M', 'C'],
    // Milieu défensif central = MDC (FR) ; MD (FR) = Milieu droit (tranché le 29/08).
    'MDC' => ['CDM', null], 'CDM' => ['CDM', null], 'DM' => ['CDM', null],
    'MOC' => ['AM', 'C'], 'CAM' => ['AM', 'C'], 'AMC' => ['AM', 'C'], 'MPC' => ['AM', 'C'],
    'MO' => ['AM', null], 'AM' => ['AM', null],
    'MG' => ['M', 'L'], 'LM' => ['M', 'L'], 'RM' => ['M', 'R'], 'MD' => ['M', 'R'],
    'MR' => ['M', 'R'], 'ML' => ['M', 'L'], 'MED' => ['M', 'R'], 'MEI' => ['M', 'L'], 'MEC' => ['M', 'C'],
    'MOD' => ['W', 'R'], 'RW' => ['W', 'R'], 'AMR' => ['W', 'R'], 'MPD' => ['W', 'R'],
    'MOG' => ['W', 'L'], 'LW' => ['W', 'L'], 'AML' => ['W', 'L'], 'MPI' => ['W', 'L'],
    'AL' => ['W', null],
    'BTC' => ['ST', null], 'BT' => ['ST', null], 'ST' => ['ST', null], 'STC' => ['ST', null], 'DLC' => ['ST', null],
    'FW' => ['FW', null],
];

// Les 16 rôles "utilisés en match" proposés dans le sélecteur (codes courts
// EN de la liste FR/EN/ES fournie par Guillaume, 2026-08-29 — le code est
// toujours stocké en EN, l'abréviation affichée dans le sélecteur et le
// glossaire est traduite via $t['role_abbr_XXX']). Liste fermée : un seul
// rôle par combinaison rôle+côté.
$roleOptions = ['GK', 'CB', 'RB', 'LB', 'RWB', 'LWB', 'SW', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'RW', 'LW', 'ST', 'FW'];
// Ordre d'affichage voulu par Guillaume pour le filtre "Tous les postes" de
// l'effectif (GB, DD, DG, DC, ALD, ALG, MDC, MD, MG, MC, MOD, MOG, MOC, BTC
// — 2026-09-02), différent de l'ordre catégorie de $roleOptions. SW et FW
// n'y figurent pas (Guillaume ne les a pas mentionnés) : ajoutés à la fin
// pour ne pas les faire disparaître du filtre si un joueur les a.
$filterPosteOrder = ['GK', 'RB', 'LB', 'CB', 'RWB', 'LWB', 'CDM', 'RM', 'LM', 'CM', 'RW', 'LW', 'CAM', 'ST', 'SW', 'FW'];
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

// Tous les [rôle interne EN, côté] valides d'un poste importé. Le format FM
// "BASE (LETTRES)" est un raccourci pour plusieurs postes complets — ex.
// "D (DGC)" veut dire "défenseur central ET droit ET gauche", pas "un seul
// côté combiné" — donc chaque lettre de côté est résolue séparément via la
// clé composée BASE+LETTRE si elle existe dans le dictionnaire (ex. 'DD',
// 'DG', 'DC', 'MOD', 'MOC', 'ALD'...), qui porte déjà le bon rôle interne
// pour cette variante précise (utile notamment pour "MO" : "MOD"/"MOG"
// pointent vers un rôle différent — Attaque — de "MOC" — Milieu). Si aucune
// clé composée n'existe pour une lettre donnée, on retombe sur l'entrée
// générique du rôle de base (côté ignoré).
$findAllRoleTokens = function(string $poste) use ($posteMap, $roleEnMap): array {
    $groups = array_filter(array_map('trim', explode(',', $poste)));
    $result = [];
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
            if ($sideRaw === '') {
                $result[] = $roleEnMap[$tok] ?? [$tok, null];
                continue;
            }
            $matched = false;
            foreach (str_split($sideRaw) as $letter) {
                $compound = $tok . $letter;
                if (isset($roleEnMap[$compound])) {
                    $result[] = $roleEnMap[$compound];
                    $matched = true;
                }
            }
            if (!$matched) {
                $result[] = $roleEnMap[$tok] ?? [$tok, null];
            }
        }
    }
    return $result;
};
// Résout un [rôle interne EN, côté] déjà désambiguïsé vers un code de la
// liste fermée des 16 rôles.
$resolveFinalRole = function(string $enRole, ?string $side) use ($finalRoleMap): string {
    if ($enRole === 'AM') return 'CAM'; // AM n'a que la variante centrale dans la liste actée.
    if (in_array($enRole, ['GK', 'SW', 'CDM', 'ST', 'FW'], true)) {
        return $finalRoleMap["$enRole|"] ?? 'CM';
    }
    $side = $side ?: (($enRole === 'W' || $enRole === 'WB') ? 'R' : 'C');
    return $finalRoleMap["$enRole|$side"] ?? 'CM';
};
// Suggestion de postes déduits de l'import : tous les rôles détectés dans le
// poste brut (pas seulement le plus prioritaire), dédupliqués, triés dans
// l'ordre de $roleOptions. Sert de valeur par défaut tant que l'utilisateur
// n'a pas fait de choix manuel (table joueur_role).
$suggestRoleMatches = function(string $poste) use ($findAllRoleTokens, $resolveFinalRole, $roleOptions): array {
    $pairs = $findAllRoleTokens($poste);
    if (empty($pairs)) return ['CM'];
    $roles = [];
    foreach ($pairs as [$enRole, $side]) {
        $roles[] = $resolveFinalRole($enRole, $side);
    }
    $roles = array_values(array_unique($roles));
    usort($roles, fn($a, $b) => array_search($a, $roleOptions) <=> array_search($b, $roleOptions));
    return $roles;
};
