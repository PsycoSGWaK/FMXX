<?php
/**
 * Envoi d'emails applicatifs (confirmation d'inscription) via la fonction
 * mail() native de PHP : relais géré par l'hébergeur (o2switch), aucun
 * identifiant SMTP à stocker côté code.
 *
 * Ne fonctionne pas en local WAMP (pas de MTA configuré) : mail() y renvoie
 * simplement false. Ça n'empêche jamais la création du compte — voir
 * signup_post.php — seul l'envoi de l'email échoue silencieusement.
 */

require_once __DIR__ . '/env.php';

if (!function_exists('fmxx_base_url')) {
    function fmxx_base_url(): string {
        $scheme = fmxx_is_https() ? 'https' : 'http';
        $host   = $_SERVER['HTTP_HOST'] ?? 'fmxx.idevnormandie.fr';
        return "$scheme://$host";
    }
}

if (!function_exists('fmxx_send_mail')) {
    /** Envoie un mail en multipart/alternative (texte brut + HTML), meilleur pour la délivrabilité. */
    function fmxx_send_mail(string $to, string $subject, string $htmlBody, string $textBody): bool {
        $sender   = 'no-reply@idevnormandie.fr';
        $boundary = md5(uniqid((string) mt_rand(), true));

        $headers = [
            'MIME-Version: 1.0',
            'Content-Type: multipart/alternative; boundary="' . $boundary . '"',
            'From: iDev Compagnon <' . $sender . '>',
        ];

        $message = "--$boundary\r\n"
                 . "Content-Type: text/plain; charset=UTF-8\r\n\r\n"
                 . $textBody . "\r\n\r\n"
                 . "--$boundary\r\n"
                 . "Content-Type: text/html; charset=UTF-8\r\n\r\n"
                 . "<html><body>$htmlBody</body></html>\r\n\r\n"
                 . "--$boundary--";

        // Sans -f, l'enveloppe (Return-Path) part avec l'adresse système du compte
        // cPanel plutôt que ce domaine, ce qui fait échouer l'alignement SPF côté
        // destinataire (le domaine passe pourtant "Valid" dans Email Deliverability :
        // ce contrôle-là est sur l'enveloppe, pas sur le header From).
        return @mail($to, mb_encode_mimeheader($subject, 'UTF-8'), $message, implode("\r\n", $headers), '-f' . $sender);
    }
}

if (!function_exists('fmxx_send_confirmation_email')) {
    function fmxx_send_confirmation_email(string $to, string $token): bool {
        $link    = fmxx_base_url() . '/confirm_email.php?token=' . urlencode($token);
        $subject = 'Confirme ton inscription à iDev Compagnon';
        $html    = '<p>Bienvenue sur iDev Compagnon !</p>'
                 . '<p>Confirme ton adresse email en cliquant sur ce lien (valable 24h) :</p>'
                 . '<p><a href="' . htmlspecialchars($link) . '">' . htmlspecialchars($link) . '</a></p>'
                 . '<p>Si tu n\'es pas à l\'origine de cette inscription, ignore simplement cet email.</p>';
        $text    = "Bienvenue sur iDev Compagnon !\n\n"
                 . "Confirme ton adresse email en visitant ce lien (valable 24h) :\n$link\n\n"
                 . "Si tu n'es pas à l'origine de cette inscription, ignore simplement cet email.";
        return fmxx_send_mail($to, $subject, $html, $text);
    }
}
