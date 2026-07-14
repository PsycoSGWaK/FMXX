<?php
session_start();
require_once("db.php");
require_once("csrf.php");

if (!isset($_SESSION['idUser']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: mercato.php");
    exit;
}

csrf_verify();
$idUser = $_SESSION['idUser'];

// Suppression totale
if (isset($_POST['delete_all'])) {
    $stmt = $pdo->prepare("DELETE FROM mercato_arrivee WHERE idUser = :idUser");
    $stmt->execute(['idUser' => $idUser]);
    header("Location: mercato.php?saved=1");
    exit;
}

// Suppression
if (isset($_POST['delete_id'])) {
    $id = (int)$_POST['delete_id'];
    $stmt = $pdo->prepare("DELETE FROM mercato_arrivee WHERE idArrivee = :id AND idUser = :idUser");
    $stmt->execute(['id' => $id, 'idUser' => $idUser]);
    header("Location: mercato.php?saved=1");
    exit;
}

$nom    = trim($_POST['nom'] ?? '');
$poste  = trim($_POST['poste'] ?? '');
$prix   = (isset($_POST['prix']) && $_POST['prix'] !== '') ? (int)$_POST['prix'] : null;
$statut = in_array($_POST['statut'] ?? '', ['cible','nego','signe']) ? $_POST['statut'] : 'cible';

if ($nom === '') {
    header("Location: mercato.php");
    exit;
}

// Modification
if (isset($_POST['edit_id'])) {
    $id = (int)$_POST['edit_id'];
    $stmt = $pdo->prepare("UPDATE mercato_arrivee SET nom=:nom, poste=:poste, prix=:prix, statut=:statut WHERE idArrivee=:id AND idUser=:idUser");
    $stmt->execute(['nom' => $nom, 'poste' => $poste, 'prix' => $prix, 'statut' => $statut, 'id' => $id, 'idUser' => $idUser]);
    header("Location: mercato.php?saved=1");
    exit;
}

// Ajout
$stmt = $pdo->prepare("INSERT INTO mercato_arrivee (idUser, nom, poste, prix, statut) VALUES (:idUser, :nom, :poste, :prix, :statut)");
$stmt->execute(['idUser' => $idUser, 'nom' => $nom, 'poste' => $poste, 'prix' => $prix, 'statut' => $statut]);

header("Location: mercato.php?saved=1");
exit;
