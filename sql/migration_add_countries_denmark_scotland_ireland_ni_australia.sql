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
