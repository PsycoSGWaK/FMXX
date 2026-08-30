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
-- A executer en production (phpMyAdmin o2switch) en plus du local.

-- ---------------------------------------------------------------------
-- Nouvelles competitions
-- ---------------------------------------------------------------------
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
-- Hommes
('Trophée des Champions', 'Ligue', 5, 'M'),      -- France
('DFL-Supercup', 'Ligue', 3, 'M'),                -- Allemagne
('Supercoppa Italiana', 'Ligue', 4, 'M'),         -- Italie
('Community Shield', 'Ligue', 1, 'M'),            -- Angleterre
('Belgian Super Cup', 'Ligue', 11, 'M'),          -- Belgique
('Johan Cruyff Shield', 'Ligue', 13, 'M'),        -- Pays-Bas
('Supertaça de Portugal', 'Ligue', 14, 'M'),      -- Portugal
('Supercopa do Brasil', 'Ligue', 12, 'M'),        -- Bresil
('Turkish Super Cup', 'Ligue', 15, 'M'),          -- Turquie
('Japanese Super Cup', 'Ligue', 7, 'M'),          -- Japon
('Svenska Supercupen', 'Ligue', 9, 'M'),          -- Suede
('President of Ireland''s Cup', 'Ligue', 19, 'M'),-- Irlande
('NIFL Charity Shield', 'Ligue', 18, 'M'),        -- Irlande du Nord

-- Femmes
('Trophée des Championnes', 'Ligue', 5, 'F'),     -- France
('DFB-Supercup Frauen', 'Ligue', 3, 'F'),         -- Allemagne
('Supercoppa Italiana Femminile', 'Ligue', 4, 'F'),-- Italie
('Svenska Supercupen Damer', 'Ligue', 9, 'F');    -- Suede

-- ---------------------------------------------------------------------
-- Regles de qualification (OR : champion du championnat, ou vainqueur
-- de la coupe nationale). Resolution par sous-requete nomCompetition +
-- idPays + genre pour rester valable quels que soient les
-- AUTO_INCREMENT reels en prod.
-- ---------------------------------------------------------------------
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`)
SELECT sc.idCompetition, champ.idCompetition, 1, 1
FROM (VALUES
    ROW('Trophée des Champions', 5, 'M', 'Ligue 1', 5, 'M', 'Championnat'),
    ROW('DFL-Supercup', 3, 'M', 'Bundesliga', 3, 'M', 'Championnat'),
    ROW('Supercoppa Italiana', 4, 'M', 'Serie A', 4, 'M', 'Championnat'),
    ROW('Community Shield', 1, 'M', 'Premier League', 1, 'M', 'Championnat'),
    ROW('Belgian Super Cup', 11, 'M', 'Pro League', 11, 'M', 'Championnat'),
    ROW('Johan Cruyff Shield', 13, 'M', 'Eredivisie', 13, 'M', 'Championnat'),
    ROW('Supertaça de Portugal', 14, 'M', 'Primeira Liga', 14, 'M', 'Championnat'),
    ROW('Supercopa do Brasil', 12, 'M', 'Campeonato Brasileiro Série A', 12, 'M', 'Championnat'),
    ROW('Turkish Super Cup', 15, 'M', 'Süper Lig', 15, 'M', 'Championnat'),
    ROW('Japanese Super Cup', 7, 'M', 'J1 League', 7, 'M', 'Championnat'),
    ROW('Svenska Supercupen', 9, 'M', 'Allsvenskan', 9, 'M', 'Championnat'),
    ROW('President of Ireland''s Cup', 19, 'M', 'League of Ireland Premier Division', 19, 'M', 'Championnat'),
    ROW('NIFL Charity Shield', 18, 'M', 'NIFL Premiership', 18, 'M', 'Championnat'),
    ROW('Trophée des Championnes', 5, 'F', 'Première Ligue', 5, 'F', 'Championnat'),
    ROW('DFB-Supercup Frauen', 3, 'F', 'Frauen-Bundesliga', 3, 'F', 'Championnat'),
    ROW('Supercoppa Italiana Femminile', 4, 'F', 'Serie A Femminile', 4, 'F', 'Championnat'),
    ROW('Svenska Supercupen Damer', 9, 'F', 'Damallsvenskan', 9, 'F', 'Championnat'),
    ROW('Supercoupe d Espagne', 2, 'M', 'LaLiga', 2, 'M', 'Championnat'),
    ROW('Supercoupe d Espagne Feminine', 2, 'F', 'Liga F', 2, 'F', 'Championnat')
) AS m(sc_nom, sc_pays, sc_genre, champ_nom, champ_pays, champ_genre, champ_type)
JOIN `competition` sc ON sc.nomCompetition = m.sc_nom AND sc.idPays = m.sc_pays AND sc.genre = m.sc_genre
JOIN `competition` champ ON champ.nomCompetition = m.champ_nom AND champ.idPays = m.champ_pays AND champ.genre = m.champ_genre AND champ.typeCompetition = m.champ_type;

INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `resultat_exact`)
SELECT sc.idCompetition, cup.idCompetition, 'Gagner'
FROM (VALUES
    ROW('Trophée des Champions', 5, 'M', 'Coupe de France', 5, 'M'),
    ROW('DFL-Supercup', 3, 'M', 'DFB-Pokal', 3, 'M'),
    ROW('Supercoppa Italiana', 4, 'M', 'Coppa Italia', 4, 'M'),
    ROW('Community Shield', 1, 'M', 'FA Cup', 1, 'M'),
    ROW('Belgian Super Cup', 11, 'M', 'Belgian Cup', 11, 'M'),
    ROW('Johan Cruyff Shield', 13, 'M', 'KNVB Cup', 13, 'M'),
    ROW('Supertaça de Portugal', 14, 'M', 'Taça de Portugal', 14, 'M'),
    ROW('Supercopa do Brasil', 12, 'M', 'Copa do Brasil', 12, 'M'),
    ROW('Turkish Super Cup', 15, 'M', 'Türkiye Kupası', 15, 'M'),
    ROW('Japanese Super Cup', 7, 'M', 'Emperor''s Cup', 7, 'M'),
    ROW('Svenska Supercupen', 9, 'M', 'Svenska Cupen', 9, 'M'),
    ROW('President of Ireland''s Cup', 19, 'M', 'FAI Cup', 19, 'M'),
    ROW('NIFL Charity Shield', 18, 'M', 'Irish Cup', 18, 'M'),
    ROW('Trophée des Championnes', 5, 'F', 'Coupe de France Féminine', 5, 'F'),
    ROW('DFB-Supercup Frauen', 3, 'F', 'DFB-Pokal Frauen', 3, 'F'),
    ROW('Supercoppa Italiana Femminile', 4, 'F', 'Coppa Italia Femminile', 4, 'F'),
    ROW('Svenska Supercupen Damer', 9, 'F', 'Svenska Cupen Damer', 9, 'F'),
    ROW('Supercoupe d Espagne', 2, 'M', 'Copa del Rey', 2, 'M'),
    ROW('Supercoupe d Espagne Feminine', 2, 'F', 'Copa de la Reina', 2, 'F')
) AS m(sc_nom, sc_pays, sc_genre, cup_nom, cup_pays, cup_genre)
JOIN `competition` sc ON sc.nomCompetition = m.sc_nom AND sc.idPays = m.sc_pays AND sc.genre = m.sc_genre
JOIN `competition` cup ON cup.nomCompetition = m.cup_nom AND cup.idPays = m.cup_pays AND cup.genre = m.cup_genre AND cup.typeCompetition = 'Nationale';
