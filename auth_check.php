<?php
if (isset($_SESSION['idUser'])) {
    // L'utilisateur est déjà connecté, pas besoin de vérifier le cookie
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
    } else {
        // Le jeton n'est pas valide ou expiré, effacez le cookie
        setcookie("auth_token", "", time() - 3600, "/");
    }
} else {
    exit;
}
