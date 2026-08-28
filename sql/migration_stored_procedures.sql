-- Procédures stockées utilisées par l'appli (signup_post.php, delete_account.php),
-- absentes de la base de prod (jamais migrées depuis le dump initial fmxx.sql).
-- Pas de DEFINER=root explicite (cet utilisateur n'existe pas sur o2switch) :
-- on laisse MySQL utiliser CURRENT_USER, l'utilisateur qui exécute ce script.
-- À exécuter en production (phpMyAdmin o2switch) en plus du local.

DELIMITER $$

DROP PROCEDURE IF EXISTS `CheckUserExists`$$
CREATE PROCEDURE `CheckUserExists` (
    IN `p_username` VARCHAR(100),
    IN `p_mail` VARCHAR(255),
    OUT `p_username_taken` TINYINT(1),
    OUT `p_mail_taken` TINYINT(1)
)
BEGIN
    SELECT COUNT(*) INTO p_username_taken FROM user WHERE username = p_username;
    SELECT COUNT(*) INTO p_mail_taken FROM user WHERE mail = p_mail;
END$$

DROP PROCEDURE IF EXISTS `DeleteUser`$$
CREATE PROCEDURE `DeleteUser` (IN `p_idUser` INT)
BEGIN
    DELETE FROM mercato_arrivee WHERE idUser = p_idUser;
    DELETE FROM tactic        WHERE idUser = p_idUser;
    DELETE FROM objectif      WHERE idUser = p_idUser;
    DELETE FROM saison_meta   WHERE idUser = p_idUser;
    DELETE FROM joueur        WHERE idUser = p_idUser;
    DELETE FROM user          WHERE idUser = p_idUser;
END$$

DELIMITER ;
