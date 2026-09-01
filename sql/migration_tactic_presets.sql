-- Bibliotheque de tactiques partagees + "cards" personnelles.
--
-- tactic_preset / tactic_preset_slot : la bibliotheque partagee, visible et
-- utilisable par tous les users - une tactique = un nom + 11 postes
-- ordonnes (liste canonique $roleOptions d'index.php), pas de schema visuel.
--
-- tactic_card : les tactiques qu'UN user a ajoutees a son propre espace
-- (onglet Tactic Sub : grille de cards, "+" pour en ajouter, jusqu'a 5 -
-- TACTIC_MAX_CARDS dans tactic_card_post.php). Plusieurs cards d'un meme
-- user peuvent pointer vers la meme tactique de la bibliotheque - chacune
-- garde sa propre composition, independante des autres cards.
--
-- tactic (composition, table existante) : desormais rattachee a une card
-- (idTacticCard) plutot qu'a idUser seul. Changer la tactique active d'une
-- card reinitialise sa composition (comportement volontaire, discute le
-- 2026-08-31 : la notion de "garder une composition par tactique" est
-- remplacee par la possibilite d'avoir plusieurs cards).
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

CREATE TABLE IF NOT EXISTS `tactic_preset` (
  `idTacticPreset` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(60) NOT NULL,
  `idUserCreateur` int DEFAULT NULL,
  `dateCreation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idTacticPreset`),
  UNIQUE KEY `nom` (`nom`),
  KEY `idUserCreateur` (`idUserCreateur`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tactic_preset_slot` (
  `idTacticPresetSlot` int NOT NULL AUTO_INCREMENT,
  `idTacticPreset` int NOT NULL,
  `position` tinyint NOT NULL,
  `poste` varchar(10) NOT NULL,
  PRIMARY KEY (`idTacticPresetSlot`),
  UNIQUE KEY `preset_position` (`idTacticPreset`, `position`),
  KEY `idTacticPreset` (`idTacticPreset`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed des 6 formations historiques comme presets "systeme" (idUserCreateur
-- NULL), en traduisant leurs codes de poste (style FORMATIONS/tacticRoleMap)
-- vers la liste canonique $roleOptions deja utilisee pour le role des
-- joueurs (index.php).
INSERT INTO `tactic_preset` (`idTacticPreset`, `nom`, `idUserCreateur`) VALUES
(1, '4-3-3', NULL),
(2, '4-4-2', NULL),
(3, '4-2-3-1', NULL),
(4, '3-5-2', NULL),
(5, '5-3-2', NULL),
(6, '4-1-2-1-2', NULL);

INSERT INTO `tactic_preset_slot` (`idTacticPreset`, `position`, `poste`) VALUES
-- 4-3-3 : GK,CB,CB,LB,RB,CM,CM,CM,LW,RW,ST
(1,1,'GK'), (1,2,'CB'), (1,3,'CB'), (1,4,'LB'), (1,5,'RB'),
(1,6,'CM'), (1,7,'CM'), (1,8,'CM'), (1,9,'LW'), (1,10,'RW'), (1,11,'ST'),
-- 4-4-2 : GK,CB,CB,LB,RB,LM,CM,CM,RM,ST,ST
(2,1,'GK'), (2,2,'CB'), (2,3,'CB'), (2,4,'LB'), (2,5,'RB'),
(2,6,'LM'), (2,7,'CM'), (2,8,'CM'), (2,9,'RM'), (2,10,'ST'), (2,11,'ST'),
-- 4-2-3-1 : GK,CB,CB,LB,RB,CM,CM,CAM,LW,RW,ST
(3,1,'GK'), (3,2,'CB'), (3,3,'CB'), (3,4,'LB'), (3,5,'RB'),
(3,6,'CM'), (3,7,'CM'), (3,8,'CAM'), (3,9,'LW'), (3,10,'RW'), (3,11,'ST'),
-- 3-5-2 : GK,CB,CB,CB,LM,CM,CM,CM,RM,ST,ST
(4,1,'GK'), (4,2,'CB'), (4,3,'CB'), (4,4,'CB'), (4,5,'LM'),
(4,6,'CM'), (4,7,'CM'), (4,8,'CM'), (4,9,'RM'), (4,10,'ST'), (4,11,'ST'),
-- 5-3-2 : GK,CB,CB,CB,LB,RB,CM,CM,CM,ST,ST
(5,1,'GK'), (5,2,'CB'), (5,3,'CB'), (5,4,'CB'), (5,5,'LB'),
(5,6,'RB'), (5,7,'CM'), (5,8,'CM'), (5,9,'CM'), (5,10,'ST'), (5,11,'ST'),
-- 4-1-2-1-2 : GK,CB,CB,LB,RB,CM,LM,RM,CAM,ST,ST
(6,1,'GK'), (6,2,'CB'), (6,3,'CB'), (6,4,'LB'), (6,5,'RB'),
(6,6,'CM'), (6,7,'LM'), (6,8,'RM'), (6,9,'CAM'), (6,10,'ST'), (6,11,'ST');

CREATE TABLE IF NOT EXISTS `tactic_card` (
  `idTacticCard` int NOT NULL AUTO_INCREMENT,
  `idUser` int NOT NULL,
  `idTacticPreset` int NOT NULL,
  `dateCreation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idTacticCard`),
  KEY `idUser` (`idUser`),
  KEY `idTacticPreset` (`idTacticPreset`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Migration des compositions existantes (ancien systeme mono-tactique) :
-- une card est creee pour chaque user ayant deja une composition
-- sauvegardee, pointant sur sa formation actuelle, et ses lignes tactic lui
-- sont rattachees.
INSERT INTO `tactic_card` (`idUser`, `idTacticPreset`)
SELECT DISTINCT u.`idUser`, COALESCE(
    (SELECT p.`idTacticPreset` FROM `tactic_preset` p WHERE p.`nom` = u.`formation` AND p.`idUserCreateur` IS NULL),
    1
) FROM `user` u WHERE EXISTS (SELECT 1 FROM `tactic` t WHERE t.`idUser` = u.`idUser`);

ALTER TABLE `tactic` ADD COLUMN `idTacticCard` int DEFAULT NULL AFTER `idTactic`;

UPDATE `tactic` t
    JOIN `tactic_card` c ON c.`idUser` = t.`idUser`
    SET t.`idTacticCard` = c.`idTacticCard`;

ALTER TABLE `tactic` MODIFY `idTacticCard` int NOT NULL;
ALTER TABLE `tactic` DROP KEY `idUser_position`;
ALTER TABLE `tactic` ADD UNIQUE KEY `card_position` (`idTacticCard`, `position`);
ALTER TABLE `tactic` ADD KEY `idTacticCard` (`idTacticCard`);
