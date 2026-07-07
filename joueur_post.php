<?php
session_start();
require_once("db.php");
require_once("csrf.php");

if (!isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

csrf_verify();

$idUser   = $_SESSION['idUser'];
$idJoueur = (int)($_POST['idJoueur'] ?? 0);

if (!$idJoueur) {
    header("Location: index.php?tab=effectif");
    exit;
}

// Vérifier que le joueur appartient bien à l'utilisateur
$check = $pdo->prepare("SELECT idJoueur FROM joueur WHERE idJoueur = :id AND idUser = :idUser");
$check->execute(['id' => $idJoueur, 'idUser' => $idUser]);
if (!$check->fetch()) {
    header("Location: index.php?tab=effectif");
    exit;
}

$nom            = trim($_POST['nom'] ?? '');
$age            = $_POST['age'] !== '' ? (int)$_POST['age'] : null;
$numero         = $_POST['numero'] !== '' ? (int)$_POST['numero'] : null;
$nat            = trim($_POST['nat'] ?? '') ?: null;
$pdn            = trim($_POST['pdn'] ?? '') ?: null;
$poste          = trim($_POST['poste'] ?? '') ?: null;
$expireContrat  = trim($_POST['expireContrat'] ?? '') ?: null;
$mercatoStatus  = in_array($_POST['mercato_status'] ?? '', ['sell', 'loan', 'free']) ? $_POST['mercato_status'] : null;

$stmt = $pdo->prepare(
    "UPDATE joueur SET nom = :nom, age = :age, numero = :numero, nat = :nat, pdn = :pdn,
     poste = :poste, expireContrat = :expireContrat, mercato_status = :mercato_status
     WHERE idJoueur = :id AND idUser = :idUser"
);
$stmt->execute([
    'nom'            => $nom,
    'age'            => $age,
    'numero'         => $numero,
    'nat'            => $nat,
    'pdn'            => $pdn,
    'poste'          => $poste,
    'expireContrat'  => $expireContrat,
    'mercato_status' => $mercatoStatus,
    'id'             => $idJoueur,
    'idUser'         => $idUser,
]);

header("Location: joueur.php?id={$idJoueur}&saved=1");
