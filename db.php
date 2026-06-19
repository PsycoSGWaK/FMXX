<?php
// PRODUCTION : remplacer root/vide par un utilisateur MySQL dédié avec mot de passe fort
// ex: CREATE USER 'fmxx_user'@'localhost' IDENTIFIED BY 'motdepasse'; GRANT ALL ON fmxx.* TO 'fmxx_user'@'localhost';
$serverName = "localhost";
$username = "root";
$password = "";
$dbname = "fmxx";
$charset = "utf8mb4";

// Tentative de connexion à la base de données
try {
        $dsn = "mysql:host=$serverName;dbname=$dbname;charset=$charset";
        $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        $pdo = new PDO($dsn, $username, $password, $options);
} catch (\PDOException $e) {
        throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
