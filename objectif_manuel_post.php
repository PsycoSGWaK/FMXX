<?php
/**
 * Ajout/retrait manuel d'une compétition dans l'onglet Objectifs, pour les
 * cas où la déduction automatique (règles de qualification, voir
 * competition_qualif_rule) ne peut rien déduire — typiquement la toute
 * première saison suivie dans l'outil (pas de saison précédente pour
 * calculer une qualification) alors que le club joue réellement une
 * Supercoupe ou une compétition continentale dans la save FM.
 */
session_start();
require_once("db.php");
require_once("csrf.php");

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php?tab=objectifs");
    exit;
}

csrf_verify();
$idUser = $_SESSION['idUser'];
$saison = $_SESSION['saison_active'] ?? '';

// Retrait (uniquement les compétitions ajoutées manuellement)
if (isset($_POST['remove_idCompetition'])) {
    $idComp = (int)$_POST['remove_idCompetition'];
    $stmt = $pdo->prepare("DELETE FROM objectif WHERE idUser = :idUser AND idCompetition = :idComp AND saison = :saison AND manuel = 1");
    $stmt->execute(['idUser' => $idUser, 'idComp' => $idComp, 'saison' => $saison]);
    header("Location: index.php?tab=objectifs");
    exit;
}

// Ajout
$idComp = (int)($_POST['idCompetition'] ?? 0);
if (!$idComp || $saison === '') {
    header("Location: index.php?tab=objectifs");
    exit;
}

$check = $pdo->prepare("SELECT idCompetition FROM competition WHERE idCompetition = :idComp");
$check->execute(['idComp' => $idComp]);
if (!$check->fetchColumn()) {
    header("Location: index.php?tab=objectifs");
    exit;
}

$stmt = $pdo->prepare(
    "INSERT INTO objectif (idUser, idCompetition, saison, manuel)
     VALUES (:idUser, :idComp, :saison, 1)
     ON DUPLICATE KEY UPDATE manuel = 1"
);
$stmt->execute(['idUser' => $idUser, 'idComp' => $idComp, 'saison' => $saison]);

header("Location: index.php?tab=objectifs");
