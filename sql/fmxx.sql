-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 19 juin 2026 à 15:50
-- Version du serveur : 8.4.7
-- Version de PHP : 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `fmxx`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `CheckUserExists`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckUserExists` (IN `p_username` VARCHAR(100), IN `p_mail` VARCHAR(255), OUT `p_username_taken` TINYINT(1), OUT `p_mail_taken` TINYINT(1))   BEGIN
    SELECT COUNT(*) INTO p_username_taken
    FROM user
    WHERE username = p_username;

    SELECT COUNT(*) INTO p_mail_taken
    FROM user
    WHERE mail = p_mail;
END$$

DROP PROCEDURE IF EXISTS `DeleteUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser` (IN `p_idUser` INT)   BEGIN
    DELETE FROM mercato_arrivee WHERE idUser = p_idUser;
    DELETE FROM tactic        WHERE idUser = p_idUser;
    DELETE FROM objectif      WHERE idUser = p_idUser;
    DELETE FROM saison_meta   WHERE idUser = p_idUser;
    DELETE FROM joueur        WHERE idUser = p_idUser;
    DELETE FROM user          WHERE idUser = p_idUser;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `competition`
--

DROP TABLE IF EXISTS `competition`;
CREATE TABLE IF NOT EXISTS `competition` (
  `idCompetition` int NOT NULL AUTO_INCREMENT,
  `nomCompetition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `typeCompetition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idPays` int DEFAULT NULL,
  `division` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `genre` enum('M','F') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'M',
  `qualif_rang_min` tinyint DEFAULT NULL,
  `qualif_rang_max` tinyint DEFAULT NULL,
  PRIMARY KEY (`idCompetition`),
  KEY `idPays` (`idPays`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `competition`
--

INSERT INTO `competition` (`idCompetition`, `nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`, `qualif_rang_min`, `qualif_rang_max`) VALUES
(1, 'UEFA Champions League', 'Continentale', NULL, NULL, 'M', 1, 1),
(2, 'UEFA Europa League', 'Continentale', NULL, NULL, 'M', 2, 3),
(3, 'UEFA Europa Conference League', 'Continentale', NULL, NULL, 'M', 4, 5),
(4, 'Carabo Cup', 'Ligue', 1, 'D1', 'M', NULL, NULL),
(29, 'Supercoupe d Espagne', 'Ligue', 2, 'D1', 'M', NULL, NULL),
(9, 'Premier League', 'Championnat', 1, 'D1', 'M', NULL, NULL),
(10, 'EFL Championship', 'Championnat', 1, 'D2', 'M', NULL, NULL),
(11, 'EFL League One', 'Championnat', 1, 'D3', 'M', NULL, NULL),
(12, 'LaLiga EA Sports FC', 'Championnat', 2, 'D1', 'M', NULL, NULL),
(13, 'LaLiga HyperMotion', 'Championnat', 2, 'D2', 'M', NULL, NULL),
(14, 'Primera Federación', 'Championnat', 2, 'D3', 'M', NULL, NULL),
(15, 'Bundesliga', 'Championnat', 3, 'D1', 'M', NULL, NULL),
(16, '2. Bundesliga', 'Championnat', 3, 'D2', 'M', NULL, NULL),
(17, '3. Liga', 'Championnat', 3, 'D3', 'M', NULL, NULL),
(18, 'Serie A', 'Championnat', 4, 'D1', 'M', NULL, NULL),
(19, 'Serie BKT', 'Championnat', 4, 'D2', 'M', NULL, NULL),
(20, 'Serie C', 'Championnat', 4, 'D3', 'M', NULL, NULL),
(21, 'Ligue 1', 'Championnat', 5, 'D1', 'M', NULL, NULL),
(22, 'Ligue 2', 'Championnat', 5, 'D2', 'M', NULL, NULL),
(23, 'National', 'Championnat', 5, 'D3', 'M', NULL, NULL),
(24, 'FA Cup', 'Nationale', 1, NULL, 'M', NULL, NULL),
(25, 'Copa del Rey', 'Nationale', 2, NULL, 'M', NULL, NULL),
(26, 'DFB-Pokal', 'Nationale', 3, NULL, 'M', NULL, NULL),
(27, 'Coppa Italia', 'Nationale', 4, NULL, 'M', NULL, NULL),
(28, 'Coupe de France', 'Nationale', 5, NULL, 'M', NULL, NULL),
(30, 'UEFA Women s Champions League', 'Continentale', NULL, NULL, 'F', 1, 1),
(31, 'Women s Super League', 'Championnat', 1, 'D1', 'F', NULL, NULL),
(32, 'Women s Championship', 'Championnat', 1, 'D2', 'F', NULL, NULL),
(33, 'FA Women s Cup', 'Nationale', 1, NULL, 'F', NULL, NULL),
(34, 'Division 1 Arkema', 'Championnat', 5, 'D1', 'F', NULL, NULL),
(35, 'D2 Féminine', 'Championnat', 5, 'D2', 'F', NULL, NULL),
(36, 'Coupe de France Féminine', 'Nationale', 5, NULL, 'F', NULL, NULL),
(37, 'Frauen-Bundesliga', 'Championnat', 3, 'D1', 'F', NULL, NULL),
(38, '2. Frauen-Bundesliga', 'Championnat', 3, 'D2', 'F', NULL, NULL),
(39, 'DFB-Pokal Frauen', 'Nationale', 3, NULL, 'F', NULL, NULL),
(40, 'Liga F', 'Championnat', 2, 'D1', 'F', NULL, NULL),
(41, 'Primera División Femenina', 'Championnat', 2, 'D2', 'F', NULL, NULL),
(42, 'Copa de la Reina', 'Nationale', 2, NULL, 'F', NULL, NULL),
(43, 'Serie A Femminile', 'Championnat', 4, 'D1', 'F', NULL, NULL),
(44, 'Serie B Femminile', 'Championnat', 4, 'D2', 'F', NULL, NULL),
(45, 'Coppa Italia Femminile', 'Nationale', 4, NULL, 'F', NULL, NULL),
(46, 'UEFA Women s Europa Cup', 'Continentale', NULL, NULL, 'F', 2, 20),
(47, 'Supercoupe d Espagne Feminine', 'Ligue', 2, 'D1', 'F', NULL, NULL);

--
-- Déclencheurs `competition`
--
DROP TRIGGER IF EXISTS `before_insert_competition`;
DELIMITER $$
CREATE TRIGGER `before_insert_competition` BEFORE INSERT ON `competition` FOR EACH ROW BEGIN
  DECLARE competition_exists INT;
  
  -- Vérifier si une compétition avec le même nom, type et pays existe déjà
  SELECT COUNT(*)
  INTO competition_exists
  FROM competition
  WHERE nomCompetition = NEW.nomCompetition
    AND typeCompetition = NEW.typeCompetition
    AND IFNULL(idPays, -1) = IFNULL(NEW.idPays, -1);
  
  -- Si une compétition existe déjà, alors signaler une erreur
  IF competition_exists > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Une compétition similaire existe déjà.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `equipe`
--

DROP TABLE IF EXISTS `equipe`;
CREATE TABLE IF NOT EXISTS `equipe` (
  `idEquipe` int NOT NULL AUTO_INCREMENT,
  `nomEquipe` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idPays` int DEFAULT NULL,
  `genre` enum('M','F') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'M',
  `division` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idEquipe`),
  KEY `idPays` (`idPays`)
) ENGINE=MyISAM AUTO_INCREMENT=758 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `equipe`
--

INSERT INTO `equipe` (`idEquipe`, `nomEquipe`, `idPays`, `genre`, `division`) VALUES
(1, '1899 Hoffenheim W', 3, 'F', 'D1'),
(2, 'Bayer Leverkusen W', 3, 'F', 'D1'),
(3, 'Bayern Munich W', 3, 'F', 'D1'),
(4, 'VfL Wolfsburg W', 3, 'F', 'D1'),
(5, 'SC Freiburg W', 3, 'F', 'D1'),
(6, 'SGS Essen W', 3, 'F', 'D1'),
(7, '1. FC Nürnberg', 3, 'F', 'D1'),
(8, 'Werder Bremen W', 3, 'F', 'D1'),
(9, 'FC Koln W', 3, 'F', 'D1'),
(10, 'Eintracht Frankfurt W', 3, 'F', 'D1'),
(11, 'Carl Zeiss Jena  W', 3, 'F', 'D1'),
(12, 'RB Leipzig W', 3, 'F', 'D1'),
(13, 'Liverpool W', 1, 'F', 'D1'),
(14, 'Arsenal W', 1, 'F', 'D1'),
(15, 'Chelsea W', 1, 'F', 'D1'),
(16, 'Manchester City W', 1, 'F', 'D1'),
(17, 'Everton W', 1, 'F', 'D1'),
(18, 'West Ham W', 1, 'F', 'D1'),
(19, 'Brighton W', 1, 'F', 'D1'),
(20, 'Manchester United W', 1, 'F', 'D1'),
(21, 'Tottenham Hotspur W', 1, 'F', 'D1'),
(22, 'Aston Villa W', 1, 'F', 'D1'),
(23, 'Leicester City FC W', 1, 'F', 'D1'),
(24, 'Crystal Palace W', 1, 'F', 'D1'),
(25, 'Birmingham City W', 1, 'F', 'D2'),
(26, 'Bristol City W', 1, 'F', 'D2'),
(27, 'Sunderland W', 1, 'F', 'D2'),
(28, 'Blackburn Rovers W', 1, 'F', 'D2'),
(29, 'Charlton Athletic W', 1, 'F', 'D2'),
(30, 'Durham W', 1, 'F', 'D2'),
(31, 'London City Lionesses W', 1, 'F', 'D2'),
(32, 'Sheffield United W', 1, 'F', 'D2'),
(33, 'Portsmouth W', 1, 'F', 'D2'),
(34, 'Southampton W', 1, 'F', 'D2'),
(35, 'Newcastle United W', 1, 'F', 'D2'),
(36, 'Athletic Club W', 2, 'F', 'D1'),
(37, 'Real Betis W', 2, 'F', 'D1'),
(38, 'Valencia W', 2, 'F', 'D1'),
(39, 'Atletico Madrid W', 2, 'F', 'D1'),
(40, 'Levante W', 2, 'F', 'D1'),
(41, 'Real Sociedad W', 2, 'F', 'D1'),
(42, 'Granad. Tenerife W', 2, 'F', 'D1'),
(43, 'Barcelona W', 2, 'F', 'D1'),
(44, 'Espanyol W', 2, 'F', 'D1'),
(45, 'Sevilla W', 2, 'F', 'D1'),
(46, 'Madrid CFF W', 2, 'F', 'D1'),
(47, 'Deportivo de La Coruña W', 2, 'F', 'D1'),
(48, 'Real Madrid W', 2, 'F', 'D1'),
(49, 'Eibar W', 2, 'F', 'D1'),
(50, 'FC Levante Badalona', 2, 'F', 'D1'),
(51, 'Granada', 2, 'F', 'D1'),
(52, 'Chicago Red Stars W', 6, 'F', 'D1'),
(53, 'Houston Dash W', 6, 'F', 'D1'),
(54, 'North Carolina Courage W', 6, 'F', 'D1'),
(55, 'Orlando Pride W', 6, 'F', 'D1'),
(56, 'Portland Thorns W', 6, 'F', 'D1'),
(57, 'Seattle Reign FC W', 6, 'F', 'D1'),
(58, 'NJ/NY Gotham FC W', 6, 'F', 'D1'),
(59, 'Utah Royals W', 6, 'F', 'D1'),
(60, 'Washington Spirit W', 6, 'F', 'D1'),
(61, 'Kansas City W', 6, 'F', 'D1'),
(62, 'Racing Louisville W', 6, 'F', 'D1'),
(63, 'Angel City W', 6, 'F', 'D1'),
(64, 'San Diego Wave W', 6, 'F', 'D1'),
(65, 'Bay FC W', 6, 'F', 'D1'),
(66, 'Paris Saint Germain W', 5, 'F', 'D1'),
(67, 'Guingamp W', 5, 'F', 'D1'),
(68, 'Lyon W', 5, 'F', 'D1'),
(69, 'Montpellier W', 5, 'F', 'D1'),
(70, 'Paris FC W', 5, 'F', 'D1'),
(71, 'FC Fleury 91 W', 5, 'F', 'D1'),
(72, 'Dijon W', 5, 'F', 'D1'),
(73, 'Stade de Reims W', 5, 'F', 'D1'),
(74, 'Le Havre W', 5, 'F', 'D1'),
(75, 'Saint-Étienne W', 5, 'F', 'D1'),
(76, 'Nantes W', 5, 'F', 'D1'),
(77, 'Strasbourg W', 5, 'F', 'D1'),
(78, 'Fiorentina W', 4, 'F', 'D1'),
(79, 'Juventus W', 4, 'F', 'D1'),
(80, 'Sassuolo W', 4, 'F', 'D1'),
(81, 'Roma W', 4, 'F', 'D1'),
(82, 'AC Milan W', 4, 'F', 'D1'),
(83, 'Inter Milano W', 4, 'F', 'D1'),
(84, 'Napoli W', 4, 'F', 'D1'),
(85, 'Lazio W', 4, 'F', 'D1'),
(86, 'Sampdoria W', 4, 'F', 'D1'),
(87, 'Como W', 4, 'F', 'D1'),
(88, 'Elfen Saitama W', 7, 'F', 'D1'),
(89, 'INAC Kobe Leonessa W', 7, 'F', 'D1'),
(90, 'JEF United W', 7, 'F', 'D1'),
(91, 'Nojima Stella W', 7, 'F', 'D1'),
(92, 'Omiya Ardija Ventus W', 7, 'F', 'D1'),
(93, 'Tokyo Verdy Beleza W', 7, 'F', 'D1'),
(94, 'Urawa Reds W', 7, 'F', 'D1'),
(95, 'Albirex Niigata W', 7, 'F', 'D1'),
(96, 'Parceiro Nagano W', 7, 'F', 'D1'),
(97, 'Sanfrecce Hiroshima W', 7, 'F', 'D1'),
(98, 'Vegalta Sendai W', 7, 'F', 'D1'),
(99, 'Cerezo Osaka W', 7, 'F', 'D1'),
(100, 'Piteå W', 9, 'F', 'D1'),
(101, 'Rosengård W', 9, 'F', 'D1'),
(102, 'Djurgården W', 9, 'F', 'D1'),
(103, 'KIF Örebro W', 9, 'F', 'D1'),
(104, 'Kristianstad W', 9, 'F', 'D1'),
(105, 'Linköping W', 9, 'F', 'D1'),
(106, 'Umeå W', 9, 'F', 'D1'),
(107, 'Vittsjö W', 9, 'F', 'D1'),
(108, 'Växjö W', 9, 'F', 'D1'),
(109, 'AIK W', 9, 'F', 'D1'),
(110, 'Hammarby W', 9, 'F', 'D1'),
(111, 'Brommapojkarna W', 9, 'F', 'D1'),
(112, 'Norrköping W', 9, 'F', 'D1'),
(113, 'Häcken W', 9, 'F', 'D1'),
(114, 'Trelleborg W', 9, 'F', 'D1'),
(115, 'Eskilstuna United W', 9, 'F', 'D2'),
(116, 'Umeå W', 9, 'F', 'D2'),
(117, 'Uppsala W', 9, 'F', 'D2'),
(118, 'Alingsås W', 9, 'F', 'D2'),
(119, 'Bollstanäs W', 9, 'F', 'D2'),
(120, 'Jitex W', 9, 'F', 'D2'),
(121, 'Kalmar W', 9, 'F', 'D2'),
(122, 'Mallbacken W', 9, 'F', 'D2'),
(123, 'Sundsvall W', 9, 'F', 'D2'),
(124, 'Lidköping W', 9, 'F', 'D2'),
(125, 'Örebro SK W', 9, 'F', 'D2'),
(126, 'Gamla Upsala W', 9, 'F', 'D2'),
(127, 'Sunnanå W', 9, 'F', 'D2'),
(128, 'Malmö FF W', 9, 'F', 'D2'),
(129, 'Bayern München', 3, 'M', 'D1'),
(130, 'SC Freiburg', 3, 'M', 'D1'),
(131, 'VfL Wolfsburg', 3, 'M', 'D1'),
(132, 'Werder Bremen', 3, 'M', 'D1'),
(133, 'Borussia Mönchengladbach', 3, 'M', 'D1'),
(134, 'FSV Mainz 05', 3, 'M', 'D1'),
(135, 'Borussia Dortmund', 3, 'M', 'D1'),
(136, '1899 Hoffenheim', 3, 'M', 'D1'),
(137, 'Bayer Leverkusen', 3, 'M', 'D1'),
(138, 'Eintracht Frankfurt', 3, 'M', 'D1'),
(139, 'FC Augsburg', 3, 'M', 'D1'),
(140, 'VfB Stuttgart', 3, 'M', 'D1'),
(141, 'RB Leipzig', 3, 'M', 'D1'),
(142, 'VfL Bochum', 3, 'M', 'D1'),
(143, '1. FC Heidenheim', 3, 'M', 'D1'),
(144, 'Union Berlin', 3, 'M', 'D1'),
(145, 'FC St. Pauli', 3, 'M', 'D1'),
(146, 'Holstein Kiel', 3, 'M', 'D1'),
(147, 'SV Elversberg', 3, 'M', 'D1'),
(148, 'Fortuna Düsseldorf', 3, 'M', 'D2'),
(149, 'Hertha BSC', 3, 'M', 'D2'),
(150, 'Hannover 96', 3, 'M', 'D2'),
(151, '1. FC Nürnberg', 3, 'M', 'D2'),
(152, 'FC Schalke 04', 3, 'M', 'D2'),
(153, 'Hamburger SV', 3, 'M', 'D2'),
(154, 'SSV Jahn Regensburg', 3, 'M', 'D2'),
(155, 'SpVgg Greuther Fürth', 3, 'M', 'D2'),
(156, '1. FC Magdeburg', 3, 'M', 'D2'),
(157, 'SV Darmstadt 98', 3, 'M', 'D2'),
(158, 'SC Paderborn 07', 3, 'M', 'D2'),
(159, '1. FC Köln', 3, 'M', 'D2'),
(160, 'Eintracht Braunschweig', 3, 'M', 'D2'),
(161, '1. FC Kaiserslautern', 3, 'M', 'D2'),
(162, 'Karlsruher SC', 3, 'M', 'D2'),
(163, 'Preußen Münster', 3, 'M', 'D2'),
(164, 'FC Saarbrücken', 3, 'M', 'D2'),
(165, 'SSV Ulm 1846', 3, 'M', 'D2'),
(166, 'SV Elversberg', 3, 'M', 'D2'),
(167, 'Manchester United', 1, 'M', 'D1'),
(168, 'Newcastle', 1, 'M', 'D1'),
(169, 'Bournemouth', 1, 'M', 'D1'),
(170, 'Fulham', 1, 'M', 'D1'),
(171, 'Wolves', 1, 'M', 'D1'),
(172, 'Liverpool', 1, 'M', 'D1'),
(173, 'Southampton', 1, 'M', 'D1'),
(174, 'Arsenal', 1, 'M', 'D1'),
(175, 'Everton', 1, 'M', 'D1'),
(176, 'Leicester', 1, 'M', 'D1'),
(177, 'Tottenham', 1, 'M', 'D1'),
(178, 'West Ham', 1, 'M', 'D1'),
(179, 'Chelsea', 1, 'M', 'D1'),
(180, 'Manchester City', 1, 'M', 'D1'),
(181, 'Brighton', 1, 'M', 'D1'),
(182, 'Crystal Palace', 1, 'M', 'D1'),
(183, 'Brentford', 1, 'M', 'D1'),
(184, 'Ipswich', 1, 'M', 'D1'),
(185, 'Nottingham Forest', 1, 'M', 'D1'),
(186, 'Aston Villa', 1, 'M', 'D1'),
(187, 'Watford', 1, 'M', 'D2'),
(188, 'Cardiff', 1, 'M', 'D2'),
(189, 'Burnley', 1, 'M', 'D2'),
(190, 'Bristol City', 1, 'M', 'D2'),
(191, 'Millwall', 1, 'M', 'D2'),
(192, 'Preston', 1, 'M', 'D2'),
(193, 'West Brom', 1, 'M', 'D2'),
(194, 'Sheffield Utd', 1, 'M', 'D2'),
(195, 'Leeds', 1, 'M', 'D2'),
(196, 'Hull City', 1, 'M', 'D2'),
(197, 'Blackburn', 1, 'M', 'D2'),
(198, 'Derby', 1, 'M', 'D2'),
(199, 'Middlesbrough', 1, 'M', 'D2'),
(200, 'Norwich', 1, 'M', 'D2'),
(201, 'QPR', 1, 'M', 'D2'),
(202, 'Sheffield Wednesday', 1, 'M', 'D2'),
(203, 'Stoke City', 1, 'M', 'D2'),
(204, 'Swansea', 1, 'M', 'D2'),
(205, 'Sunderland', 1, 'M', 'D2'),
(206, 'Oxford United', 1, 'M', 'D2'),
(207, 'Coventry', 1, 'M', 'D2'),
(208, 'Portsmouth', 1, 'M', 'D2'),
(209, 'Plymouth', 1, 'M', 'D2'),
(210, 'Luton', 1, 'M', 'D2'),
(211, 'Huddersfield', 1, 'M', 'D3'),
(212, 'Reading', 1, 'M', 'D3'),
(213, 'Birmingham', 1, 'M', 'D3'),
(214, 'Wigan', 1, 'M', 'D3'),
(215, 'Bolton', 1, 'M', 'D3'),
(216, 'Rotherham', 1, 'M', 'D3'),
(217, 'Barnsley', 1, 'M', 'D3'),
(218, 'Burton Albion', 1, 'M', 'D3'),
(219, 'Bristol Rovers', 1, 'M', 'D3'),
(220, 'Charlton', 1, 'M', 'D3'),
(221, 'Northampton', 1, 'M', 'D3'),
(222, 'Peterborough', 1, 'M', 'D3'),
(223, 'Shrewsbury', 1, 'M', 'D3'),
(224, 'Blackpool', 1, 'M', 'D3'),
(225, 'Wycombe', 1, 'M', 'D3'),
(226, 'Crawley Town', 1, 'M', 'D3'),
(227, 'Exeter City', 1, 'M', 'D3'),
(228, 'Stevenage', 1, 'M', 'D3'),
(229, 'Cambridge United', 1, 'M', 'D3'),
(230, 'Leyton Orient', 1, 'M', 'D3'),
(231, 'Mansfield Town', 1, 'M', 'D3'),
(232, 'Lincoln', 1, 'M', 'D3'),
(233, 'Wrexham', 1, 'M', 'D3'),
(234, 'Stockport County', 1, 'M', 'D3'),
(235, 'Red Bull Salzburg', 10, 'M', 'D1'),
(236, 'Austria Vienna', 10, 'M', 'D1'),
(237, 'SCR Altach', 10, 'M', 'D1'),
(238, 'Sturm Graz', 10, 'M', 'D1'),
(239, 'Rapid Vienna', 10, 'M', 'D1'),
(240, 'Wolfsberger AC', 10, 'M', 'D1'),
(241, 'Lask Linz', 10, 'M', 'D1'),
(242, 'TSV Hartberg', 10, 'M', 'D1'),
(243, 'FC BW Linz', 10, 'M', 'D1'),
(244, 'WSG Wattens', 10, 'M', 'D1'),
(245, 'Austria Klagenfurt', 10, 'M', 'D1'),
(246, 'Grazer AK', 10, 'M', 'D1'),
(247, 'OH Leuven', 11, 'M', 'D1'),
(248, 'KVC Westerlo', 11, 'M', 'D1'),
(249, 'Beerschot VA', 11, 'M', 'D1'),
(250, 'KV Mechelen', 11, 'M', 'D1'),
(251, 'Anderlecht', 11, 'M', 'D1'),
(252, 'Club Brugge KV', 11, 'M', 'D1'),
(253, 'Gent', 11, 'M', 'D1'),
(254, 'Standard Liege', 11, 'M', 'D1'),
(255, 'Kortrijk', 11, 'M', 'D1'),
(256, 'St. Truiden', 11, 'M', 'D1'),
(257, 'Charleroi', 11, 'M', 'D1'),
(258, 'Antwerp', 11, 'M', 'D1'),
(259, 'Cercle Brugge', 11, 'M', 'D1'),
(260, 'Genk', 11, 'M', 'D1'),
(261, 'Union St. Gilloise', 11, 'M', 'D1'),
(262, 'Dender', 11, 'M', 'D1'),
(263, 'Patro Eisden', 11, 'M', 'D1'),
(264, 'Lommel United', 11, 'M', 'D2'),
(265, 'Zulte Waregem', 11, 'M', 'D2'),
(266, 'SK Beveren', 11, 'M', 'D2'),
(267, 'AS Eupen', 11, 'M', 'D2'),
(268, 'Francs Borains', 11, 'M', 'D2'),
(269, 'RAAL La Louvière', 11, 'M', 'D2'),
(270, 'Deinze', 11, 'M', 'D2'),
(271, 'K. Lierse S.K.', 11, 'M', 'D2'),
(272, 'Liège', 11, 'M', 'D2'),
(273, 'Patro Eisden', 11, 'M', 'D2'),
(274, 'RWDM', 11, 'M', 'D2'),
(275, 'Seraing United', 11, 'M', 'D2'),
(276, 'Lokeren-Temse', 11, 'M', 'D2'),
(277, 'Club Brugge II', 11, 'M', 'D2'),
(278, 'KRC Genk II', 11, 'M', 'D2'),
(279, 'RSC Anderlecht II', 11, 'M', 'D2'),
(280, 'Bahia', 12, 'M', 'D1'),
(281, 'Internacional', 12, 'M', 'D1'),
(282, 'Botafogo', 12, 'M', 'D1'),
(283, 'Palmeiras', 12, 'M', 'D1'),
(284, 'Fluminense', 12, 'M', 'D1'),
(285, 'Sao Paulo', 12, 'M', 'D1'),
(286, 'Flamengo', 12, 'M', 'D1'),
(287, 'Gremio', 12, 'M', 'D1'),
(288, 'Corinthians', 12, 'M', 'D1'),
(289, 'Vasco DA Gama', 12, 'M', 'D1'),
(290, 'Atletico Paranaense', 12, 'M', 'D1'),
(291, 'Cruzeiro', 12, 'M', 'D1'),
(292, 'Vitoria', 12, 'M', 'D1'),
(293, 'Criciuma', 12, 'M', 'D1'),
(294, 'Atletico Goianiense', 12, 'M', 'D1'),
(295, 'Juventude', 12, 'M', 'D1'),
(296, 'Fortaleza EC', 12, 'M', 'D1'),
(297, 'RB Bragantino', 12, 'M', 'D1'),
(298, 'Atletico-MG', 12, 'M', 'D1'),
(299, 'Cuiaba', 12, 'M', 'D1'),
(300, 'Sport Recife', 12, 'M', 'D2'),
(301, 'America Mineiro', 12, 'M', 'D2'),
(302, 'Santos', 12, 'M', 'D2'),
(303, 'Ceara', 12, 'M', 'D2'),
(304, 'Chapecoense-sc', 12, 'M', 'D2'),
(305, 'Guarani Campinas', 12, 'M', 'D2'),
(306, 'Ponte Preta', 12, 'M', 'D2'),
(307, 'Vila Nova', 12, 'M', 'D2'),
(308, 'Avai', 12, 'M', 'D2'),
(309, 'CRB', 12, 'M', 'D2'),
(310, 'Coritiba', 12, 'M', 'D2'),
(311, 'Paysandu', 12, 'M', 'D2'),
(312, 'Goias', 12, 'M', 'D2'),
(313, 'Brusque', 12, 'M', 'D2'),
(314, 'Operario-PR', 12, 'M', 'D2'),
(315, 'Botafogo SP', 12, 'M', 'D2'),
(316, 'Ituano', 12, 'M', 'D2'),
(317, 'Novorizontino', 12, 'M', 'D2'),
(318, 'Mirassol', 12, 'M', 'D2'),
(319, 'Amazonas', 12, 'M', 'D2'),
(320, 'Barcelona', 2, 'M', 'D1'),
(321, 'Atletico Madrid', 2, 'M', 'D1'),
(322, 'Athletic Club', 2, 'M', 'D1'),
(323, 'Valencia', 2, 'M', 'D1'),
(324, 'Villarreal', 2, 'M', 'D1'),
(325, 'Las Palmas', 2, 'M', 'D1'),
(326, 'Sevilla', 2, 'M', 'D1'),
(327, 'Leganes', 2, 'M', 'D1'),
(328, 'Celta Vigo', 2, 'M', 'D1'),
(329, 'Espanyol', 2, 'M', 'D1'),
(330, 'Real Madrid', 2, 'M', 'D1'),
(331, 'Alaves', 2, 'M', 'D1'),
(332, 'Real Betis', 2, 'M', 'D1'),
(333, 'Getafe', 2, 'M', 'D1'),
(334, 'Girona', 2, 'M', 'D1'),
(335, 'Real Sociedad', 2, 'M', 'D1'),
(336, 'Valladolid', 2, 'M', 'D1'),
(337, 'Osasuna', 2, 'M', 'D1'),
(338, 'Rayo Vallecano', 2, 'M', 'D1'),
(339, 'Mallorca', 2, 'M', 'D1'),
(340, 'Malaga', 2, 'M', 'D2'),
(341, 'Levante', 2, 'M', 'D2'),
(342, 'Deportivo La Coruna', 2, 'M', 'D2'),
(343, 'Eibar', 2, 'M', 'D2'),
(344, 'Cordoba', 2, 'M', 'D2'),
(345, 'Granada CF', 2, 'M', 'D2'),
(346, 'Oviedo', 2, 'M', 'D2'),
(347, 'Tenerife', 2, 'M', 'D2'),
(348, 'Albacete', 2, 'M', 'D2'),
(349, 'Almeria', 2, 'M', 'D2'),
(350, 'Cadiz', 2, 'M', 'D2'),
(351, 'Huesca', 2, 'M', 'D2'),
(352, 'Sporting Gijon', 2, 'M', 'D2'),
(353, 'Zaragoza', 2, 'M', 'D2'),
(354, 'Elche', 2, 'M', 'D2'),
(355, 'Mirandes', 2, 'M', 'D2'),
(356, 'Racing Santander', 2, 'M', 'D2'),
(357, 'Castellón', 2, 'M', 'D2'),
(358, 'FC Cartagena', 2, 'M', 'D2'),
(359, 'Racing Ferrol', 2, 'M', 'D2'),
(360, 'Burgos', 2, 'M', 'D2'),
(361, 'Eldense', 2, 'M', 'D2'),
(362, 'Seattle Sounders', 6, 'M', 'D1'),
(363, 'San Jose Earthquakes', 6, 'M', 'D1'),
(364, 'FC Dallas', 6, 'M', 'D1'),
(365, 'Orlando City SC', 6, 'M', 'D1'),
(366, 'Philadelphia Union', 6, 'M', 'D1'),
(367, 'Houston Dynamo', 6, 'M', 'D1'),
(368, 'Toronto FC', 6, 'M', 'D1'),
(369, 'New York Red Bulls', 6, 'M', 'D1'),
(370, 'Vancouver Whitecaps', 6, 'M', 'D1'),
(371, 'New York City FC', 6, 'M', 'D1'),
(372, 'Los Angeles Galaxy', 6, 'M', 'D1'),
(373, 'Real Salt Lake', 6, 'M', 'D1'),
(374, 'Chicago Fire', 6, 'M', 'D1'),
(375, 'Atlanta United FC', 6, 'M', 'D1'),
(376, 'New England Revolution', 6, 'M', 'D1'),
(377, 'Colorado Rapids', 6, 'M', 'D1'),
(378, 'Sporting Kansas City', 6, 'M', 'D1'),
(379, 'Minnesota United FC', 6, 'M', 'D1'),
(380, 'Columbus Crew', 6, 'M', 'D1'),
(381, 'CF Montreal', 6, 'M', 'D1'),
(382, 'DC United', 6, 'M', 'D1'),
(383, 'Los Angeles FC', 6, 'M', 'D1'),
(384, 'Portland Timbers', 6, 'M', 'D1'),
(385, 'FC Cincinnati', 6, 'M', 'D1'),
(386, 'Inter Miami', 6, 'M', 'D1'),
(387, 'Nashville SC', 6, 'M', 'D1'),
(388, 'Austin', 6, 'M', 'D1'),
(389, 'Charlotte', 6, 'M', 'D1'),
(390, 'St. Louis City', 6, 'M', 'D1'),
(391, 'Angers', 5, 'M', 'D1'),
(392, 'Lille', 5, 'M', 'D1'),
(393, 'Lyon', 5, 'M', 'D1'),
(394, 'Marseille', 5, 'M', 'D1'),
(395, 'Montpellier', 5, 'M', 'D1'),
(396, 'Nantes', 5, 'M', 'D1'),
(397, 'Nice', 5, 'M', 'D1'),
(398, 'Paris Saint Germain', 5, 'M', 'D1'),
(399, 'Monaco', 5, 'M', 'D1'),
(400, 'Reims', 5, 'M', 'D1'),
(401, 'Rennes', 5, 'M', 'D1'),
(402, 'Strasbourg', 5, 'M', 'D1'),
(403, 'Toulouse', 5, 'M', 'D1'),
(404, 'Stade Brestois 29', 5, 'M', 'D1'),
(405, 'Auxerre', 5, 'M', 'D1'),
(406, 'Le Havre', 5, 'M', 'D1'),
(407, 'Metz', 5, 'M', 'D1'),
(408, 'Lens', 5, 'M', 'D1'),
(409, 'Saint Etienne', 5, 'M', 'D1'),
(410, 'Amiens', 5, 'M', 'D2'),
(411, 'Caen', 5, 'M', 'D2'),
(412, 'Guingamp', 5, 'M', 'D2'),
(413, 'Lorient', 5, 'M', 'D2'),
(414, 'Ajaccio', 5, 'M', 'D2'),
(415, 'Clermont Foot', 5, 'M', 'D2'),
(416, 'Grenoble', 5, 'M', 'D2'),
(417, 'RED Star FC 93', 5, 'M', 'D2'),
(418, 'Estac Troyes', 5, 'M', 'D2'),
(419, 'Metz', 5, 'M', 'D2'),
(420, 'Paris FC', 5, 'M', 'D2'),
(421, 'Laval', 5, 'M', 'D2'),
(422, 'PAU', 5, 'M', 'D2'),
(423, 'Boulogne', 5, 'M', 'D2'),
(424, 'Rodez', 5, 'M', 'D2'),
(425, 'Dunkerque', 5, 'M', 'D2'),
(426, 'Bastia', 5, 'M', 'D2'),
(427, 'Annecy', 5, 'M', 'D2'),
(428, 'Martigues', 5, 'M', 'D2'),
(429, 'Dijon', 5, 'M', 'D3'),
(430, 'Nimes', 5, 'M', 'D3'),
(431, 'Nancy', 5, 'M', 'D3'),
(432, 'Orleans', 5, 'M', 'D3'),
(433, 'Valenciennes', 5, 'M', 'D3'),
(434, 'Chateauroux', 5, 'M', 'D3'),
(435, 'Sochaux', 5, 'M', 'D3'),
(436, 'Bourg-en-bresse 01', 5, 'M', 'D3'),
(437, 'Quevilly', 5, 'M', 'D3'),
(438, 'Le Mans', 5, 'M', 'D3'),
(439, 'Boulogne', 5, 'M', 'D3'),
(440, 'Concarneau', 5, 'M', 'D3'),
(441, 'Villefranche', 5, 'M', 'D3'),
(442, 'Versailles', 5, 'M', 'D3'),
(443, 'Rouen', 5, 'M', 'D3'),
(444, 'Gobelins', 5, 'M', 'D3'),
(445, 'Aubagne', 5, 'M', 'D3'),
(446, 'Marignane', 5, 'M', 'D4'),
(447, 'Andrézieux', 5, 'M', 'D4'),
(448, 'Anglet Genets', 5, 'M', 'D4'),
(449, 'Angoulême', 5, 'M', 'D4'),
(450, 'Bergerac', 5, 'M', 'D4'),
(451, 'Fréjus St-Raphaël', 5, 'M', 'D4'),
(452, 'Hyères', 5, 'M', 'D4'),
(453, 'Le Puy Foot', 5, 'M', 'D4'),
(454, 'Toulon', 5, 'M', 'D4'),
(455, 'Istres', 5, 'M', 'D4'),
(456, 'Saint-Priest', 5, 'M', 'D4'),
(457, 'Chasselay MDA', 5, 'M', 'D4'),
(458, 'Jura Sud Foot', 5, 'M', 'D4'),
(459, 'Grasse', 5, 'M', 'D4'),
(460, 'Cannes', 5, 'M', 'D4'),
(461, 'Rumilly Vallières', 5, 'M', 'D4'),
(462, 'Bordeaux', 5, 'M', 'D4'),
(463, 'Avranches', 5, 'M', 'D4'),
(464, 'Les Herbiers', 5, 'M', 'D4'),
(465, 'Blois', 5, 'M', 'D4'),
(466, 'Le Poiré sur Vie', 5, 'M', 'D4'),
(467, 'Poitiers', 5, 'M', 'D4'),
(468, 'Saint-Malo', 5, 'M', 'D4'),
(469, 'St-Pryvé St-Hilaire', 5, 'M', 'D4'),
(470, 'Granville', 5, 'M', 'D4'),
(471, 'Saint-Colomban Locminé', 5, 'M', 'D4'),
(472, 'Saumur', 5, 'M', 'D4'),
(473, 'Stade Briochin', 5, 'M', 'D4'),
(474, 'Châteaubriant', 5, 'M', 'D4'),
(475, 'Dinan Léhon', 5, 'M', 'D4'),
(476, 'La Roche VF', 5, 'M', 'D4'),
(477, 'Bourges Foot 18', 5, 'M', 'D4'),
(478, 'Chambly Thelle FC', 5, 'M', 'D4'),
(479, 'Creteil', 5, 'M', 'D4'),
(480, 'Epinal', 5, 'M', 'D4'),
(481, 'Biesheim', 5, 'M', 'D4'),
(482, 'Bobigny', 5, 'M', 'D4'),
(483, 'Haguenau', 5, 'M', 'D4'),
(484, 'Villers Houlgate CF', 5, 'M', 'D4'),
(485, 'Wasquehal', 5, 'M', 'D4'),
(486, 'Aubervilliers', 5, 'M', 'D4'),
(487, 'Beauvais', 5, 'M', 'D4'),
(488, 'Chantilly', 5, 'M', 'D4'),
(489, 'Feignies-Aulnoye', 5, 'M', 'D4'),
(490, 'Fleury 91', 5, 'M', 'D4'),
(491, 'Furiani-Agliani', 5, 'M', 'D4'),
(492, 'Balagne', 5, 'M', 'D4'),
(493, 'Thionville Lusitanos', 5, 'M', 'D4'),
(494, 'Lazio', 4, 'M', 'D1'),
(495, 'AC Milan', 4, 'M', 'D1'),
(496, 'Cagliari', 4, 'M', 'D1'),
(497, 'Napoli', 4, 'M', 'D1'),
(498, 'Udinese', 4, 'M', 'D1'),
(499, 'Genoa', 4, 'M', 'D1'),
(500, 'Juventus', 4, 'M', 'D1'),
(501, 'AS Roma', 4, 'M', 'D1'),
(502, 'Atalanta', 4, 'M', 'D1'),
(503, 'Bologna', 4, 'M', 'D1'),
(504, 'Fiorentina', 4, 'M', 'D1'),
(505, 'Torino', 4, 'M', 'D1'),
(506, 'Hellas Verona', 4, 'M', 'D1'),
(507, 'Inter', 4, 'M', 'D1'),
(508, 'Empoli', 4, 'M', 'D1'),
(509, 'Venezia', 4, 'M', 'D1'),
(510, 'Parma', 4, 'M', 'D1'),
(511, 'Lecce', 4, 'M', 'D1'),
(512, 'Como', 4, 'M', 'D1'),
(513, 'Monza', 4, 'M', 'D1'),
(514, 'Sassuolo', 4, 'M', 'D2'),
(515, 'Sampdoria', 4, 'M', 'D2'),
(516, 'Bari', 4, 'M', 'D2'),
(517, 'Cesena', 4, 'M', 'D2'),
(518, 'Cittadella', 4, 'M', 'D2'),
(519, 'Frosinone', 4, 'M', 'D2'),
(520, 'Salernitana', 4, 'M', 'D2'),
(521, 'Spezia', 4, 'M', 'D2'),
(522, 'Brescia', 4, 'M', 'D2'),
(523, 'Cremonese', 4, 'M', 'D2'),
(524, 'Palermo', 4, 'M', 'D2'),
(525, 'Pisa', 4, 'M', 'D2'),
(526, 'Juve Stabia', 4, 'M', 'D2'),
(527, 'Reggiana', 4, 'M', 'D2'),
(528, 'Modena', 4, 'M', 'D2'),
(529, 'Sudtirol', 4, 'M', 'D2'),
(530, 'Carrarese', 4, 'M', 'D2'),
(531, 'Catanzaro', 4, 'M', 'D2'),
(532, 'Mantova', 4, 'M', 'D2'),
(533, 'Cosenza', 4, 'M', 'D2'),
(534, 'Consadole Sapporo', 7, 'M', 'D1'),
(535, 'Jubilo Iwata', 7, 'M', 'D1'),
(536, 'Kashiwa Reysol', 7, 'M', 'D1'),
(537, 'Sanfrecce Hiroshima', 7, 'M', 'D1'),
(538, 'Shonan Bellmare', 7, 'M', 'D1'),
(539, 'Urawa', 7, 'M', 'D1'),
(540, 'Nagoya Grampus', 7, 'M', 'D1'),
(541, 'Vissel Kobe', 7, 'M', 'D1'),
(542, 'Kashima', 7, 'M', 'D1'),
(543, 'Cerezo Osaka', 7, 'M', 'D1'),
(544, 'FC Tokyo', 7, 'M', 'D1'),
(545, 'Gamba Osaka', 7, 'M', 'D1'),
(546, 'Kawasaki Frontale', 7, 'M', 'D1'),
(547, 'Sagan Tosu', 7, 'M', 'D1'),
(548, 'Yokohama F. Marinos', 7, 'M', 'D1'),
(549, 'Kyoto Sanga', 7, 'M', 'D1'),
(550, 'Machida Zelvia', 7, 'M', 'D1'),
(551, 'Tokyo Verdy', 7, 'M', 'D1'),
(552, 'Albirex Niigata', 7, 'M', 'D1'),
(553, 'Avispa Fukuoka', 7, 'M', 'D1'),
(554, 'Shimizu S-pulse', 7, 'M', 'D2'),
(555, 'V-varen Nagasaki', 7, 'M', 'D2'),
(556, 'Vegalta Sendai', 7, 'M', 'D2'),
(557, 'Oita Trinita', 7, 'M', 'D2'),
(558, 'Tokushima Vortis', 7, 'M', 'D2'),
(559, 'JEF United Chiba', 7, 'M', 'D2'),
(560, 'Mito Hollyhock', 7, 'M', 'D2'),
(561, 'Yokohama FC', 7, 'M', 'D2'),
(562, 'Ventforet Kofu', 7, 'M', 'D2'),
(563, 'Renofa Yamaguchi', 7, 'M', 'D2'),
(564, 'Fagiano Okayama', 7, 'M', 'D2'),
(565, 'Montedio Yamagata', 7, 'M', 'D2'),
(566, 'Roasso Kumamoto', 7, 'M', 'D2'),
(567, 'Tochigi SC', 7, 'M', 'D2'),
(568, 'Ehime FC', 7, 'M', 'D2'),
(569, 'Thespakusatsu Gunma', 7, 'M', 'D2'),
(570, 'Kagoshima United', 7, 'M', 'D2'),
(571, 'Blaublitz Akita', 7, 'M', 'D2'),
(572, 'Fujieda MYFC', 7, 'M', 'D2'),
(573, 'Iwaki', 7, 'M', 'D2'),
(574, 'Aberystwyth Town', 8, 'M', 'D1'),
(575, 'Bala Town', 8, 'M', 'D1'),
(576, 'Cardiff MET', 8, 'M', 'D1'),
(577, 'The New Saints', 8, 'M', 'D1'),
(578, 'Caernarfon Town', 8, 'M', 'D1'),
(579, 'GAP Connah S Quay FC', 8, 'M', 'D1'),
(580, 'Newtown AFC', 8, 'M', 'D1'),
(581, 'Barry Town', 8, 'M', 'D1'),
(582, 'Penybont', 8, 'M', 'D1'),
(583, 'Haverfordwest County AFC', 8, 'M', 'D1'),
(584, 'Briton Ferry', 8, 'M', 'D1'),
(585, 'Flint Town United', 8, 'M', 'D1'),
(586, 'llanelli AFC', 8, 'M', 'D2'),
(587, 'Carmarthen Town', 8, 'M', 'D2'),
(588, 'Llandudno', 8, 'M', 'D2'),
(589, 'Goytre United', 8, 'M', 'D2'),
(590, 'Ammanford AFC', 8, 'M', 'D2'),
(591, 'Cwmbran Celtic', 8, 'M', 'D2'),
(592, 'Pontypridd Town', 8, 'M', 'D2'),
(593, 'Llantwit Major', 8, 'M', 'D2'),
(594, 'Taffs Well', 8, 'M', 'D2'),
(595, 'Afan Lido', 8, 'M', 'D2'),
(596, 'Cambrian & Clydach', 8, 'M', 'D2'),
(597, 'Airbus UK', 8, 'M', 'D2'),
(598, 'Buckley Town', 8, 'M', 'D2'),
(599, 'Caerau (Ely)', 8, 'M', 'D2'),
(600, 'Colwyn Bay', 8, 'M', 'D2'),
(601, 'Gresford Athletic', 8, 'M', 'D2'),
(602, 'Guilsfield', 8, 'M', 'D2'),
(603, 'Penrhyncoch', 8, 'M', 'D2'),
(604, 'Prestatyn Town', 8, 'M', 'D2'),
(605, 'Ruthin Town', 8, 'M', 'D2'),
(606, 'Caersws', 8, 'M', 'D2'),
(607, 'Denbigh Town', 8, 'M', 'D2'),
(608, 'Holywell', 8, 'M', 'D2'),
(609, 'Llay Miners Welfare', 8, 'M', 'D2'),
(610, 'Mold Alexandra', 8, 'M', 'D2'),
(611, 'Trefelin', 8, 'M', 'D2'),
(612, 'Bangor 1876', 8, 'M', 'D2'),
(613, 'Trethomas Bluebirds', 8, 'M', 'D2'),
(614, 'Penrhiwceiber Rangers', 8, 'M', 'D2'),
(615, 'Baglan Dragons', 8, 'M', 'D2'),
(616, 'Flint Mountain', 8, 'M', 'D2'),
(617, 'Newport City', 8, 'M', 'D2'),
(618, 'PEC Zwolle', 13, 'M', 'D1'),
(619, 'Ajax', 13, 'M', 'D1'),
(620, 'Willem II', 13, 'M', 'D1'),
(621, 'PSV Eindhoven', 13, 'M', 'D1'),
(622, 'ADO Den Haag', 13, 'M', 'D1'),
(623, 'De Graafschap', 13, 'M', 'D1'),
(624, 'AZ Alkmaar', 13, 'M', 'D1'),
(625, 'Groningen', 13, 'M', 'D1'),
(626, 'NAC Breda', 13, 'M', 'D1'),
(627, 'Fortuna Sittard', 13, 'M', 'D1'),
(628, 'Heracles', 13, 'M', 'D1'),
(629, 'Utrecht', 13, 'M', 'D1'),
(630, 'Feyenoord', 13, 'M', 'D1'),
(631, 'Heerenveen', 13, 'M', 'D1'),
(632, 'Dordrecht', 13, 'M', 'D1'),
(633, 'GO Ahead Eagles', 13, 'M', 'D1'),
(634, 'NEC Nijmegen', 13, 'M', 'D1'),
(635, 'Twente', 13, 'M', 'D1'),
(636, 'Waalwijk', 13, 'M', 'D1'),
(637, 'Almere City FC', 13, 'M', 'D1'),
(638, 'Cambuur', 13, 'M', 'D1'),
(639, 'Den Bosch', 13, 'M', 'D1'),
(640, 'Sparta Rotterdam', 13, 'M', 'D1'),
(641, 'Telstar', 13, 'M', 'D1'),
(642, 'Excelsior', 13, 'M', 'D2'),
(643, 'ADO Den Haag', 13, 'M', 'D2'),
(644, 'De Graafschap', 13, 'M', 'D2'),
(645, 'Vitesse', 13, 'M', 'D2'),
(646, 'VVV Venlo', 13, 'M', 'D2'),
(647, 'Emmen', 13, 'M', 'D2'),
(648, 'Dordrecht', 13, 'M', 'D2'),
(649, 'Jong PSV U21', 13, 'M', 'D2'),
(650, 'MVV', 13, 'M', 'D2'),
(651, 'Roda', 13, 'M', 'D2'),
(652, 'FC Volendam', 13, 'M', 'D2'),
(653, 'Jong AZ', 13, 'M', 'D2'),
(654, 'Cambuur', 13, 'M', 'D2'),
(655, 'Den Bosch', 13, 'M', 'D2'),
(656, 'FC Eindhoven', 13, 'M', 'D2'),
(657, 'FC OSS', 13, 'M', 'D2'),
(658, 'Helmond Sport', 13, 'M', 'D2'),
(659, 'Jong Ajax', 13, 'M', 'D2'),
(660, 'Telstar', 13, 'M', 'D2'),
(661, 'Jong Utrecht', 13, 'M', 'D2'),
(662, 'Benfica', 14, 'M', 'D1'),
(663, 'FC Porto', 14, 'M', 'D1'),
(664, 'Moreirense', 14, 'M', 'D1'),
(665, 'SC Braga', 14, 'M', 'D1'),
(666, 'Boavista', 14, 'M', 'D1'),
(667, 'Guimaraes', 14, 'M', 'D1'),
(668, 'Nacional', 14, 'M', 'D1'),
(669, 'Rio Ave', 14, 'M', 'D1'),
(670, 'Santa Clara', 14, 'M', 'D1'),
(671, 'Sporting CP', 14, 'M', 'D1'),
(672, 'Estoril', 14, 'M', 'D1'),
(673, 'Farense', 14, 'M', 'D1'),
(674, 'Arouca', 14, 'M', 'D1'),
(675, 'Famalicao', 14, 'M', 'D1'),
(676, 'GIL Vicente', 14, 'M', 'D1'),
(677, 'Vizela', 14, 'M', 'D1'),
(678, 'Casa Pia', 14, 'M', 'D1'),
(679, 'Estrela', 14, 'M', 'D1'),
(680, 'AVS', 14, 'M', 'D1'),
(681, 'Feirense', 14, 'M', 'D2'),
(682, 'Maritimo', 14, 'M', 'D2'),
(683, 'Portimonense', 14, 'M', 'D2'),
(684, 'Tondela', 14, 'M', 'D2'),
(685, 'Chaves', 14, 'M', 'D2'),
(686, 'Benfica B', 14, 'M', 'D2'),
(687, 'Oliveirense', 14, 'M', 'D2'),
(688, 'Pacos Ferreira', 14, 'M', 'D2'),
(689, 'Penafiel', 14, 'M', 'D2'),
(690, 'Academico Viseu', 14, 'M', 'D2'),
(691, 'FC Porto B', 14, 'M', 'D2'),
(692, 'Leixoes', 14, 'M', 'D2'),
(693, 'Mafra', 14, 'M', 'D2'),
(694, 'Vizela', 14, 'M', 'D2'),
(695, 'União de Leiria', 14, 'M', 'D2'),
(696, 'Alverca', 14, 'M', 'D2'),
(697, 'Felgueiras 1932', 14, 'M', 'D2'),
(698, 'Torreense', 14, 'M', 'D2'),
(699, 'CF Os Belenenses', 14, 'M', 'D2'),
(700, 'Beşiktaş', 15, 'M', 'D1'),
(701, 'Başakşehir', 15, 'M', 'D1'),
(702, 'Konyaspor', 15, 'M', 'D1'),
(703, 'Fenerbahçe', 15, 'M', 'D1'),
(704, 'Galatasaray', 15, 'M', 'D1'),
(705, 'Göztepe', 15, 'M', 'D1'),
(706, 'Alanyaspor', 15, 'M', 'D1'),
(707, 'Trabzonspor', 15, 'M', 'D1'),
(708, 'Kayserispor', 15, 'M', 'D1'),
(709, 'Sivasspor', 15, 'M', 'D1'),
(710, 'Kasımpaşa', 15, 'M', 'D1'),
(711, 'Antalyaspor', 15, 'M', 'D1'),
(712, 'Rizespor', 15, 'M', 'D1'),
(713, 'Adana Demirspor', 15, 'M', 'D1'),
(714, 'Gaziantep FK', 15, 'M', 'D1'),
(715, 'Hatayspor', 15, 'M', 'D1'),
(716, 'Bodrum FK', 15, 'M', 'D1'),
(717, 'Eyüpspor', 15, 'M', 'D1'),
(718, 'Samsunspor', 15, 'M', 'D1'),
(719, 'Gençlerbirliği S.K.', 15, 'M', 'D2'),
(720, 'Yeni Malatyaspor', 15, 'M', 'D2'),
(721, 'Erzurumspor FK', 15, 'M', 'D2'),
(722, 'Ankaragücü', 15, 'M', 'D2'),
(723, 'Adanaspor', 15, 'M', 'D2'),
(724, 'Boluspor', 15, 'M', 'D2'),
(725, 'Ümraniyespor', 15, 'M', 'D2'),
(726, 'İstanbulspor', 15, 'M', 'D2'),
(727, 'Amed', 15, 'M', 'D2'),
(728, 'Bandırmaspor', 15, 'M', 'D2'),
(729, 'Fatih Karagümrük', 15, 'M', 'D2'),
(730, 'Keçiörengücü', 15, 'M', 'D2'),
(731, 'Manisa F.K.', 15, 'M', 'D2'),
(732, 'Pendikspor', 15, 'M', 'D2'),
(733, 'Sakaryaspor', 15, 'M', 'D2'),
(734, 'Şanlıurfaspor', 15, 'M', 'D2'),
(735, 'Çorum FK', 15, 'M', 'D2'),
(736, 'Esenler Erokspor', 15, 'M', 'D2'),
(737, 'Kocaelispor', 15, 'M', 'D2'),
(738, 'Iğdır FK', 15, 'M', 'D2'),
(739, 'Hammarby FF', 9, 'M', 'D1'),
(740, 'Djurgardens IF', 9, 'M', 'D1'),
(741, 'IFK Goteborg', 9, 'M', 'D1'),
(742, 'BK Hacken', 9, 'M', 'D1'),
(743, 'Sirius', 9, 'M', 'D1'),
(744, 'IF Brommapojkarna', 9, 'M', 'D1'),
(745, 'IF Elfsborg', 9, 'M', 'D1'),
(746, 'Kalmar FF', 9, 'M', 'D1'),
(747, 'Malmo FF', 9, 'M', 'D1'),
(748, 'AIK Stockholm', 9, 'M', 'D1'),
(749, 'IFK Norrkoping', 9, 'M', 'D1'),
(750, 'Halmstad', 9, 'M', 'D1'),
(751, 'IFK Varnamo', 9, 'M', 'D1'),
(752, 'Gais', 9, 'M', 'D1'),
(753, 'Landskrona BoIS', 9, 'M', 'D1'),
(754, 'Mjallby AIF', 9, 'M', 'D1'),
(755, 'Vasteras SK FK', 9, 'M', 'D1'),
(756, '1. FC Union Berlin', 3, 'F', 'D1'),
(757, 'Hamburger SV', 3, 'F', 'D1');

-- --------------------------------------------------------

--
-- Structure de la table `joueur`
--

DROP TABLE IF EXISTS `joueur`;
CREATE TABLE IF NOT EXISTS `joueur` (
  `idJoueur` int NOT NULL AUTO_INCREMENT,
  `positionTact` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nom` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `age` int DEFAULT NULL,
  `numero` int DEFAULT NULL,
  `nat` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdn` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poste` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `app` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pDec` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buts` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `noteMoy` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `montantTransfert` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idUser` int NOT NULL,
  `mercato_status` enum('sell','loan','free') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prixDemande` bigint DEFAULT NULL,
  `expireContrat` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idJoueur`),
  KEY `idUser` (`idUser`)
) ENGINE=MyISAM AUTO_INCREMENT=339 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `joueur`
--

INSERT INTO `joueur` (`idJoueur`, `positionTact`, `nom`, `age`, `numero`, `nat`, `pdn`, `poste`, `app`, `pDec`, `buts`, `noteMoy`, `montantTransfert`, `idUser`, `mercato_status`, `prixDemande`, `expireContrat`) VALUES
(1, 'BU', 'Guillaume', 19, 19, 'FRA', 'FRA', 'MO (GC), BT (C)', NULL, NULL, NULL, NULL, '3,1M € - 6,6M €', 8, NULL, NULL, NULL),
(338, NULL, 'Cristina Redondo', 20, NULL, 'Esp', 'Esp', 'BT (C)', '0', '0', '0', NULL, NULL, 1, 'loan', 175000, '30/6/2027'),
(337, NULL, 'Giovana Queiroz', 23, 18, 'Bré', 'Bré', 'MO (DG), BT (C)', '3 (15)', '0', '3', '6,72', NULL, 1, NULL, 130000, '30/6/2026'),
(335, NULL, 'Amaiur Sarriegi', 26, 20, 'Esp', 'Esp', 'MO (DC), BT (C)', '35', '11', '12', '7,41', NULL, 1, NULL, 400000, '30/6/2026'),
(336, NULL, 'Synne Jensen', 31, 7, 'Nor', 'Nor', 'MO (DGC), BT (C)', '35 (1)', '5', '20', '7,18', NULL, 1, NULL, 96000, '30/6/2026'),
(334, NULL, 'Luany da Silva Rosa', 24, 22, 'Bré', 'Bré', 'MO (D), BT (C)', '3 (13)', '1', '5', '6,97', NULL, 1, NULL, 275000, '30/6/2026'),
(333, NULL, 'Macarena Portales', 28, 19, 'Esp', 'Esp', 'MO (DGC)', '1 (14)', '2', '1', '6,86', NULL, 1, NULL, 37000, '30/6/2026'),
(332, NULL, 'Alexia Fernández', 24, NULL, 'Esp', 'Esp', 'MO (DG)', '0 (9)', '0', '0', '6,54', NULL, 1, NULL, 51000, '30/6/2029'),
(331, NULL, 'Priscila Chinchilla', 25, NULL, 'Cos', 'Cos', 'MO (DGC)', '0', '0', '0', NULL, NULL, 1, 'free', 5750, '30/6/2026'),
(329, NULL, 'Rosa Otermín', 26, 14, 'Esp', 'Esp', 'M/MO (G)', '32', '4', '10', '7,09', NULL, 1, NULL, 350000, '30/6/2027'),
(330, NULL, 'Fiamma Benítez', 22, 21, 'Esp', 'Esp', 'M (C), MO (DGC)', '34', '5', '3', '6,49', NULL, 1, NULL, 175000, '30/6/2026'),
(328, NULL, 'Kathrine Kühl', 23, 12, 'Dan', 'Dan', 'M (DC)', '36', '3', '5', '6,51', NULL, 1, NULL, 250000, '30/6/2028'),
(327, NULL, 'Daniela Miñambres', 20, NULL, 'Esp', 'Esp', 'MD, M (C)', '2 (12)', '0', '0', '6,59', NULL, 1, 'free', 5750, '30/6/2026'),
(326, NULL, 'Naara Miranda', 21, 47, 'Esp', 'Esp', 'D (DG), AL/MO (D)', '0 (12)', '0', '0', '6,54', NULL, 1, NULL, 66000, '30/6/2026'),
(325, NULL, 'Laura Tanarro', 23, NULL, 'Esp', 'Esp', 'D (DG), AL (D)', '0 (5)', '0', '0', '6,53', NULL, 1, 'free', 2100, '30/6/2026'),
(324, NULL, 'Silvia Lloris', 22, 15, 'Esp', 'Esp', 'D (DGC), AL (DG), MD', '36', '4', '1', '6,89', NULL, 1, NULL, 725000, '30/6/2026'),
(323, NULL, 'Carmen Menayo', 28, 11, 'Esp', 'Esp', 'D (GC), AL (G)', '36', '6', '1', '7,09', NULL, 1, NULL, 110000, '30/6/2026'),
(321, NULL, 'Lauren Leal', 24, 4, 'Bré', 'Bré', 'D (DGC)', '36', '3', '0', '7,19', NULL, 1, NULL, 180000, '30/6/2026'),
(322, NULL, 'Yolanda Sierra', 22, 46, 'Esp', 'Esp', 'D (DGC)', '16 (7)', '0', '0', '6,59', NULL, 1, NULL, 3400, '30/6/2026'),
(320, NULL, 'Xènia Pérez', 25, 5, 'Esp', 'Esp', 'D (DC)', '31 (3)', '3', '0', '6,99', NULL, 1, NULL, 65000, '30/6/2026'),
(319, NULL, 'Lydia Rodríguez', 21, 52, 'Esp', 'Esp', 'D (C)', '18', '0', '0', '6,64', NULL, 1, 'loan', 50000, '30/6/2026'),
(318, NULL, 'Leyre Valdivia', 20, NULL, 'Esp', 'Esp', 'D (DC)', '0 (2)', '0', '0', '6,60', NULL, 1, 'free', 39000, '30/6/2026'),
(317, NULL, 'Alba de Isidro', 22, 13, 'Esp', 'Esp', 'GB', '0', '0', '0', NULL, NULL, 1, NULL, 64000, '30/6/2028'),
(316, NULL, 'Lola Gallardo', 33, 1, 'Esp', 'Esp', 'GB', '36', '0', '0', '6,97', NULL, 1, NULL, 52000, '30/6/2026');

-- --------------------------------------------------------

--
-- Structure de la table `mercato_arrivee`
--

DROP TABLE IF EXISTS `mercato_arrivee`;
CREATE TABLE IF NOT EXISTS `mercato_arrivee` (
  `idArrivee` int NOT NULL AUTO_INCREMENT,
  `idUser` int NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `poste` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prix` bigint DEFAULT NULL,
  `statut` enum('cible','nego','signe') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cible',
  PRIMARY KEY (`idArrivee`),
  KEY `idUser` (`idUser`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `mercato_arrivee`
--

INSERT INTO `mercato_arrivee` (`idArrivee`, `idUser`, `nom`, `poste`, `prix`, `statut`) VALUES
(8, 1, 'Paulina Dudek', 'DC', 0, 'cible'),
(7, 1, 'Adriana Nanclares', 'GB', 0, 'cible'),
(9, 1, 'Hanna Bennison', 'MC', 0, 'signe'),
(10, 1, 'Nahia Aparicio', 'DC / MD', 0, 'cible'),
(11, 1, 'Tuva Hansen', 'DD / DC', 0, 'signe');

-- --------------------------------------------------------

--
-- Structure de la table `objectif`
--

DROP TABLE IF EXISTS `objectif`;
CREATE TABLE IF NOT EXISTS `objectif` (
  `idObjectif` int NOT NULL AUTO_INCREMENT,
  `idUser` int NOT NULL,
  `idCompetition` int NOT NULL,
  `objectif` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `saison` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resultat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idObjectif`),
  UNIQUE KEY `idUser` (`idUser`,`idCompetition`,`saison`),
  KEY `idCompetition` (`idCompetition`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `objectif`
--

INSERT INTO `objectif` (`idObjectif`, `idUser`, `idCompetition`, `objectif`, `saison`, `resultat`) VALUES
(46, 1, 46, 'Demi-finale', '2025/2026', 'Demi-finale'),
(45, 1, 42, 'Quarts', '2025/2026', 'Finale'),
(44, 1, 40, '2ème', '2025/2026', '3ème');

-- --------------------------------------------------------

--
-- Structure de la table `participation`
--

DROP TABLE IF EXISTS `participation`;
CREATE TABLE IF NOT EXISTS `participation` (
  `idParticipation` int NOT NULL AUTO_INCREMENT,
  `annee` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `objectif` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resultat` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nbrPourcentage` int DEFAULT NULL,
  `idEquipe` int DEFAULT NULL,
  `idCompetition` int DEFAULT NULL,
  `idUser` int DEFAULT NULL,
  PRIMARY KEY (`idParticipation`),
  KEY `idEquipe` (`idEquipe`),
  KEY `idCompetition` (`idCompetition`),
  KEY `idUser` (`idUser`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `pays`
--

DROP TABLE IF EXISTS `pays`;
CREATE TABLE IF NOT EXISTS `pays` (
  `idPays` int NOT NULL AUTO_INCREMENT,
  `nomPays` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paysA2C` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paysA3C` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paysNum` int DEFAULT NULL,
  PRIMARY KEY (`idPays`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pays`
--

INSERT INTO `pays` (`idPays`, `nomPays`, `paysA2C`, `paysA3C`, `paysNum`) VALUES
(1, 'United Kingdom', 'GB', 'GBR', 826),
(2, 'Spain', 'ES', 'ESP', 724),
(3, 'Germany', 'DE', 'DEU', 276),
(4, 'Italy', 'IT', 'ITA', 380),
(5, 'France', 'FR', 'FRA', 250),
(6, 'United States', 'US', 'USA', 840),
(7, 'Japan', 'JP', 'JPN', 392),
(8, 'Wales', 'WL', 'WAL', 0),
(9, 'Sweden', 'SE', 'SWE', 752),
(10, 'Austria', 'AT', 'AUT', 40),
(11, 'Belgium', 'BE', 'BEL', 56),
(12, 'Brazil', 'BR', 'BRA', 76),
(13, 'Netherlands', 'NL', 'NLD', 528),
(14, 'Portugal', 'PT', 'PRT', 620),
(15, 'Turkey', 'TR', 'TUR', 792);

-- --------------------------------------------------------

--
-- Structure de la table `saison_meta`
--

DROP TABLE IF EXISTS `saison_meta`;
CREATE TABLE IF NOT EXISTS `saison_meta` (
  `idUser` int NOT NULL,
  `saison` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `club` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `division` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `genre` enum('M','F') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'M',
  `idPays` int DEFAULT NULL,
  PRIMARY KEY (`idUser`,`saison`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `saison_meta`
--

INSERT INTO `saison_meta` (`idUser`, `saison`, `club`, `division`, `genre`, `idPays`) VALUES
(1, '2025/2026', 'Atletico Madrid W', 'D1', 'F', 2);

-- --------------------------------------------------------

--
-- Structure de la table `tactic`
--

DROP TABLE IF EXISTS `tactic`;
CREATE TABLE IF NOT EXISTS `tactic` (
  `idTactic` int NOT NULL AUTO_INCREMENT,
  `position` int NOT NULL,
  `titulaire` int DEFAULT NULL,
  `remplacant` int DEFAULT NULL,
  `supersub` int DEFAULT NULL,
  `idUser` int NOT NULL,
  PRIMARY KEY (`idTactic`),
  KEY `idUser` (`idUser`),
  KEY `titulaire` (`titulaire`),
  KEY `remplacant` (`remplacant`),
  KEY `supersub` (`supersub`)
) ENGINE=MyISAM AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `tactic`
--

INSERT INTO `tactic` (`idTactic`, `position`, `titulaire`, `remplacant`, `supersub`, `idUser`) VALUES
(165, 11, NULL, NULL, NULL, 1),
(164, 10, 334, NULL, NULL, 1),
(163, 9, 329, 333, NULL, 1),
(162, 8, NULL, NULL, NULL, 1),
(161, 7, NULL, NULL, NULL, 1),
(160, 6, NULL, NULL, NULL, 1),
(159, 5, NULL, 322, NULL, 1),
(158, 4, 321, NULL, NULL, 1),
(157, 3, 324, NULL, NULL, 1),
(156, 2, 321, NULL, NULL, 1),
(155, 1, 316, 317, NULL, 1);

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `idUser` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `club` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `division` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mail` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pourcentage` int DEFAULT NULL,
  `type` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `auth_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token_expiry` datetime DEFAULT NULL,
  `formation` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `genre` enum('M','F') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'M',
  `idPays` int DEFAULT NULL,
  `saison_active` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget_transfert` bigint DEFAULT NULL,
  `budget_salaires` bigint DEFAULT NULL,
  `comp_europe_override` int DEFAULT NULL,
  PRIMARY KEY (`idUser`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`idUser`, `username`, `club`, `division`, `mail`, `password`, `pourcentage`, `type`, `auth_token`, `token_expiry`, `formation`, `genre`, `idPays`, `saison_active`, `budget_transfert`, `budget_salaires`, `comp_europe_override`) VALUES
(1, 'PsycoSGWaK', 'Atletico Madrid W', 'D1', 'guillaume.hurard@gmail.com', '$2y$10$yz/67Nq.UQJf67cmruLOCe.ivA0.6e0eZjMVHkM42UGtKjtLwuCy2', NULL, '1', 'c02699bed7ad84a7c6a10e4df52a9023f20c5930120afa286f9a40f19be3bdd2511e84f190febed4175914034f7041794c461ffe91c6a19d8d7b2fa1ef1bcddc', '2026-07-19 17:17:43', '4-2-3-1', 'F', 2, '2025/2026', NULL, NULL, 46);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vueparticipation`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vueparticipation`;
CREATE TABLE IF NOT EXISTS `vueparticipation` (
`nomCompetition` varchar(255)
,`nomEquipe` varchar(255)
,`objectif` varchar(255)
,`resultat` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure de la vue `vueparticipation`
--
DROP TABLE IF EXISTS `vueparticipation`;

DROP VIEW IF EXISTS `vueparticipation`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueparticipation`  AS SELECT `e`.`nomEquipe` AS `nomEquipe`, `c`.`nomCompetition` AS `nomCompetition`, `p`.`objectif` AS `objectif`, `p`.`resultat` AS `resultat` FROM ((`equipe` `e` join `participation` `p` on((`e`.`idEquipe` = `p`.`idEquipe`))) join `competition` `c` on((`p`.`idCompetition` = `c`.`idCompetition`))) WHERE ((`c`.`idPays` is null) OR (`c`.`idPays` = `e`.`idPays`)) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
