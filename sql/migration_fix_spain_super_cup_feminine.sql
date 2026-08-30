-- La Supercoupe d'Espagne Feminine (Supercopa Femenina) a ete ajoutee
-- directement dans sql/fmxx.sql le 2026-07-07 (commit fbcc6e1), un fichier
-- de seed pour une base neuve -- jamais via une migration jouee sur la
-- prod existante. Consequence : la ligne `competition` n'a donc jamais
-- ete creee en prod, contrairement au local (recree depuis fmxx.sql).
-- migration_super_cups.sql (2026-08-30) a bien tente d'ajouter ses 2
-- regles de qualification "retroactivement", mais resolvait la
-- competition cible par un JOIN sur son nom -- sans la ligne, le JOIN ne
-- matchait rien et n'inserait rien, silencieusement, aucune erreur.
--
-- Idempotent : chaque INSERT est protege par WHERE NOT EXISTS resolu par
-- cle naturelle (nom + pays + genre), jamais par id en dur (lecon de
-- migration_fix_prod_data_integrity.sql).

-- ---------------------------------------------------------------------
-- La competition manquante
-- ---------------------------------------------------------------------
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `division`, `genre`)
SELECT 'Supercoupe d Espagne Feminine', 'Ligue', p.idPays, 'D1', 'F'
FROM `pays` p
WHERE p.nomPays = 'Spain'
  AND NOT EXISTS (
      SELECT 1 FROM `competition` c
      WHERE c.nomCompetition = 'Supercoupe d Espagne Feminine'
        AND c.idPays = p.idPays
        AND c.genre = 'F'
  );

-- ---------------------------------------------------------------------
-- Ses 2 regles de qualification (OR) : championne de Liga F, ou
-- vainqueur de la Copa de la Reina la saison precedente -- meme
-- mecanisme que la version masculine (idRule 83/114 en local).
-- ---------------------------------------------------------------------
INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`, `resultat_exact`)
SELECT sc.idCompetition, src.idCompetition, 1, 1, NULL
FROM `competition` sc
JOIN `pays` p ON p.nomPays = 'Spain'
JOIN `competition` src ON src.nomCompetition = 'Liga F' AND src.idPays = p.idPays AND src.genre = 'F'
WHERE sc.nomCompetition = 'Supercoupe d Espagne Feminine' AND sc.idPays = p.idPays AND sc.genre = 'F'
  AND NOT EXISTS (
      SELECT 1 FROM `competition_qualif_rule` r
      WHERE r.idCompetition = sc.idCompetition AND r.idCompetitionSource = src.idCompetition
  );

INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `rang_min`, `rang_max`, `resultat_exact`)
SELECT sc.idCompetition, src.idCompetition, NULL, NULL, 'Gagner'
FROM `competition` sc
JOIN `pays` p ON p.nomPays = 'Spain'
JOIN `competition` src ON src.nomCompetition = 'Copa de la Reina' AND src.idPays = p.idPays AND src.genre = 'F'
WHERE sc.nomCompetition = 'Supercoupe d Espagne Feminine' AND sc.idPays = p.idPays AND sc.genre = 'F'
  AND NOT EXISTS (
      SELECT 1 FROM `competition_qualif_rule` r
      WHERE r.idCompetition = sc.idCompetition AND r.idCompetitionSource = src.idCompetition
  );
