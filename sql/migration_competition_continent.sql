-- Ajoute la notion de continent (confederation FIFA) sur les competitions
-- continentales, qui n'ont pas d'idPays et ne peuvent donc pas etre
-- filtrees comme le reste du catalogue. Sert a filtrer :
-- 1. Le selecteur "+ Ajouter une competition" de l'onglet Objectifs
--    (garde-fou manuel) : ne proposer que les continentales de la bonne
--    confederation, pas les 14 melangees.
-- 2. Le selecteur "competition europeenne" des Parametres saison, qui
--    liste en realite toutes les confederations depuis l'extension du
--    catalogue (2026-08-30), pas seulement l'UEFA malgre son nom.
--
-- Necessite aussi la confederation de chaque pays (pour savoir a quelle
-- confederation appartient le club suivi). FIFA Club World Cup et FIFA
-- Women Champions Cup sont mondiales, pas rattachables a une seule
-- confederation : continent = 'FIFA', toujours proposees quel que soit
-- le pays du club.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- ---------------------------------------------------------------------
-- Colonnes (portable, pas besoin de "ADD COLUMN IF NOT EXISTS")
-- ---------------------------------------------------------------------
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'pays' AND COLUMN_NAME = 'continent'
);
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `pays` ADD COLUMN `continent` VARCHAR(10) NULL COMMENT ''confederation FIFA : UEFA, CONMEBOL, CONCACAF, AFC''',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'competition' AND COLUMN_NAME = 'continent'
);
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `competition` ADD COLUMN `continent` VARCHAR(10) NULL COMMENT ''confederation FIFA pour les Continentale : UEFA, CONMEBOL, CONCACAF, AFC, FIFA (mondiale)''',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ---------------------------------------------------------------------
-- Confederation de chaque pays (rejouable : simple UPDATE)
-- ---------------------------------------------------------------------
UPDATE `pays` SET `continent` = 'CONCACAF' WHERE `nomPays` = 'United States';
UPDATE `pays` SET `continent` = 'CONMEBOL' WHERE `nomPays` = 'Brazil';
UPDATE `pays` SET `continent` = 'AFC'      WHERE `nomPays` IN ('Japan', 'Australia');
UPDATE `pays` SET `continent` = 'UEFA'     WHERE `nomPays` IN (
    'United Kingdom', 'Spain', 'Germany', 'Italy', 'France', 'Wales',
    'Sweden', 'Austria', 'Belgium', 'Netherlands', 'Portugal', 'Turkey',
    'Denmark', 'Scotland', 'Northern Ireland', 'Ireland'
);

-- ---------------------------------------------------------------------
-- Confederation de chaque competition continentale (rejouable : simple
-- UPDATE, resolu par nom, jamais par id -- id non fiable entre local et
-- prod, cf. lecon de migration_fix_prod_data_integrity.sql)
-- ---------------------------------------------------------------------
UPDATE `competition` SET `continent` = 'UEFA' WHERE `typeCompetition` = 'Continentale' AND `nomCompetition` IN (
    'UEFA Champions League', 'UEFA Europa League', 'UEFA Europa Conference League',
    'UEFA Women s Champions League', 'UEFA Women s Europa Cup'
);
UPDATE `competition` SET `continent` = 'CONMEBOL' WHERE `typeCompetition` = 'Continentale' AND `nomCompetition` IN (
    'Copa Libertadores', 'Copa Sudamericana'
);
UPDATE `competition` SET `continent` = 'CONCACAF' WHERE `typeCompetition` = 'Continentale' AND `nomCompetition` IN (
    'Concacaf Champions Cup', 'Concacaf W Champions Cup'
);
UPDATE `competition` SET `continent` = 'AFC' WHERE `typeCompetition` = 'Continentale' AND `nomCompetition` IN (
    'AFC Champions League Elite', 'AFC Champions League Two', 'AFC Women''s Champions League'
);
UPDATE `competition` SET `continent` = 'FIFA' WHERE `typeCompetition` = 'Continentale' AND `nomCompetition` IN (
    'FIFA Club World Cup', 'FIFA Women Champions Cup'
);
