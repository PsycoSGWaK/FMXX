-- Etend les regles de qualification UEFA (deja en place pour les 5 pays
-- d'origine, voir migration_qualif_rules.sql) aux 11 pays europeens
-- ajoutes via la consolidation SportMonks. Aucune nouvelle ligne
-- `competition` : on rattache juste ces championnats aux competitions
-- continentales UEFA existantes (1=UCL, 2=UEL, 3=UECL, 30=UWCL, 46=UEFA
-- Women's Europa Cup), memes seuils que les pays d'origine.
--
-- Cote femmes, seuls les pays ayant un championnat D1 feminin trackee
-- recoivent une regle (Danemark, Suede, Pays de Galles) ; Autriche,
-- Belgique, Pays-Bas, Portugal, Turquie, Ecosse, Irlande, Irlande du
-- Nord n'ont pas de championnat feminin en base, donc pas de regle.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.
--
-- Reecrit le 2026-08-30 pour etre portable et rejouable sans doublon :
-- resolution des idCompetition par nom/pays/genre (les ids fixes
-- 49/50/69/... sont ceux de la base locale, pas garantis identiques en
-- prod) + WHERE NOT EXISTS sur chaque regle.

-- --- Hommes : 1er -> UCL, 2e-3e -> UEL, 4e-5e -> UECL ---
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`)
SELECT cible.idCompetition, src.idCompetition, m.rmin, m.rmax
FROM (
    SELECT 1 AS cible_nom_ordre, 'Bundesliga' AS src_nom, 10 AS src_pays, 1 AS rmin, 1 AS rmax
    UNION ALL SELECT 2, 'Bundesliga', 10, 2, 3
    UNION ALL SELECT 3, 'Bundesliga', 10, 4, 5
    UNION ALL SELECT 1, 'Pro League', 11, 1, 1
    UNION ALL SELECT 2, 'Pro League', 11, 2, 3
    UNION ALL SELECT 3, 'Pro League', 11, 4, 5
    UNION ALL SELECT 1, 'Superliga', 16, 1, 1
    UNION ALL SELECT 2, 'Superliga', 16, 2, 3
    UNION ALL SELECT 3, 'Superliga', 16, 4, 5
    UNION ALL SELECT 1, 'Premier Division', 19, 1, 1
    UNION ALL SELECT 2, 'Premier Division', 19, 2, 3
    UNION ALL SELECT 3, 'Premier Division', 19, 4, 5
    UNION ALL SELECT 1, 'Eredivisie', 13, 1, 1
    UNION ALL SELECT 2, 'Eredivisie', 13, 2, 3
    UNION ALL SELECT 3, 'Eredivisie', 13, 4, 5
    UNION ALL SELECT 1, 'NIFL Premiership', 18, 1, 1
    UNION ALL SELECT 2, 'NIFL Premiership', 18, 2, 3
    UNION ALL SELECT 3, 'NIFL Premiership', 18, 4, 5
    UNION ALL SELECT 1, 'Primeira Liga', 14, 1, 1
    UNION ALL SELECT 2, 'Primeira Liga', 14, 2, 3
    UNION ALL SELECT 3, 'Primeira Liga', 14, 4, 5
    UNION ALL SELECT 1, 'Scottish Premiership', 17, 1, 1
    UNION ALL SELECT 2, 'Scottish Premiership', 17, 2, 3
    UNION ALL SELECT 3, 'Scottish Premiership', 17, 4, 5
    UNION ALL SELECT 1, 'Allsvenskan', 9, 1, 1
    UNION ALL SELECT 2, 'Allsvenskan', 9, 2, 3
    UNION ALL SELECT 3, 'Allsvenskan', 9, 4, 5
    UNION ALL SELECT 1, 'Süper Lig', 15, 1, 1
    UNION ALL SELECT 2, 'Süper Lig', 15, 2, 3
    UNION ALL SELECT 3, 'Süper Lig', 15, 4, 5
    UNION ALL SELECT 1, 'Cymru Premier', 8, 1, 1
    UNION ALL SELECT 2, 'Cymru Premier', 8, 2, 3
    UNION ALL SELECT 3, 'Cymru Premier', 8, 4, 5
) AS m
JOIN `competition` cible ON cible.idCompetition = m.cible_nom_ordre AND cible.typeCompetition = 'Continentale'
JOIN `competition` src ON src.nomCompetition = m.src_nom AND src.idPays = m.src_pays AND src.genre = 'M' AND src.typeCompetition = 'Championnat'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = cible.idCompetition AND r.idCompetitionSource = src.idCompetition AND r.rang_min = m.rmin
);

-- --- Femmes : 1re -> UWCL, 2e-20e -> Women's Europa Cup ---
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`)
SELECT cible.idCompetition, src.idCompetition, m.rmin, m.rmax
FROM (
    SELECT 30 AS cible_id, 'Superliga' AS src_nom, 16 AS src_pays, 1 AS rmin, 1 AS rmax
    UNION ALL SELECT 46, 'Superliga', 16, 2, 20
    UNION ALL SELECT 30, 'Damallsvenskan', 9, 1, 1
    UNION ALL SELECT 46, 'Damallsvenskan', 9, 2, 20
    UNION ALL SELECT 30, 'Adran Premier', 8, 1, 1
    UNION ALL SELECT 46, 'Adran Premier', 8, 2, 20
) AS m
JOIN `competition` cible ON cible.idCompetition = m.cible_id AND cible.typeCompetition = 'Continentale'
JOIN `competition` src ON src.nomCompetition = m.src_nom AND src.idPays = m.src_pays AND src.genre = 'F' AND src.typeCompetition = 'Championnat'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = cible.idCompetition AND r.idCompetitionSource = src.idCompetition AND r.rang_min = m.rmin
);
