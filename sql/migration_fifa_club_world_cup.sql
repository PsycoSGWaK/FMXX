-- FIFA Club World Cup : nouveau format 32 equipes depuis 2025, joue tous
-- les 4 ans (2025, 2029...) avec une qualification qui s'etale sur
-- plusieurs saisons et confederations, pas un simple "vainqueur de la
-- Ligue des champions l'an dernier". Ne colle pas au modele par saison
-- de l'outil (comme la MLS/Concacaf, cf migration_non_uefa_continentales.sql).
-- Ajoutee au catalogue sans regle de qualification automatique :
-- rejoint le filet de securite "+ Ajouter une competition".
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
('FIFA Club World Cup', 'Continentale', NULL, 'M');
