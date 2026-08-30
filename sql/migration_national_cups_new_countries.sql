-- Coupes nationales (type Nationale) pour les 15 pays ajoutes via la
-- consolidation SportMonks. Noms verifies par recherche web avant
-- insertion (pas de sponsor, nom natif quand c'est la convention deja
-- suivie pour les pays d'origine : DFB-Pokal, Copa del Rey, Coppa
-- Italia...).
--
-- Cote femmes : uniquement les pays ayant a la fois un championnat F D1
-- tracke ET une vraie coupe nationale feminine confirmee. Verifie
-- explicitement l'absence de coupe feminine nationale pour :
--   - Australie (Women's Australia Cup annoncee en 2023, jamais lancee)
--   - Etats-Unis (pas d'equivalent feminin du US Open Cup pour la NWSL)
--
-- A executer en production (phpMyAdmin o2switch) en plus du local.

INSERT INTO `competition` (`nomCompetition`, `typeCompetition`, `idPays`, `genre`) VALUES
-- Hommes
('ÖFB-Cup', 'Nationale', 10, 'M'),           -- Autriche
('Belgian Cup', 'Nationale', 11, 'M'),        -- Belgique
('Copa do Brasil', 'Nationale', 12, 'M'),     -- Bresil
('KNVB Cup', 'Nationale', 13, 'M'),           -- Pays-Bas
('Taça de Portugal', 'Nationale', 14, 'M'),   -- Portugal
('Türkiye Kupası', 'Nationale', 15, 'M'),     -- Turquie
('Emperor''s Cup', 'Nationale', 7, 'M'),      -- Japon
('U.S. Open Cup', 'Nationale', 6, 'M'),       -- Etats-Unis
('Svenska Cupen', 'Nationale', 9, 'M'),       -- Suede
('DBU Pokalen', 'Nationale', 16, 'M'),        -- Danemark
('Scottish Cup', 'Nationale', 17, 'M'),       -- Ecosse
('FAI Cup', 'Nationale', 19, 'M'),            -- Irlande
('Irish Cup', 'Nationale', 18, 'M'),          -- Irlande du Nord
('Australia Cup', 'Nationale', 20, 'M'),      -- Australie
('Welsh Cup', 'Nationale', 8, 'M'),           -- Pays de Galles

-- Femmes (uniquement ou une coupe feminine nationale confirmee existe)
('DBU KvindePokalen', 'Nationale', 16, 'F'),  -- Danemark
('Svenska Cupen Damer', 'Nationale', 9, 'F'), -- Suede
('FAW Women''s Cup', 'Nationale', 8, 'F'),    -- Pays de Galles
('Empress''s Cup', 'Nationale', 7, 'F');      -- Japon
