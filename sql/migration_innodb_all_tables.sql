-- Passe le reste du schéma (historiquement MyISAM, comme joueur avant
-- migration_joueur_role.sql) en InnoDB : verrouillage ligne par ligne,
-- transactions, et cohérence avec joueur/joueur_role/competition_qualif_rule
-- /login_attempts déjà en InnoDB. Aucun index FULLTEXT/SPATIAL dans le
-- schéma (vérifié), conversion sans impact fonctionnel.
-- À exécuter en production (phpMyAdmin o2switch) en plus du local, après
-- migration_joueur_role.sql.

ALTER TABLE `competition` ENGINE=InnoDB;
ALTER TABLE `equipe` ENGINE=InnoDB;
ALTER TABLE `mercato_arrivee` ENGINE=InnoDB;
ALTER TABLE `objectif` ENGINE=InnoDB;
ALTER TABLE `participation` ENGINE=InnoDB;
ALTER TABLE `pays` ENGINE=InnoDB;
ALTER TABLE `saison_meta` ENGINE=InnoDB;
ALTER TABLE `tactic` ENGINE=InnoDB;
ALTER TABLE `tactic_card` ENGINE=InnoDB;
ALTER TABLE `tactic_preset` ENGINE=InnoDB;
ALTER TABLE `tactic_preset_slot` ENGINE=InnoDB;
ALTER TABLE `user` ENGINE=InnoDB;
