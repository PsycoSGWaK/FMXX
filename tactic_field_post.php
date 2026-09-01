<?php
/**
 * Met à jour UN SEUL joueur (titulaire/remplaçant/super sub) d'UNE SEULE
 * position d'UNE card tactique, appelé en arrière-plan (fetch) depuis les
 * select de la vue détail Tactic Sub — pas de bouton "Sauvegarder", pas de
 * rechargement de page. Remplace tactic_post.php qui supprimait puis
 * réinsérait les 11 positions à chaque sauvegarde (même piège déjà corrigé
 * ailleurs pour mercato et objectifs). UPSERT sur la clé unique
 * (idTacticCard, position).
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

$validRoles = ['titulaire', 'remplacant', 'supersub'];
$idUser       = $_SESSION['idUser'];
$idTacticCard = (int)($_POST['idTacticCard'] ?? 0);
$position     = (int)($_POST['position'] ?? 0);
$role         = $_POST['role'] ?? '';
$value        = $_POST['value'] ?? '';

if ($position < 1 || $position > 11 || !in_array($role, $validRoles, true) || $idTacticCard < 1) {
    http_response_code(400);
    echo json_encode(['ok' => false]);
    exit;
}

// La card doit appartenir a l'utilisateur courant (evite qu'un idTacticCard
// arbitraire d'un autre compte soit modifie).
$cardCheck = $pdo->prepare("SELECT COUNT(*) FROM tactic_card WHERE idTacticCard = :id AND idUser = :idUser");
$cardCheck->execute(['id' => $idTacticCard, 'idUser' => $idUser]);
if (!$cardCheck->fetchColumn()) {
    http_response_code(403);
    echo json_encode(['ok' => false]);
    exit;
}

$playerId = $value !== '' ? (int)$value : null;

// Si un joueur est choisi, verifier qu'il appartient bien a cet utilisateur
// (evite qu'un idJoueur arbitraire d'un autre compte soit enregistre).
if ($playerId !== null) {
    $check = $pdo->prepare("SELECT COUNT(*) FROM joueur WHERE idJoueur = :id AND idUser = :idUser");
    $check->execute(['id' => $playerId, 'idUser' => $idUser]);
    if (!$check->fetchColumn()) {
        http_response_code(400);
        echo json_encode(['ok' => false]);
        exit;
    }
}

$cols = ['titulaire' => null, 'remplacant' => null, 'supersub' => null];
$cols[$role] = $playerId;

$stmt = $pdo->prepare("INSERT INTO tactic (idUser, idTacticCard, position, titulaire, remplacant, supersub)
    VALUES (:idUser, :idTacticCard, :position, :titulaire, :remplacant, :supersub)
    ON DUPLICATE KEY UPDATE `$role` = VALUES(`$role`)");
$stmt->execute([
    'idUser'       => $idUser,
    'idTacticCard' => $idTacticCard,
    'position'     => $position,
    'titulaire'    => $cols['titulaire'],
    'remplacant'   => $cols['remplacant'],
    'supersub'     => $cols['supersub'],
]);

echo json_encode(['ok' => true]);
