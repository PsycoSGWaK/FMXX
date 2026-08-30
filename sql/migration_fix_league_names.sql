-- Retire les noms de sponsor (qui changent chaque saison, cf discussion
-- avec Guillaume sur la liste des championnats reellement joues dans
-- FM26) et corrige un renommage structurel recent non lie a un sponsor,
-- verifie par recherche web avant application :
--   - Angleterre D2F : "Women's Championship" -> "Women's Super League 2"
--     (rebrand sous l'ombrelle WSL, effectif saison 2025-26)
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

UPDATE `competition` SET `nomCompetition` = 'LaLiga' WHERE `idCompetition` = 12;
UPDATE `competition` SET `nomCompetition` = 'LaLiga 2' WHERE `idCompetition` = 13;
UPDATE `competition` SET `nomCompetition` = 'Serie B' WHERE `idCompetition` = 19;
UPDATE `competition` SET `nomCompetition` = 'Women''s Super League 2' WHERE `idCompetition` = 32;
