-- Salaire par joueur (importé depuis FM26, colonne "Salaire"), pour calculer
-- la masse salariale utilisée dans le bandeau budget.
-- À exécuter en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `joueur`
    ADD COLUMN `salaire` BIGINT NULL DEFAULT NULL AFTER `prixDemande`;
