<?php
session_start();
require_once("db.php");

if (!isset($_POST['mail'], $_POST['password'])) {
    header('Location: index.php?error=form');
    exit;
}

// Rate limiting : 5 échecs max par IP+email sur une fenêtre de 15 minutes.
const LOGIN_RATE_LIMIT_MAX    = 5;
const LOGIN_RATE_LIMIT_WINDOW = 15 * 60;

function fmxx_client_ip(): string {
    // Derrière Cloudflare, REMOTE_ADDR est l'IP du proxy, pas du visiteur.
    return $_SERVER['HTTP_CF_CONNECTING_IP'] ?? $_SERVER['REMOTE_ADDR'] ?? 'unknown';
}

$clientIp = fmxx_client_ip();
$mailAttempt = (string)$_POST['mail'];

$pdo->prepare("DELETE FROM login_attempts WHERE created_at < (NOW() - INTERVAL 1 DAY)")->execute();

$attemptsStmt = $pdo->prepare("
    SELECT COUNT(*) FROM login_attempts
    WHERE ip_address = :ip AND mail = :mail AND created_at > (NOW() - INTERVAL :window SECOND)
");
$attemptsStmt->execute(['ip' => $clientIp, 'mail' => $mailAttempt, 'window' => LOGIN_RATE_LIMIT_WINDOW]);
if ((int)$attemptsStmt->fetchColumn() >= LOGIN_RATE_LIMIT_MAX) {
    header('Location: index.php?error=too_many_attempts');
    exit;
}

$req = $pdo->prepare('SELECT idUser, username, club, division, mail, password, pourcentage, type, email_verified_at FROM user WHERE mail = ?');
$req->execute([$_POST['mail']]);
$resultat = $req->fetch();

if ($resultat && password_verify($_POST['password'], $resultat['password'])) {
    $pdo->prepare("DELETE FROM login_attempts WHERE ip_address = :ip AND mail = :mail")
        ->execute(['ip' => $clientIp, 'mail' => $mailAttempt]);

    if ($resultat['email_verified_at'] === null) {
        $_SESSION['unverified_mail'] = $resultat['mail'];
        header('Location: index.php?error=unverified');
        exit;
    }

    session_regenerate_id(true);
    $_SESSION['idUser']   = $resultat['idUser'];
    $_SESSION['username'] = $resultat['username'];
    $_SESSION['club']     = $resultat['club'];
    $_SESSION['division']      = $resultat['division'];
    $_SESSION['mail']          = $resultat['mail'];
    $_SESSION['pourcentage']   = $resultat['pourcentage'];
    $_SESSION['type']          = $resultat['type'];

    $token  = bin2hex(random_bytes(64));
    $expiry = time() + (86400 * 30);

    setcookie("auth_token", $token, [
        'expires'  => $expiry,
        'path'     => '/',
        'httponly' => true,
        'samesite' => 'Lax',
        'secure'   => fmxx_is_https(),
    ]);

    $pdo->prepare("UPDATE user SET auth_token = :token, token_expiry = FROM_UNIXTIME(:expiry) WHERE idUser = :id")
        ->execute(['token' => $token, 'expiry' => $expiry, 'id' => $resultat['idUser']]);

    header('Location: hub.php');
} else {
    $pdo->prepare("INSERT INTO login_attempts (ip_address, mail) VALUES (:ip, :mail)")
        ->execute(['ip' => $clientIp, 'mail' => $mailAttempt]);
    header('Location: index.php?error=login');
}
exit;
