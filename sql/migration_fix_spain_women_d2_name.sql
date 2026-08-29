-- Corrige le nom trompeur de la D2 feminine espagnole : "Primera División
-- Femenina" laissait penser a une D1 alors qu'il s'agit bien de la D2
-- (Liga F, idCompetition 40, est la vraie D1). Repere depuis la pause du
-- 2026-07-07 sur la refonte des competitions (voir
-- project_competition_qualif_rules dans la memoire), corrige a la demande
-- de Guillaume avec le vrai nom.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

UPDATE `competition`
SET `nomCompetition` = 'Primera Federación FutFem'
WHERE `idCompetition` = 41;
