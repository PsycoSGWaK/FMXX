-- Permet d'ajouter manuellement une competition a l'onglet Objectifs meme
-- quand elle n'est pas deduite automatiquement (1ere saison suivie = pas
-- de saison precedente pour calculer une qualification, ou realite du
-- save FM qui diverge de ce que l'outil peut deduire). Signale par
-- Guillaume : bloque des la 1ere saison des qu'un club joue une
-- Supercoupe ou une comp continentale que l'outil ne peut pas deviner.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Rendu rejouable sans erreur si la colonne existe deja (portable, pas
-- besoin de "ADD COLUMN IF NOT EXISTS" qui necessite MySQL 8.0.29+).
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'objectif' AND COLUMN_NAME = 'manuel'
);
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `objectif` ADD COLUMN `manuel` TINYINT(1) NOT NULL DEFAULT 0 COMMENT ''ajoutee a la main via le selecteur Ajouter une competition, toujours affichee quelle que soit la deduction automatique''',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
