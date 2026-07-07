<?php
/**
 * Connexion à la base de données (PDO).
 *
 * Les identifiants sont résolus dans cet ordre, du plus prioritaire au moins :
 *   1. config.php (hors git) s'il existe          → déploiement
 *   2. variables d'environnement DB_HOST/USER/...  → hébergeurs qui les exposent
 *   3. valeurs par défaut localhost/root/fmxx      → WAMP local
 *
 * Voir config.example.php pour créer config.php en production.
 */

$fmxxConfig = is_file(__DIR__ . '/config.php') ? require __DIR__ . '/config.php' : [];

/** Résout une valeur : config.php > variable d'env > défaut local. */
function fmxx_db_cfg(array $config, string $key, string $env, string $default): string {
    if (isset($config[$key]) && $config[$key] !== '') {
        return (string) $config[$key];
    }
    $fromEnv = getenv($env);
    if ($fromEnv !== false && $fromEnv !== '') {
        return $fromEnv;
    }
    return $default;
}

$serverName = fmxx_db_cfg($fmxxConfig, 'db_host', 'DB_HOST', 'localhost');
$username   = fmxx_db_cfg($fmxxConfig, 'db_user', 'DB_USER', 'root');
$password   = fmxx_db_cfg($fmxxConfig, 'db_pass', 'DB_PASS', '');
$dbname     = fmxx_db_cfg($fmxxConfig, 'db_name', 'DB_NAME', 'fmxx');
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
