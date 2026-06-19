<?php
session_start();
require_once("db.php");
require_once("csrf.php");
require_once("validation.php");

csrf_verify();

if (!isset($_POST['username'], $_POST['mail'], $_POST['password'])) {
    header("Location: index.php?error=signup_missing");
    exit;
}

$username = trim($_POST['username']);
$mail     = trim($_POST['mail']);
$password = $_POST['password'];
$confirm  = $_POST['password_confirm'] ?? '';

// Réafficher les champs saisis en cas d'erreur (jamais le mot de passe)
$_SESSION['signup_old'] = ['username' => $username, 'mail' => $mail];

/** Redirige vers le formulaire en signalant l'erreur (code page + code de validation optionnel). */
function signup_fail(string $code, ?string $valCode = null): void {
    if ($valCode !== null) {
        $_SESSION['signup_error_code'] = $valCode;
    }
    header("Location: index.php?error=$code");
    exit;
}

if ($username === '' || $mail === '' || $password === '') {
    signup_fail('signup_missing');
}

// Validation de l'adresse email (format + domaine MX)
if ($mailCode = validate_email($mail)) {
    signup_fail('signup_mail_invalid', $mailCode);
}

// Validation de la robustesse du mot de passe
if ($pwdCode = validate_password($password)) {
    signup_fail('signup_pwd', $pwdCode);
}

// Confirmation du mot de passe
if ($password !== $confirm) {
    signup_fail('signup_pwd', 'pwd_mismatch');
}

// Unicité pseudo / email
$stmt = $pdo->prepare("CALL CheckUserExists(:username, :mail, @username_taken, @mail_taken)");
$stmt->execute([':username' => $username, ':mail' => $mail]);
$stmt->closeCursor();

$result = $pdo->query("SELECT @username_taken AS username_taken, @mail_taken AS mail_taken")->fetch();

if ($result['username_taken']) {
    signup_fail('signup_username');
}
if ($result['mail_taken']) {
    signup_fail('signup_mail');
}

// Création du compte
$passwordHash = password_hash($password, PASSWORD_DEFAULT);
$req = $pdo->prepare("INSERT INTO user (username, mail, password, type) VALUES (?, ?, ?, 0)");
$req->execute([$username, $mail, $passwordHash]);

unset($_SESSION['signup_old'], $_SESSION['signup_error_code']);
header("Location: index.php?signup=ok");
exit;
