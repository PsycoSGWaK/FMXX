-- Verification en LECTURE SEULE apres application de :
--   1) migration_uefa_extend_new_countries.sql (version corrigee)
--   2) migration_fix_prod_data_integrity.sql
-- A executer dans phpMyAdmin, resultat a copier-coller.

-- 1) FIFA Women Champions Cup existe et a bien sa regle de qualification
--    (attendu : 1 ligne, resultat_exact = 'Gagner', source = UEFA Women's
--    Champions League)
SELECT fwc.idCompetition AS id_fwc, fwc.nomCompetition, r.idCompetitionSource, src.nomCompetition AS nom_source, r.resultat_exact
FROM competition fwc
LEFT JOIN competition_qualif_rule r ON r.idCompetition = fwc.idCompetition
LEFT JOIN competition src ON src.idCompetition = r.idCompetitionSource
WHERE fwc.nomCompetition = 'FIFA Women Champions Cup';

-- 2) Plus aucune regle attachee a l'ancien id=48 errone (Pro League) ;
--    doit retourner un resultat vide
SELECT r.idRule, r.idCompetition, c.nomCompetition
FROM competition_qualif_rule r
JOIN competition c ON c.idCompetition = r.idCompetition
WHERE c.nomCompetition = 'Pro League' AND r.resultat_exact = 'Gagner';

-- 3) Denmark D2 correctement nomme "1. Division", aucun doublon
SELECT idCompetition, nomCompetition, idPays, division, genre
FROM competition
WHERE idPays = 16 AND division = 'D2' AND genre = 'M';

-- 4) France D4 correctement renommee "National" (plus de "National 2")
SELECT idCompetition, nomCompetition, idPays, division, genre
FROM competition
WHERE idPays = 5 AND division = 'D4' AND genre = 'M';

-- 5) Plus aucune regle dans la plage des 39 invalides (idRule 27-65) ;
--    doit retourner un resultat vide
SELECT idRule, idCompetition, idCompetitionSource
FROM competition_qualif_rule
WHERE idRule BETWEEN 27 AND 65;

-- 6) Danemark feminin a bien ses 2 regles UEFA (UWCL + Women's Europa
--    Cup), source = Elitedivisionen
SELECT r.idRule, r.idCompetition, cible.nomCompetition AS cible_nom, r.idCompetitionSource, src.nomCompetition AS source_nom, r.rang_min, r.rang_max
FROM competition_qualif_rule r
JOIN competition src ON src.idCompetition = r.idCompetitionSource
JOIN competition cible ON cible.idCompetition = r.idCompetition
WHERE src.nomCompetition = 'Elitedivisionen' AND src.idPays = 16;

-- 7) Compteurs globaux (a comparer avec le run precedent : plus aucun
--    doublon de competition, ni de club, ni de regle orpheline)
SELECT
    (SELECT COUNT(*) FROM pays) AS nb_pays,
    (SELECT COUNT(*) FROM competition) AS nb_competition,
    (SELECT COUNT(*) FROM equipe) AS nb_equipe,
    (SELECT COUNT(*) FROM competition_qualif_rule) AS nb_rule;

SELECT nomCompetition, idPays, genre, division, COUNT(*) AS n
FROM competition
GROUP BY nomCompetition, idPays, genre, division
HAVING COUNT(*) > 1;

SELECT r.idRule, r.idCompetition, r.idCompetitionSource
FROM competition_qualif_rule r
LEFT JOIN competition c1 ON c1.idCompetition = r.idCompetition
LEFT JOIN competition c2 ON c2.idCompetition = r.idCompetitionSource
WHERE c1.idCompetition IS NULL OR c2.idCompetition IS NULL;
