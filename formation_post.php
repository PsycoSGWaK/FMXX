<?php
session_start();
require_once("db.php");

if (!isset($_SESSION['idUser']) || empty($_POST['formation'])) {
    header("Location: index.php");
    exit;
}

$allowed = ['4-3-3','4-4-2','4-2-3-1','3-5-2','5-3-2','4-1-2-1-2'];
$formation = $_POST['formation'];

if (!in_array($formation, $allowed)) {
    header("Location: index.php");
    exit;
}

$pdo->prepare("UPDATE user SET formation = :f WHERE idUser = :id")
    ->execute(['f' => $formation, 'id' => $_SESSION['idUser']]);

$_SESSION['formation'] = $formation;

$redirect = $_POST['redirect'] ?? 'index.php';
// Sécurité : on n'autorise que les redirects internes (pas d'URL externe)
if (!preg_match('/^[a-zA-Z0-9_.?\-=&\/]+$/', $redirect)) {
    $redirect = 'index.php';
}
header("Location: " . $redirect);
