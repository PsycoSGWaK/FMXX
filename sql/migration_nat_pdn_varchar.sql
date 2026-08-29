-- joueur.nat et joueur.pdn étaient en VARCHAR(3), pensé pour des codes pays
-- ("ESP", "GER"). L'export FM26 donne des noms de pays complets en français
-- ("Espagne", "Allemagne", "États-Unis"...), silencieusement tronqués à 3
-- caractères par MySQL depuis toujours — bug préexistant, indépendant de
-- l'import du salaire. Élargi pour accueillir le nom complet.
-- À exécuter en production (phpMyAdmin o2switch) en plus du local.

ALTER TABLE `joueur`
    MODIFY COLUMN `nat` VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    MODIFY COLUMN `pdn` VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL;
