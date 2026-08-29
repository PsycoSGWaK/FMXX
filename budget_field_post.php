<?php
/**
 * Sauvegarde en arrière-plan (fetch) les budgets transfert/salaires,
 * appelée au changement de l'un ou l'autre input — pas de bouton
 * "Sauvegarder", pas de rechargement de page. Remplace budget_post.php ;
 * les deux valeurs sont toujours envoyées ensemble (comme avant, via les
 * champs hidden) pour ne pas écraser l'une en modifiant l'autre.
 */
session_start();
require_once("db.php");
require_once(__DIR__ . "/csrf.php");

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

$idUser = $_SESSION['idUser'];
$bt = isset($_POST['budget_transfert']) && $_POST['budget_transfert'] !== '' ? (int)$_POST['budget_transfert'] : null;
$bs = isset($_POST['budget_salaires'])  && $_POST['budget_salaires']  !== '' ? (int)$_POST['budget_salaires']  : null;

$pdo->prepare("UPDATE user SET budget_transfert = :bt, budget_salaires = :bs WHERE idUser = :id")
    ->execute(['bt' => $bt, 'bs' => $bs, 'id' => $idUser]);

echo json_encode(['ok' => true]);
