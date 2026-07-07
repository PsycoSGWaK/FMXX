<?php
session_start();
require_once("db.php");

// Après la soumission du formulaire
$nouvelleDivision = NULL; // Assurez-vous que le nom de l'input dans votre formulaire correspond.
$nouveauClub = NULL; // De même, assurez-vous que le nom correspond.

$sql = "UPDATE user SET division = :division, club = :club WHERE idUser = :idUser";
$stmt = $pdo->prepare($sql);
$stmt->execute([
        'division' => $nouvelleDivision,
        'club' => $nouveauClub,
        'idUser' => $_SESSION['idUser']
]);

// Vérifiez si la mise à jour a réussi
if ($stmt->rowCount()) {
        // Mise à jour réussie, mettez à jour la session
        $_SESSION['division'] = $nouvelleDivision;
        $_SESSION['club'] = $nouveauClub;
        // Redirection ou autre logique post-mise à jour
        // par exemple, rediriger vers une page avec un message de succès
        header('Location: index.php?miseajour=success');
        exit;
} else {
        echo "Veuillez remplir correctement le formulaire.";
}
