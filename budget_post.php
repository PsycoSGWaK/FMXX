<?php
session_start();
require_once("db.php");
require_once(__DIR__ . "/csrf.php");

if (!isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php?tab=objectifs");
    exit;
}

csrf_verify();

$idUser = $_SESSION['idUser'];
$bt = isset($_POST['budget_transfert']) && $_POST['budget_transfert'] !== '' ? (int)$_POST['budget_transfert'] : null;
$bs = isset($_POST['budget_salaires'])  && $_POST['budget_salaires']  !== '' ? (int)$_POST['budget_salaires']  : null;

$pdo->prepare("UPDATE user SET budget_transfert = :bt, budget_salaires = :bs WHERE idUser = :id")
    ->execute(['bt' => $bt, 'bs' => $bs, 'id' => $idUser]);

header("Location: index.php?tab=objectifs&budget=saved");
