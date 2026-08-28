<?php
/**
 * Détection d'environnement + durcissement de l'affichage des erreurs.
 *
 * Production = présence de config.php (voir config.example.php et db.php :
 * config.php n'existe que sur le serveur de déploiement, jamais en local WAMP).
 * En prod, les erreurs ne s'affichent jamais au visiteur (juste dans les logs
 * serveur) ; en local, on garde l'affichage pour faciliter le débogage.
 */

if (!function_exists('fmxx_is_production')) {
    function fmxx_is_production(): bool {
        return is_file(__DIR__ . '/config.php');
    }
}

if (!function_exists('fmxx_is_https')) {
    function fmxx_is_https(): bool {
        // Derrière Cloudflare, HTTPS peut n'être vrai que jusqu'au proxy :
        // on regarde aussi les en-têtes qu'il ajoute.
        return (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on')
            || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https')
            || (strpos($_SERVER['HTTP_CF_VISITOR'] ?? '', 'https') !== false);
    }
}

if (fmxx_is_production()) {
    ini_set('display_errors', '0');
    ini_set('display_startup_errors', '0');
    ini_set('log_errors', '1');
} else {
    ini_set('display_errors', '1');
    ini_set('display_startup_errors', '1');
}
error_reporting(E_ALL);
