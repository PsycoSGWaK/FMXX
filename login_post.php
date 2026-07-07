<?php
session_start();
require_once("db.php");

if (!isset($_POST['mail'], $_POST['password'])) {
    header('Location: index.php?error=form');
    exit;
}

$req = $pdo->prepare('SELECT idUser, username, club, division, mail, password, pourcentage, type FROM user WHERE mail = ?');
$req->execute([$_POST['mail']]);
$resultat = $req->fetch();

if ($resultat && password_verify($_POST['password'], $resultat['password'])) {
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

    // HTTPS direct OU via le proxy Cloudflare (X-Forwarded-Proto / Cf-Visitor),
    // pour que le cookie soit marqué « secure » même quand l'origine reçoit du HTTP.
    $isHttps = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on')
        || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https')
        || (strpos($_SERVER['HTTP_CF_VISITOR'] ?? '', 'https') !== false);

    setcookie("auth_token", $token, [
        'expires'  => $expiry,
        'path'     => '/',
        'httponly' => true,
        'samesite' => 'Lax',
        'secure'   => $isHttps,
    ]);

    $pdo->prepare("UPDATE user SET auth_token = :token, token_expiry = FROM_UNIXTIME(:expiry) WHERE idUser = :id")
        ->execute(['token' => $token, 'expiry' => $expiry, 'id' => $resultat['idUser']]);

    header('Location: hub.php');
} else {
    header('Location: index.php?error=login');
}
exit;
