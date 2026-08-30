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

-- Rejouable sans doublon (WHERE NOT EXISTS par nomCompetition/genre ;
-- idPays est NULL pour toutes, donc pas discriminant ici).
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`)
SELECT nouvelles.n, nouvelles.t, NULL, nouvelles.g FROM (
    SELECT 'Copa Libertadores' AS n, 'Continentale' AS t, 'M' AS g
    UNION ALL SELECT 'Copa Sudamericana', 'Continentale', 'M'
    UNION ALL SELECT 'Concacaf Champions Cup', 'Continentale', 'M'
    UNION ALL SELECT 'AFC Champions League Elite', 'Continentale', 'M'
    UNION ALL SELECT 'AFC Champions League Two', 'Continentale', 'M'
    UNION ALL SELECT 'AFC Women''s Champions League', 'Continentale', 'F'
    UNION ALL SELECT 'Concacaf W Champions Cup', 'Continentale', 'F'
) AS nouvelles
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` c
    WHERE c.nomCompetition = nouvelles.n AND c.genre = nouvelles.g
);
