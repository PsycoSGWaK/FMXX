<?php
session_start();
require_once("db.php");
require_once("csrf.php");

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}

csrf_verify();

$idUser = $_SESSION['idUser'];
$pdo->prepare("DELETE FROM tactic WHERE idUser = :idUser")->execute([':idUser' => $idUser]);
// joueur_role est nettoyée automatiquement (FK ON DELETE CASCADE, voir sql/migration_joueur_role.sql).
$pdo->prepare("DELETE FROM joueur WHERE idUser = :idUser")->execute([':idUser' => $idUser]);
header("Location: index.php?tab=effectif");
exit;
