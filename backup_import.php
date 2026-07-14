<?php
/**
 * Réimport d'une sauvegarde JSON générée par backup_export.php. Les données de jeu
 * actuelles du compte connecté (effectif, tactique, objectifs, saisons, arrivées mercato)
 * sont d'abord purgées, puis remplacées par le contenu du fichier. Les données sont
 * réinjectées sous le idUser de la session courante (jamais sous un idUser fourni par
 * le fichier), les identifiants de connexion (username/mail/password) ne sont jamais
 * touchés, et les idJoueur sont remappés vers les nouveaux ID générés pour préserver
 * les liaisons de la table tactic.
 */
session_start();
require_once("db.php");
require_once("csrf.php");

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}

csrf_verify();
$idUser = $_SESSION['idUser'];

const MAX_ROWS = 2000;

function backupFail(string $msg): never {
    header("Location: index.php?backup_error=" . urlencode($msg));
    exit;
}

if (!isset($_FILES['backup_file']) || $_FILES['backup_file']['error'] !== UPLOAD_ERR_OK) {
    backupFail('upload');
}

$file = $_FILES['backup_file'];
if ($file['size'] > 5 * 1024 * 1024) {
    backupFail('size');
}

$content = file_get_contents($file['tmp_name']);
$data = json_decode($content, true);

if (!is_array($data) || ($data['format'] ?? '') !== 'fmxx_backup') {
    backupFail('format');
}

$userData     = is_array($data['user'] ?? null) ? $data['user'] : null;
$saisonData   = is_array($data['saison_meta'] ?? null) ? $data['saison_meta'] : [];
$objectifData = is_array($data['objectif'] ?? null) ? $data['objectif'] : [];
$joueurData   = is_array($data['joueur'] ?? null) ? $data['joueur'] : [];
$tacticData   = is_array($data['tactic'] ?? null) ? $data['tactic'] : [];
$arriveeData  = is_array($data['mercato_arrivee'] ?? null) ? $data['mercato_arrivee'] : [];

foreach ([$saisonData, $objectifData, $joueurData, $tacticData, $arriveeData] as $set) {
    if (count($set) > MAX_ROWS) {
        backupFail('too_large');
    }
}

try {
    // Purge des données de jeu actuelles du compte avant réinjection (jamais la ligne user elle-même)
    foreach (['mercato_arrivee', 'tactic', 'objectif', 'saison_meta', 'joueur'] as $table) {
        $pdo->prepare("DELETE FROM $table WHERE idUser = :idUser")->execute(['idUser' => $idUser]);
    }

    // Profil (jamais username/mail/password)
    if ($userData) {
        $stmt = $pdo->prepare("
            UPDATE user SET club=:club, division=:division, formation=:formation, genre=:genre,
                idPays=:idPays, saison_active=:saison_active, budget_transfert=:budget_transfert,
                budget_salaires=:budget_salaires, comp_europe_override=:comp_europe_override
            WHERE idUser = :idUser
        ");
        $stmt->execute([
            'club'                 => $userData['club'] ?? null,
            'division'             => $userData['division'] ?? null,
            'formation'            => $userData['formation'] ?? null,
            'genre'                => in_array($userData['genre'] ?? null, ['M', 'F'], true) ? $userData['genre'] : 'M',
            'idPays'               => isset($userData['idPays']) ? (int)$userData['idPays'] : null,
            'saison_active'        => $userData['saison_active'] ?? null,
            'budget_transfert'     => isset($userData['budget_transfert']) ? (int)$userData['budget_transfert'] : null,
            'budget_salaires'      => isset($userData['budget_salaires']) ? (int)$userData['budget_salaires'] : null,
            'comp_europe_override' => isset($userData['comp_europe_override']) ? (int)$userData['comp_europe_override'] : null,
            'idUser'               => $idUser,
        ]);
    }

    // Joueurs : réinsertion avec nouveaux idJoueur, on garde la correspondance ancien->nouveau
    $joueurMap = [];
    $insJoueur = $pdo->prepare("
        INSERT INTO joueur (positionTact, nom, age, numero, nat, pdn, poste, app, pDec, buts, noteMoy,
            montantTransfert, idUser, mercato_status, prixDemande, expireContrat)
        VALUES (:positionTact, :nom, :age, :numero, :nat, :pdn, :poste, :app, :pDec, :buts, :noteMoy,
            :montantTransfert, :idUser, :mercato_status, :prixDemande, :expireContrat)
    ");
    foreach ($joueurData as $j) {
        if (empty($j['nom'])) continue;
        $statut = in_array($j['mercato_status'] ?? null, ['sell', 'loan', 'free'], true) ? $j['mercato_status'] : null;
        $insJoueur->execute([
            'positionTact'      => $j['positionTact'] ?? null,
            'nom'               => (string)$j['nom'],
            'age'               => isset($j['age']) ? (int)$j['age'] : null,
            'numero'            => isset($j['numero']) ? (int)$j['numero'] : null,
            'nat'               => $j['nat'] ?? null,
            'pdn'               => $j['pdn'] ?? null,
            'poste'             => $j['poste'] ?? null,
            'app'               => $j['app'] ?? null,
            'pDec'              => $j['pDec'] ?? null,
            'buts'              => $j['buts'] ?? null,
            'noteMoy'           => $j['noteMoy'] ?? null,
            'montantTransfert'  => $j['montantTransfert'] ?? null,
            'idUser'            => $idUser,
            'mercato_status'    => $statut,
            'prixDemande'       => isset($j['prixDemande']) ? (int)$j['prixDemande'] : null,
            'expireContrat'     => $j['expireContrat'] ?? null,
        ]);
        if (isset($j['idJoueur'])) {
            $joueurMap[(int)$j['idJoueur']] = (int)$pdo->lastInsertId();
        }
    }

    // Saisons
    $insSaison = $pdo->prepare("
        INSERT IGNORE INTO saison_meta (idUser, saison, club, division, genre, idPays)
        VALUES (:idUser, :saison, :club, :division, :genre, :idPays)
    ");
    foreach ($saisonData as $s) {
        if (empty($s['saison'])) continue;
        $insSaison->execute([
            'idUser'   => $idUser,
            'saison'   => (string)$s['saison'],
            'club'     => $s['club'] ?? null,
            'division' => $s['division'] ?? null,
            'genre'    => in_array($s['genre'] ?? null, ['M', 'F'], true) ? $s['genre'] : 'M',
            'idPays'   => isset($s['idPays']) ? (int)$s['idPays'] : null,
        ]);
    }

    // Objectifs (idCompetition référence le référentiel global, réutilisé tel quel)
    $insObjectif = $pdo->prepare("
        INSERT IGNORE INTO objectif (idUser, idCompetition, objectif, saison, resultat)
        VALUES (:idUser, :idCompetition, :objectif, :saison, :resultat)
    ");
    foreach ($objectifData as $o) {
        if (empty($o['idCompetition']) || empty($o['saison'])) continue;
        $insObjectif->execute([
            'idUser'        => $idUser,
            'idCompetition' => (int)$o['idCompetition'],
            'objectif'      => $o['objectif'] ?? null,
            'saison'        => (string)$o['saison'],
            'resultat'      => $o['resultat'] ?? null,
        ]);
    }

    // Tactique : remap des idJoueur vers les nouveaux ID
    $insTactic = $pdo->prepare("
        INSERT INTO tactic (position, titulaire, remplacant, supersub, idUser)
        VALUES (:position, :titulaire, :remplacant, :supersub, :idUser)
    ");
    $remap = fn($oldId) => $oldId !== null && isset($joueurMap[(int)$oldId]) ? $joueurMap[(int)$oldId] : null;
    foreach ($tacticData as $tac) {
        if (!isset($tac['position'])) continue;
        $insTactic->execute([
            'position'   => (int)$tac['position'],
            'titulaire'  => $remap($tac['titulaire'] ?? null),
            'remplacant' => $remap($tac['remplacant'] ?? null),
            'supersub'   => $remap($tac['supersub'] ?? null),
            'idUser'     => $idUser,
        ]);
    }

    // Arrivées mercato
    $insArrivee = $pdo->prepare("
        INSERT INTO mercato_arrivee (idUser, nom, poste, prix, statut)
        VALUES (:idUser, :nom, :poste, :prix, :statut)
    ");
    foreach ($arriveeData as $a) {
        if (empty($a['nom'])) continue;
        $statut = in_array($a['statut'] ?? null, ['cible', 'nego', 'signe'], true) ? $a['statut'] : 'cible';
        $insArrivee->execute([
            'idUser' => $idUser,
            'nom'    => (string)$a['nom'],
            'poste'  => $a['poste'] ?? null,
            'prix'   => isset($a['prix']) ? (int)$a['prix'] : null,
            'statut' => $statut,
        ]);
    }
} catch (\PDOException $e) {
    backupFail('db');
}

header("Location: index.php?backup_restored=1");
