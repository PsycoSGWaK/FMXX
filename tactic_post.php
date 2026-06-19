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

$pdo->prepare("DELETE FROM tactic WHERE idUser = :idUser")->execute(['idUser' => $idUser]);

$stmt = $pdo->prepare(
    "INSERT INTO tactic (position, titulaire, remplacant, supersub, idUser)
     VALUES (:position, :titulaire, :remplacant, :supersub, :idUser)"
);

for ($i = 1; $i <= 11; $i++) {
    $titulaire  = $_POST["line_{$i}_titulaire"]  ?: null;
    $remplacant = $_POST["line_{$i}_remplacant"] ?: null;
    $supersub   = $_POST["line_{$i}_supersub"]   ?: null;

    $stmt->execute([
        'position'   => $i,
        'titulaire'  => $titulaire,
        'remplacant' => $remplacant,
        'supersub'   => $supersub,
        'idUser'     => $idUser,
    ]);
}

header("Location: index.php?tab=tactic&tactic=saved");
