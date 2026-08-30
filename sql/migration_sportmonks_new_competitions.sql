-- Nouvelles lignes `competition` decouvertes en consolidant le catalogue
-- via SportMonks : le Pays de Galles n'avait jamais eu de ligne
-- `competition` (seulement des clubs importes a l'origine, jamais
-- selectionnables cote utilisateur), et il manquait les 2 dernieres
-- competitions feminines identifiees (Danemark, Australie).
-- Noms reels choisis a la main, pas les noms SportMonks (parfois
-- sponsorises ou differents de nos conventions).
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Rejouable sans doublon (WHERE NOT EXISTS par nomCompetition/idPays/division/genre).
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`)
SELECT * FROM (
    SELECT 'Cymru Premier' AS n, 'Championnat' AS t, 8 AS p, 'D1' AS d, 'M' AS g
    UNION ALL SELECT 'Cymru North/South', 'Championnat', 8, 'D2', 'M'
    UNION ALL SELECT 'Adran Premier', 'Championnat', 8, 'D1', 'F'
    UNION ALL SELECT 'Elitedivisionen', 'Championnat', 16, 'D1', 'F'
    UNION ALL SELECT 'A-League Women', 'Championnat', 20, 'D1', 'F'
) AS nouvelles
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` c
    WHERE c.nomCompetition = nouvelles.n AND c.idPays = nouvelles.p AND c.division = nouvelles.d AND c.genre = nouvelles.g
);
