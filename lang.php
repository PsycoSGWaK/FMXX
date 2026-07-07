<?php
$lang = $_SESSION['lang'] ?? 'fr';
if (!in_array($lang, ['fr', 'en', 'es'])) $lang = 'fr';
require_once __DIR__ . "/lang/{$lang}.php";
