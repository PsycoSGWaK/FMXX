<?php
/**
 * Ajoute une nouvelle "card" tactique dans l'espace personnel de
 * l'utilisateur (bouton "+" de la grille Tactic Sub). La card pointe par
 * defaut sur la premiere tactique de la bibliotheque (ordre alphabetique,
 * meme tri que dans index.php) ; l'utilisateur choisit ensuite librement
 * une autre tactique ou en cree une nouvelle depuis la vue detail.
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

// Doit rester synchronise avec TACTIC_MAX_CARDS dans index.php.
const TACTIC_MAX_CARDS = 5;

$countStmt = $pdo->prepare("SELECT COUNT(*) FROM tactic_card WHERE idUser = :idUser");
$countStmt->execute(['idUser' => $idUser]);

if ((int)$countStmt->fetchColumn() < TACTIC_MAX_CARDS) {
    $defaultPreset = $pdo->query("SELECT idTacticPreset FROM tactic_preset ORDER BY idUserCreateur IS NULL DESC, nom LIMIT 1")->fetchColumn();
    if ($defaultPreset) {
        $pdo->prepare("INSERT INTO tactic_card (idUser, idTacticPreset) VALUES (:idUser, :idTacticPreset)")
            ->execute(['idUser' => $idUser, 'idTacticPreset' => $defaultPreset]);
    }
}

header("Location: index.php?tab=tactic");
