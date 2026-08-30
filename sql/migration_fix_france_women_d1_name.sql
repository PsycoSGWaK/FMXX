-- Corrige le nom perime de la D1 feminine francaise : "Division 1 Arkema"
-- a ete renommee "Premiere Ligue" a partir de la saison 2024-25 (Arkema
-- reste sponsor mais n'est plus dans le nom de la competition).
-- Corrige a la demande de Guillaume.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

UPDATE `competition`
SET `nomCompetition` = 'Première Ligue'
WHERE `idCompetition` = 34;
