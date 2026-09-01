<?php
session_start();
require_once("db.php");
require_once("csrf.php");

// Doit être un POST d'un utilisateur connecté
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

// Anti-CSRF : le formulaire d'import envoie déjà csrf_field()
csrf_verify();

// Taille maximale acceptée pour un fichier d'effectif (5 Mo, largement suffisant)
const MAX_UPLOAD_BYTES = 5 * 1024 * 1024;

// Extensions autorisées
const ALLOWED_EXT = ['csv', 'html', 'htm'];

// Vérifier qu'un fichier a bien été reçu sans erreur
if (!isset($_FILES['playerFile']) || $_FILES['playerFile']['error'] !== UPLOAD_ERR_OK) {
    header("Location: index.php?error=upload");
    exit;
}

// Vérifier que c'est bien un fichier réellement uploadé (anti-injection de chemin)
if (!is_uploaded_file($_FILES['playerFile']['tmp_name'])) {
    header("Location: index.php?error=upload");
    exit;
}

// Limite de taille
if ($_FILES['playerFile']['size'] > MAX_UPLOAD_BYTES) {
    header("Location: index.php?error=too_big");
    exit;
}

$idUser   = $_SESSION['idUser'];
$tmpFile  = $_FILES['playerFile']['tmp_name'];
$ext      = strtolower(pathinfo($_FILES['playerFile']['name'], PATHINFO_EXTENSION));

// N'accepter que les extensions attendues
if (!in_array($ext, ALLOWED_EXT, true)) {
    header("Location: index.php?error=format");
    exit;
}

// Correspondance entêtes FM → colonnes BDD (FM24 + FM26)
const COL_MAP = [
    // ID unique FM (stable d'une saison à l'autre, sert à détecter les
    // joueurs déjà importés pour permettre un import additif)
    'unique id'            => 'fmUid',
    'uid'                  => 'fmUid',
    'id unique'            => 'fmUid',
    // Nom
    'nom'                  => 'nom',
    'joueuse'              => 'nom',  // équipe féminine
    'joueur'               => 'nom',  // équipe masculine
    'name'                 => 'nom',
    // Âge
    'âge'                  => 'age',
    'age'                  => 'age',
    // Numéro
    'n°'                   => 'numero',
    'no'                   => 'numero',
    // Nationalité
    'nat'                  => 'nat',
    'nation'               => 'nat',
    'nationality'          => 'nat',
    // Pays de naissance
    'pdn'                  => 'pdn',
    'pays de naissance'    => 'pdn',
    'place of birth'       => 'pdn',
    // Poste
    'poste'                => 'poste',
    'position'             => 'poste',
    // Matchs
    'app'                  => 'app',
    'matchs disputés'      => 'app',
    'apps'                 => 'app',
    // Passes décisives
    'déc'                  => 'pDec',
    'dec'                  => 'pDec',
    'passes décisives'     => 'pDec',
    'assists'              => 'pDec',
    // Buts
    'buts'                 => 'buts',
    'goals'                => 'buts',
    // Note
    'note moy'             => 'noteMoy',
    'note'                 => 'noteMoy',
    'avg rating'           => 'noteMoy',
    'rating'               => 'noteMoy',
    // Valeur transfert
    'montant transfert'    => 'montantTransfert',
    'transfer value'       => 'montantTransfert',
    'valeur transfert'     => 'montantTransfert',
    // Prix demandé
    'prix demandé'         => 'prixDemande',
    'prix demande'         => 'prixDemande',
    'asking price'         => 'prixDemande',
    // Salaire
    'salaire'              => 'salaire',
    'wage'                 => 'salaire',
    // Expiration contrat
    'expire le'            => 'expireContrat',
    'contract expires'     => 'expireContrat',
    'expires'              => 'expireContrat',
];

function parseAmount(string $value): ?int {
    $v = trim($value);
    if ($v === '' || $v === '-') return null;
    // Supprimer symboles monétaires, espaces normales et insécables
    $v = str_replace(['€', '$', '£', ' ', "\xc2\xa0", "\u{202F}"], '', $v);
    // Périodicité de salaire FM ("p/m", "p/w", "p/a"...) : le "m" de "p/m" serait sinon
    // confondu avec le multiplicateur "millions" ci-dessous. Période ignorée (pas de
    // conversion) : à l'utilisateur de rester cohérent avec la période de son budget salaires.
    $v = preg_replace('/p\/[a-z]$/i', '', $v);
    $v = trim($v);
    if ($v === '' || $v === '-') return null;
    // Détecter K ou M en fin de chaîne (insensible à la casse)
    $multiplier = 1;
    if (preg_match('/([KkMm])$/u', $v, $m)) {
        $multiplier = strtoupper($m[1]) === 'K' ? 1000 : 1000000;
        $v = substr($v, 0, -1);
    }
    // Remplacer virgule décimale par point
    $v = str_replace(',', '.', $v);
    if (!is_numeric($v)) return null;
    return (int) round((float)$v * $multiplier);
}

function formatAmount(?int $value): string {
    if ($value === null) return '';
    return number_format($value, 0, ',', ' ') . ' €';
}

function normalizeHeader(string $h): string {
    // Supprimer BOM UTF-8 éventuel
    $h = str_replace("\xEF\xBB\xBF", '', $h);
    return mb_strtolower(trim(preg_replace('/\s+/', ' ', $h)), 'UTF-8');
}

// --- Lecture du fichier ---
$headers = [];
$rows    = [];

if ($ext === 'csv') {
    $content = file_get_contents($tmpFile);
    $content = mb_convert_encoding($content, 'UTF-8', mb_detect_encoding($content, null, true));
    $lines   = explode("\n", trim($content));
    if (count($lines) < 2) { header("Location: index.php?error=empty"); exit; }

    $rawHeaders = str_getcsv($lines[0], ';');
    foreach ($rawHeaders as $h) {
        $headers[] = normalizeHeader($h);
    }
    for ($i = 1; $i < count($lines); $i++) {
        $line = trim($lines[$i]);
        if ($line === '') continue;
        $rows[] = str_getcsv($line, ';');
    }

} elseif (in_array($ext, ['html', 'htm'])) {
    $content = file_get_contents($tmpFile);
    $content = mb_convert_encoding($content, 'UTF-8', mb_detect_encoding($content, null, true));
    $dom = new DOMDocument();
    @$dom->loadHTML(mb_convert_encoding($content, 'HTML-ENTITIES', 'UTF-8'));
    $xpath = new DOMXPath($dom);

    // Lire les entêtes depuis <th>
    $ths = $xpath->query('//table/tr[1]/th');
    if ($ths->length === 0) $ths = $xpath->query('//table/thead/tr/th');
    foreach ($ths as $th) {
        $headers[] = normalizeHeader($th->nodeValue);
    }

    $tableRows = $xpath->query('//table/tr');
    for ($i = 1; $i < $tableRows->length; $i++) {
        $cols   = $xpath->query('td', $tableRows->item($i));
        $values = [];
        for ($j = 0; $j < $cols->length; $j++) {
            $values[] = trim($cols->item($j)->nodeValue);
        }
        if (count($values) > 0) $rows[] = $values;
    }
} else {
    header("Location: index.php?error=format");
    exit;
}

// Mapper index de colonne → champ BDD
$colIndex = [];
foreach ($headers as $i => $h) {
    $key = normalizeHeader($h);
    if (isset(COL_MAP[$key])) {
        $colIndex[COL_MAP[$key]] = $i;
    }
}

// --- Insertion en BDD ---
// Import additif : n'ajoute que les joueurs pas encore presents pour ce
// compte, ne touche jamais aux joueurs/tactiques deja enregistres. La
// detection de doublon se fait par l'ID unique FM (colonne "Unique ID" de
// l'export, stable d'une saison a l'autre) quand le fichier la fournit ;
// a defaut (ancien format d'export), on retombe sur une comparaison de nom.
$existingUids = $pdo->prepare("SELECT fm_uid FROM joueur WHERE idUser = :idUser AND fm_uid IS NOT NULL");
$existingUids->execute(['idUser' => $idUser]);
$knownUids = array_flip($existingUids->fetchAll(PDO::FETCH_COLUMN));

$existingNoms = $pdo->prepare("SELECT nom FROM joueur WHERE idUser = :idUser");
$existingNoms->execute(['idUser' => $idUser]);
$knownNoms = array_flip(array_map('mb_strtolower', $existingNoms->fetchAll(PDO::FETCH_COLUMN)));

$stmt = $pdo->prepare(
    'INSERT INTO joueur (fm_uid, nom, age, numero, nat, pdn, poste, app, pDec, buts, noteMoy, montantTransfert, prixDemande, salaire, expireContrat, idUser)
     VALUES (:fm_uid, :nom, :age, :numero, :nat, :pdn, :poste, :app, :pDec, :buts, :noteMoy, :montantTransfert, :prixDemande, :salaire, :expireContrat, :idUser)'
);

function colVal(array $row, array $colIndex, string $field): ?string {
    if (!isset($colIndex[$field])) return null;
    $v = $row[$colIndex[$field]] ?? null;
    if ($v === null || trim($v) === '' || $v === '-') return null;
    return trim($v);
}

$imported = 0;
$skipped  = 0;

foreach ($rows as $row) {
    $nom = colVal($row, $colIndex, 'nom');
    if ($nom === null) continue; // ligne invalide, sans nom

    $fmUid = colVal($row, $colIndex, 'fmUid');

    // Doublon si l'UID correspond a un joueur deja connu, OU si le nom
    // correspond : les joueurs importes avant cette fonctionnalite n'ont pas
    // d'UID enregistre, donc seul le nom permet de les reconnaitre meme si
    // le nouveau fichier fournit un UID pour cette ligne.
    $isDuplicate = ($fmUid !== null && isset($knownUids[$fmUid])) || isset($knownNoms[mb_strtolower($nom)]);
    if ($isDuplicate) { $skipped++; continue; }

    $prixRaw    = colVal($row, $colIndex, 'prixDemande');
    $salaireRaw = colVal($row, $colIndex, 'salaire');
    $stmt->execute([
        'fm_uid'           => $fmUid,
        'nom'              => $nom,
        'age'              => colVal($row, $colIndex, 'age'),
        'numero'           => colVal($row, $colIndex, 'numero'),
        'nat'              => colVal($row, $colIndex, 'nat'),
        'pdn'              => colVal($row, $colIndex, 'pdn'),
        'poste'            => colVal($row, $colIndex, 'poste'),
        'app'              => colVal($row, $colIndex, 'app'),
        'pDec'             => colVal($row, $colIndex, 'pDec'),
        'buts'             => colVal($row, $colIndex, 'buts'),
        'noteMoy'          => colVal($row, $colIndex, 'noteMoy'),
        'montantTransfert' => colVal($row, $colIndex, 'montantTransfert'),
        'prixDemande'      => $prixRaw !== null ? parseAmount($prixRaw) : null,
        'salaire'          => $salaireRaw !== null ? parseAmount($salaireRaw) : null,
        'expireContrat'    => colVal($row, $colIndex, 'expireContrat'),
        'idUser'           => $idUser,
    ]);
    $imported++;
    if ($fmUid !== null) $knownUids[$fmUid] = true;
    $knownNoms[mb_strtolower($nom)] = true;
}

header("Location: index.php?success=true&imported=$imported&skipped=$skipped");
