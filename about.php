<?php
session_start();
require_once("head.php");
require_once("navbar.php");
?>
<body>
<div class="container py-5" style="max-width:760px">

    <h1 class="fw-bold mb-1">FMXX Tools</h1>
    <p class="text-muted mb-4">A personal companion tool for Football Manager careers</p>

    <!-- What is it -->
    <h5 class="fw-bold">What is FMXX Tools?</h5>
    <p>FMXX Tools is a web app designed to complement your Football Manager save. It replaces the classic spreadsheet approach and gives you a clean interface to manage your squad, plan transfers, organise your tactical substitutions, track season objectives, and build a career history — all in one place.</p>

    <!-- Getting started -->
    <h5 class="fw-bold mt-4">Getting started</h5>
    <ol>
        <li class="mb-2"><strong>Create an account</strong> — sign up with an email and password. Each account is isolated: you only see your own data.</li>
        <li class="mb-2"><strong>Configure your settings</strong> — open <em>Settings</em> from the main page and select your country, gender (Men / Women), division (D1/D2/D3), club, and current season year.</li>
        <li class="mb-2"><strong>Import your squad</strong> — export your squad from FM using the <a href="https://www.fmscout.com/a-fm26-player-csv-export.html" target="_blank" rel="noopener">FMScout CSV Export</a> mod. Both HTML and CSV formats are supported. Column headers are detected automatically.</li>
    </ol>

    <!-- Features -->
    <h5 class="fw-bold mt-4">Features</h5>

    <div class="row g-3 mb-2">
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h6 class="fw-bold">📋 Squad</h6>
                    <p class="small mb-0">View your full squad with stats imported from FM. Filter by name, position, contract expiry, or transfer status. Players listed for sale or loan are highlighted automatically.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h6 class="fw-bold">💰 Transfer window</h6>
                    <p class="small mb-0">Mark players as <em>Sell</em> or <em>Loan</em>. Get a summary of how many players are leaving, how many you're keeping, and an estimate of your incoming transfer revenue.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h6 class="fw-bold">🔄 Tactic Sub</h6>
                    <p class="small mb-0">Plan your starting XI, substitutes, and super subs for 6 formations (4-3-3, 4-4-2, 4-2-3-1, 3-5-2, 5-3-2, 4-1-2-1-2). Players listed for sale or loan are automatically excluded from selection.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h6 class="fw-bold">🎯 Season objectives</h6>
                    <p class="small mb-0">Set a target and record your actual result for each competition (league, domestic cups, continental). Each objective is colour-coded green or red based on whether you met it, with an overall success rate.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h6 class="fw-bold">🏆 Career history</h6>
                    <p class="small mb-0">Every completed season is saved in your career timeline. See total trophies won, seasons played, average success rate, and a breakdown of every objective season by season.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h6 class="fw-bold">⚙️ Multi-season support</h6>
                    <p class="small mb-0">Move to the next season with one click. Change club or league between seasons — objectives and squad data are kept separate per season, so switching teams won't mix up your history.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Squad import -->
    <h5 class="fw-bold mt-4">Squad import — supported columns</h5>
    <p class="small text-muted">The importer detects column names automatically (FM English and French headers are both supported).</p>
    <div class="table-responsive">
        <table class="table table-sm table-bordered">
            <thead class="table-dark">
                <tr><th>Field</th><th>Accepted header names</th></tr>
            </thead>
            <tbody class="small">
                <tr><td>Name</td><td>Nom, Joueur, Joueuse, Name</td></tr>
                <tr><td>Age</td><td>Âge, Age</td></tr>
                <tr><td>Squad number</td><td>N°, No</td></tr>
                <tr><td>Nationality</td><td>Nat, Nation, Nationality</td></tr>
                <tr><td>Place of birth</td><td>PdN, Pays de naissance, Place of birth</td></tr>
                <tr><td>Position</td><td>Poste, Position</td></tr>
                <tr><td>Appearances</td><td>App, Matchs disputés, Apps</td></tr>
                <tr><td>Assists</td><td>Déc, Dec, Passes décisives, Assists</td></tr>
                <tr><td>Goals</td><td>Buts, Goals</td></tr>
                <tr><td>Avg rating</td><td>Note, Note moy, Avg rating, Rating</td></tr>
                <tr><td>Asking price</td><td>Prix demandé, Asking price</td></tr>
                <tr><td>Contract expires</td><td>Expire le, Contract expires, Expires</td></tr>
            </tbody>
        </table>
    </div>
    <p class="small text-muted">Transfer amounts in K/M format (e.g. <code>4.5K €</code>, <code>2.5M €</code>) are parsed automatically.</p>

    <!-- Data & privacy -->
    <h5 class="fw-bold mt-4">Data & privacy</h5>
    <p>All data is stored in your own MySQL database. Nothing is sent to any external server. Each user account can only access their own data.</p>

    <!-- RGPD -->
    <h5 class="fw-bold mt-4">Données personnelles & RGPD</h5>
    <div class="card border-0 bg-light p-3 small">
        <p class="mb-2">Conformément au <strong>Règlement Général sur la Protection des Données (RGPD — UE 2016/679)</strong>, vous êtes informé(e) des points suivants :</p>

        <p class="fw-semibold mb-1">Responsable du traitement</p>
        <p class="mb-2">Guillaume Hurard — iDev Normandie. Contact : <a href="mailto:guillaume.hurard@gmail.com">guillaume.hurard@gmail.com</a></p>

        <p class="fw-semibold mb-1">Données collectées</p>
        <p class="mb-2">Lors de la création d'un compte, les données suivantes sont collectées : nom d'utilisateur, adresse email, mot de passe (chiffré via bcrypt). Ces données sont strictement nécessaires au fonctionnement du service.</p>

        <p class="fw-semibold mb-1">Finalité du traitement</p>
        <p class="mb-2">Les données sont utilisées uniquement pour l'authentification et la gestion de votre compte. Aucune donnée n'est cédée, vendue ou transmise à des tiers.</p>

        <p class="fw-semibold mb-1">Hébergement & stockage</p>
        <p class="mb-2">FMXX Tools est une application à usage personnel, hébergée localement sur un serveur privé (WAMP). Aucune donnée n'est envoyée vers un serveur externe ou un service cloud.</p>

        <p class="fw-semibold mb-1">Durée de conservation</p>
        <p class="mb-2">Les données sont conservées tant que le compte est actif. Vous pouvez demander la suppression de votre compte et de l'ensemble de vos données à tout moment.</p>

        <p class="fw-semibold mb-1">Vos droits</p>
        <p class="mb-2">Conformément au RGPD, vous disposez des droits suivants sur vos données personnelles :</p>
        <ul class="mb-2">
            <li><strong>Droit d'accès</strong> — obtenir une copie de vos données</li>
            <li><strong>Droit de rectification</strong> — corriger des données inexactes</li>
            <li><strong>Droit à l'effacement</strong> — demander la suppression de vos données</li>
            <li><strong>Droit d'opposition</strong> — vous opposer à un traitement</li>
        </ul>
        <p class="mb-0">Pour exercer ces droits, contactez : <a href="mailto:guillaume.hurard@gmail.com">guillaume.hurard@gmail.com</a>. En cas de litige, vous pouvez également saisir la <a href="https://www.cnil.fr" target="_blank" rel="noopener">CNIL</a>.</p>
    </div>

    <!-- Stack -->
    <h5 class="fw-bold mt-4">Stack</h5>
    <p class="mb-0">PHP / MySQL (PDO) / Bootstrap 5. Personal project by <strong>Guillaume</strong>.</p>

</div>
<?php require_once("footer.php"); ?>
</body>
