<?php
session_start();
require_once("db.php");
require_once("csrf.php");
require_once("mailer.php");

csrf_verify();

$mail = trim($_POST['mail'] ?? '');
if ($mail === '') {
    header('Location: index.php?error=form');
    exit;
}

$stmt = $pdo->prepare("SELECT idUser, email_verified_at, email_verify_expiry FROM user WHERE mail = :mail");
$stmt->execute(['mail' => $mail]);
$user = $stmt->fetch();

// Anti-spam : pas plus d'un renvoi par minute (le jeton précédent expire dans 24h,
// donc si son expiration est encore à plus de 23h59, il vient d'être généré).
$onCooldown = $user && $user['email_verify_expiry']
    && (strtotime($user['email_verify_expiry']) - 86400) > (time() - 60);

if ($user && $user['email_verified_at'] === null && !$onCooldown) {
    $token  = bin2hex(random_bytes(32));
    $expiry = date('Y-m-d H:i:s', time() + 86400);
    $pdo->prepare("UPDATE user SET email_verify_token = :token, email_verify_expiry = :expiry WHERE idUser = :id")
        ->execute(['token' => $token, 'expiry' => $expiry, 'id' => $user['idUser']]);
    fmxx_send_confirmation_email($mail, $token);
}

// Réponse identique que le compte existe, soit déjà vérifié, soit en cooldown :
// évite de laisser deviner quelles adresses sont inscrites (énumération d'emails).
header('Location: index.php?resend=ok');
exit;
