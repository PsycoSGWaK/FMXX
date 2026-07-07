<?php
session_start();
require_once("db.php");

if (!isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

require_once("csrf.php");
csrf_verify();

$idUser = $_SESSION['idUser'];
$saison = $_POST['saison'] ?? date('Y') . '/' . (date('Y') + 1);

// Sauvegarder les métadonnées pour la saison active (pas forcément l'année réelle)
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

// Supprimer les anciens objectifs de cette saison avant de réinsérer (évite le merge si changement d'équipe)
$pdo->prepare("DELETE FROM objectif WHERE idUser = :idUser AND saison = :saison")
    ->execute(['idUser' => $idUser, 'saison' => $saison]);

$stmt = $pdo->prepare(
    "INSERT INTO objectif (idUser, idCompetition, objectif, resultat, saison)
     VALUES (:idUser, :idComp, :obj, :res, :saison)"
);

foreach ($_POST['objectif'] ?? [] as $idComp => $obj) {
    $res = $_POST['resultat'][$idComp] ?? null;
    $stmt->execute([
        'idUser' => $idUser,
        'idComp' => $idComp,
        'obj'    => $obj ?: null,
        'res'    => $res ?: null,
        'saison' => $saison,
    ]);
}

header("Location: index.php?tab=objectifs&objectifs=saved&saison=" . urlencode($saison));
