<?php
session_start();
require_once("db.php");

if (!isset($_SESSION['idUser'])) { header("Location: index.php"); exit; }

$saison = $_SESSION['saison_active'] ?? date('Y') . '/' . (date('Y') + 1);
[$debut, $fin] = explode('/', $saison);
$nouvelleSaison = ($debut + 1) . '/' . ($fin + 1);

$pdo->prepare("UPDATE user SET saison_active = :s WHERE idUser = :id")
    ->execute(['s' => $nouvelleSaison, 'id' => $_SESSION['idUser']]);

$_SESSION['saison_active'] = $nouvelleSaison;

header("Location: index.php");
