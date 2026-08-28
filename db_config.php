<?php
/**
 * Résolution des identifiants de connexion à la base de données.
 *
 * Isolé de db.php pour être réutilisable par des scripts CLI (sql/backup_db.php)
 * qui ont besoin des identifiants sans ouvrir de connexion PDO applicative.
 *
 * Ordre de priorité, du plus prioritaire au moins :
 *   1. config.php (hors git) s'il existe          → déploiement
 *   2. variables d'environnement DB_HOST/USER/...  → hébergeurs qui les exposent
 *   3. valeurs par défaut localhost/root/fmxx      → WAMP local
 *
 * Voir config.example.php pour créer config.php en production.
 */

require_once __DIR__ . '/env.php';

if (!function_exists('fmxx_db_cfg')) {
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
}

if (!function_exists('fmxx_resolve_db_config')) {
    function fmxx_resolve_db_config(): array {
        $fmxxConfig = is_file(__DIR__ . '/config.php') ? require __DIR__ . '/config.php' : [];

        return [
            'host' => fmxx_db_cfg($fmxxConfig, 'db_host', 'DB_HOST', 'localhost'),
            'user' => fmxx_db_cfg($fmxxConfig, 'db_user', 'DB_USER', 'root'),
            'pass' => fmxx_db_cfg($fmxxConfig, 'db_pass', 'DB_PASS', ''),
            'name' => fmxx_db_cfg($fmxxConfig, 'db_name', 'DB_NAME', 'fmxx'),
        ];
    }
}
