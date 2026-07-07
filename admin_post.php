<?php
session_start();
require_once("db.php");
require_once(__DIR__ . "/csrf.php");
require_once(__DIR__ . "/validation.php");
require_once(__DIR__ . "/lang.php");   // définit $t selon la langue de session

if (!isset($_SESSION['mail'])) {
    header("Location: index.php");
    exit;
}

// Vérification admin
$stmtType = $pdo->prepare("SELECT type FROM user WHERE idUser = :id");
$stmtType->execute(['id' => $_SESSION['idUser']]);
$userType = $stmtType->fetchColumn();

if ($userType !== '1') {
    header("Location: index.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: admin.php");
    exit;
}

csrf_verify();

$action = $_POST['action'] ?? '';

function redirect(string $tab, string $param, string $msg): void {
    header("Location: admin.php?tab=$tab&$param=" . urlencode($msg));
    exit;
}

switch ($action) {

    case 'toggle_user_type':
        $idUser = (int)($_POST['idUser'] ?? 0);
        if ($idUser === (int)$_SESSION['idUser']) {
            redirect('users', 'err', 'Impossible de modifier votre propre type.');
        }
        $current = $pdo->prepare("SELECT type FROM user WHERE idUser = :id");
        $current->execute(['id' => $idUser]);
        $currentType = $current->fetchColumn();
        $newType = $currentType === '1' ? '0' : '1';
        $pdo->prepare("UPDATE user SET type = :type WHERE idUser = :id")->execute(['type' => $newType, 'id' => $idUser]);
        redirect('users', 'msg', 'Type utilisateur mis à jour.');

    case 'delete_user':
        $idUser = (int)($_POST['idUser'] ?? 0);
        if ($idUser === (int)$_SESSION['idUser']) {
            redirect('users', 'err', 'Impossible de supprimer votre propre compte.');
        }
        $pdo->prepare("CALL DeleteUser(:id)")->execute(['id' => $idUser]);
        redirect('users', 'msg', 'Utilisateur supprimé.');

    case 'add_competition':
        $nom  = trim($_POST['nomCompetition'] ?? '');
        $type = $_POST['typeCompetition'] ?? '';
        $idP  = (int)($_POST['idPays'] ?? 0);
        $div  = $_POST['division'] ?? null;
        $gen  = $_POST['genre'] ?? '';

        if (!$nom || !$type || !$idP || !$gen) {
            redirect('competitions', 'err', 'Champs obligatoires manquants.');
        }
        $pdo->prepare("INSERT INTO competition (nomCompetition, typeCompetition, idPays, division, genre) VALUES (?,?,?,?,?)")
            ->execute([$nom, $type, $idP, $div ?: null, $gen]);
        redirect('competitions', 'msg', 'Compétition ajoutée.');

    case 'delete_competition':
        $id = (int)($_POST['idCompetition'] ?? 0);
        $pdo->prepare("DELETE FROM objectif WHERE idCompetition = :id")->execute(['id' => $id]);
        $pdo->prepare("DELETE FROM competition WHERE idCompetition = :id")->execute(['id' => $id]);
        redirect('competitions', 'msg', 'Compétition supprimée.');

    case 'add_club':
        $nom  = trim($_POST['nomEquipe'] ?? '');
        $idP  = (int)($_POST['idPays'] ?? 0);
        $gen  = $_POST['genre'] ?? '';
        $div  = $_POST['division'] ?? '';

        if (!$nom || !$idP || !$gen || !$div) {
            redirect('clubs', 'err', 'Champs obligatoires manquants.');
        }
        $pdo->prepare("INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES (?,?,?,?)")
            ->execute([$nom, $idP, $gen, $div]);
        redirect('clubs', 'msg', 'Club ajouté.');

    case 'delete_club':
        $id = (int)($_POST['idEquipe'] ?? 0);
        $pdo->prepare("DELETE FROM equipe WHERE idEquipe = :id")->execute(['id' => $id]);
        redirect('clubs', 'msg', 'Club supprimé.');

    case 'add_pays':
        $nom  = trim($_POST['nomPays'] ?? '');
        $a2   = strtoupper(trim($_POST['paysA2C'] ?? ''));
        $a3   = strtoupper(trim($_POST['paysA3C'] ?? '')) ?: null;
        $num  = $_POST['paysNum'] ? (int)$_POST['paysNum'] : null;

        if (!$nom || !$a2) {
            redirect('pays', 'err', 'Nom et code A2 obligatoires.');
        }
        $pdo->prepare("INSERT INTO pays (nomPays, paysA2C, paysA3C, paysNum) VALUES (?,?,?,?)")
            ->execute([$nom, $a2, $a3, $num]);
        redirect('pays', 'msg', 'Pays ajouté.');

    case 'delete_pays':
        $id = (int)($_POST['idPays'] ?? 0);
        $pdo->prepare("DELETE FROM pays WHERE idPays = :id")->execute(['id' => $id]);
        redirect('pays', 'msg', 'Pays supprimé.');

    case 'reset_password':
        $idUser = (int)($_POST['idUser'] ?? 0);
        $pwd    = $_POST['new_password']     ?? '';
        $conf   = $_POST['confirm_password'] ?? '';
        if ($pwdCode = validate_password($pwd)) {
            redirect('users', 'err', validation_message($pwdCode, $t));
        }
        if ($pwd !== $conf) {
            redirect('users', 'err', $t['val_pwd_mismatch']);
        }
        $hash = password_hash($pwd, PASSWORD_DEFAULT);
        $pdo->prepare("UPDATE user SET password = ? WHERE idUser = ?")->execute([$hash, $idUser]);
        redirect('users', 'msg', 'Mot de passe réinitialisé.');

    case 'edit_competition':
        $id      = (int)($_POST['idCompetition'] ?? 0);
        $nom     = trim($_POST['nomCompetition'] ?? '');
        $type    = $_POST['typeCompetition'] ?? '';
        $idP     = (int)($_POST['idPays'] ?? 0);
        $div     = $_POST['division'] ?? null;
        $gen     = $_POST['genre'] ?? '';
        $qualMin = $_POST['qualif_rang_min'] !== '' ? (int)$_POST['qualif_rang_min'] : null;
        $qualMax = $_POST['qualif_rang_max'] !== '' ? (int)$_POST['qualif_rang_max'] : null;
        if (!$id || !$nom || !$type || !$idP || !$gen) {
            redirect('competitions', 'err', 'Champs obligatoires manquants.');
        }
        $pdo->prepare("UPDATE competition SET nomCompetition=?, typeCompetition=?, idPays=?, division=?, genre=?, qualif_rang_min=?, qualif_rang_max=? WHERE idCompetition=?")
            ->execute([$nom, $type, $idP, $div ?: null, $gen, $qualMin, $qualMax, $id]);
        redirect('competitions', 'msg', 'Compétition modifiée.');

    case 'edit_club':
        $id   = (int)($_POST['idEquipe'] ?? 0);
        $nom  = trim($_POST['nomEquipe'] ?? '');
        $idP  = (int)($_POST['idPays'] ?? 0);
        $gen  = $_POST['genre'] ?? '';
        $div  = $_POST['division'] ?? '';
        if (!$id || !$nom || !$idP || !$gen || !$div) {
            redirect('clubs', 'err', 'Champs obligatoires manquants.');
        }
        $pdo->prepare("UPDATE equipe SET nomEquipe=?, idPays=?, genre=?, division=? WHERE idEquipe=?")
            ->execute([$nom, $idP, $gen, $div, $id]);
        redirect('clubs', 'msg', 'Club modifié.');

    case 'edit_pays':
        $id  = (int)($_POST['idPays'] ?? 0);
        $nom = trim($_POST['nomPays'] ?? '');
        $a2  = strtoupper(trim($_POST['paysA2C'] ?? ''));
        $a3  = strtoupper(trim($_POST['paysA3C'] ?? '')) ?: null;
        $num = $_POST['paysNum'] ? (int)$_POST['paysNum'] : null;
        if (!$id || !$nom || !$a2) {
            redirect('pays', 'err', 'Nom et code A2 obligatoires.');
        }
        $pdo->prepare("UPDATE pays SET nomPays=?, paysA2C=?, paysA3C=?, paysNum=? WHERE idPays=?")
            ->execute([$nom, $a2, $a3, $num, $id]);
        redirect('pays', 'msg', 'Pays modifié.');

    default:
        header("Location: admin.php");
        exit;
}
