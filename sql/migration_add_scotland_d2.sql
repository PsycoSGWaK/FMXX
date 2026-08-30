-- Ecosse D2 - Scottish Championship (10 clubs, saison 2025-26).
-- Liste fournie directement par Guillaume (les recherches web
-- automatisees donnaient des resultats contradictoires/incomplets).
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Rejouable sans doublon : competition via WHERE NOT EXISTS, equipe via
-- DELETE-puis-INSERT (meme pattern que equipe_insert_sportmonks.sql).
SET @idScotland = (SELECT idPays FROM pays WHERE paysA2C = 'SC');

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`)
SELECT 'Scottish Championship', 'Championnat', @idScotland, 'D2', 'M'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition`
    WHERE nomCompetition = 'Scottish Championship' AND idPays = @idScotland AND division = 'D2' AND genre = 'M'
);

DELETE FROM `equipe` WHERE idPays = @idScotland AND genre = 'M' AND division = 'D2';

INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('St Johnstone FC', @idScotland, 'M', 'D2'),
('Partick Thistle FC', @idScotland, 'M', 'D2'),
('Arbroath FC', @idScotland, 'M', 'D2'),
('Dunfermline Athletic FC', @idScotland, 'M', 'D2'),
('Raith Rovers FC', @idScotland, 'M', 'D2'),
('Queen''s Park FC', @idScotland, 'M', 'D2'),
('Ayr United FC', @idScotland, 'M', 'D2'),
('Greenock Morton FC', @idScotland, 'M', 'D2'),
('Airdrieonians FC', @idScotland, 'M', 'D2'),
('Ross County FC', @idScotland, 'M', 'D2');
