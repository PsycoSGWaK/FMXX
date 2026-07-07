<?php
if (!isset($pdo)) require_once("db.php");
$pays       = $pdo->query("SELECT * FROM pays ORDER BY nomPays")->fetchAll();
$equipes    = $pdo->query("SELECT idEquipe, nomEquipe, idPays, genre, division FROM equipe ORDER BY nomEquipe")->fetchAll();

$currentSaison   = $_SESSION['saison_active'] ?? date('Y') . '/' . (date('Y') + 1);
$currentGenre    = $_SESSION['genre']    ?? 'M';
$currentIdPays   = $_SESSION['idPays']   ?? null;
$currentDivision = $_SESSION['division'] ?? null;
$currentClub     = $_SESSION['club']     ?? '';

$compsEurope = $pdo->query("SELECT idCompetition, nomCompetition, genre FROM competition WHERE typeCompetition = 'Continentale' ORDER BY genre, qualif_rang_min")->fetchAll();

$currentOverride = $pdo->prepare("SELECT comp_europe_override FROM user WHERE idUser = :id");
$currentOverride->execute(['id' => $_SESSION['idUser']]);
$currentOverride = $currentOverride->fetchColumn();
?>
<div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title"><?= $t['setting_title'] ?></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <form action="setting_post.php" method="post">
                <?= csrf_field() ?>
                <div class="mb-3">
                    <label class="form-label fw-semibold"><?= $t['setting_country'] ?></label>
                    <select class="form-select" name="idPays" id="settingPays">
                        <option value=""><?= $t['lbl_select'] ?></option>
                        <?php foreach ($pays as $p): ?>
                            <option value="<?= $p['idPays'] ?>" <?= $currentIdPays == $p['idPays'] ? 'selected' : '' ?>>
                                <?= htmlspecialchars($p['nomPays']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold"><?= $t['setting_gender'] ?></label>
                    <div class="d-flex gap-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="genre" value="M" id="genreM"
                                   <?= $currentGenre !== 'F' ? 'checked' : '' ?>>
                            <label class="form-check-label" for="genreM"><?= $t['setting_male'] ?></label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="genre" value="F" id="genreF"
                                   <?= $currentGenre === 'F' ? 'checked' : '' ?>>
                            <label class="form-check-label" for="genreF"><?= $t['setting_female'] ?></label>
                        </div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold"><?= $t['setting_division'] ?></label>
                    <select class="form-select" name="division">
                        <option value=""><?= $t['lbl_select'] ?></option>
                        <option value="D1" <?= $currentDivision === 'D1' ? 'selected' : '' ?>><?= $t['d1_label'] ?></option>
                        <option value="D2" <?= $currentDivision === 'D2' ? 'selected' : '' ?>><?= $t['d2_label'] ?></option>
                        <option value="D3" <?= $currentDivision === 'D3' ? 'selected' : '' ?>><?= $t['d3_label'] ?></option>
                        <option value="D4" <?= $currentDivision === 'D4' ? 'selected' : '' ?>><?= $t['d4_label'] ?></option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold"><?= $t['setting_club'] ?></label>
                    <select class="form-select" name="club" id="settingClub">
                        <option value=""><?= $t['setting_club_no_country'] ?></option>
                        <?php foreach ($equipes as $e): ?>
                            <option value="<?= htmlspecialchars($e['nomEquipe']) ?>"
                                    data-pays="<?= $e['idPays'] ?>"
                                    data-genre="<?= $e['genre'] ?>"
                                    data-division="<?= $e['division'] ?>"
                                    <?= $currentClub === $e['nomEquipe'] ? 'selected' : '' ?>>
                                <?= htmlspecialchars($e['nomEquipe']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold"><?= $t['setting_season'] ?></label>
                    <?php $debutSaison = (int)explode('/', $currentSaison)[0]; ?>
                    <input type="number" class="form-control" name="saison_active"
                           value="<?= $debutSaison ?>" min="2000" max="2100" placeholder="<?= $t['setting_season_example'] ?>">
                    <div class="form-text"><?= $t['setting_season_hint'] ?> <?= $debutSaison ?>/<?= $debutSaison + 1 ?>.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold"><?= $t['setting_europe_comp'] ?></label>
                    <select class="form-select" name="comp_europe_override" id="settingEuropeComp">
                        <option value=""><?= $t['setting_europe_auto'] ?></option>
                        <?php foreach ($compsEurope as $ce): ?>
                            <option value="<?= $ce['idCompetition'] ?>" data-genre="<?= $ce['genre'] ?>"
                                    <?= (int)$currentOverride === (int)$ce['idCompetition'] ? 'selected' : '' ?>>
                                <?= htmlspecialchars($ce['nomCompetition']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                    <div class="form-text"><?= $t['setting_europe_hint'] ?></div>
                </div>
                <button type="submit" class="btn btn-primary w-100"><?= $t['btn_save'] ?></button>
            </form>

        </div>
    </div>
</div>

<script>
(function () {
    const paysSelect  = document.getElementById('settingPays');
    const clubSelect  = document.getElementById('settingClub');
    const europeSelect = document.getElementById('settingEuropeComp');
    const europeOptions = Array.from(europeSelect.querySelectorAll('option[data-genre]'));
    const genreRadios = document.querySelectorAll('input[name="genre"]');
    const allOptions  = Array.from(clubSelect.querySelectorAll('option[data-pays]'));
    const divisionSelect = document.querySelector('select[name="division"]');
    const noCountryText = <?= json_encode($t['setting_club_no_country']) ?>;
    const selectText    = <?= json_encode($t['setting_club_select']) ?>;

    function filterEuropeComp() {
        const genre = document.querySelector('input[name="genre"]:checked')?.value || 'M';
        europeOptions.forEach(opt => {
            const match = opt.dataset.genre === genre;
            opt.style.display = match ? '' : 'none';
            if (!match && opt.selected) europeSelect.value = '';
        });
    }

    function filterClubs() {
        const pays     = paysSelect.value;
        const genre    = document.querySelector('input[name="genre"]:checked')?.value || 'M';
        const division = divisionSelect.value;

        allOptions.forEach(opt => {
            const match = (!pays     || opt.dataset.pays     === pays)
                       && opt.dataset.genre === genre
                       && (!division || opt.dataset.division === division);
            opt.style.display = match ? '' : 'none';
            if (!match && opt.selected) opt.selected = false;
        });

        const placeholder = clubSelect.querySelector('option:not([data-pays])');
        placeholder.textContent = pays ? selectText : noCountryText;
    }

    paysSelect.addEventListener('change', filterClubs);
    divisionSelect.addEventListener('change', filterClubs);
    genreRadios.forEach(r => r.addEventListener('change', filterClubs));
    genreRadios.forEach(r => r.addEventListener('change', filterEuropeComp));

    document.getElementById('settingModal').addEventListener('shown.bs.modal', filterClubs);
    document.getElementById('settingModal').addEventListener('shown.bs.modal', filterEuropeComp);
})();
</script>
