<?php
session_start();
require_once("head.php");
require_once("navbar.php");
?>
<div class="container py-5" style="max-width:760px">

    <h1 class="fw-bold mb-1">Mentions légales</h1>
    <p class="text-muted mb-4">iDev Compagnon — iDev Normandie</p>

    <h5 class="fw-bold section-heading">Éditeur du site</h5>
    <p>
        Le site iDev Compagnon est édité, à titre non professionnel, par <strong>Guillaume Hurard</strong>.
        Conformément à l'article 1-1 de la loi n°2004-575 du 21 juin 2004 pour la confiance dans l'économie
        numérique (LCEN), l'éditeur, personne physique agissant à titre non professionnel, a communiqué ses
        données personnelles d'identification à l'hébergeur du site et a fait le choix de ne pas les rendre
        publiques.
    </p>
    <p>Contact : <a href="mailto:contact@idevnormandie.fr">contact@idevnormandie.fr</a></p>

    <h5 class="fw-bold mt-4 section-heading">Hébergeur</h5>
    <div class="table-panel mt-2">
        <div class="p-3 small">
            <p class="mb-1"><strong>o2switch</strong> — SAS au capital de 100 000 €</p>
            <p class="mb-1">RCS Clermont-Ferrand — SIRET 510 909 807 00032</p>
            <p class="mb-1">Chemin des Pardiaux, 63000 Clermont-Ferrand, France</p>
            <p class="mb-0">Téléphone : 04 44 44 60 40</p>
        </div>
    </div>

    <h5 class="fw-bold mt-4 section-heading">Propriété intellectuelle</h5>
    <p>
        L'ensemble des éléments composant le site (structure, textes, logo, mise en page) est la propriété de
        l'éditeur, sauf mentions contraires. Toute reproduction, représentation ou diffusion, en tout ou partie,
        sans autorisation préalable, est interdite.
    </p>

    <h5 class="fw-bold mt-4 section-heading">Données personnelles</h5>
    <p>
        Le traitement des données personnelles des utilisateurs du service est détaillé dans la section
        <a href="about.php#rgpd"><em>Données personnelles &amp; RGPD</em></a> de la page À propos.
    </p>

    <h5 class="fw-bold mt-4 section-heading">Contact</h5>
    <p class="mb-0">
        Pour toute question relative au site ou à l'exercice de vos droits sur vos données,
        contactez <a href="mailto:contact@idevnormandie.fr">contact@idevnormandie.fr</a>.
    </p>

</div>
<?php require_once("footer.php"); ?>
