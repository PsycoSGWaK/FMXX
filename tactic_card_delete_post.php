<?php
/**
 * Retire une card de l'espace personnel de l'utilisateur (bouton x sur la
 * grille Tactic Sub), avec la composition (joueurs assignes) associee.
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

// Verifie que la card appartient bien a l'utilisateur courant avant de la
// supprimer (evite qu'un idTacticCard arbitraire d'un autre compte soit
// efface).
$check = $pdo->prepare("SELECT COUNT(*) FROM tactic_card WHERE idTacticCard = :id AND idUser = :idUser");
$check->execute(['id' => $idTacticCard, 'idUser' => $idUser]);

if ($check->fetchColumn()) {
    $pdo->prepare("DELETE FROM tactic WHERE idTacticCard = :id")->execute(['id' => $idTacticCard]);
    $pdo->prepare("DELETE FROM tactic_card WHERE idTacticCard = :id")->execute(['id' => $idTacticCard]);
}

header("Location: index.php?tab=tactic");
