-- Remplace le systeme de qualification aux competitions continentales
-- (plage de rang GLOBALE sur `competition.qualif_rang_min/max`, jamais
-- scopee par pays) par un systeme de regles, scopees par pays et
-- generalisable a "qualifie si le resultat d'une AUTRE competition
-- correspond" (rang OU resultat exact), pas seulement "top N du
-- championnat national".
--
-- Cas d'usage direct : la FIFA Women Champions Cup (idCompetition 48)
-- avait qualif_rang_min/max = NULL car elle ne se qualifie pas par un
-- rang de championnat mais en ayant GAGNE l'UEFA Women's Champions
-- League la saison precedente -- structurellement impossible a
-- representer avec l'ancien systeme, elle n'apparaissait donc jamais.
--
-- IMPORTANT -- ordre de deploiement : deployer le code (branche mergee
-- dans main, deploiement auto) AVANT d'executer ce script en prod. Entre
-- les deux, l'edition d'une competition dans l'admin planterait (colonnes
-- inconnues) -- l'affichage des competitions continentales, lui, se
-- degraderait sans casser (juste aucune comp continentale affichee).
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

CREATE TABLE IF NOT EXISTS `competition_qualif_rule` (
  `idRule` INT NOT NULL AUTO_INCREMENT,
  `idCompetition` INT NOT NULL COMMENT 'competition cible, debloquee si la regle est satisfaite',
  `idCompetitionSource` INT NOT NULL COMMENT 'competition dont on regarde le resultat de la saison precedente',
  `rang_min` TINYINT DEFAULT NULL COMMENT 'qualif par rang (avec rang_max) -- ex: finir 1er a 3e du championnat',
  `rang_max` TINYINT DEFAULT NULL,
  `resultat_exact` VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'qualif par resultat exact -- ex: avoir "Gagner" la source',
  PRIMARY KEY (`idRule`),
  KEY `idCompetition` (`idCompetition`),
  KEY `idCompetitionSource` (`idCompetitionSource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Une competition cible peut avoir PLUSIEURS regles : elle est incluse
-- des qu'AU MOINS UNE regle est satisfaite (OR), evalue cote PHP.

-- --- Hommes : qualification europeenne par rang du championnat D1 national ---
-- UEFA Champions League (idCompetition 1) : 1er de chaque championnat D1
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`) VALUES
(1, 9,  1, 1),  -- Premier League (Angleterre)
(1, 12, 1, 1),  -- LaLiga EA Sports FC (Espagne)
(1, 15, 1, 1),  -- Bundesliga (Allemagne)
(1, 18, 1, 1),  -- Serie A (Italie)
(1, 21, 1, 1),  -- Ligue 1 (France)
-- UEFA Europa League (idCompetition 2) : 2e-3e de chaque championnat D1
(2, 9,  2, 3),
(2, 12, 2, 3),
(2, 15, 2, 3),
(2, 18, 2, 3),
(2, 21, 2, 3),
-- UEFA Europa Conference League (idCompetition 3) : 4e-5e de chaque championnat D1
(3, 9,  4, 5),
(3, 12, 4, 5),
(3, 15, 4, 5),
(3, 18, 4, 5),
(3, 21, 4, 5);

-- --- Femmes : qualification europeenne par rang du championnat D1 national ---
-- UEFA Women's Champions League (idCompetition 30) : 1re de chaque championnat D1
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`) VALUES
(30, 31, 1, 1),  -- Women's Super League (Angleterre)
(30, 40, 1, 1),  -- Liga F (Espagne)
(30, 37, 1, 1),  -- Frauen-Bundesliga (Allemagne)
(30, 43, 1, 1),  -- Serie A Femminile (Italie)
(30, 34, 1, 1),  -- Division 1 Arkema (France)
-- UEFA Women's Europa Cup (idCompetition 46) : 2e-20e de chaque championnat D1
(46, 31, 2, 20),
(46, 40, 2, 20),
(46, 37, 2, 20),
(46, 43, 2, 20),
(46, 34, 2, 20);

-- --- FIFA Women Champions Cup (idCompetition 48) : qualif par resultat exact ---
-- Se joue entre les vainqueurs des competitions continentales feminines ;
-- seule l'UEFA Women's Champions League (idCompetition 30) est modelisee
-- dans ce catalogue, donc seule source geree pour l'instant.
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `resultat_exact`) VALUES
(48, 30, 'Gagner');

-- --- Nettoyage : l'ancien mecanisme de qualif (colonnes globales, jamais
-- scopees par pays) est remplace par la table ci-dessus ---
ALTER TABLE `competition`
    DROP COLUMN `qualif_rang_min`,
    DROP COLUMN `qualif_rang_max`;
