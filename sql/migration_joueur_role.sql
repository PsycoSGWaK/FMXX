-- Rôles "utilisés en match" multi-poste (un joueur peut avoir plusieurs
-- rôles, ex: latéral droit + piston droit). Remplace l'ancienne colonne
-- unique joueur.role_match (conservée mais plus lue/écrite par le code).
-- À exécuter en production (phpMyAdmin o2switch) en plus du local.

CREATE TABLE IF NOT EXISTS `joueur_role` (
    `idJoueur` INT NOT NULL,
    `role_code` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`idJoueur`, `role_code`),
    CONSTRAINT `fk_joueur_role_joueur` FOREIGN KEY (`idJoueur`) REFERENCES `joueur` (`idJoueur`) ON DELETE CASCADE
);

-- Migre les choix manuels existants (role_match non NULL) vers la nouvelle table.
INSERT INTO `joueur_role` (`idJoueur`, `role_code`)
SELECT `idJoueur`, `role_match` FROM `joueur` WHERE `role_match` IS NOT NULL;
