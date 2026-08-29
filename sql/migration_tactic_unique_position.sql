-- Cle unique (idUser, position) pour permettre l'auto-save ligne par ligne
-- de l'onglet Tactic Sub (UPSERT au lieu de DELETE+reinsertion complete).
-- A executer en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `tactic`
    ADD UNIQUE KEY `idUser_position` (`idUser`, `position`);
