-- Nouvelles lignes `competition` decouvertes en consolidant le catalogue
-- via SportMonks : le Pays de Galles n'avait jamais eu de ligne
-- `competition` (seulement des clubs importes a l'origine, jamais
-- selectionnables cote utilisateur), et il manquait les 2 dernieres
-- competitions feminines identifiees (Danemark, Australie).
-- Noms reels choisis a la main, pas les noms SportMonks (parfois
-- sponsorises ou differents de nos conventions).
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
('Cymru Premier', 'Championnat', 8, 'D1', 'M'),
('Cymru North/South', 'Championnat', 8, 'D2', 'M'),
('Adran Premier', 'Championnat', 8, 'D1', 'F'),
('Elitedivisionen', 'Championnat', 16, 'D1', 'F'),
('A-League Women', 'Championnat', 20, 'D1', 'F');
