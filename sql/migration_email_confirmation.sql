-- Confirmation d'adresse email à l'inscription.
-- À exécuter en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `user`
    ADD COLUMN `email_verified_at`   DATETIME NULL DEFAULT NULL AFTER `mail`,
    ADD COLUMN `email_verify_token`  VARCHAR(64) NULL DEFAULT NULL AFTER `email_verified_at`,
    ADD COLUMN `email_verify_expiry` DATETIME NULL DEFAULT NULL AFTER `email_verify_token`;

-- Comptes déjà existants avant cette migration : considérés vérifiés
-- (déjà utilisés par le passé, pas de nouvelle vérification à imposer).
UPDATE `user` SET `email_verified_at` = NOW() WHERE `email_verified_at` IS NULL;
