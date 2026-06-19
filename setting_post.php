<?php
session_start();
require_once("db.php");

if (!isset($_SESSION['idUser'])) {
    header("Location: index.php");
    exit;
}

require_once("csrf.php");
csrf_verify();

$debutSaison = (int)($_POST['saison_active'] ?? 0);
$saison = ($debutSaison >= 2000 && $debutSaison <= 2100)
    ? $debutSaison . '/' . ($debutSaison + 1)
    : null;

$compEuropeOverride = $_POST['comp_europe_override'] !== '' ? (int)$_POST['comp_europe_override'] : null;

$pdo->prepare("UPDATE user SET club = :club, idPays = :idPays, genre = :genre, division = :division, saison_active = :saison, comp_europe_override = :override WHERE idUser = :id")
    ->execute([
        'club'     => trim($_POST['club'] ?? ''),
        'idPays'   => $_POST['idPays']   ?: null,
        'genre'    => $_POST['genre']    === 'F' ? 'F' : 'M',
        'division' => $_POST['division'] ?? null,
        'saison'   => $saison,
        'override' => $compEuropeOverride,
        'id'       => $_SESSION['idUser'],
    ]);

$_SESSION['club']          = trim($_POST['club'] ?? '');
$_SESSION['idPays']        = $_POST['idPays']   ?: null;
$_SESSION['genre']         = $_POST['genre']    === 'F' ? 'F' : 'M';
$_SESSION['division']      = $_POST['division'] ?? null;
if ($saison) $_SESSION['saison_active'] = $saison;

header('Location: index.php?miseajour=success');
