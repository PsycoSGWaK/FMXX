<?php
/**
 * Change la tactique associee a UNE card (selecteur de la vue detail Tactic
 * Sub). Remplace tactic_active_post.php : la tactique active n'est plus une
 * notion globale par user mais propre a chaque card. Changer la tactique
 * d'une card reinitialise sa composition (les postes ne correspondent plus
 * forcement), comportement voulu : garder plusieurs compositions se fait
 * desormais en ayant plusieurs cards, pas en gardant un historique par
 * tactique au sein d'une meme card.
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
$idTacticPreset = (int)($_POST['idTacticPreset'] ?? 0);

$cardCheck = $pdo->prepare("SELECT COUNT(*) FROM tactic_card WHERE idTacticCard = :id AND idUser = :idUser");
$cardCheck->execute(['id' => $idTacticCard, 'idUser' => $idUser]);

$presetCheck = $pdo->prepare("SELECT COUNT(*) FROM tactic_preset WHERE idTacticPreset = :id");
$presetCheck->execute(['id' => $idTacticPreset]);

if ($cardCheck->fetchColumn() && $presetCheck->fetchColumn()) {
    $pdo->prepare("UPDATE tactic_card SET idTacticPreset = :p WHERE idTacticCard = :id")
        ->execute(['p' => $idTacticPreset, 'id' => $idTacticCard]);
    $pdo->prepare("DELETE FROM tactic WHERE idTacticCard = :id")->execute(['id' => $idTacticCard]);
}

header("Location: index.php?tab=tactic&card=" . $idTacticCard);
