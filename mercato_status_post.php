<?php
/**
 * Met à jour le statut mercato (vente/prêt/libérer/aucun) d'UN SEUL joueur,
 * appelé en arrière-plan (fetch) depuis le select de la colonne Statut de
 * l'effectif — pas de rechargement de page, pas de bouton "Sauvegarder".
 * Contrairement à l'ancien mercato_post.php, ne touche jamais aux autres
 * joueurs (celui-ci remettait TOUS les statuts à zéro à chaque sauvegarde,
 * incompatible avec une sauvegarde ligne par ligne).
 */
session_start();
require_once("db.php");
require_once("csrf.php");

header('Content-Type: application/json');

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(403);
    echo json_encode(['ok' => false]);
    exit;
}

$token = $_POST['csrf_token'] ?? '';
if (!hash_equals(csrf_token(), $token)) {
    http_response_code(403);
    echo json_encode(['ok' => false]);
    exit;
}

$idUser    = $_SESSION['idUser'];
$idJoueur  = (int)($_POST['idJoueur'] ?? 0);
$status    = $_POST['status'] ?? '';
$statusVal = in_array($status, ['sell', 'loan', 'free'], true) ? $status : null;

if (array_key_exists('prixVente', $_POST)) {
    $prixVente = $_POST['prixVente'] !== '' ? (int)$_POST['prixVente'] : null;
    $stmt = $pdo->prepare("UPDATE joueur SET prixVente = :prixVente WHERE idJoueur = :id AND idUser = :idUser");
    $stmt->execute(['prixVente' => $prixVente, 'id' => $idJoueur, 'idUser' => $idUser]);
    echo json_encode(['ok' => true, 'prixVente' => $prixVente]);
    exit;
}

$stmt = $pdo->prepare("UPDATE joueur SET mercato_status = :status WHERE idJoueur = :id AND idUser = :idUser");
$stmt->execute(['status' => $statusVal, 'id' => $idJoueur, 'idUser' => $idUser]);

echo json_encode(['ok' => true, 'status' => $statusVal]);
