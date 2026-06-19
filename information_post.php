<?php
session_start();
?>

<?php  
// Connexion a la base 
require_once("connexion.php");

// Requete
var_dump($_SESSION);
$req = $bdd->prepare ('UPDATE user SET username= ?, prenom= ?, dateNaissance= ?, ville= ?, cp= ?, adresse= ?, tel= ?, nom= ?, mail= ?, password= ?, type= ? WHERE iduser = ?');
$req->execute(array($_POST['username'], $_POST['prenom'], $_POST['dateNaissance'], $_POST['ville'], $_POST['cp'], $_POST['adresse'], $_POST['tel'], $_POST['nom'], $_POST['mail'], $_POST['password'], $_POST['type'], $_SESSION['iduser']));
header('Location: information.php');