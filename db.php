<?php
/**
 * Connexion à la base de données (PDO).
 *
 * Les identifiants sont résolus par db_config.php (config.php > variables
 * d'environnement > défauts locaux). Voir config.example.php pour créer
 * config.php en production.
 */

require_once __DIR__ . '/db_config.php';

$dbConfig   = fmxx_resolve_db_config();
$serverName = $dbConfig['host'];
$username   = $dbConfig['user'];
$password   = $dbConfig['pass'];
$dbname     = $dbConfig['name'];
$charset    = "utf8mb4";

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
