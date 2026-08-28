<?php
// Expiration de session par inactivité : au-delà de ce délai sans activité,
// déconnexion forcée même si le cookie "auth_token" (30 jours) est encore valide.
const SESSION_INACTIVITY_TIMEOUT = 6 * 60 * 60; // 6h

if (isset($_SESSION['idUser']) && isset($_SESSION['last_activity'])
    && (time() - $_SESSION['last_activity']) > SESSION_INACTIVITY_TIMEOUT) {
    require_once("db.php");
    $pdo->prepare("UPDATE user SET auth_token = NULL, token_expiry = NULL WHERE idUser = :id")
        ->execute(['id' => $_SESSION['idUser']]);
    $_SESSION = [];
    session_destroy();
    setcookie("auth_token", "", time() - 3600, "/");
    header("Location: index.php?error=session_expired");
    exit;
}

if (isset($_SESSION['idUser'])) {
    // L'utilisateur est déjà connecté, pas besoin de vérifier le cookie
    $_SESSION['last_activity'] = time();
} elseif (isset($_COOKIE['auth_token'])) {
    require_once("db.php");
    $token = $_COOKIE['auth_token'];

    // Vérifiez le jeton dans la base de données
    $sql = "SELECT idUser, token_expiry FROM user WHERE auth_token = :auth_token AND token_expiry > NOW()";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['auth_token' => $token]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // Le jeton est valide, restaurez la session
        $_SESSION['idUser'] = $user['idUser'];
        $_SESSION['last_activity'] = time();
    } else {
        // Le jeton n'est pas valide ou expiré, effacez le cookie
        setcookie("auth_token", "", time() - 3600, "/");
    }
} else {
    exit;
}
