<?php
/**
 * Cree une nouvelle tactique partagee (tactic_preset + ses 11
 * tactic_preset_slot) depuis le modal "Creer une tactique" de la vue detail
 * Tactic Sub. La tactique est visible et utilisable par tous les users des
 * sa creation ; la card depuis laquelle elle a ete creee bascule dessus
 * automatiquement (composition reinitialisee, meme comportement qu'un
 * changement de tactique via tactic_card_preset_post.php).
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

// Doit rester synchronisee avec $roleOptions dans index.php.
$validRoles = ['GK', 'CB', 'RB', 'LB', 'RWB', 'LWB', 'SW', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'RW', 'LW', 'ST', 'FW'];

$idUser       = $_SESSION['idUser'];
$idTacticCard = (int)($_POST['idTacticCard'] ?? 0);
$nom          = trim((string)($_POST['nom'] ?? ''));
$slots        = json_decode($_POST['slots'] ?? '', true);

if ($nom === '' || mb_strlen($nom) > 60 || !is_array($slots) || count($slots) !== 11) {
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

// Bibliotheque partagee entre tous les users : le nom doit etre unique tous
// createurs confondus (comparaison insensible a la casse, portee par la
// collation utf8mb4_unicode_ci de la colonne).
$dupCheck = $pdo->prepare("SELECT COUNT(*) FROM tactic_preset WHERE nom = :nom");
$dupCheck->execute(['nom' => $nom]);
if ($dupCheck->fetchColumn() > 0) {
    http_response_code(409);
    echo json_encode(['ok' => false, 'error' => 'duplicate_name']);
    exit;
}

$byPosition = [];
foreach ($slots as $slot) {
    $position = (int)($slot['position'] ?? 0);
    $poste    = $slot['poste'] ?? '';

    if ($position < 1 || $position > 11 || isset($byPosition[$position])) {
        http_response_code(400);
        echo json_encode(['ok' => false]);
        exit;
    }
    if (!in_array($poste, $validRoles, true)) {
        http_response_code(400);
        echo json_encode(['ok' => false]);
        exit;
    }
    $byPosition[$position] = $poste;
}

try {
    $insPreset = $pdo->prepare("INSERT INTO tactic_preset (nom, idUserCreateur) VALUES (:nom, :idUser)");
    $insPreset->execute(['nom' => $nom, 'idUser' => $idUser]);
    $idTacticPreset = (int)$pdo->lastInsertId();

    $insSlot = $pdo->prepare("INSERT INTO tactic_preset_slot (idTacticPreset, position, poste)
        VALUES (:idTacticPreset, :position, :poste)");
    foreach ($byPosition as $position => $poste) {
        $insSlot->execute([
            'idTacticPreset' => $idTacticPreset,
            'position'       => $position,
            'poste'          => $poste,
        ]);
    }

    $pdo->prepare("UPDATE tactic_card SET idTacticPreset = :p WHERE idTacticCard = :id")
        ->execute(['p' => $idTacticPreset, 'id' => $idTacticCard]);
    $pdo->prepare("DELETE FROM tactic WHERE idTacticCard = :id")->execute(['id' => $idTacticCard]);
} catch (\PDOException $e) {
    if ((int)$e->getCode() === 23000) {
        http_response_code(409);
        echo json_encode(['ok' => false, 'error' => 'duplicate_name']);
        exit;
    }
    http_response_code(500);
    echo json_encode(['ok' => false]);
    exit;
}

echo json_encode(['ok' => true, 'idTacticPreset' => $idTacticPreset]);
