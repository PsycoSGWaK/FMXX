-- Competitions continentales hors UEFA (CONMEBOL, CONCACAF, AFC), pour
-- les pays consolides sans equivalence europeenne (Bresil, Etats-Unis,
-- Japon, Australie). Ajoutees au catalogue SANS regle de qualification
-- automatique (competition_qualif_rule) : la qualification reelle melange
-- classement + vainqueur de coupe nationale + resultats continentaux de
-- l'annee precedente, trop complexe/incertain pour un rang simple sans
-- risquer une regle fausse. Rejoignent le filet de securite "+ Ajouter
-- une competition" (objectif_manuel_post.php) comme pour tout cas ou la
-- deduction automatique ne peut pas s'appliquer.
--
-- idPays = NULL (competitions globales, comme les competitions UEFA
-- existantes) : le rattachement au bon pays se fait via le contexte de
-- l'utilisateur, pas via une colonne idPays sur la ligne elle-meme.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
('Copa Libertadores', 'Continentale', NULL, 'M'),
('Copa Sudamericana', 'Continentale', NULL, 'M'),
('Concacaf Champions Cup', 'Continentale', NULL, 'M'),
('AFC Champions League Elite', 'Continentale', NULL, 'M'),
('AFC Champions League Two', 'Continentale', NULL, 'M'),
('AFC Women''s Champions League', 'Continentale', NULL, 'F'),
('Concacaf W Champions Cup', 'Continentale', NULL, 'F');
