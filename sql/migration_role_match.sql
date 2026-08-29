-- Rôle utilisé en match (sélectionné manuellement par l'utilisateur, ou
-- pré-rempli automatiquement depuis l'import). NULL = pas de choix manuel,
-- on retombe sur le rôle déduit du poste importé.
-- À exécuter en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `joueur`
    ADD COLUMN `role_match` VARCHAR(10) NULL DEFAULT NULL AFTER `poste`;
