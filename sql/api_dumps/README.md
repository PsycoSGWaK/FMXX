# Dumps API-Football → import équipes

Ce dossier contient les **réponses brutes** de l'API-Football (endpoint `GET /teams`),
une réponse JSON par fichier, une ligue par fichier.

## Workflow (pour ne jamais payer 2× le même call)

1. Faire **1 call `/leagues`** une seule fois pour récupérer les `league.id` exacts
   (voir `leagues_ids.txt` à remplir au fur et à mesure).
2. Pour chaque ligue de la liste : appeler
   `GET https://v3.football.api-sports.io/teams?league=<ID>&season=2024`
   (saison 2024 = dernière saison accessible sur le plan gratuit)
   et **sauvegarder la réponse JSON complète** dans ce dossier sous le nom de slug
   attendu (colonne « fichier » du tableau dans `../import_teams_from_dumps.php`).
   Exemple : `de_bundesliga.json`, `gb_premier_league.json`, etc.
3. Lancer `php ../import_teams_from_dumps.php` (en CLI ou via le navigateur) :
   il lit tous les JSON présents et génère `../equipe_insert.sql`.
4. Vérifier le `.sql` généré, puis l'injecter en base (phpMyAdmin / ligne de commande).

## Notes
- Si une réponse contient `"errors"` non vide (ex: saison non autorisée sur le
  plan gratuit), le script l'ignore et le signale — on relancera ce call avec une
  autre saison. Saison cible = 2024 (dernière accessible en gratuit).
- Certaines divisions sont scindées en groupes régionaux côté API (ex: National 2
  français). Dans ce cas il y aura plusieurs fichiers JSON pour la même division :
  les nommer `fr_national_2_a.json`, `fr_national_2_b.json`, etc. et ajouter une
  ligne par fichier dans le tableau de config du script.
