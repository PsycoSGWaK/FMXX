-- Diagnostic en LECTURE SEULE (aucune ecriture) pour verifier l'etat du
-- catalogue en prod apres l'execution de migration_ALL_2026-08-30.sql.
-- A coller tel quel dans l'onglet SQL de phpMyAdmin, resultat a copier-coller.

-- 1) Compteurs globaux (a comparer avec le local : pays=20, competition=125,
--    equipe=927, competition_qualif_rule=103)
SELECT
    (SELECT COUNT(*) FROM pays) AS nb_pays,
    (SELECT COUNT(*) FROM competition) AS nb_competition,
    (SELECT COUNT(*) FROM equipe) AS nb_equipe,
    (SELECT COUNT(*) FROM competition_qualif_rule) AS nb_rule,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'objectif' AND COLUMN_NAME = 'manuel') AS objectif_manuel_existe;

-- 2) Doublons de competition (meme nom/pays/genre/division) : ne devrait
--    rien remonter si les migrations idempotentes ont tourne proprement
SELECT nomCompetition, idPays, genre, division, COUNT(*) AS n
FROM competition
GROUP BY nomCompetition, idPays, genre, division
HAVING COUNT(*) > 1;

-- 3) Doublons de club (meme nom/pays/genre/division)
SELECT nomEquipe, idPays, genre, division, COUNT(*) AS n
FROM equipe
GROUP BY nomEquipe, idPays, genre, division
HAVING COUNT(*) > 1;

-- 4) Noms de competition suspects (encodage UTF-8 corrompu, signe qu'un
--    script serait passe par le CLI mysql brut plutot que phpMyAdmin/PDO)
SELECT idCompetition, nomCompetition, idPays, genre
FROM competition
WHERE nomCompetition LIKE '%�%' OR nomCompetition LIKE '%Ã%' OR nomCompetition LIKE '%â€%';

-- 5) Regles de qualification orphelines (pointent vers une competition
--    qui n'existe plus/pas)
SELECT r.idRule, r.idCompetition, r.idCompetitionSource
FROM competition_qualif_rule r
LEFT JOIN competition c1 ON c1.idCompetition = r.idCompetition
LEFT JOIN competition c2 ON c2.idCompetition = r.idCompetitionSource
WHERE c1.idCompetition IS NULL OR c2.idCompetition IS NULL;

-- 6) Detail des 20 competitions de type Ligue (super coupes) + nombre de
--    regles de qualification associees (attendu : 2 chacune, sauf les 2
--    espagnoles qui devraient aussi en avoir 2 desormais)
SELECT c.idCompetition, c.nomCompetition, c.idPays, c.genre, COUNT(r.idRule) AS nb_regles
FROM competition c
LEFT JOIN competition_qualif_rule r ON r.idCompetition = c.idCompetition
WHERE c.typeCompetition = 'Ligue'
GROUP BY c.idCompetition, c.nomCompetition, c.idPays, c.genre
ORDER BY c.nomCompetition;

-- 7) Pays avec un championnat sans aucun club (signe d'un import de clubs
--    manquant/rate)
SELECT c.idCompetition, c.nomCompetition, c.idPays, c.division, c.genre
FROM competition c
WHERE c.typeCompetition = 'Championnat'
AND NOT EXISTS (
    SELECT 1 FROM equipe e
    WHERE e.idPays = c.idPays AND e.genre = c.genre AND e.division = c.division
);
