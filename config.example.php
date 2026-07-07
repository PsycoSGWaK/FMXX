<?php
/**
 * Modèle de configuration pour le DÉPLOIEMENT.
 *
 * COPIER ce fichier en « config.php » sur le serveur d'hébergement, puis y mettre
 * les vrais identifiants de la base. config.php est ignoré par git (.gitignore) :
 * il ne doit JAMAIS être commité ni accessible par le navigateur.
 *
 * En local (WAMP), inutile de créer config.php : db.php retombe sur les valeurs
 * par défaut (localhost / root / sans mot de passe / base « fmxx »).
 *
 * Alternative : définir les variables d'environnement DB_HOST, DB_USER, DB_PASS,
 * DB_NAME (utile sur les hébergeurs qui exposent des variables d'env).
 */

return [
    'db_host' => 'localhost',          // souvent « localhost » ou un hôte fourni par l'hébergeur
    'db_user' => 'fmxx_user',          // utilisateur MySQL dédié (PAS root)
    'db_pass' => 'CHANGER_MOI',        // mot de passe fort
    'db_name' => 'fmxx',               // nom de la base (parfois préfixé par l'hébergeur)
];
