<?php
/**
 * Sauvegarde complète des données de jeu de l'utilisateur (hors identifiants de connexion),
 * au format JSON, pensée pour être réimportée via backup_import.php après une suppression
 * puis recréation de compte. Les tables `competition` et `pays` sont des référentiels
 * globaux partagés entre comptes : leurs identifiants ne sont pas exportés, seulement
 * réutilisés tels quels.
 */
session_start();
require_once("db.php");

if (!isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

$idUser   = $_SESSION['idUser'];
$username = $_SESSION['username'] ?? 'user';

$userStmt = $pdo->prepare("
    SELECT club, division, formation, genre, idPays, saison_active, budget_transfert, budget_salaires, comp_europe_override
    FROM user WHERE idUser = :id
");
$userStmt->execute(['id' => $idUser]);
$userData = $userStmt->fetch();

$saisonStmt = $pdo->prepare("SELECT saison, club, division, genre, idPays FROM saison_meta WHERE idUser = :id");
$saisonStmt->execute(['id' => $idUser]);
$saisonData = $saisonStmt->fetchAll();

$objectifStmt = $pdo->prepare("SELECT idCompetition, objectif, saison, resultat FROM objectif WHERE idUser = :id");
$objectifStmt->execute(['id' => $idUser]);
$objectifData = $objectifStmt->fetchAll();

$joueurStmt = $pdo->prepare("
    SELECT idJoueur, positionTact, nom, age, numero, nat, pdn, poste, app, pDec, buts, noteMoy,
           montantTransfert, mercato_status, prixDemande, expireContrat
    FROM joueur WHERE idUser = :id
");
$joueurStmt->execute(['id' => $idUser]);
$joueurData = $joueurStmt->fetchAll();

$tacticStmt = $pdo->prepare("SELECT position, titulaire, remplacant, supersub FROM tactic WHERE idUser = :id");
$tacticStmt->execute(['id' => $idUser]);
$tacticData = $tacticStmt->fetchAll();

$arriveeStmt = $pdo->prepare("SELECT nom, poste, prix, statut FROM mercato_arrivee WHERE idUser = :id");
$arriveeStmt->execute(['id' => $idUser]);
$arriveeData = $arriveeStmt->fetchAll();

$backup = [
    'format'      => 'fmxx_backup',
    'version'     => 1,
    'exported_at' => date('c'),
    'user'        => $userData ?: null,
    'saison_meta' => $saisonData,
    'objectif'    => $objectifData,
    'joueur'      => $joueurData,
    'tactic'      => $tacticData,
    'mercato_arrivee' => $arriveeData,
];

$filename = 'fmxx_backup_' . preg_replace('/[^a-z0-9_]/i', '_', $username) . '_' . date('Ymd_His') . '.json';

header('Content-Type: application/json');
header('Content-Disposition: attachment; filename="' . $filename . '"');
echo json_encode($backup, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
