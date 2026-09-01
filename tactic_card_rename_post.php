<?php
/**
 * Renomme UNE card tactique (bouton "renommer" a cote du titre de la vue
 * detail Tactic Sub). Un nom vide efface le nom personnalise : l'UI retombe
 * alors sur le libelle par defaut "Style tactique N".
 */
session_start();
require_once("db.php");
require_once("csrf.php");

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}

csrf_verify();
$idUser = $_SESSION['idUser'];
$idTacticCard = (int)($_POST['idTacticCard'] ?? 0);
$nom = trim((string)($_POST['nom'] ?? ''));
if (mb_strlen($nom) > 60) {
    $nom = mb_substr($nom, 0, 60);
}

$check = $pdo->prepare("SELECT COUNT(*) FROM tactic_card WHERE idTacticCard = :id AND idUser = :idUser");
$check->execute(['id' => $idTacticCard, 'idUser' => $idUser]);

if ($check->fetchColumn()) {
    $pdo->prepare("UPDATE tactic_card SET nom = :nom WHERE idTacticCard = :id")
        ->execute(['nom' => $nom !== '' ? $nom : null, 'id' => $idTacticCard]);
}

header("Location: index.php?tab=tactic&card=" . $idTacticCard);
