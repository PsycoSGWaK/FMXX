<?php
/**
 * Sauvegarde complète de la base MySQL FMXX (toutes tables, tous comptes),
 * pensée pour être lancée par un cron sur l'hébergeur (o2switch) :
 *
 *   FMXX_BACKUP_DIR=/home/nayo1552/fmxx_backups php /home/nayo1552/repositories/FMXX/sql/backup_db.php
 *
 * IMPORTANT : FMXX_BACKUP_DIR DOIT pointer en dehors du webroot. Le document
 * root o2switch pointe directement sur ce dépôt (voir .htaccess), donc tout
 * fichier laissé dedans est potentiellement téléchargeable. Sans cette
 * variable, le script écrit par défaut dans sql/../backups — pratique pour
 * tester en local WAMP, à ne JAMAIS utiliser tel quel en production.
 *
 * Ne dépend d'aucun accès shell (mysqldump/exec, souvent désactivés en
 * mutualisé) : le dump est généré en PHP pur via PDO (DROP/CREATE/INSERT),
 * compressé en gzip. Conserve $keepDays jours de sauvegardes, purge le reste.
 *
 * Restauration : `zcat fmxx_backup_xxx.sql.gz | mysql -u user -p dbname`
 */

require_once __DIR__ . '/../db_config.php';

$keepDays = 14;

$backupDir = getenv('FMXX_BACKUP_DIR') ?: (__DIR__ . '/../backups');
if (!is_dir($backupDir) && !mkdir($backupDir, 0700, true) && !is_dir($backupDir)) {
    fwrite(STDERR, "Impossible de créer le dossier de sauvegarde : $backupDir\n");
    exit(1);
}

$config = fmxx_resolve_db_config();
try {
    $pdo = new PDO(
        "mysql:host={$config['host']};dbname={$config['name']};charset=utf8mb4",
        $config['user'],
        $config['pass'],
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    fwrite(STDERR, "Connexion BDD échouée : {$e->getMessage()}\n");
    exit(1);
}

$filename = 'fmxx_backup_' . date('Ymd_His') . '.sql.gz';
$filepath = rtrim($backupDir, '/\\') . '/' . $filename;

$gz = gzopen($filepath, 'w9');
if ($gz === false) {
    fwrite(STDERR, "Impossible d'écrire $filepath\n");
    exit(1);
}

gzwrite($gz, "-- Sauvegarde FMXX générée le " . date('c') . "\n");
gzwrite($gz, "SET NAMES utf8mb4;\nSET FOREIGN_KEY_CHECKS=0;\n\n");

$allTables = $pdo->query('SHOW FULL TABLES')->fetchAll(PDO::FETCH_NUM);
$tables = array_column(array_filter($allTables, fn($t) => $t[1] === 'BASE TABLE'), 0);
$views  = array_column(array_filter($allTables, fn($t) => $t[1] === 'VIEW'), 0);

foreach ($tables as $table) {
    $quoted = '`' . str_replace('`', '``', $table) . '`';

    gzwrite($gz, "-- Table $quoted\n");
    gzwrite($gz, "DROP TABLE IF EXISTS $quoted;\n");
    $createRow = $pdo->query("SHOW CREATE TABLE $quoted")->fetch(PDO::FETCH_ASSOC);
    gzwrite($gz, $createRow['Create Table'] . ";\n\n");

    $stmt = $pdo->query("SELECT * FROM $quoted");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $columns = array_map(fn($c) => '`' . str_replace('`', '``', $c) . '`', array_keys($row));
        $values  = array_map(fn($v) => $v === null ? 'NULL' : $pdo->quote((string) $v), array_values($row));
        gzwrite($gz, "INSERT INTO $quoted (" . implode(',', $columns) . ") VALUES (" . implode(',', $values) . ");\n");
    }
    gzwrite($gz, "\n");
}

// Les vues sont recréées après les tables (elles peuvent en dépendre) ; pas
// de données à insérer, leur contenu est calculé dynamiquement.
foreach ($views as $view) {
    $quoted = '`' . str_replace('`', '``', $view) . '`';

    gzwrite($gz, "-- Vue $quoted\n");
    gzwrite($gz, "DROP VIEW IF EXISTS $quoted;\n");
    $createRow = $pdo->query("SHOW CREATE VIEW $quoted")->fetch(PDO::FETCH_ASSOC);
    gzwrite($gz, $createRow['Create View'] . ";\n\n");
}

gzwrite($gz, "SET FOREIGN_KEY_CHECKS=1;\n");
gzclose($gz);

fwrite(STDOUT, "Sauvegarde écrite : $filepath (" . count($tables) . " tables)\n");

// Rotation : supprime les sauvegardes plus vieilles que $keepDays jours.
$cutoff = time() - $keepDays * 86400;
foreach (glob(rtrim($backupDir, '/\\') . '/fmxx_backup_*.sql.gz') as $old) {
    if (filemtime($old) < $cutoff) {
        unlink($old);
        fwrite(STDOUT, "Ancienne sauvegarde supprimée : $old\n");
    }
}

exit(0);
