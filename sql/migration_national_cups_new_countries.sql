-- Coupes nationales (type Nationale) pour les 15 pays ajoutes via la
-- consolidation SportMonks. Noms verifies par recherche web avant
-- insertion (pas de sponsor, nom natif quand c'est la convention deja
-- suivie pour les pays d'origine : DFB-Pokal, Copa del Rey, Coppa
-- Italia...).
--
-- Cote femmes : uniquement les pays ayant a la fois un championnat F D1
-- tracke ET une vraie coupe nationale feminine confirmee. Verifie
-- explicitement l'absence de coupe feminine nationale pour :
--   - Australie (Women's Australia Cup annoncee en 2023, jamais lancee)
--   - Etats-Unis (pas d'equivalent feminin du US Open Cup pour la NWSL)
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Rejouable sans doublon (WHERE NOT EXISTS par nomCompetition/idPays/genre).
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`)
SELECT * FROM (
    -- Hommes
    SELECT 'ÖFB-Cup' AS n, 'Nationale' AS t, 10 AS p, 'M' AS g           -- Autriche
    UNION ALL SELECT 'Belgian Cup', 'Nationale', 11, 'M'                 -- Belgique
    UNION ALL SELECT 'Copa do Brasil', 'Nationale', 12, 'M'              -- Bresil
    UNION ALL SELECT 'KNVB Cup', 'Nationale', 13, 'M'                    -- Pays-Bas
    UNION ALL SELECT 'Taça de Portugal', 'Nationale', 14, 'M'            -- Portugal
    UNION ALL SELECT 'Türkiye Kupası', 'Nationale', 15, 'M'              -- Turquie
    UNION ALL SELECT 'Emperor''s Cup', 'Nationale', 7, 'M'               -- Japon
    UNION ALL SELECT 'U.S. Open Cup', 'Nationale', 6, 'M'                -- Etats-Unis
    UNION ALL SELECT 'Svenska Cupen', 'Nationale', 9, 'M'                -- Suede
    UNION ALL SELECT 'DBU Pokalen', 'Nationale', 16, 'M'                 -- Danemark
    UNION ALL SELECT 'Scottish Cup', 'Nationale', 17, 'M'                -- Ecosse
    UNION ALL SELECT 'FAI Cup', 'Nationale', 19, 'M'                     -- Irlande
    UNION ALL SELECT 'Irish Cup', 'Nationale', 18, 'M'                   -- Irlande du Nord
    UNION ALL SELECT 'Australia Cup', 'Nationale', 20, 'M'               -- Australie
    UNION ALL SELECT 'Welsh Cup', 'Nationale', 8, 'M'                    -- Pays de Galles
    -- Femmes (uniquement ou une coupe feminine nationale confirmee existe)
    UNION ALL SELECT 'DBU KvindePokalen', 'Nationale', 16, 'F'           -- Danemark
    UNION ALL SELECT 'Svenska Cupen Damer', 'Nationale', 9, 'F'          -- Suede
    UNION ALL SELECT 'FAW Women''s Cup', 'Nationale', 8, 'F'             -- Pays de Galles
    UNION ALL SELECT 'Empress''s Cup', 'Nationale', 7, 'F'               -- Japon
) AS nouvelles
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` c
    WHERE c.nomCompetition = nouvelles.n AND c.idPays = nouvelles.p AND c.genre = nouvelles.g
);
