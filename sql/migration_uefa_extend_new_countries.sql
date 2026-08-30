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

-- --- Hommes : 1er -> UCL, 2e-3e -> UEL, 4e-5e -> UECL ---
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`) VALUES
(1, 49, 1, 1), (2, 49, 2, 3), (3, 49, 4, 5),  -- Autriche (Bundesliga)
(1, 50, 1, 1), (2, 50, 2, 3), (3, 50, 4, 5),  -- Belgique (Pro League)
(1, 69, 1, 1), (2, 69, 2, 3), (3, 69, 4, 5),  -- Danemark (Superliga)
(1, 72, 1, 1), (2, 72, 2, 3), (3, 72, 4, 5),  -- Irlande (Premier Division)
(1, 54, 1, 1), (2, 54, 2, 3), (3, 54, 4, 5),  -- Pays-Bas (Eredivisie)
(1, 74, 1, 1), (2, 74, 2, 3), (3, 74, 4, 5),  -- Irlande du Nord (NIFL Premiership)
(1, 56, 1, 1), (2, 56, 2, 3), (3, 56, 4, 5),  -- Portugal (Primeira Liga)
(1, 71, 1, 1), (2, 71, 2, 3), (3, 71, 4, 5),  -- Ecosse (Scottish Premiership)
(1, 65, 1, 1), (2, 65, 2, 3), (3, 65, 4, 5),  -- Suede (Allsvenskan)
(1, 58, 1, 1), (2, 58, 2, 3), (3, 58, 4, 5),  -- Turquie (Super Lig)
(1, 80, 1, 1), (2, 80, 2, 3), (3, 80, 4, 5);  -- Pays de Galles (Cymru Premier)

-- --- Femmes : 1re -> UWCL, 2e-20e -> Women's Europa Cup ---
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`) VALUES
(30, 83, 1, 1), (46, 83, 2, 20),  -- Danemark (Elitedivisionen)
(30, 66, 1, 1), (46, 66, 2, 20),  -- Suede (Damallsvenskan)
(30, 82, 1, 1), (46, 82, 2, 20);  -- Pays de Galles (Adran Premier)
