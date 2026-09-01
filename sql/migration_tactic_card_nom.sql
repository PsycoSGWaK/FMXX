-- Nom personnalise pour une card tactique (bouton "renommer" dans la vue
-- detail de l'onglet Tactic Sub). NULL = pas de nom personnalise, l'UI
-- retombe alors sur le libelle par defaut "Style tactique N".
-- A executer en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `tactic_card` ADD COLUMN `nom` varchar(60) DEFAULT NULL AFTER `idTacticPreset`;
