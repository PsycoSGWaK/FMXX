-- Table de suivi des tentatives de connexion échouées, pour le rate limiting du login.
-- À exécuter une fois en production (phpMyAdmin o2switch) en plus du local.

CREATE TABLE IF NOT EXISTS `login_attempts` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `ip_address` VARCHAR(45) NOT NULL,
    `mail`       VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_ip_mail_time` (`ip_address`, `mail`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
