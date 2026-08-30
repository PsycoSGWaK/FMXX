-- Corrige des incoherences propres a la production, decouvertes en
-- comparant un export CSV de prod (competition + competition_qualif_rule)
-- au local. Trois causes distinctes, toutes liees a des idCompetition
-- codes en dur qui supposaient (a tort) que les ids seraient identiques
-- entre local et prod :
--
-- 1) migration_qualif_rules.sql (executee en prod tres tot dans le
--    projet) suppose qu'une ligne `competition` "FIFA Women Champions
--    Cup" existe deja avec idCompetition=48. Cette ligne n'a en realite
--    JAMAIS ete creee en prod (elle n'existe qu'en local, ajoutee a la
--    main avant que ce fichier ne soit trace) -- en prod, id 48 designe
--    autre chose (Pro League, ajoutee bien plus tard). La regle
--    "qualifie en gagnant l'UEFA Women's Champions League" s'est donc
--    retrouvee attachee a la Pro League belge au lieu de la FIFA Women
--    Champions Cup -- LE bug que tout ce chantier devait resoudre a
--    l'origine, jamais corrige en prod faute de cette ligne manquante.
--
-- 2) migration_fix_france_d3_d4_names.sql utilise `WHERE idCompetition
--    = 68` en supposant que c'est la National 2 francaise (D4). En prod,
--    id 68 est en realite le D2 danois (1. Division, ajoute plus tard
--    via la consolidation SportMonks). Consequence : le D2 danois a ete
--    renomme "National" par erreur, la vraie National 2 francaise
--    (idCompetition 66) n'a jamais ete renommee, et le script idempotent
--    de migration_add_competitions_new_countries.sql a ensuite recree
--    un doublon "1. Division" (nouvel idCompetition) puisqu'il ne
--    retrouvait plus le nom d'origine.
--
-- 3) 39 lignes `competition_qualif_rule` invalides (idRule 27 a 65),
--    issues de la toute premiere tentative du script consolide : la
--    version non-idempotente de migration_uefa_extend_new_countries.sql
--    (ids en dur, avant sa reecriture) s'est executee avec succes avant
--    que le script echoue plus loin sur migration_super_cups.sql.
--    Verifie une a une : aucune ne pointe vers la bonne competition
--    source (ex. idCompetitionSource=49 au lieu de 47 pour l'Autriche).
--    Rejouer le script corrige a bien insere les 39 bonnes lignes a la
--    suite (idRule >= 128), les anciennes n'ont jamais ete nettoyees.
--
-- Idempotent : chaque etape peut etre rejouee sans effet si deja
-- appliquee. A executer en production (phpMyAdmin o2switch), une seule
-- fois suffit mais un second passage ne fait rien de plus.

-- ---------------------------------------------------------------------
-- 1) FIFA Women Champions Cup : cree la ligne manquante puis corrige la
--    regle de qualification pour pointer dessus (au lieu de id=48 en dur)
-- ---------------------------------------------------------------------
INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`)
SELECT 'FIFA Women Champions Cup', 'Continentale', NULL, 'F'
WHERE NOT EXISTS (
    SELECT 1 FROM `competition` WHERE nomCompetition = 'FIFA Women Champions Cup' AND genre = 'F'
);

DELETE FROM `competition_qualif_rule`
WHERE idRule = 26 AND idCompetition = 48 AND idCompetitionSource = 30 AND resultat_exact = 'Gagner';

INSERT INTO `competition_qualif_rule` (`idCompetition`, `idCompetitionSource`, `resultat_exact`)
SELECT fwc.idCompetition, uwcl.idCompetition, 'Gagner'
FROM `competition` fwc, `competition` uwcl
WHERE fwc.nomCompetition = 'FIFA Women Champions Cup' AND fwc.genre = 'F'
AND uwcl.nomCompetition = 'UEFA Women s Champions League' AND uwcl.typeCompetition = 'Continentale'
AND NOT EXISTS (
    SELECT 1 FROM `competition_qualif_rule` r
    WHERE r.idCompetition = fwc.idCompetition AND r.idCompetitionSource = uwcl.idCompetition AND r.resultat_exact = 'Gagner'
);

-- ---------------------------------------------------------------------
-- 2) Denmark D2 / France D4 : annule le mauvais renommage, supprime le
--    doublon cree entre-temps, applique le bon renommage francais
-- ---------------------------------------------------------------------
DELETE FROM `competition`
WHERE nomCompetition = '1. Division' AND idPays = 16 AND division = 'D2' AND genre = 'M' AND idCompetition <> 68;

UPDATE `competition` SET `nomCompetition` = '1. Division'
WHERE idCompetition = 68 AND idPays = 16 AND division = 'D2' AND genre = 'M';

UPDATE `competition` SET `nomCompetition` = 'National'
WHERE nomCompetition = 'National 2' AND idPays = 5 AND division = 'D4' AND genre = 'M';

-- ---------------------------------------------------------------------
-- 3) Purge les 39 regles invalides issues de la premiere tentative
--    (verifie une a une contre le CSV prod, aucune ne pointe juste)
-- ---------------------------------------------------------------------
DELETE FROM `competition_qualif_rule` WHERE idRule BETWEEN 27 AND 65;
