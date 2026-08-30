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

-- Rejouable sans doublon (WHERE NOT EXISTS par nomCompetition/idPays/division/genre).
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`)
SELECT * FROM (
    SELECT 'Bundesliga' AS n, 'Championnat' AS t, 10 AS p, 'D1' AS d, 'M' AS g
    UNION ALL SELECT 'Pro League', 'Championnat', 11, 'D1', 'M'
    UNION ALL SELECT 'Challenger Pro League', 'Championnat', 11, 'D2', 'M'
    UNION ALL SELECT 'Campeonato Brasileiro Série A', 'Championnat', 12, 'D1', 'M'
    UNION ALL SELECT 'Campeonato Brasileiro Série B', 'Championnat', 12, 'D2', 'M'
    UNION ALL SELECT 'Eredivisie', 'Championnat', 13, 'D1', 'M'
    UNION ALL SELECT 'Eerste Divisie', 'Championnat', 13, 'D2', 'M'
    UNION ALL SELECT 'Primeira Liga', 'Championnat', 14, 'D1', 'M'
    UNION ALL SELECT 'Liga Portugal 2', 'Championnat', 14, 'D2', 'M'
    UNION ALL SELECT 'Süper Lig', 'Championnat', 15, 'D1', 'M'
    UNION ALL SELECT '1. Lig', 'Championnat', 15, 'D2', 'M'
    UNION ALL SELECT 'J1 League', 'Championnat', 7, 'D1', 'M'
    UNION ALL SELECT 'J2 League', 'Championnat', 7, 'D2', 'M'
    UNION ALL SELECT 'WE League', 'Championnat', 7, 'D1', 'F'
    UNION ALL SELECT 'Major League Soccer', 'Championnat', 6, 'D1', 'M'
    UNION ALL SELECT 'National Women''s Soccer League', 'Championnat', 6, 'D1', 'F'
    UNION ALL SELECT 'Allsvenskan', 'Championnat', 9, 'D1', 'M'
    UNION ALL SELECT 'Damallsvenskan', 'Championnat', 9, 'D1', 'F'
    UNION ALL SELECT 'Elitettan', 'Championnat', 9, 'D2', 'F'
    UNION ALL SELECT 'National 2', 'Championnat', 5, 'D4', 'M'
) AS nouvelles
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` c
    WHERE c.nomCompetition = nouvelles.n AND c.idPays = nouvelles.p AND c.division = nouvelles.d AND c.genre = nouvelles.g
);
