-- Migration : préparation import équipes via API-Football
-- 1. Suppression des colonnes couleur (jamais utilisées)
ALTER TABLE equipe
  DROP COLUMN couleur1,
  DROP COLUMN couleur2,
  DROP COLUMN couleur3;

-- 2. Ajout des nouveaux pays nécessaires aux championnats demandés
-- NB : Wales n'a pas de code ISO 3166-1 officiel (c'est une nation du
-- Royaume-Uni, code ISO 3166-2 = GB-WLS). Codes WL/WAL/0 utilisés ici
-- comme convention interne pour distinguer les championnats gallois
-- de ceux d'Angleterre (tous deux sous idPays GB sinon).
INSERT INTO pays (nomPays, paysA2C, paysA3C, paysNum) VALUES
  ('United States', 'US', 'USA', 840),
  ('Japan', 'JP', 'JPN', 392),
  ('Wales', 'WL', 'WAL', 0),
  ('Sweden', 'SE', 'SWE', 752),
  ('Austria', 'AT', 'AUT', 40),
  ('Belgium', 'BE', 'BEL', 56),
  ('Brazil', 'BR', 'BRA', 76),
  ('Netherlands', 'NL', 'NLD', 528),
  ('Portugal', 'PT', 'PRT', 620),
  ('Turkey', 'TR', 'TUR', 792);
