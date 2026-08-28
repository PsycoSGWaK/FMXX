<?php
session_start();
require_once("db.php");

$token = $_GET['token'] ?? '';
if ($token === '') {
    header('Location: index.php?error=confirm_invalid');
    exit;
}

$stmt = $pdo->prepare("SELECT idUser FROM user WHERE email_verify_token = :token AND email_verify_expiry > NOW()");
$stmt->execute(['token' => $token]);
$user = $stmt->fetch();

if (!$user) {
    header('Location: index.php?error=confirm_invalid');
    exit;
}

$pdo->prepare("UPDATE user SET email_verified_at = NOW(), email_verify_token = NULL, email_verify_expiry = NULL WHERE idUser = :id")
    ->execute(['id' => $user['idUser']]);

header('Location: index.php?confirmed=ok');
exit;
