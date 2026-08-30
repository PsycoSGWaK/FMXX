-- Autriche D2 - 2. Liga (16 clubs, saison 2025-26).
-- Liste fournie directement par Guillaume - les recherches web
-- automatisees donnaient des resultats incomplets pour ce championnat.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
('2. Liga', 'Championnat', 10, 'D2', 'M');

INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Admira Wacker', 10, 'M', 'D2'),
('Austria Klagenfurt', 10, 'M', 'D2'),
('Austria Lustenau', 10, 'M', 'D2'),
('Austria Salzburg', 10, 'M', 'D2'),
('Austria Vienna', 10, 'M', 'D2'),
('FC Liefering', 10, 'M', 'D2'),
('First Vienna', 10, 'M', 'D2'),
('Floridsdorfer AC', 10, 'M', 'D2'),
('Rapid Wien II', 10, 'M', 'D2'),
('Schwarz-Weiß Bregenz', 10, 'M', 'D2'),
('SKN St. Pölten', 10, 'M', 'D2'),
('SKU Amstetten', 10, 'M', 'D2'),
('Stripfing', 10, 'M', 'D2'),
('Sturm Graz II', 10, 'M', 'D2'),
('SV Kapfenberg', 10, 'M', 'D2'),
('WSPG Wels', 10, 'M', 'D2');
