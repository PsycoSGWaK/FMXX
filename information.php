<?php
session_start();
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>NEIGE & SOLEIL</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
	<link href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css" />
<!--===============================================================================================-->
	<link rel="icon" type="image/png" href="images/icons/favicon.ico"/>
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animsition/css/animsition.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
<!--===============================================================================================-->

</head>
<body>
	<div class="container-contact100">
		<div class="wrap-contact100">
		<a class="mbtn" href="index.php"><img src="assets/img/close.png"></a>
			<form class="contact100-form validate-form" action="information_post.php" method="post" autocomplete="off">
				<span class="contact100-form-title">
					INFORMATION
				</span>
<!-- 
				<div class="wrap-input100 validate-input" data-validate="Name is required">
					<span class="label-input100">Your Name</span>
					<input class="input100" type="text" name="name" placeholder="Enter your name">
					<span class="focus-input100"></span>
				</div> -->
				<div class="wrap-input100 validate-input">
					<span class="label-input100">Nom d'utilisateur</span>
					<?php echo' <input class="input100" type="text" name="username" id="username" value="'. $_SESSION['username'] .'"></input>';?>
					<span class="focus-input100"></span>
				</div>

				<div class="wrap-input100 validate-input" data-validate = "Valid email is required: ex@abc.xyz">
					<span class="label-input100">Email</span>
					<?php echo'<input class="input100" type="text" name="mail" id="mail" value="' . $_SESSION['mail']. '" pattern="[a-zA-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"></input>';?>
					<span class="focus-input100"></span>
				</div>

				<div class="wrap-input100 validate-input" data-validate = "Message is required">
					<span class="label-input100">Mot de passe</span>
					<?php echo'<input class="input100" type="password" name="password" id="password" value="'. $_SESSION['password'] .'" ></input>';?>
					<span class="focus-input100"></span>
				</div>

				<div class="wrap-input100 validate-input" data-validate = "Valid email is required: ex@abc.xyz">
					<span class="label-input100">Prénom</span>
					<?php echo'<input class="input100" type="text" name="prenom" id="prenom" value="' . $_SESSION['prenom'] . '"></input>';?>
					<span class="focus-input100"></span>
				</div>

                <div class="wrap-input100 validate-input" data-validate = "Valid email is required: ex@abc.xyz">
					<span class="label-input100">Date de naissance</span>
					<?php echo'<input class="input100" type="date" name="dateNaissance" id="dateNaissance" value="'. $_SESSION['dateNaissance'] .'" ></input>';?>
					<span class="focus-input100"></span>
				</div>

                <div class="wrap-input100 validate-input">
					<span class="label-input100">Ville</span>
					<?php echo'<input class="input100" type="text" name="ville" id="ville" value="'. $_SESSION['ville'] . '"></input>';?>
					<span class="focus-input100"></span>
				</div>

                <div class="wrap-input100 validate-input">
					<span class="label-input100">CP</span>
					<?php echo'<input class="input100" type="text" name="cp" id="cp" value="' . $_SESSION['cp'] . '" ></input>';?>
					<span class="focus-input100"></span>
				</div>

                <div class="wrap-input100 validate-input">
					<span class="label-input100">Adresse</span>
					<?php echo'<input class="input100" type="text" name="adresse" id="adresse" value="' . $_SESSION['adresse'] . '" ></input>';?>
					<span class="focus-input100"></span>
				</div>

                <div class="wrap-input100 validate-input">
					<span class="label-input100">Tel</span>
					<?php echo'<input class="input100" type="text" name="tel" id="tel" value="' . $_SESSION['tel'] .'"></input>';?>
					<span class="focus-input100"></span>
				</div>

				<div class="wrap-input100 validate-input" data-validate = "Valid email is required: ex@abc.xyz">
					<span class="label-input100">Nom</span>
					<?php echo'<input class="input100" type="text" name="nom" id="nom" value="' . $_SESSION['nom'] . '"></input>';?>
					<span class="focus-input100"></span>
				</div>

				<div class="wrap-input100 validate-input form">
					<span class="label-input100">Vous êtes ?</span>
					<div class="container">
						<div class="radio-tile-group">
							<div class="input-container">
								<input id="walk" class="radio-button" id="type" name="type" value="1" type="radio" />
								<div class="radio-tile">
									<div class="icon walk-icon">
										<img fill="#000000" height="90" viewBox="0 0 24 24" width="90" src="assets/img/ProprioOn.png">
									</div>
									<label for="walk" class="radio-tile-label">PROPRIETAIRE</label>
								</div>
							</div>

							<div class="input-container">
								<input id="bike" class="radio-button" id="type" name="type" value="0" type="radio" />
								<div class="radio-tile">
									<div class="icon walk-icon">
										<img fill="#000000" height="90" viewBox="0 0 24 24" width="90" src="assets/img/LocataireOn.png">
									</div>
									<label class="radio-tile-label">LOCATAIRE</label>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="container-contact100-form-btn">
					<div class="wrap-contact100-form-btn">
						<div class="contact100-form-bgbtn"></div>
						<button class="contact100-form-btn">
							<span>
							Mettre à jour
								<i class="fa fa-long-arrow-right m-l-7" aria-hidden="true"></i>
							</span>
						</button>
					</div>
				</div>
			</form>
		</div>
	</div>


	<div id="dropDownSelect1"></div>

<!--===============================================================================================-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/select2/select2.min.js"></script>
	<script>
		$(".selection-2").select2({
			minimumResultsForSearch: 20,
			dropdownParent: $('#dropDownSelect1')
		});
	</script>
<!--===============================================================================================-->
	<script src="vendor/daterangepicker/moment.min.js"></script>
	<script src="vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
	<script src="vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
	<script src="js/main.js"></script>

	<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-23581568-13"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-23581568-13');
</script>
</body>
</html>