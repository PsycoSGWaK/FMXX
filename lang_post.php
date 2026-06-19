<?php
session_start();
$lang = $_GET['lang'] ?? 'fr';
if (in_array($lang, ['fr', 'en', 'es'])) {
    $_SESSION['lang'] = $lang;
}
$redirect = $_SERVER['HTTP_REFERER'] ?? 'index.php';
header("Location: $redirect");
