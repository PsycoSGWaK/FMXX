-- Renommage structurel de la saison 2026-27 en France (confirme par
-- Guillaume) : l'ancienne "National" (D3) devient "Ligue 3", et
-- l'ancienne "National 2" (D4) recupere le nom "National". Meme
-- structure de divisions, juste un decalage des noms d'un cran.

UPDATE `competition` SET `nomCompetition` = 'Ligue 3' WHERE `idCompetition` = 23;
UPDATE `competition` SET `nomCompetition` = 'National' WHERE `idCompetition` = 68;
