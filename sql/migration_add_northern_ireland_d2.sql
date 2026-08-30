-- Irlande du Nord D2 - NIFL Championship (12 clubs, saison 2025-26).
-- Liste fournie directement par Guillaume (source Wikipedia,
-- https://en.wikipedia.org/wiki/2025%E2%80%9326_NIFL_Championship) -
-- les recherches web automatisees donnaient des resultats
-- contradictoires/incomplets.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Rejouable sans doublon : competition via WHERE NOT EXISTS, equipe via
-- DELETE-puis-INSERT (meme pattern que equipe_insert_sportmonks.sql).
SET @idNorthernIreland = (SELECT idPays FROM pays WHERE paysA2C = 'NI');

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`)
SELECT 'NIFL Championship', 'Championnat', @idNorthernIreland, 'D2', 'M'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition`
    WHERE nomCompetition = 'NIFL Championship' AND idPays = @idNorthernIreland AND division = 'D2' AND genre = 'M'
);

DELETE FROM `equipe` WHERE idPays = @idNorthernIreland AND genre = 'M' AND division = 'D2';

INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Limavady United', @idNorthernIreland, 'M', 'D2'),
('Annagh United', @idNorthernIreland, 'M', 'D2'),
('Harland & Wolff Welders', @idNorthernIreland, 'M', 'D2'),
('Newington FC', @idNorthernIreland, 'M', 'D2'),
('Loughgall FC', @idNorthernIreland, 'M', 'D2'),
('Queen''s University', @idNorthernIreland, 'M', 'D2'),
('Institute FC', @idNorthernIreland, 'M', 'D2'),
('Ards FC', @idNorthernIreland, 'M', 'D2'),
('Warrenpoint Town', @idNorthernIreland, 'M', 'D2'),
('Ballinamallard United', @idNorthernIreland, 'M', 'D2'),
('Dundela FC', @idNorthernIreland, 'M', 'D2'),
('Armagh City', @idNorthernIreland, 'M', 'D2');
