<?php
/**
 * Drapeau (emoji) à partir d'un nom de pays en français, tel qu'exporté par
 * FM26 dans la colonne "Nation" de l'effectif (voir upload.php, champ `nat`).
 *
 * Couvre les nations courantes en jeu. Un pays absent de la table renvoie
 * simplement une chaîne vide (pas de drapeau) plutôt qu'un symbole erroné.
 */

const FMXX_COUNTRY_CODES = [
    'Afghanistan' => 'AF', 'Afrique du Sud' => 'ZA', 'Albanie' => 'AL', 'Algérie' => 'DZ',
    'Allemagne' => 'DE', 'Andorre' => 'AD', 'Angleterre' => 'GB', 'Angola' => 'AO',
    'Arabie saoudite' => 'SA', 'Argentine' => 'AR', 'Arménie' => 'AM', 'Australie' => 'AU',
    'Autriche' => 'AT', 'Azerbaïdjan' => 'AZ', 'Bahreïn' => 'BH', 'Belgique' => 'BE',
    'Bénin' => 'BJ', 'Biélorussie' => 'BY', 'Bolivie' => 'BO', 'Bosnie-Herzégovine' => 'BA',
    'Botswana' => 'BW', 'Brésil' => 'BR', 'Bulgarie' => 'BG', 'Burkina Faso' => 'BF',
    'Cambodge' => 'KH', 'Cameroun' => 'CM', 'Canada' => 'CA', 'Cap-Vert' => 'CV',
    'Chili' => 'CL', 'Chine' => 'CN', 'Chypre' => 'CY', 'Colombie' => 'CO',
    'Congo' => 'CG', 'RD Congo' => 'CD', 'Corée du Nord' => 'KP', 'Corée du Sud' => 'KR',
    'Costa Rica' => 'CR', 'Côte d\'Ivoire' => 'CI', 'Croatie' => 'HR', 'Cuba' => 'CU',
    'Danemark' => 'DK', 'Égypte' => 'EG', 'Émirats arabes unis' => 'AE', 'Équateur' => 'EC',
    'Écosse' => 'GB-SCT', 'Espagne' => 'ES', 'Estonie' => 'EE', 'États-Unis' => 'US',
    'Éthiopie' => 'ET', 'Finlande' => 'FI', 'France' => 'FR', 'Gabon' => 'GA',
    'Galles' => 'GB-WLS', 'Gambie' => 'GM', 'Géorgie' => 'GE', 'Ghana' => 'GH',
    'Grèce' => 'GR', 'Guatemala' => 'GT', 'Guinée' => 'GN', 'Haïti' => 'HT',
    'Honduras' => 'HN', 'Hongrie' => 'HU', 'Inde' => 'IN', 'Indonésie' => 'ID',
    'Irak' => 'IQ', 'Iran' => 'IR', 'Irlande' => 'IE', 'Irlande du Nord' => 'GB-NIR',
    'Islande' => 'IS', 'Israël' => 'IL', 'Italie' => 'IT', 'Jamaïque' => 'JM',
    'Japon' => 'JP', 'Jordanie' => 'JO', 'Kazakhstan' => 'KZ', 'Kenya' => 'KE',
    'Kosovo' => 'XK', 'Koweït' => 'KW', 'Lettonie' => 'LV', 'Liban' => 'LB',
    'Libye' => 'LY', 'Lituanie' => 'LT', 'Luxembourg' => 'LU', 'Macédoine du Nord' => 'MK',
    'Madagascar' => 'MG', 'Malaisie' => 'MY', 'Mali' => 'ML', 'Malte' => 'MT',
    'Maroc' => 'MA', 'Mexique' => 'MX', 'Moldavie' => 'MD', 'Monaco' => 'MC',
    'Mongolie' => 'MN', 'Monténégro' => 'ME', 'Mozambique' => 'MZ', 'Namibie' => 'NA',
    'Nicaragua' => 'NI', 'Niger' => 'NE', 'Nigeria' => 'NG', 'Norvège' => 'NO',
    'Nouvelle-Zélande' => 'NZ', 'Oman' => 'OM', 'Ouganda' => 'UG', 'Ouzbékistan' => 'UZ',
    'Pakistan' => 'PK', 'Panama' => 'PA', 'Paraguay' => 'PY', 'Pays-Bas' => 'NL',
    'Pérou' => 'PE', 'Philippines' => 'PH', 'Pologne' => 'PL', 'Portugal' => 'PT',
    'Qatar' => 'QA', 'République dominicaine' => 'DO', 'République tchèque' => 'CZ', 'Roumanie' => 'RO',
    'Russie' => 'RU', 'Rwanda' => 'RW', 'Salvador' => 'SV', 'Sénégal' => 'SN',
    'Serbie' => 'RS', 'Singapour' => 'SG', 'Slovaquie' => 'SK', 'Slovénie' => 'SI',
    'Soudan' => 'SD', 'Sri Lanka' => 'LK', 'Suède' => 'SE', 'Suisse' => 'CH',
    'Syrie' => 'SY', 'Tanzanie' => 'TZ', 'Tchad' => 'TD', 'Thaïlande' => 'TH',
    'Togo' => 'TG', 'Trinité-et-Tobago' => 'TT', 'Tunisie' => 'TN', 'Turquie' => 'TR',
    'Ukraine' => 'UA', 'Uruguay' => 'UY', 'Venezuela' => 'VE', 'Viêt Nam' => 'VN',
    'Zambie' => 'ZM', 'Zimbabwe' => 'ZW',
];

if (!function_exists('fmxx_flag_emoji')) {
    function fmxx_flag_emoji(?string $countryNameFr): string {
        if (!$countryNameFr) return '';
        $code = FMXX_COUNTRY_CODES[trim($countryNameFr)] ?? null;
        if ($code === null) return '';
        // Nations britanniques (Angleterre, Écosse, Galles, Irlande du Nord) : pas de
        // drapeau régional simple en emoji standard, on retombe sur 🇬🇧.
        if (str_starts_with($code, 'GB-')) $code = 'GB';
        $chars = str_split(strtoupper($code));
        if (count($chars) !== 2) return '';
        return mb_chr(0x1F1E6 + (ord($chars[0]) - 65)) . mb_chr(0x1F1E6 + (ord($chars[1]) - 65));
    }
}

if (!function_exists('fmxx_initials')) {
    /** Initiales (2 lettres max) d'un nom, pour l'avatar de l'effectif. */
    function fmxx_initials(string $name): string {
        $parts = preg_split('/\s+/', trim($name));
        $parts = array_filter($parts);
        if (count($parts) >= 2) {
            return mb_strtoupper(mb_substr($parts[0], 0, 1) . mb_substr($parts[array_key_last($parts)], 0, 1));
        }
        return mb_strtoupper(mb_substr($name, 0, 2));
    }
}
