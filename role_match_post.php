<?php
/**
 * Met à jour les rôles "utilisés en match" (choix manuel de l'utilisateur,
 * pré-remplis automatiquement depuis l'import) d'UN SEUL joueur, appelé en
 * arrière-plan (fetch) depuis le multi-select de la colonne Poste de
 * l'effectif — pas de rechargement de page. Un joueur peut avoir plusieurs
 * rôles ; une liste vide efface le choix manuel (retour à la suggestion
 * automatique déduite du poste importé).
 */
session_start();
require_once("db.php");
require_once("csrf.php");
require_once("poste_helpers.php");

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

$idUser   = $_SESSION['idUser'];
$idJoueur = (int)($_POST['idJoueur'] ?? 0);
$rolesIn  = is_array($_POST['roles'] ?? null) ? $_POST['roles'] : [];
$roles    = array_values(array_unique(array_filter($rolesIn, fn($r) => in_array($r, $roleOptions, true))));

if (count($roles) !== count(array_unique($rolesIn))) {
    // Au moins une valeur envoyée n'est pas dans la liste fermée des 16 rôles.
    http_response_code(400);
    echo json_encode(['ok' => false]);
    exit;
}

$checkStmt = $pdo->prepare("SELECT poste FROM joueur WHERE idJoueur = :id AND idUser = :idUser");
$checkStmt->execute(['id' => $idJoueur, 'idUser' => $idUser]);
$joueur = $checkStmt->fetch();
if (!$joueur) {
    http_response_code(404);
    echo json_encode(['ok' => false]);
    exit;
}

$pdo->beginTransaction();
$pdo->prepare("DELETE FROM joueur_role WHERE idJoueur = :id")->execute(['id' => $idJoueur]);
if (!empty($roles)) {
    $insertStmt = $pdo->prepare("INSERT INTO joueur_role (idJoueur, role_code) VALUES (:id, :role)");
    foreach ($roles as $role) {
        $insertStmt->execute(['id' => $idJoueur, 'role' => $role]);
    }
}
$pdo->commit();

// Liste vide envoyée -> le client doit resynchroniser ses cases sur la
// suggestion automatique recalculée, pas rester avec un select vide.
$returnedRoles = !empty($roles) ? $roles : $suggestRoleMatches($joueur['poste'] ?? '');
usort($returnedRoles, fn($a, $b) => array_search($a, $roleOptions) <=> array_search($b, $roleOptions));

echo json_encode(['ok' => true, 'roles' => $returnedRoles]);
