<?php
/**
 * Cluster langue (drapeaux) + thème + menu utilisateur, à inclure dans le
 * header propre à chaque page (context-bar d'index.php, admin.php...).
 * Suppose que navbar.php a déjà tourné juste avant (variables $isAdmin,
 * $currentLang, $initials disponibles) et que l'utilisateur est connecté.
 */
?>
    <a href="hub.php" class="btn-ghost" style="font-size:.8rem; padding:.35rem .7rem;" title="<?= htmlspecialchars($t['nav_switch_game']) ?>">
        <ion-icon name="grid-outline"></ion-icon> <?= $t['nav_switch_game'] ?>
    </a>
<div class="lang-flags">
    <a href="lang_post.php?lang=fr" class="lang-flag <?= $currentLang === 'fr' ? 'active' : '' ?>" title="Français">🇫🇷</a>
    <a href="lang_post.php?lang=en" class="lang-flag <?= $currentLang === 'en' ? 'active' : '' ?>" title="English">🇬🇧</a>
    <a href="lang_post.php?lang=es" class="lang-flag <?= $currentLang === 'es' ? 'active' : '' ?>" title="Español">🇪🇸</a>
</div>
<button type="button" class="theme-toggle" id="themeToggle" aria-label="<?= $t['nav_theme_toggle'] ?>">
    <ion-icon name="moon-outline"></ion-icon>
</button>
<div class="dropdown user-dropdown">
    <button type="button" class="user-chip" data-bs-toggle="dropdown" style="background:none; border:none; cursor:pointer;">
        <div class="user-avatar"><?= htmlspecialchars($initials) ?></div>
        <div class="text-start">
            <div class="user-name"><?= htmlspecialchars($_SESSION['username'] ?? '') ?></div>
            <div class="user-role"><?= $isAdmin ? 'Admin' : '' ?></div>
        </div>
    </button>
    <ul class="dropdown-menu dropdown-menu-end">
        <?php if ($isAdmin): ?>
        <li><a class="dropdown-item" href="admin.php"><?= $t['nav_admin'] ?></a></li>
        <li><hr class="dropdown-divider"></li>
        <?php endif; ?>
        <li>
            <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">
                <?= $t['dropdown_edit_profile'] ?>
            </a>
        </li>
        <li><hr class="dropdown-divider"></li>
        <li><a class="dropdown-item" href="export_data.php"><?= $t['dropdown_export'] ?></a></li>
        <li><a class="dropdown-item" href="backup_export.php"><?= $t['dropdown_backup'] ?></a></li>
        <li>
            <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#restoreBackupModal">
                <?= $t['dropdown_restore_backup'] ?>
            </a>
        </li>
        <li><hr class="dropdown-divider"></li>
        <li>
            <a class="dropdown-item text-danger" href="#" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                <?= $t['dropdown_delete_account'] ?>
            </a>
        </li>
        <li><hr class="dropdown-divider"></li>
        <li><a class="dropdown-item" href="logout.php"><?= $t['nav_logout'] ?></a></li>
    </ul>
</div>
