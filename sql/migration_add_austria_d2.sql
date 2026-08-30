-- Autriche D2 - 2. Liga (16 clubs, saison 2025-26).
-- Liste fournie directement par Guillaume - les recherches web
-- automatisees donnaient des resultats incomplets pour ce championnat.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Rejouable sans doublon : competition via WHERE NOT EXISTS, equipe via
-- DELETE-puis-INSERT (meme pattern que equipe_insert_sportmonks.sql).
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`)
SELECT '2. Liga', 'Championnat', 10, 'D2', 'M'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition`
    WHERE nomCompetition = '2. Liga' AND idPays = 10 AND division = 'D2' AND genre = 'M'
);

DELETE FROM `equipe` WHERE idPays = 10 AND genre = 'M' AND division = 'D2';

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
