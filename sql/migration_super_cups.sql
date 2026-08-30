-- Super coupes nationales (champion du championnat vs vainqueur de la
-- coupe nationale), type Ligue. Existence + nom reels verifies par
-- recherche web pays par pays avant insertion. Volontairement absentes
-- (confirme inexistantes ou discontinuees, pas d'invention) :
-- Autriche (arretee en 2004), Danemark (irreguliere/inactive recemment),
-- Ecosse, Australie, Pays de Galles, Etats-Unis (aucune n'existe),
-- Angleterre F (Women's Community Shield arretee apres 2020),
-- Japon F (aucune equivalence femme).
--
-- Chaque super coupe recoit 2 regles de qualification (OR, meme
-- mecanisme que FIFA Women Champions Cup) : etre champion du
-- championnat national OU avoir gagne la coupe nationale la saison
-- precedente. Applique aussi retroactivement aux 2 super coupes
-- espagnoles deja en base (jusqu'ici affichees sans condition).
--
-- Reecrit le 2026-08-30 : la premiere version utilisait la syntaxe
-- "VALUES ROW(...)" (constructeur de lignes), qui necessite MySQL
-- 8.0.19+ et a echoue en prod (hebergeur sur une version plus ancienne
-- ou MariaDB). Remplace par du UNION ALL SELECT, portable partout.
-- Les INSERT INTO competition sont aussi rendus rejouables sans
-- doublon (WHERE NOT EXISTS) au cas ou la version precedente aurait
-- deja partiellement reussi.
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- ---------------------------------------------------------------------
-- Nouvelles competitions (rejouable sans creer de doublon)
-- ---------------------------------------------------------------------
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`)
SELECT * FROM (
    SELECT 'Trophée des Champions' AS n, 'Ligue' AS t, 5 AS p, 'M' AS g
    UNION ALL SELECT 'DFL-Supercup', 'Ligue', 3, 'M'
    UNION ALL SELECT 'Supercoppa Italiana', 'Ligue', 4, 'M'
    UNION ALL SELECT 'Community Shield', 'Ligue', 1, 'M'
    UNION ALL SELECT 'Belgian Super Cup', 'Ligue', 11, 'M'
    UNION ALL SELECT 'Johan Cruyff Shield', 'Ligue', 13, 'M'
    UNION ALL SELECT 'Supertaça de Portugal', 'Ligue', 14, 'M'
    UNION ALL SELECT 'Supercopa do Brasil', 'Ligue', 12, 'M'
    UNION ALL SELECT 'Turkish Super Cup', 'Ligue', 15, 'M'
    UNION ALL SELECT 'Japanese Super Cup', 'Ligue', 7, 'M'
    UNION ALL SELECT 'Svenska Supercupen', 'Ligue', 9, 'M'
    UNION ALL SELECT 'President of Ireland''s Cup', 'Ligue', 19, 'M'
    UNION ALL SELECT 'NIFL Charity Shield', 'Ligue', 18, 'M'
    UNION ALL SELECT 'Trophée des Championnes', 'Ligue', 5, 'F'
    UNION ALL SELECT 'DFB-Supercup Frauen', 'Ligue', 3, 'F'
    UNION ALL SELECT 'Supercoppa Italiana Femminile', 'Ligue', 4, 'F'
    UNION ALL SELECT 'Svenska Supercupen Damer', 'Ligue', 9, 'F'
) AS nouvelles
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` c
    WHERE c.nomCompetition = nouvelles.n AND c.idPays = nouvelles.p AND c.genre = nouvelles.g
);

-- ---------------------------------------------------------------------
-- Regles de qualification (OR : champion du championnat, ou vainqueur
-- de la coupe nationale). Resolution par sous-requete nomCompetition +
-- idPays + genre pour rester valable quels que soient les
-- AUTO_INCREMENT reels en prod. Chaque INSERT...SELECT est rejouable
-- sans doublon (WHERE NOT EXISTS).
-- ---------------------------------------------------------------------
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`)
SELECT sc.idCompetition, champ.idCompetition, 1, 1
FROM (
    SELECT 'Trophée des Champions' AS sc_nom, 5 AS sc_pays, 'M' AS sc_genre, 'Ligue 1' AS champ_nom, 5 AS champ_pays, 'M' AS champ_genre
    UNION ALL SELECT 'DFL-Supercup', 3, 'M', 'Bundesliga', 3, 'M'
    UNION ALL SELECT 'Supercoppa Italiana', 4, 'M', 'Serie A', 4, 'M'
    UNION ALL SELECT 'Community Shield', 1, 'M', 'Premier League', 1, 'M'
    UNION ALL SELECT 'Belgian Super Cup', 11, 'M', 'Pro League', 11, 'M'
    UNION ALL SELECT 'Johan Cruyff Shield', 13, 'M', 'Eredivisie', 13, 'M'
    UNION ALL SELECT 'Supertaça de Portugal', 14, 'M', 'Primeira Liga', 14, 'M'
    UNION ALL SELECT 'Supercopa do Brasil', 12, 'M', 'Campeonato Brasileiro Série A', 12, 'M'
    UNION ALL SELECT 'Turkish Super Cup', 15, 'M', 'Süper Lig', 15, 'M'
    UNION ALL SELECT 'Japanese Super Cup', 7, 'M', 'J1 League', 7, 'M'
    UNION ALL SELECT 'Svenska Supercupen', 9, 'M', 'Allsvenskan', 9, 'M'
    UNION ALL SELECT 'President of Ireland''s Cup', 19, 'M', 'League of Ireland Premier Division', 19, 'M'
    UNION ALL SELECT 'NIFL Charity Shield', 18, 'M', 'NIFL Premiership', 18, 'M'
    UNION ALL SELECT 'Trophée des Championnes', 5, 'F', 'Première Ligue', 5, 'F'
    UNION ALL SELECT 'DFB-Supercup Frauen', 3, 'F', 'Frauen-Bundesliga', 3, 'F'
    UNION ALL SELECT 'Supercoppa Italiana Femminile', 4, 'F', 'Serie A Femminile', 4, 'F'
    UNION ALL SELECT 'Svenska Supercupen Damer', 9, 'F', 'Damallsvenskan', 9, 'F'
    UNION ALL SELECT 'Supercoupe d Espagne', 2, 'M', 'LaLiga', 2, 'M'
    UNION ALL SELECT 'Supercoupe d Espagne Feminine', 2, 'F', 'Liga F', 2, 'F'
) AS m
JOIN `competition` sc ON sc.nomCompetition = m.sc_nom AND sc.idPays = m.sc_pays AND sc.genre = m.sc_genre
JOIN `competition` champ ON champ.nomCompetition = m.champ_nom AND champ.idPays = m.champ_pays AND champ.genre = m.champ_genre AND champ.typeCompetition = 'Championnat'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = sc.idCompetition AND r.idCompetitionSource = champ.idCompetition AND r.rang_min = 1
);

INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `resultat_exact`)
SELECT sc.idCompetition, cup.idCompetition, 'Gagner'
FROM (
    SELECT 'Trophée des Champions' AS sc_nom, 5 AS sc_pays, 'M' AS sc_genre, 'Coupe de France' AS cup_nom, 5 AS cup_pays, 'M' AS cup_genre
    UNION ALL SELECT 'DFL-Supercup', 3, 'M', 'DFB-Pokal', 3, 'M'
    UNION ALL SELECT 'Supercoppa Italiana', 4, 'M', 'Coppa Italia', 4, 'M'
    UNION ALL SELECT 'Community Shield', 1, 'M', 'FA Cup', 1, 'M'
    UNION ALL SELECT 'Belgian Super Cup', 11, 'M', 'Belgian Cup', 11, 'M'
    UNION ALL SELECT 'Johan Cruyff Shield', 13, 'M', 'KNVB Cup', 13, 'M'
    UNION ALL SELECT 'Supertaça de Portugal', 14, 'M', 'Taça de Portugal', 14, 'M'
    UNION ALL SELECT 'Supercopa do Brasil', 12, 'M', 'Copa do Brasil', 12, 'M'
    UNION ALL SELECT 'Turkish Super Cup', 15, 'M', 'Türkiye Kupası', 15, 'M'
    UNION ALL SELECT 'Japanese Super Cup', 7, 'M', 'Emperor''s Cup', 7, 'M'
    UNION ALL SELECT 'Svenska Supercupen', 9, 'M', 'Svenska Cupen', 9, 'M'
    UNION ALL SELECT 'President of Ireland''s Cup', 19, 'M', 'FAI Cup', 19, 'M'
    UNION ALL SELECT 'NIFL Charity Shield', 18, 'M', 'Irish Cup', 18, 'M'
    UNION ALL SELECT 'Trophée des Championnes', 5, 'F', 'Coupe de France Féminine', 5, 'F'
    UNION ALL SELECT 'DFB-Supercup Frauen', 3, 'F', 'DFB-Pokal Frauen', 3, 'F'
    UNION ALL SELECT 'Supercoppa Italiana Femminile', 4, 'F', 'Coppa Italia Femminile', 4, 'F'
    UNION ALL SELECT 'Svenska Supercupen Damer', 9, 'F', 'Svenska Cupen Damer', 9, 'F'
    UNION ALL SELECT 'Supercoupe d Espagne', 2, 'M', 'Copa del Rey', 2, 'M'
    UNION ALL SELECT 'Supercoupe d Espagne Feminine', 2, 'F', 'Copa de la Reina', 2, 'F'
) AS m
JOIN `competition` sc ON sc.nomCompetition = m.sc_nom AND sc.idPays = m.sc_pays AND sc.genre = m.sc_genre
JOIN `competition` cup ON cup.nomCompetition = m.cup_nom AND cup.idPays = m.cup_pays AND cup.genre = m.cup_genre AND cup.typeCompetition = 'Nationale'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = sc.idCompetition AND r.idCompetitionSource = cup.idCompetition AND r.resultat_exact = 'Gagner'
);
