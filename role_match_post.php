<?php
/**
 * Met à jour le rôle "utilisé en match" (choix manuel de l'utilisateur,
 * pré-rempli automatiquement depuis l'import) d'UN SEUL joueur, appelé en
 * arrière-plan (fetch) depuis le sélecteur de la colonne Poste de
 * l'effectif — pas de rechargement de page.
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

// Doit rester synchronisé avec $roleOptions dans index.php.
$validRoles = ['GK', 'CB', 'RB', 'LB', 'RWB', 'LWB', 'SW', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'RW', 'LW', 'ST', 'FW'];

$idUser   = $_SESSION['idUser'];
$idJoueur = (int)($_POST['idJoueur'] ?? 0);
$role     = $_POST['role'] ?? '';
$roleVal  = in_array($role, $validRoles, true) ? $role : null;

if ($roleVal === null) {
    http_response_code(400);
    echo json_encode(['ok' => false]);
    exit;
}

$stmt = $pdo->prepare("UPDATE joueur SET role_match = :role WHERE idJoueur = :id AND idUser = :idUser");
$stmt->execute(['role' => $roleVal, 'id' => $idJoueur, 'idUser' => $idUser]);

echo json_encode(['ok' => true, 'role' => $roleVal]);
