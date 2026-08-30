-- Permet d'ajouter manuellement une competition a l'onglet Objectifs meme
-- quand elle n'est pas deduite automatiquement (1ere saison suivie = pas
-- de saison precedente pour calculer une qualification, ou realite du
-- save FM qui diverge de ce que l'outil peut deduire). Signale par
-- Guillaume : bloque des la 1ere saison des qu'un club joue une
-- Supercoupe ou une comp continentale que l'outil ne peut pas deviner.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `objectif`
    ADD COLUMN `manuel` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'ajoutee a la main via le selecteur "Ajouter une competition", toujours affichee quelle que soit la deduction automatique';
