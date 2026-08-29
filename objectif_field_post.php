<?php
/**
 * Met à jour l'objectif + résultat d'UNE SEULE compétition, appelé en
 * arrière-plan (fetch) depuis les select de l'onglet Objectifs — pas de
 * bouton "Sauvegarder", pas de rechargement de page. Contrairement à
 * l'ancien objectif_post.php (formulaire complet, DELETE+réinsertion de
 * TOUTES les compétitions à chaque sauvegarde), ne touche qu'UNE ligne à
 * la fois via UPSERT sur la clé unique (idUser, idCompetition, saison).
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

$idUser = $_SESSION['idUser'];
$idComp = (int)($_POST['idCompetition'] ?? 0);
$saison = trim($_POST['saison'] ?? '');
$obj    = $_POST['objectif'] ?? '';
$res    = $_POST['resultat'] ?? '';

if (!$idComp || $saison === '') {
    http_response_code(400);
    echo json_encode(['ok' => false]);
    exit;
}

// Garde la saison visible dans le Palmarès (saison_meta) même si l'utilisateur
// ne fait plus jamais de sauvegarde "pleine page" — même logique que l'ancien
// objectif_post.php, déclenchée à chaque sauvegarde d'un champ.
$pdo->prepare("INSERT INTO saison_meta (idUser, saison, club, division, genre, idPays)
    VALUES (:idUser, :saison, :club, :division, :genre, :idPays)
    ON DUPLICATE KEY UPDATE club=VALUES(club), division=VALUES(division), genre=VALUES(genre), idPays=VALUES(idPays)")
    ->execute([
        'idUser'   => $idUser,
        'saison'   => $saison,
        'club'     => $_SESSION['club']     ?? null,
        'division' => $_SESSION['division'] ?? null,
        'genre'    => $_SESSION['genre']    ?? 'M',
        'idPays'   => $_SESSION['idPays']   ?? null,
    ]);

$stmt = $pdo->prepare(
    "INSERT INTO objectif (idUser, idCompetition, objectif, resultat, saison)
     VALUES (:idUser, :idComp, :obj, :res, :saison)
     ON DUPLICATE KEY UPDATE objectif = VALUES(objectif), resultat = VALUES(resultat)"
);
$stmt->execute([
    'idUser' => $idUser,
    'idComp' => $idComp,
    'obj'    => $obj !== '' ? $obj : null,
    'res'    => $res !== '' ? $res : null,
    'saison' => $saison,
]);

echo json_encode(['ok' => true]);
