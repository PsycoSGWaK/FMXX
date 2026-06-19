<?php
session_start();
require_once("db.php");

if (!isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

$idUser   = $_SESSION['idUser'];
$username = $_SESSION['username'] ?? 'user';

function rowsToCsv(array $rows): string {
    if (empty($rows)) return '';
    $out = fopen('php://temp', 'r+');
    fputcsv($out, array_keys($rows[0]), ';');
    foreach ($rows as $row) fputcsv($out, $row, ';');
    rewind($out);
    $csv = stream_get_contents($out);
    fclose($out);
    return $csv;
}

// Collecte des données
$user = $pdo->prepare("SELECT username, mail, club, genre FROM user WHERE idUser = :id");
$user->execute(['id' => $idUser]);
$userData = $user->fetchAll();

$joueurs = $pdo->prepare("SELECT nom, age, numero, nat, pdn, poste, app, pDec, buts, noteMoy, montantTransfert, prixDemande, expireContrat, mercato_status FROM joueur WHERE idUser = :id ORDER BY poste, nom");
$joueurs->execute(['id' => $idUser]);
$joueursData = $joueurs->fetchAll();

$objectifs = $pdo->prepare("SELECT o.saison, c.nomCompetition, c.typeCompetition, o.objectif, o.resultat FROM objectif o JOIN competition c ON c.idCompetition = o.idCompetition WHERE o.idUser = :id ORDER BY o.saison DESC");
$objectifs->execute(['id' => $idUser]);
$objectifsData = $objectifs->fetchAll();

$saisons = $pdo->prepare("SELECT saison, club, division, genre FROM saison_meta WHERE idUser = :id ORDER BY saison DESC");
$saisons->execute(['id' => $idUser]);
$saisonsData = $saisons->fetchAll();

// Génération du ZIP
$tmpFile = tempnam(sys_get_temp_dir(), 'fmxx_export_');
$zip = new ZipArchive();
$zip->open($tmpFile, ZipArchive::OVERWRITE);
$zip->addFromString('compte.csv',    rowsToCsv($userData));
$zip->addFromString('effectif.csv',  rowsToCsv($joueursData));
$zip->addFromString('objectifs.csv', rowsToCsv($objectifsData));
$zip->addFromString('saisons.csv',   rowsToCsv($saisonsData));
$zip->close();

$filename = 'fmxx_export_' . preg_replace('/[^a-z0-9_]/i', '_', $username) . '_' . date('Ymd') . '.zip';

header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Content-Length: ' . filesize($tmpFile));
readfile($tmpFile);
unlink($tmpFile);
