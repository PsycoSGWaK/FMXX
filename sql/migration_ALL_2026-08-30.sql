-- =============================================================
-- Script consolide : toutes les migrations de la session du 2026-08-30
-- restant a executer en prod, dans l'ordre. NE CONTIENT PAS
-- migration_qualif_rules.sql ni migration_nat_pdn_varchar.sql,
-- deja executees en prod par Guillaume.
-- A executer en une fois (phpMyAdmin o2switch), APRES deploiement du code.
-- =============================================================

-- =============================================================
-- migration_fix_spain_women_d2_name.sql
-- =============================================================
-- Corrige le nom trompeur de la D2 feminine espagnole : "Primera División
-- Femenina" laissait penser a une D1 alors qu'il s'agit bien de la D2
-- (Liga F, idCompetition 40, est la vraie D1). Repere depuis la pause du
-- 2026-07-07 sur la refonte des competitions (voir
-- project_competition_qualif_rules dans la memoire), corrige a la demande
-- de Guillaume avec le vrai nom.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

UPDATE `competition`
SET `nomCompetition` = 'Primera Federación FutFem'
WHERE `idCompetition` = 41;

-- =============================================================
-- migration_objectif_manuel.sql
-- =============================================================
-- Permet d'ajouter manuellement une competition a l'onglet Objectifs meme
-- quand elle n'est pas deduite automatiquement (1ere saison suivie = pas
-- de saison precedente pour calculer une qualification, ou realite du
-- save FM qui diverge de ce que l'outil peut deduire). Signale par
-- Guillaume : bloque des la 1ere saison des qu'un club joue une
-- Supercoupe ou une comp continentale que l'outil ne peut pas deviner.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `objectif`
    ADD COLUMN `manuel` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'ajoutee a la main via le selecteur "Ajouter une competition", toujours affichee quelle que soit la deduction automatique';

-- =============================================================
-- migration_fix_france_women_d1_name.sql
-- =============================================================
-- Corrige le nom perime de la D1 feminine francaise : "Division 1 Arkema"
-- a ete renommee "Premiere Ligue" a partir de la saison 2024-25 (Arkema
-- reste sponsor mais n'est plus dans le nom de la competition).
-- Corrige a la demande de Guillaume.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

UPDATE `competition`
SET `nomCompetition` = 'Première Ligue'
WHERE `idCompetition` = 34;

-- =============================================================
-- migration_fix_league_names.sql
-- =============================================================
-- Retire les noms de sponsor (qui changent chaque saison, cf discussion
-- avec Guillaume sur la liste des championnats reellement joues dans
-- FM26) et corrige un renommage structurel recent non lie a un sponsor,
-- verifie par recherche web avant application :
--   - Angleterre D2F : "Women's Championship" -> "Women's Super League 2"
--     (rebrand sous l'ombrelle WSL, effectif saison 2025-26)
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

UPDATE `competition` SET `nomCompetition` = 'LaLiga' WHERE `idCompetition` = 12;
UPDATE `competition` SET `nomCompetition` = 'LaLiga 2' WHERE `idCompetition` = 13;
UPDATE `competition` SET `nomCompetition` = 'Serie B' WHERE `idCompetition` = 19;
UPDATE `competition` SET `nomCompetition` = 'Women''s Super League 2' WHERE `idCompetition` = 32;

-- =============================================================
-- migration_add_competitions_new_countries.sql
-- =============================================================
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

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
-- Autriche (idPays 10)
('Bundesliga', 'Championnat', 10, 'D1', 'M'),
-- Belgique (idPays 11)
('Pro League', 'Championnat', 11, 'D1', 'M'),
('Challenger Pro League', 'Championnat', 11, 'D2', 'M'),
-- Bresil (idPays 12)
('Campeonato Brasileiro Série A', 'Championnat', 12, 'D1', 'M'),
('Campeonato Brasileiro Série B', 'Championnat', 12, 'D2', 'M'),
-- Pays-Bas (idPays 13)
('Eredivisie', 'Championnat', 13, 'D1', 'M'),
('Eerste Divisie', 'Championnat', 13, 'D2', 'M'),
-- Portugal (idPays 14)
('Primeira Liga', 'Championnat', 14, 'D1', 'M'),
('Liga Portugal 2', 'Championnat', 14, 'D2', 'M'),
-- Turquie (idPays 15)
('Süper Lig', 'Championnat', 15, 'D1', 'M'),
('1. Lig', 'Championnat', 15, 'D2', 'M'),
-- Japon (idPays 7)
('J1 League', 'Championnat', 7, 'D1', 'M'),
('J2 League', 'Championnat', 7, 'D2', 'M'),
('WE League', 'Championnat', 7, 'D1', 'F'),
-- Etats-Unis (idPays 6)
('Major League Soccer', 'Championnat', 6, 'D1', 'M'),
('National Women''s Soccer League', 'Championnat', 6, 'D1', 'F'),
-- Suede (idPays 9)
('Allsvenskan', 'Championnat', 9, 'D1', 'M'),
('Damallsvenskan', 'Championnat', 9, 'D1', 'F'),
('Elitettan', 'Championnat', 9, 'D2', 'F'),
-- France (idPays 5) : National 2 (D4) manquait alors que les 48 clubs
-- sont deja importes
('National 2', 'Championnat', 5, 'D4', 'M');

-- =============================================================
-- migration_add_countries_denmark_scotland_ireland_ni_australia.sql
-- =============================================================
-- Ajoute 5 nouveaux pays (Danemark, Ecosse, Irlande, Irlande du Nord,
-- Australie), les championnats hommes correspondants (noms reels, sans
-- sponsor) et les clubs de la saison en cours, pour les divisions dont
-- les listes ont pu etre verifiees de facon fiable (recherche web,
-- plusieurs sources croisees). Complete aussi Suede D2 (Superettan),
-- pays deja en base.
--
-- Restent en attente (listes trouvees incompletes/contradictoires,
-- a fournir manuellement) : Ecosse D2, Irlande du Nord D2, Autriche D2.
-- Aucune competition femme dans ce lot (Danemark F, Australie F,
-- Pays de Galles F) : source Transfermarkt insuffisante sur le
-- feminin, a traiter separement.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- Nouveaux pays (codes synthetiques pour Ecosse/Irlande du Nord, comme
-- Wales -> WL/WAL/0, faute de code ISO 3166-1 propre a ces nations
-- constitutives du Royaume-Uni)
INSERT INTO `pays` (`nomPays`, `paysA2C`, `paysA3C`, `paysNum`) VALUES
('Denmark', 'DK', 'DNK', 208),
('Scotland', 'SC', 'SCT', 0),
('Northern Ireland', 'NI', 'NIR', 0),
('Ireland', 'IE', 'IRL', 372),
('Australia', 'AU', 'AUS', 36);

-- Recupere les nouveaux idPays (a adapter si AUTO_INCREMENT differe en prod)
SET @idDenmark = (SELECT idPays FROM pays WHERE paysA2C = 'DK');
SET @idScotland = (SELECT idPays FROM pays WHERE paysA2C = 'SC');
SET @idNorthernIreland = (SELECT idPays FROM pays WHERE paysA2C = 'NI');
SET @idIreland = (SELECT idPays FROM pays WHERE paysA2C = 'IE');
SET @idAustralia = (SELECT idPays FROM pays WHERE paysA2C = 'AU');
SET @idSweden = (SELECT idPays FROM pays WHERE paysA2C = 'SE');

-- Championnats (noms reels, sans sponsor)
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
('Superliga', 'Championnat', @idDenmark, 'D1', 'M'),
('1. Division', 'Championnat', @idDenmark, 'D2', 'M'),
('Scottish Premiership', 'Championnat', @idScotland, 'D1', 'M'),
('League of Ireland Premier Division', 'Championnat', @idIreland, 'D1', 'M'),
('League of Ireland First Division', 'Championnat', @idIreland, 'D2', 'M'),
('NIFL Premiership', 'Championnat', @idNorthernIreland, 'D1', 'M'),
('A-League Men', 'Championnat', @idAustralia, 'D1', 'M'),
('Superettan', 'Championnat', @idSweden, 'D2', 'M');

-- Clubs (saison 2025-26 / 2026, selon le pays)

-- Danemark D1 - Superliga (12)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('AGF Aarhus', @idDenmark, 'M', 'D1'),
('Brøndby IF', @idDenmark, 'M', 'D1'),
('FC Copenhagen', @idDenmark, 'M', 'D1'),
('FC Midtjylland', @idDenmark, 'M', 'D1'),
('FC Fredericia', @idDenmark, 'M', 'D1'),
('FC Nordsjælland', @idDenmark, 'M', 'D1'),
('OB Odense', @idDenmark, 'M', 'D1'),
('Randers FC', @idDenmark, 'M', 'D1'),
('Silkeborg IF', @idDenmark, 'M', 'D1'),
('SønderjyskE', @idDenmark, 'M', 'D1'),
('Vejle BK', @idDenmark, 'M', 'D1'),
('Viborg FF', @idDenmark, 'M', 'D1');

-- Danemark D2 - 1. Division (12)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Lyngby BK', @idDenmark, 'M', 'D2'),
('Hvidovre IF', @idDenmark, 'M', 'D2'),
('Hillerød Fodbold', @idDenmark, 'M', 'D2'),
('Esbjerg fB', @idDenmark, 'M', 'D2'),
('Kolding IF', @idDenmark, 'M', 'D2'),
('AC Horsens', @idDenmark, 'M', 'D2'),
('AaB', @idDenmark, 'M', 'D2'),
('B93', @idDenmark, 'M', 'D2'),
('Aarhus Fremad', @idDenmark, 'M', 'D2'),
('Hobro IK', @idDenmark, 'M', 'D2'),
('HB Køge', @idDenmark, 'M', 'D2'),
('Middelfart BK', @idDenmark, 'M', 'D2');

-- Ecosse D1 - Premiership (12)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Aberdeen FC', @idScotland, 'M', 'D1'),
('Celtic FC', @idScotland, 'M', 'D1'),
('Dundee FC', @idScotland, 'M', 'D1'),
('Dundee United FC', @idScotland, 'M', 'D1'),
('Falkirk FC', @idScotland, 'M', 'D1'),
('Heart of Midlothian FC', @idScotland, 'M', 'D1'),
('Hibernian FC', @idScotland, 'M', 'D1'),
('Kilmarnock FC', @idScotland, 'M', 'D1'),
('Livingston FC', @idScotland, 'M', 'D1'),
('Motherwell FC', @idScotland, 'M', 'D1'),
('Rangers FC', @idScotland, 'M', 'D1'),
('St Mirren FC', @idScotland, 'M', 'D1');

-- Irlande D1 - Premier Division (10)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Shamrock Rovers', @idIreland, 'M', 'D1'),
('Bohemian FC', @idIreland, 'M', 'D1'),
('Shelbourne FC', @idIreland, 'M', 'D1'),
('Dundalk FC', @idIreland, 'M', 'D1'),
('Derry City FC', @idIreland, 'M', 'D1'),
('St Patrick''s Athletic', @idIreland, 'M', 'D1'),
('Sligo Rovers', @idIreland, 'M', 'D1'),
('Drogheda United', @idIreland, 'M', 'D1'),
('Galway United', @idIreland, 'M', 'D1'),
('Waterford FC', @idIreland, 'M', 'D1');

-- Irlande D2 - First Division (10)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Athlone Town', @idIreland, 'M', 'D2'),
('Bray Wanderers', @idIreland, 'M', 'D2'),
('Cobh Ramblers', @idIreland, 'M', 'D2'),
('Cork City FC', @idIreland, 'M', 'D2'),
('Finn Harps', @idIreland, 'M', 'D2'),
('Kerry FC', @idIreland, 'M', 'D2'),
('Treaty United', @idIreland, 'M', 'D2'),
('UCD AFC', @idIreland, 'M', 'D2'),
('Wexford FC', @idIreland, 'M', 'D2'),
('Longford Town', @idIreland, 'M', 'D2');

-- Irlande du Nord D1 - NIFL Premiership (12). Le 12e club promu en D1
-- pour 2025-26 est Bangor FC (champion de D2 2024-25) et non Limavady
-- United comme suppose dans une premiere recherche -- Limavady est bien
-- en D2 2025-26, confirme par Guillaume via Wikipedia.
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Larne FC', @idNorthernIreland, 'M', 'D1'),
('Linfield FC', @idNorthernIreland, 'M', 'D1'),
('Glentoran FC', @idNorthernIreland, 'M', 'D1'),
('Crusaders FC', @idNorthernIreland, 'M', 'D1'),
('Coleraine FC', @idNorthernIreland, 'M', 'D1'),
('Cliftonville FC', @idNorthernIreland, 'M', 'D1'),
('Ballymena United', @idNorthernIreland, 'M', 'D1'),
('Portadown FC', @idNorthernIreland, 'M', 'D1'),
('Dungannon Swifts', @idNorthernIreland, 'M', 'D1'),
('Carrick Rangers', @idNorthernIreland, 'M', 'D1'),
('Glenavon FC', @idNorthernIreland, 'M', 'D1'),
('Bangor FC', @idNorthernIreland, 'M', 'D1');

-- Australie D1 - A-League Men (12)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Adelaide United', @idAustralia, 'M', 'D1'),
('Auckland FC', @idAustralia, 'M', 'D1'),
('Brisbane Roar', @idAustralia, 'M', 'D1'),
('Central Coast Mariners', @idAustralia, 'M', 'D1'),
('Macarthur FC', @idAustralia, 'M', 'D1'),
('Melbourne City', @idAustralia, 'M', 'D1'),
('Melbourne Victory', @idAustralia, 'M', 'D1'),
('Newcastle Jets', @idAustralia, 'M', 'D1'),
('Perth Glory', @idAustralia, 'M', 'D1'),
('Sydney FC', @idAustralia, 'M', 'D1'),
('Wellington Phoenix', @idAustralia, 'M', 'D1'),
('Western Sydney Wanderers', @idAustralia, 'M', 'D1');

-- Suede D2 - Superettan (16)
INSERT INTO `equipe` (`nomEquipe`, `idPays`, `genre`, `division`) VALUES
('Falkenbergs FF', @idSweden, 'M', 'D2'),
('GIF Sundsvall', @idSweden, 'M', 'D2'),
('Helsingborgs IF', @idSweden, 'M', 'D2'),
('IFK Norrköping', @idSweden, 'M', 'D2'),
('IFK Värnamo', @idSweden, 'M', 'D2'),
('IK Brage', @idSweden, 'M', 'D2'),
('IK Oddevold', @idSweden, 'M', 'D2'),
('Landskrona BoIS', @idSweden, 'M', 'D2'),
('Ljungskile SK', @idSweden, 'M', 'D2'),
('Nordic United FC', @idSweden, 'M', 'D2'),
('Norrby IF', @idSweden, 'M', 'D2'),
('Sandvikens IF', @idSweden, 'M', 'D2'),
('Varbergs BoIS', @idSweden, 'M', 'D2'),
('Örebro SK', @idSweden, 'M', 'D2'),
('Östers IF', @idSweden, 'M', 'D2'),
('Östersunds FK', @idSweden, 'M', 'D2');

-- =============================================================
-- migration_add_scotland_d2.sql
-- =============================================================
-- Ecosse D2 - Scottish Championship (10 clubs, saison 2025-26).
-- Liste fournie directement par Guillaume (les recherches web
-- automatisees donnaient des resultats contradictoires/incomplets).
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

SET @idScotland = (SELECT idPays FROM pays WHERE paysA2C = 'SC');

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
('Scottish Championship', 'Championnat', @idScotland, 'D2', 'M');

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

-- =============================================================
-- migration_add_northern_ireland_d2.sql
-- =============================================================
-- Irlande du Nord D2 - NIFL Championship (12 clubs, saison 2025-26).
-- Liste fournie directement par Guillaume (source Wikipedia,
-- https://en.wikipedia.org/wiki/2025%E2%80%9326_NIFL_Championship) -
-- les recherches web automatisees donnaient des resultats
-- contradictoires/incomplets.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

SET @idNorthernIreland = (SELECT idPays FROM pays WHERE paysA2C = 'NI');

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`) VALUES
('NIFL Championship', 'Championnat', @idNorthernIreland, 'D2', 'M');

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

-- =============================================================
-- migration_add_austria_d2.sql
-- =============================================================
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

-- =============================================================
-- migration_fix_france_d3_d4_names.sql
-- =============================================================
-- Renommage structurel de la saison 2026-27 en France (confirme par
-- Guillaume) : l'ancienne "National" (D3) devient "Ligue 3", et
-- l'ancienne "National 2" (D4) recupere le nom "National". Meme
-- structure de divisions, juste un decalage des noms d'un cran.

UPDATE `competition` SET `nomCompetition` = 'Ligue 3' WHERE `idCompetition` = 23;
UPDATE `competition` SET `nomCompetition` = 'National' WHERE `idCompetition` = 68;

-- =============================================================
-- migration_sportmonks_new_competitions.sql
-- =============================================================
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

-- =============================================================
-- equipe_insert_sportmonks.sql
-- =============================================================
-- Genere par sportmonks_import_teams.php le 2026-08-30 10:25:54
-- Verifier ce fichier avant de l'injecter en base.
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- au_MD1.json (A-League Men) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Western Sydney Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wellington Phoenix', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Central Coast Mariners', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sydney', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Macarthur', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Perth Glory', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Melbourne Victory', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brisbane Roar', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Melbourne City', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Adelaide United', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newcastle Jets', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Auckland', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'M', 'D1');

-- at_MD1.json (Admiral Bundesliga) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('LASK Linz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('WSG Tirol', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SK Rapid', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sturm Graz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rheindorf Altach', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Salzburg', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hartberg', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Grazer AK', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wolfsberger AC', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ried', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austria Wien', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austria Lustenau', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');

-- at_MD2.json (2. Liga) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Liefering', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wacker Innsbruck', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rapid Wien II', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austria Salzburg', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Admira', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amstetten', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Schwarz-Weiß Bregenz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blau-Weiß Linz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('WSPG Wels', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Floridsdorfer AC', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Voitsberg', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sturm Graz II', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Pölten', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austria Wien II', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kapfenberger SV', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('First Vienna', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D2');

-- be_MD1.json (Pro League) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('La Louvière', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Zulte-Waregem', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SK Beveren', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Genk', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting Charleroi', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Anderlecht', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Standard Liège', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sint-Truiden', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Club Brugge', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Antwerp', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gent', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lommel SK', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Westerlo', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mechelen', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('OH Leuven', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Union Saint-Gilloise', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KV Kortrijk', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cercle Brugge', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');

-- be_MD2.json (Challenger Pro League) - 15 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KAS Eupen', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RSCA Futures U23', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dender', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Koninklijke Lierse Sportkring', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong Gent', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong KRC Genk U23', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Patro Eisden Maasmechelen', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KSC Lokeren', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Club NXT U23', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Royal Francs Borains', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RFC Seraing', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Excelsior Virton', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RFC Liège', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('K. Beerschot V.A.', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting Hasselt', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');

-- br_MD1.json (Serie A) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mirassol', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vitória', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Remo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cruzeiro', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Internacional', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Coritiba', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athletico PR', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bahia', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('São Paulo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Corinthians', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Botafogo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Flamengo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vasco da Gama', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Santos', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bragantino', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Grêmio', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atlético Mineiro', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fluminense', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chapecoense', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Palmeiras', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');

-- br_MD2.json (Serie B) - 24 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('6th ranked', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('4th ranked', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('CRB', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('América Mineiro', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ceará', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vila Nova', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Criciúma', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('5th ranked', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Náutico', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Novorizontino', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('3rd ranked', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atlético GO', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Operário PR', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fortaleza', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Botafogo SP', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('São Bernardo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cuiabá', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ponte Preta', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Londrina', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athletic Club', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juventude', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Goiás', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avaí', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sport Recife', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');

-- dk_MD1.json (Superliga) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Viborg FF', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lyngby Boldklub', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nordsjælland', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Odense BK', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Horsens', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Randers FC', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Midtjylland', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Silkeborg IF', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC København', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sønderjyske Fodbold', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brøndby IF', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AGF', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D1');

-- dk_MD2.json (First Division) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kolding IF', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vejle Boldklub', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hobro', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aalborg BK', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Akademisk Boldklub', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hillerød', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vendsyssel', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fredericia', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('HB Køge', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Esbjerg', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hvidovre', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aarhus Fremad', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'M', 'D2');

-- fr_MD1.json (Ligue 1) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Olympique Marseille', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('LOSC Lille', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rennes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Monaco', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Havre', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Angers SCO', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Troyes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Strasbourg', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris Saint Germain', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lens', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toulouse', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brest', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lorient', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Mans', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nice', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Auxerre', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Olympique Lyonnais', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');

-- fr_MD2.json (Ligue 2) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Reims', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pau', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Laval', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rodez', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Annecy', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Montpellier', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guingamp', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Étienne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Red Star', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nantes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nancy', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Metz', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sochaux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Clermont', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dunkerque', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boulogne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dijon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Grenoble Foot 38', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');

-- fr_MD3.json (Ligue 3 (= ex-National)) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1) AND genre = 'M' AND division = 'D3';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Villefranche', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Concarneau', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Aubagne Air Bel', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amiens SC', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cannes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Orléans', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bastia', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fleury 91', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Quevilly Rouen', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris 13 Atletico', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caen', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('La Roche', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Puy-en-Velay', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rouen', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bourg-en-Bresse', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Versailles', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Thionville Lusitanos', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valenciennes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');

-- fr_MD4.json (CFA Group A/B/C = National 2 (3 groupes)) - 49 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1) AND genre = 'M' AND division = 'D4';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Pays du Valois', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bastia-Borgo', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('US Chantilly', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Feignies-Aulnoye', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Haguenau', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St Maur Lusitanos', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dieppe', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St-Pryvé St-Hilaire', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Créteil', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chambly', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Montlouis', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Biesheim', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Racing Colombes 92', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Colmar', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Épinal', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Furiani-Agliani', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chauray', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lorient II', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saumur', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aviron Bayonnais', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Malo', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stade Briochin', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tarbes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Colomban Locmine', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dinan Léhon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avranches', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pontivy GSI', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Poire sur Vie VF', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Les Herbiers', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granville', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Angoulême', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chateaubriant Voltigeurs', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Canet Roussillon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bourges Foot 18', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hyères', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Priest', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Châteauroux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Istres', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Limonest', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fréjus St-Raphaël', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Touraine', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lyon Duchère', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Andrézieux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nîmes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rumilly Vallieres', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toulon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chasselay MDA', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Troyes II', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hauts Lyonnais', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');

-- fr_FD1.json (Premiere Ligue Women) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toulouse', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lens', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('OL Lyonnes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fleury 91', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Havre', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris SG', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Montpellier', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Strasbourg', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Olympique Marseille', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nantes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint Malo', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');

-- de_MD1.json (Bundesliga) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayer 04 Leverkusen', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Freiburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Borussia Dortmund', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Werder Bremen', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Köln', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Schalke 04', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elversberg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RB Leipzig', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Augsburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Borussia Mönchengladbach', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfB Stuttgart', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paderborn', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('TSG Hoffenheim', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eintracht Frankfurt', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FSV Mainz 05', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Bayern München', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hamburger SV', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Union Berlin', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');

-- de_MD2.json (2. Bundesliga) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfL Wolfsburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Energie Cottbus', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eintracht Braunschweig', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('DSC Arminia Bielefeld', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SpVgg Greuther Fürth', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Magdeburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Holstein Kiel', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Osnabrück', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nürnberg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Heidenheim', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kaiserslautern', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfL Bochum 1848', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Karlsruher SC', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dynamo Dresden', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hannover 96', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Pauli', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Darmstadt 98', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hertha BSC', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');

-- de_FD1.json (Google Pixel Frauen-Bundesliga (sponsor, ignore pour le nom)) - 14 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Werder Bremen', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RB Leipzig', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Union Berlin', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayern Munich', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Köln', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nürnberg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hamburger SV', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Freiburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mainz 05', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wolfsburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stuttgart', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayer Leverkusen', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eintracht Frankfurt', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hoffenheim', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');

-- ie_MD1.json (Premier Division) - 10 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shelbourne', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St Patrick''s', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Drogheda United', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bohemians', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sligo Rovers', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Galway United', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Waterford United', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dundalk', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shamrock Rovers', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Derry City', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D1');

-- ie_MD2.json (First Division) - 10 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Finn Harps', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('UCD', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athlone Town', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wexford Youths', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bray Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cobh Ramblers', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kerry', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Longford Town', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cork City', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Treaty United', (SELECT idPays FROM pays WHERE paysA2C = 'IE' LIMIT 1), 'M', 'D2');

-- it_MD1.json (Serie A) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Monza', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atalanta', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Udinese', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Venezia', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AC Milan', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Genoa', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fiorentina', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lazio', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Roma', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Frosinone', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Torino', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Como', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lecce', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bologna', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sassuolo', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Napoli', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Parma', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inter', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juventus', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cagliari', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');

-- it_MD2.json (Serie B) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Virtus Entella', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pisa', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Calcio Padova', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cesena', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cremonese', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Benevento', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Empoli', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juve Stabia', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sampdoria', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Südtirol', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hellas Verona', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arezzo', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Modena', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Carrarese', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Palermo', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Catanzaro', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mantova', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vicenza', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avellino', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ascoli', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');

-- it_FD1.json (Serie A Women) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juventus', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sassuolo', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ternana', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Roma', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fiorentina', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Napoli', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lazio', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AC Milan', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Como', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Como', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inter Milano', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Parma', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');

-- jp_MD1.json (J1 League) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fagiano Okayama', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kashima Antlers', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Machida Zelvia', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Tokyo', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sanfrecce Hiroshima', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Yokohama F. Marinos', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kashiwa Reysol', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tokyo Verdy', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kawasaki Frontale', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Urawa Reds', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nagoya Grampus', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('JEF United', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kyoto Sanga', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shimizu S-Pulse', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cerezo Osaka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mito Hollyhock', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gamba Osaka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('V-Varen Nagasaki', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avispa Fukuoka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vissel Kobe', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');

-- jp_MD2.json (J2-League) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fujieda MYFC', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sagan Tosu', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Imabari', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oita Trinita', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shonan Bellmare', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tegevajaro Miyazaki', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Yokohama', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Júbilo Iwata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ventforet Kofu', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Montedio Yamagata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Omiya Ardija', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Consadole Sapporo', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vegalta Sendai', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tokushima Vortis', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vanraure Hachinohe', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Albirex Niigata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Iwaki', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blaublitz Akita', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kataller Toyama', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tochigi City', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');

-- jp_FD1.json (WE League) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Albirex Niigata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('JEF United', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('NTV Beleza', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elfen Saitama', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cerezo Osaka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Parceiro Nagano', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sanfrecce Hiroshima', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Omiya Ardija Ventus', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nojima Stella', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('INAC Kobe Leonessa', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vegalta Sendai', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Urawa Reds', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');

-- nl_MD1.json (Eredivisie) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AZ Alkmaar', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Willem II', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ajax', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Groningen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Excelsior', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sparta Rotterdam', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Utrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('NEC Nijmegen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('ADO Den Haag', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Go Ahead Eagles', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Telstar', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Heerenveen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fortuna Sittard', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Twente', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('PEC Zwolle', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Cambuur', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('PSV', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Feyenoord', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');

-- nl_MD2.json (Eerste Divisie) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RKC Waalwijk', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Den Bosch', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vitesse', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('De Graafschap', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Eindhoven', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Emmen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong AZ', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('NAC Breda', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Heracles Almelo', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong PSV', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Volendam', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong FC Utrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Roda JC Kerkrade', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong Ajax', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Helmond Sport', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VVV-Venlo', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Almere City', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('TOP Oss', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Dordrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('MVV Maastricht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');

-- ni_MD1.json (Premiership) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Larne', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portadown', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cliftonville', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ballymena United', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Coleraine', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Carrick Rangers', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dungannon Swifts', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Linfield', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Glentoran', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Limavady United', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Crusaders', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bangor', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D1');

-- ni_MD2.json (Championship) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Queen''s University', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Moyola Park', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Armagh City', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Warrenpoint Town', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ards', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dundela', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newry City AFC', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('H&W Welders', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ballinamallard United', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Annagh United', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rathfriland Rangers', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Glenavon', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Institute', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Loughgall', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Strabane Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newington Youth', (SELECT idPays FROM pays WHERE paysA2C = 'NI' LIMIT 1), 'M', 'D2');

-- pt_MD1.json (Liga Portugal) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting CP', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alverca', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Benfica', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rio Ave', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Moreirense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arouca', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Porto', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Marítimo', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Estrela Amadora', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Estoril', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting Braga', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Casa Pia', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Academico Viseu', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gil Vicente', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nacional', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Santa Clara', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vitória Guimarães', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Famalicão', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');

-- pt_MD2.json (Liga Portugal 2) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vizela', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Porto II', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leixões', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chaves', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AVS', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tondela', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amarante', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Feirense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portimonense SAD', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Académica', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('União de Leiria', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penafiel', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lusitania FC Lourosa', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Torreense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Benfica II', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Felgueiras 1932', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting CP II', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Farense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');

-- sc_MD1.json (Premiership) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Motherwell', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kilmarnock', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aberdeen', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Falkirk', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hibernian', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Celtic', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hearts', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dundee', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rangers', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dundee United', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Mirren', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Johnstone', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D1');

-- sc_MD2.json (Championship) - 10 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arbroath', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dunfermline Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stenhousemuir', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Raith Rovers', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Livingston', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inverness CT', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Queen''s Park', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Greenock Morton', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ayr United', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Partick Thistle', (SELECT idPays FROM pays WHERE paysA2C = 'SC' LIMIT 1), 'M', 'D2');

-- es_MD1.json (La Liga) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Villarreal', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Madrid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Betis', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Deportivo A Coruña', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Celta de Vigo', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Levante', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elche', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Racing Santander', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sevilla', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Barcelona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Deportivo Alavés', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Sociedad', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valencia', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atlético de Madrid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Getafe', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athletic Club', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Espanyol', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Osasuna', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rayo Vallecano', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Málaga', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');

-- es_MD2.json (La Liga 2) - 22 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Castellón', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Córdoba', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burgos', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eldense', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tenerife', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Celta Fortuna', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granada', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting Gijón', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Oviedo', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Las Palmas', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ceuta', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Sociedad II', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SD Eibar', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Valladolid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cádiz', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mallorca', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Girona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leganés', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sabadell', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Albacete', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Almería', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Andorra', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');

-- es_FD1.json (Primera Division Women) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Logroño', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sevilla', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eibar', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atletico Madrid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barcelona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granada', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Madrid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Madrid CFF', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Costa Adeje Tenerife', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alavés', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Badalona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Espanyol', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athletic Club', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Sociedad', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valencia', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Deportivo de La Coruña', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');

-- se_MD1.json (Allsvenskan) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hammarby', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kalmar', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Degerfors', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Örgryte', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sirius', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brommapojkarna', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('GAIS', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Häcken', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Halmstad', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Djurgården', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Malmö FF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Västerås SK', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elfsborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IFK Göteborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AIK', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mjällby', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');

-- se_MD2.json (Superettan) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Värnamo', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Varberg BoIS', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Norrköping', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Falkenberg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sandvikens IF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Norrby', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Helsingborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oddevold', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Öster', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('GIF Sundsvall', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brage', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Östersunds FK', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ljungskile', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('United Nordic', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Landskrona', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Örebro', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D2');

-- se_FD1.json (Damallsvenskan) - 14 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Uppsala', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rosengard', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AIK', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hammarby', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brommapojkarna', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Växjö', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Malmö FF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eskilstuna United', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Häcken', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Djurgarden', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Norrköping', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pitea', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kristianstads', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vittsjo', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');

-- se_FD2.json (Elitettan Women) - 14 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1) AND genre = 'F' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Husqvarna', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gamla Upsala', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jitex', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KIF Orebro', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sandviken', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trelleborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alingsås', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Linkoping', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IFK Göteborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Enskede', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Örebro Söder', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elfsborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Umea', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Häcken II', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');

-- tr_MD1.json (Super Lig) - 18 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Samsunspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gaziantep F.K.', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rizespor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alanyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amed SK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eyüpspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Göztepe', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fenerbahçe', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Galatasaray', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Erzurumspor FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gençlerbirliği', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kocaelispor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trabzonspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Beşiktaş', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Çorum FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('İstanbul Başakşehir', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Konyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kasımpaşa', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');

-- tr_MD2.json (1. Lig) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vanspor FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('İstanbulspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Antalyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bursaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bandırmaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mardin BB', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bodrum FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Batman Petrolspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boluspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sivasspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Esenler Erokspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Muğlaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ümraniyespor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fatih Karagümrük', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manisa FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pendikspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kayserispor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Iğdır FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sarıyer SK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Keçiörengücü', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');

-- gb_MD1.json (Premier League) - 20 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brighton & Hove Albion', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fulham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Liverpool', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arsenal', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ipswich Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Coventry City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leeds United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Crystal Palace', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brentford', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sunderland', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AFC Bournemouth', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hull City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newcastle United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nottingham Forest', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Everton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chelsea', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aston Villa', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tottenham Hotspur', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');

-- gb_MD2.json (Championship) - 24 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Derby County', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wrexham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Preston North End', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Watford', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lincoln City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bristol City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wolverhampton Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charlton Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Swansea City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sheffield United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Queens Park Rangers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Norwich City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('West Bromwich Albion', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Middlesbrough', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('West Ham United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Southampton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portsmouth', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Millwall', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blackburn Rovers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bolton Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stoke City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Birmingham City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burnley', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');

-- gb_MD3.json (League One) - 24 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1) AND genre = 'M' AND division = 'D3';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bromley', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cambridge United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leicester City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leyton Orient', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Doncaster Rovers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barnsley', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stevenage', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mansfield Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oxford United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Luton Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wigan Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blackpool', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AFC Wimbledon', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Huddersfield Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Milton Keynes Dons', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wycombe Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burton Albion', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Plymouth Argyle', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stockport County', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Peterborough United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bradford City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Notts County', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Reading', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sheffield Wednesday', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');

-- gb_FD1.json (Women's Super League) - 14 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tottenham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('London City Lionesses', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chelsea', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aston Villa', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Crystal Palace', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charlton Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Liverpool', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Everton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brighton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Birmingham City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arsenal', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('West Ham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');

-- gb_FD2.json (WSL 2) - 12 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1) AND genre = 'F' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Southampton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sunderland', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ipswich Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bristol City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sheffield Utd', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Watford', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nottingham Forest', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wolverhampton Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burnley', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newcastle United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leicester', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Durham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');

-- us_MD1.json (Major League Soccer) - 30 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Colorado Rapids', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('San Diego', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('New York RB', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portland Timbers', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('LA Galaxy', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Philadelphia Union', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('CF Montréal', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Seattle Sounders', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nashville SC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austin', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SJ Earthquakes', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting KC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vancouver Whitecaps', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Salt Lake', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charlotte', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('New York City', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('DC United', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Orlando City', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inter Miami', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Louis City', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cincinnati', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dallas', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('New England', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toronto', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Los Angeles FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chicago Fire', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Minnesota United', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Houston Dynamo', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Columbus Crew', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atlanta United', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');

-- us_FD1.json (NWSL) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boston Legacy', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Utah Royals', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Washington Spirit', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Denver Summit', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Orlando Pride', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gotham FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portland Thorns', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Angel City', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('San Diego Wave', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bay FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Racing Louisville', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Houston Dash', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Seattle Reign', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chicago Stars', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('North Carolina Courage', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kansas City Current', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');

-- wl_MD1.json (Premier League (= Cymru Premier)) - 16 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1) AND genre = 'M' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff MU', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trefelin', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ammanford', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caernarfon Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llandudno', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Holywell', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Haverfordwest County', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Briton Ferry', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Flint Town United', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Connah''s Quay', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Airbus UK', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barry Town United', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cambrian & Clydach', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penybont', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Colwyn Bay', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('The New Saints', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');

-- wl_MD2.json (Cymru Championship North + South) - 32 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1) AND genre = 'M' AND division = 'D2';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brickfield Rangers', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bala Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Holyhead Hotspur', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Porthmadog', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caersws', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Denbigh Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Buckley Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llanuwchllyn', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ruthin Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Y Rhyl 1879', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gresford Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mold Alexandra', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bangor City', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guilsfield', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newtown AFC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penrhyncoch', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trethomas Bluebirds', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llanelli Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caerau (Ely)', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Afan Lido', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff Draconians', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caerphilly Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llantwit Major', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Treowen Stars', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pontardawe Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Baglan Dragons', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aberystwyth Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Swansea University', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newport City', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ynyshir Albions', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pontypridd Town AFC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Carmarthen Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');

-- wl_FD1.json (Welsh Premier Women's League (= Adran Premier)) - 8 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wrexham', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff Metropolitan', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Swansea', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Briton Ferry', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('The New Saints', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barry Town United', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff City', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aberystwyth Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'F', 'D1');

-- dk_FD1.json (Elitedivisionen Women) - 10 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('ASA', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('København', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brondby', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Farum BK', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KoldingQ', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Køge', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Midtjylland', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AGF', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fortuna Hjorring', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Odense Q', (SELECT idPays FROM pays WHERE paysA2C = 'DK' LIMIT 1), 'F', 'D1');

-- au_FD1.json (A-League Women) - 11 equipes
DELETE FROM equipe WHERE idPays = (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1) AND genre = 'F' AND division = 'D1';
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Central Coast Mariners', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Canberra United', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wellington Phoenix', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Melbourne Victory', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brisbane Roar', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Melbourne City', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sydney FC', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Perth Glory', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Western Sydney Wanderers', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Adelaide United', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newcastle Jets', (SELECT idPays FROM pays WHERE paysA2C = 'AU' LIMIT 1), 'F', 'D1');


-- =============================================================
-- migration_uefa_extend_new_countries.sql
-- =============================================================
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

-- =============================================================
-- migration_national_cups_new_countries.sql
-- =============================================================
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

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
-- Hommes
('ÖFB-Cup', 'Nationale', 10, 'M'),           -- Autriche
('Belgian Cup', 'Nationale', 11, 'M'),        -- Belgique
('Copa do Brasil', 'Nationale', 12, 'M'),     -- Bresil
('KNVB Cup', 'Nationale', 13, 'M'),           -- Pays-Bas
('Taça de Portugal', 'Nationale', 14, 'M'),   -- Portugal
('Türkiye Kupası', 'Nationale', 15, 'M'),     -- Turquie
('Emperor''s Cup', 'Nationale', 7, 'M'),      -- Japon
('U.S. Open Cup', 'Nationale', 6, 'M'),       -- Etats-Unis
('Svenska Cupen', 'Nationale', 9, 'M'),       -- Suede
('DBU Pokalen', 'Nationale', 16, 'M'),        -- Danemark
('Scottish Cup', 'Nationale', 17, 'M'),       -- Ecosse
('FAI Cup', 'Nationale', 19, 'M'),            -- Irlande
('Irish Cup', 'Nationale', 18, 'M'),          -- Irlande du Nord
('Australia Cup', 'Nationale', 20, 'M'),      -- Australie
('Welsh Cup', 'Nationale', 8, 'M'),           -- Pays de Galles

-- Femmes (uniquement ou une coupe feminine nationale confirmee existe)
('DBU KvindePokalen', 'Nationale', 16, 'F'),  -- Danemark
('Svenska Cupen Damer', 'Nationale', 9, 'F'), -- Suede
('FAW Women''s Cup', 'Nationale', 8, 'F'),    -- Pays de Galles
('Empress''s Cup', 'Nationale', 7, 'F');      -- Japon

-- =============================================================
-- migration_non_uefa_continentales.sql
-- =============================================================
-- Competitions continentales hors UEFA (CONMEBOL, CONCACAF, AFC), pour
-- les pays consolides sans equivalence europeenne (Bresil, Etats-Unis,
-- Japon, Australie). Ajoutees au catalogue SANS regle de qualification
-- automatique (competition_qualif_rule) : la qualification reelle melange
-- classement + vainqueur de coupe nationale + resultats continentaux de
-- l'annee precedente, trop complexe/incertain pour un rang simple sans
-- risquer une regle fausse. Rejoignent le filet de securite "+ Ajouter
-- une competition" (objectif_manuel_post.php) comme pour tout cas ou la
-- deduction automatique ne peut pas s'appliquer.
--
-- idPays = NULL (competitions globales, comme les competitions UEFA
-- existantes) : le rattachement au bon pays se fait via le contexte de
-- l'utilisateur, pas via une colonne idPays sur la ligne elle-meme.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
('Copa Libertadores', 'Continentale', NULL, 'M'),
('Copa Sudamericana', 'Continentale', NULL, 'M'),
('Concacaf Champions Cup', 'Continentale', NULL, 'M'),
('AFC Champions League Elite', 'Continentale', NULL, 'M'),
('AFC Champions League Two', 'Continentale', NULL, 'M'),
('AFC Women''s Champions League', 'Continentale', NULL, 'F'),
('Concacaf W Champions Cup', 'Continentale', NULL, 'F');

-- =============================================================
-- migration_fifa_club_world_cup.sql
-- =============================================================
-- FIFA Club World Cup : nouveau format 32 equipes depuis 2025, joue tous
-- les 4 ans (2025, 2029...) avec une qualification qui s'etale sur
-- plusieurs saisons et confederations, pas un simple "vainqueur de la
-- Ligue des champions l'an dernier". Ne colle pas au modele par saison
-- de l'outil (comme la MLS/Concacaf, cf migration_non_uefa_continentales.sql).
-- Ajoutee au catalogue sans regle de qualification automatique :
-- rejoint le filet de securite "+ Ajouter une competition".
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
('FIFA Club World Cup', 'Continentale', NULL, 'M');

-- =============================================================
-- migration_super_cups.sql
-- =============================================================
-- Super coupes nationales (champion du championnat vs vainqueur de la
-- coupe nationale), type Ligue. Existence + nom reels verifies par
-- recherche web pays par pays avant insertion. Volontairement absentes
-- (confirme inexistantes ou discontinuees, pas d'invention) :
-- Autriche (arretee en 2004), Danemark (irreguliere/inactive recemment),
-- Ecosse, Australie, Pays de Galles, Etats-Unis (aucune n'existe),
-- Angleterre F (Women's Community Shield arretee apres 2020),
-- Japon F (aucune equivalence femme).
--
-- Chaque super coupe recoit 2 regles de qualification (OR, meme
-- mecanisme que FIFA Women Champions Cup) : etre champion du
-- championnat national OU avoir gagne la coupe nationale la saison
-- precedente. Applique aussi retroactivement aux 2 super coupes
-- espagnoles deja en base (jusqu'ici affichees sans condition).
--
-- Reecrit le 2026-08-30 : la premiere version utilisait la syntaxe
-- "VALUES ROW(...)" (constructeur de lignes), qui necessite MySQL
-- 8.0.19+ et a echoue en prod (hebergeur sur une version plus ancienne
-- ou MariaDB). Remplace par du UNION ALL SELECT, portable partout.
-- Les INSERT INTO competition sont aussi rendus rejouables sans
-- doublon (WHERE NOT EXISTS) au cas ou la version precedente aurait
-- deja partiellement reussi.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- ---------------------------------------------------------------------
-- Nouvelles competitions (rejouable sans creer de doublon)
-- ---------------------------------------------------------------------
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`)
SELECT * FROM (
    SELECT 'Trophée des Champions' AS n, 'Ligue' AS t, 5 AS p, 'M' AS g
    UNION ALL SELECT 'DFL-Supercup', 'Ligue', 3, 'M'
    UNION ALL SELECT 'Supercoppa Italiana', 'Ligue', 4, 'M'
    UNION ALL SELECT 'Community Shield', 'Ligue', 1, 'M'
    UNION ALL SELECT 'Belgian Super Cup', 'Ligue', 11, 'M'
    UNION ALL SELECT 'Johan Cruyff Shield', 'Ligue', 13, 'M'
    UNION ALL SELECT 'Supertaça de Portugal', 'Ligue', 14, 'M'
    UNION ALL SELECT 'Supercopa do Brasil', 'Ligue', 12, 'M'
    UNION ALL SELECT 'Turkish Super Cup', 'Ligue', 15, 'M'
    UNION ALL SELECT 'Japanese Super Cup', 'Ligue', 7, 'M'
    UNION ALL SELECT 'Svenska Supercupen', 'Ligue', 9, 'M'
    UNION ALL SELECT 'President of Ireland''s Cup', 'Ligue', 19, 'M'
    UNION ALL SELECT 'NIFL Charity Shield', 'Ligue', 18, 'M'
    UNION ALL SELECT 'Trophée des Championnes', 'Ligue', 5, 'F'
    UNION ALL SELECT 'DFB-Supercup Frauen', 'Ligue', 3, 'F'
    UNION ALL SELECT 'Supercoppa Italiana Femminile', 'Ligue', 4, 'F'
    UNION ALL SELECT 'Svenska Supercupen Damer', 'Ligue', 9, 'F'
) AS nouvelles
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` c
    WHERE c.nomCompetition = nouvelles.n AND c.idPays = nouvelles.p AND c.genre = nouvelles.g
);

-- ---------------------------------------------------------------------
-- Regles de qualification (OR : champion du championnat, ou vainqueur
-- de la coupe nationale). Resolution par sous-requete nomCompetition +
-- idPays + genre pour rester valable quels que soient les
-- AUTO_INCREMENT reels en prod. Chaque INSERT...SELECT est rejouable
-- sans doublon (WHERE NOT EXISTS).
-- ---------------------------------------------------------------------
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`)
SELECT sc.idCompetition, champ.idCompetition, 1, 1
FROM (
    SELECT 'Trophée des Champions' AS sc_nom, 5 AS sc_pays, 'M' AS sc_genre, 'Ligue 1' AS champ_nom, 5 AS champ_pays, 'M' AS champ_genre
    UNION ALL SELECT 'DFL-Supercup', 3, 'M', 'Bundesliga', 3, 'M'
    UNION ALL SELECT 'Supercoppa Italiana', 4, 'M', 'Serie A', 4, 'M'
    UNION ALL SELECT 'Community Shield', 1, 'M', 'Premier League', 1, 'M'
    UNION ALL SELECT 'Belgian Super Cup', 11, 'M', 'Pro League', 11, 'M'
    UNION ALL SELECT 'Johan Cruyff Shield', 13, 'M', 'Eredivisie', 13, 'M'
    UNION ALL SELECT 'Supertaça de Portugal', 14, 'M', 'Primeira Liga', 14, 'M'
    UNION ALL SELECT 'Supercopa do Brasil', 12, 'M', 'Campeonato Brasileiro Série A', 12, 'M'
    UNION ALL SELECT 'Turkish Super Cup', 15, 'M', 'Süper Lig', 15, 'M'
    UNION ALL SELECT 'Japanese Super Cup', 7, 'M', 'J1 League', 7, 'M'
    UNION ALL SELECT 'Svenska Supercupen', 9, 'M', 'Allsvenskan', 9, 'M'
    UNION ALL SELECT 'President of Ireland''s Cup', 19, 'M', 'League of Ireland Premier Division', 19, 'M'
    UNION ALL SELECT 'NIFL Charity Shield', 18, 'M', 'NIFL Premiership', 18, 'M'
    UNION ALL SELECT 'Trophée des Championnes', 5, 'F', 'Première Ligue', 5, 'F'
    UNION ALL SELECT 'DFB-Supercup Frauen', 3, 'F', 'Frauen-Bundesliga', 3, 'F'
    UNION ALL SELECT 'Supercoppa Italiana Femminile', 4, 'F', 'Serie A Femminile', 4, 'F'
    UNION ALL SELECT 'Svenska Supercupen Damer', 9, 'F', 'Damallsvenskan', 9, 'F'
    UNION ALL SELECT 'Supercoupe d Espagne', 2, 'M', 'LaLiga', 2, 'M'
    UNION ALL SELECT 'Supercoupe d Espagne Feminine', 2, 'F', 'Liga F', 2, 'F'
) AS m
JOIN `competition` sc ON sc.nomCompetition = m.sc_nom AND sc.idPays = m.sc_pays AND sc.genre = m.sc_genre
JOIN `competition` champ ON champ.nomCompetition = m.champ_nom AND champ.idPays = m.champ_pays AND champ.genre = m.champ_genre AND champ.typeCompetition = 'Championnat'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = sc.idCompetition AND r.idCompetitionSource = champ.idCompetition AND r.rang_min = 1
);

INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `resultat_exact`)
SELECT sc.idCompetition, cup.idCompetition, 'Gagner'
FROM (
    SELECT 'Trophée des Champions' AS sc_nom, 5 AS sc_pays, 'M' AS sc_genre, 'Coupe de France' AS cup_nom, 5 AS cup_pays, 'M' AS cup_genre
    UNION ALL SELECT 'DFL-Supercup', 3, 'M', 'DFB-Pokal', 3, 'M'
    UNION ALL SELECT 'Supercoppa Italiana', 4, 'M', 'Coppa Italia', 4, 'M'
    UNION ALL SELECT 'Community Shield', 1, 'M', 'FA Cup', 1, 'M'
    UNION ALL SELECT 'Belgian Super Cup', 11, 'M', 'Belgian Cup', 11, 'M'
    UNION ALL SELECT 'Johan Cruyff Shield', 13, 'M', 'KNVB Cup', 13, 'M'
    UNION ALL SELECT 'Supertaça de Portugal', 14, 'M', 'Taça de Portugal', 14, 'M'
    UNION ALL SELECT 'Supercopa do Brasil', 12, 'M', 'Copa do Brasil', 12, 'M'
    UNION ALL SELECT 'Turkish Super Cup', 15, 'M', 'Türkiye Kupası', 15, 'M'
    UNION ALL SELECT 'Japanese Super Cup', 7, 'M', 'Emperor''s Cup', 7, 'M'
    UNION ALL SELECT 'Svenska Supercupen', 9, 'M', 'Svenska Cupen', 9, 'M'
    UNION ALL SELECT 'President of Ireland''s Cup', 19, 'M', 'FAI Cup', 19, 'M'
    UNION ALL SELECT 'NIFL Charity Shield', 18, 'M', 'Irish Cup', 18, 'M'
    UNION ALL SELECT 'Trophée des Championnes', 5, 'F', 'Coupe de France Féminine', 5, 'F'
    UNION ALL SELECT 'DFB-Supercup Frauen', 3, 'F', 'DFB-Pokal Frauen', 3, 'F'
    UNION ALL SELECT 'Supercoppa Italiana Femminile', 4, 'F', 'Coppa Italia Femminile', 4, 'F'
    UNION ALL SELECT 'Svenska Supercupen Damer', 9, 'F', 'Svenska Cupen Damer', 9, 'F'
    UNION ALL SELECT 'Supercoupe d Espagne', 2, 'M', 'Copa del Rey', 2, 'M'
    UNION ALL SELECT 'Supercoupe d Espagne Feminine', 2, 'F', 'Copa de la Reina', 2, 'F'
) AS m
JOIN `competition` sc ON sc.nomCompetition = m.sc_nom AND sc.idPays = m.sc_pays AND sc.genre = m.sc_genre
JOIN `competition` cup ON cup.nomCompetition = m.cup_nom AND cup.idPays = m.cup_pays AND cup.genre = m.cup_genre AND cup.typeCompetition = 'Nationale'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = sc.idCompetition AND r.idCompetitionSource = cup.idCompetition AND r.resultat_exact = 'Gagner'
);

