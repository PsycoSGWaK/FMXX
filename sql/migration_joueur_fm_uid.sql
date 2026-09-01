-- ID unique du joueur cote Football Manager (colonne "Unique ID" de l'export
-- CSV/HTML), stable d'une saison a l'autre. Sert a detecter qu'un joueur a
-- deja ete importe pour ce compte, pour permettre un import additif (n'ajoute
-- que les joueurs absents) plutot que le remplacement complet actuel.
-- NULL pour les joueurs deja importes avant cette fonctionnalite (exports
-- sans cette colonne, ou imports precedents) : plusieurs NULL sont autorises
-- par la cle unique (idUser, fm_uid).
-- A executer en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `joueur` ADD COLUMN `fm_uid` varchar(20) DEFAULT NULL AFTER `idJoueur`;
ALTER TABLE `joueur` ADD UNIQUE KEY `idUser_fm_uid` (`idUser`, `fm_uid`);
