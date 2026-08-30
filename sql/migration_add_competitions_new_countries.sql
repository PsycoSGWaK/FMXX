-- Ajoute les championnats (nom reel, sans sponsor) pour les pays deja
-- presents dans `pays` et dont les clubs sont deja importes dans `equipe`,
-- mais qui n'avaient encore aucune ligne dans `competition`. Liste etablie
-- a partir des championnats reellement joues dans FM26 fournie par
-- Guillaume (voir memoire project_competition_qualif_rules).
--
-- Laisse volontairement de cote les divisions sans club importe (Autriche
-- D2, Suede D2 hommes, Pays de Galles feminin) et les pays absents de la
-- base (Danemark, Ecosse, Irlande, Irlande du Nord, Australie) - lies au
-- chantier "alternative a API-Football" en pause.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
-- Autriche (idPays 10)
('Bundesliga', 'Championnat', 10, 'D1', 'M'),
-- Belgique (idPays 11)
('Pro League', 'Championnat', 11, 'D1', 'M'),
('Challenger Pro League', 'Championnat', 11, 'D2', 'M'),
-- Bresil (idPays 12)
('Campeonato Brasileiro Série A', 'Championnat', 12, 'D1', 'M'),
('Campeonato Brasileiro Série B', 'Championnat', 12, 'D2', 'M'),
-- Pays-Bas (idPays 13)
('Eredivisie', 'Championnat', 13, 'D1', 'M'),
('Eerste Divisie', 'Championnat', 13, 'D2', 'M'),
-- Portugal (idPays 14)
('Primeira Liga', 'Championnat', 14, 'D1', 'M'),
('Liga Portugal 2', 'Championnat', 14, 'D2', 'M'),
-- Turquie (idPays 15)
('Süper Lig', 'Championnat', 15, 'D1', 'M'),
('1. Lig', 'Championnat', 15, 'D2', 'M'),
-- Japon (idPays 7)
('J1 League', 'Championnat', 7, 'D1', 'M'),
('J2 League', 'Championnat', 7, 'D2', 'M'),
('WE League', 'Championnat', 7, 'D1', 'F'),
-- Etats-Unis (idPays 6)
('Major League Soccer', 'Championnat', 6, 'D1', 'M'),
('National Women''s Soccer League', 'Championnat', 6, 'D1', 'F'),
-- Suede (idPays 9)
('Allsvenskan', 'Championnat', 9, 'D1', 'M'),
('Damallsvenskan', 'Championnat', 9, 'D1', 'F'),
('Elitettan', 'Championnat', 9, 'D2', 'F'),
-- France (idPays 5) : National 2 (D4) manquait alors que les 48 clubs
-- sont deja importes
('National 2', 'Championnat', 5, 'D4', 'M');
