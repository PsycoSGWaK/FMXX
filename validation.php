<?php
/**
 * Validation partagée : robustesse des mots de passe + adresses email.
 * Utilisé par signup_post.php, profile_post.php et admin_post.php.
 *
 * Les fonctions renvoient un CODE d'erreur stable (ou null si valide) ;
 * la traduction se fait à l'affichage via validation_message($code, $t),
 * pour que les messages suivent la langue choisie par l'utilisateur.
 */

const PASSWORD_MIN_LEN   = 14;   // longueur minimale (en caractères)
const PASSWORD_MAX_BYTES = 72;   // bcrypt (password_hash) tronque au-delà de 72 octets

/**
 * Vérifie la robustesse d'un mot de passe.
 * Règle : >= 14 caractères, avec au moins une minuscule, une majuscule,
 * un chiffre et un caractère spécial.
 *
 * @return string|null  code d'erreur, ou null si le mot de passe est valide.
 */
function validate_password(string $pwd): ?string {
    // Le plafond se mesure en octets car bcrypt tronque silencieusement à 72 octets.
    if (strlen($pwd) > PASSWORD_MAX_BYTES)             return 'pwd_max';
    if (mb_strlen($pwd, 'UTF-8') < PASSWORD_MIN_LEN)   return 'pwd_min';
    if (!preg_match('/[a-z]/u', $pwd))                 return 'pwd_lower';
    if (!preg_match('/[A-Z]/u', $pwd))                 return 'pwd_upper';
    if (!preg_match('/[0-9]/u', $pwd))                 return 'pwd_digit';
    if (!preg_match('/[^a-zA-Z0-9]/u', $pwd))          return 'pwd_special';
    return null;
}

/**
 * Valide une adresse email : format (RFC) + existence du domaine.
 * Le domaine doit accepter le courrier (enregistrement MX), avec repli sur A/AAAA.
 *
 * @return string|null  code d'erreur, ou null si l'email est valide.
 */
function validate_email(string $mail): ?string {
    if (!filter_var($mail, FILTER_VALIDATE_EMAIL)) {
        return 'email_format';
    }

    $at = strrchr($mail, '@');
    $domain = $at === false ? '' : substr($at, 1);
    if ($domain === '') {
        return 'email_format';
    }

    // Domaines internationalisés (accentués) → forme ASCII pour le lookup DNS
    if (function_exists('idn_to_ascii')) {
        $ascii = @idn_to_ascii($domain);
        if (is_string($ascii) && $ascii !== '') {
            $domain = $ascii;
        }
    }

    // Le domaine doit pouvoir recevoir des emails. MX en priorité, repli A/AAAA
    // (RFC 5321 : sans MX, l'enregistrement d'adresse fait foi).
    // Certains hébergeurs mutualisés (InfinityFree, etc.) désactivent checkdnsrr :
    // dans ce cas on ne peut pas vérifier le domaine → on s'en tient au format.
    if (function_exists('checkdnsrr')
        && !checkdnsrr($domain, 'MX')
        && !checkdnsrr($domain, 'A')
        && !checkdnsrr($domain, 'AAAA')) {
        return 'email_domain';
    }

    return null;
}

/**
 * Traduit un code d'erreur de validation dans la langue courante ($t).
 * @return string  message traduit, ou '' si le code est inconnu/null.
 */
function validation_message(?string $code, array $t): string {
    switch ($code) {
        case 'pwd_min':      return sprintf($t['val_pwd_min'], PASSWORD_MIN_LEN);
        case 'pwd_max':      return sprintf($t['val_pwd_max'], PASSWORD_MAX_BYTES);
        case 'pwd_lower':    return $t['val_pwd_lower'];
        case 'pwd_upper':    return $t['val_pwd_upper'];
        case 'pwd_digit':    return $t['val_pwd_digit'];
        case 'pwd_special':  return $t['val_pwd_special'];
        case 'pwd_mismatch': return $t['val_pwd_mismatch'];
        case 'email_format': return $t['val_email_format'];
        case 'email_domain': return $t['val_email_domain'];
        default:             return '';
    }
}

/** Texte de la politique de mot de passe (traduit), à afficher sous les champs. */
function password_policy_text(array $t): string {
    return sprintf($t['val_pwd_policy'], PASSWORD_MIN_LEN);
}
