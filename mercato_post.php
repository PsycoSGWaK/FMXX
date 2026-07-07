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

$pdo->prepare("UPDATE joueur SET mercato_status = NULL WHERE idUser = :idUser")
    ->execute(['idUser' => $idUser]);

if (!empty($_POST['status'])) {
    $stmt = $pdo->prepare("UPDATE joueur SET mercato_status = :status WHERE idJoueur = :id AND idUser = :idUser");
    foreach ($_POST['status'] as $idJoueur => $status) {
        if (in_array($status, ['sell', 'loan', 'free'])) {
            $stmt->execute(['status' => $status, 'id' => $idJoueur, 'idUser' => $idUser]);
        }
    }
}

header("Location: mercato.php?saved=1");
