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

$pdo->prepare("CALL DeleteUser(:id)")->execute(['id' => $idUser]);

session_destroy();
header("Location: index.php?account=deleted");
