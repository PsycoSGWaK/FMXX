<?php
session_start();
require_once("db.php");
require_once("csrf.php");
require_once("validation.php");

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}

csrf_verify();

$idUser   = $_SESSION['idUser'];
$username = trim($_POST['username'] ?? '');
$mail     = trim($_POST['mail'] ?? '');
$password = $_POST['password'] ?? '';

if (!$username || !$mail) {
    header("Location: index.php?error=profile_missing");
    exit;
}

// Validation de l'adresse email (format + domaine MX)
if ($mailCode = validate_email($mail)) {
    $_SESSION['profile_error_code'] = $mailCode;
    header("Location: index.php?error=profile_mail_invalid");
    exit;
}

// Si un nouveau mot de passe est fourni, il doit respecter la politique et être confirmé
if ($password !== '') {
    if ($pwdCode = validate_password($password)) {
        $_SESSION['profile_error_code'] = $pwdCode;
        header("Location: index.php?error=profile_pwd");
        exit;
    }
    if ($password !== ($_POST['password_confirm'] ?? '')) {
        $_SESSION['profile_error_code'] = 'pwd_mismatch';
        header("Location: index.php?error=profile_pwd");
        exit;
    }
}

// Vérifier pseudo/mail pris par un AUTRE utilisateur
$check = $pdo->prepare("SELECT idUser FROM user WHERE (username = :username OR mail = :mail) AND idUser != :id");
$check->execute(['username' => $username, 'mail' => $mail, 'id' => $idUser]);
$conflict = $check->fetch();

if ($conflict) {
    header("Location: index.php?error=profile_conflict");
    exit;
}

if ($password !== '') {
    $hash = password_hash($password, PASSWORD_DEFAULT);
    $pdo->prepare("UPDATE user SET username = :username, mail = :mail, password = :password WHERE idUser = :id")
        ->execute(['username' => $username, 'mail' => $mail, 'password' => $hash, 'id' => $idUser]);
} else {
    $pdo->prepare("UPDATE user SET username = :username, mail = :mail WHERE idUser = :id")
        ->execute(['username' => $username, 'mail' => $mail, 'id' => $idUser]);
}

$_SESSION['username'] = $username;
$_SESSION['mail']     = $mail;

header("Location: index.php?profile=ok");
