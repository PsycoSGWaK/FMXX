<?php
session_start();
require_once("db.php");
require_once("head.php");
require_once("navbar.php");
require_once("auth_check.php");

if (!isset($_SESSION['mail'])) { require_once("footer.php"); exit; }

$idUser = $_SESSION['idUser'];

$saisonsStmt = $pdo->prepare("
    SELECT sm.*, p.nomPays
    FROM saison_meta sm
    LEFT JOIN pays p ON p.idPays = sm.idPays
    WHERE sm.idUser = :idUser
    ORDER BY sm.saison DESC
");
$saisonsStmt->execute(['idUser' => $idUser]);
$saisons = $saisonsStmt->fetchAll();

$objStmt = $pdo->prepare("
    SELECT o.*, c.nomCompetition, c.typeCompetition
    FROM objectif o
    JOIN competition c ON c.idCompetition = o.idCompetition
    WHERE o.idUser = :idUser
    ORDER BY o.saison DESC, FIELD(c.typeCompetition,'Championnat','Ligue','Nationale','Continentale')
");
$objStmt->execute(['idUser' => $idUser]);
$allObjectifs = $objStmt->fetchAll();

$bySaison = [];
foreach ($allObjectifs as $o) {
    $bySaison[$o['saison']][] = $o;
}

$ranking = [
    '1er'=>1,'2ème'=>2,'3ème'=>3,'4ème'=>4,'5ème'=>5,'6ème'=>6,'7ème'=>7,'8ème'=>8,
    '9ème'=>9,'10ème'=>10,'11ème'=>11,'12ème'=>12,'13ème'=>13,'14ème'=>14,'15ème'=>15,
    '16ème'=>16,'17ème'=>17,'18ème'=>18,'19ème'=>19,'20ème'=>20,
    'Gagner'=>1,'Finale'=>2,'Demi-finale'=>3,'Quarts'=>4,
    '8ème de finale'=>5,'16ème de finale'=>6,'Phase de groupes'=>7,
];

function calcPct(array $objectifs, array $ranking): ?int {
    $total = $ok = 0;
    foreach ($objectifs as $o) {
        if (!$o['objectif'] || !$o['resultat']) continue;
        $total++;
        $rObj = $ranking[$o['objectif']] ?? 99;
        $rRes = $ranking[$o['resultat']] ?? 99;
        if ($rRes <= $rObj) $ok++;
    }
    return $total > 0 ? (int)round($ok / $total * 100) : null;
}

function trophees(array $objectifs): array {
    return array_filter($objectifs, fn($o) => in_array($o['resultat'], ['1er', 'Gagner']));
}
?>
<div class="main-content">

    <div class="context-bar">
        <div class="context-title"><?= $t['pal_title'] ?></div>
        <a href="index.php" class="btn-ghost"><?= $t['pal_back'] ?></a>
    </div>

    <?php if (empty($saisons)): ?>
        <div class="text-muted text-center py-5">
            <?= $t['pal_empty'] ?>
        </div>
    <?php else: ?>

        <?php
        $totalTrophees = 0;
        $totalSaisons  = count($saisons);
        $sumPct = 0; $countPct = 0;
        foreach ($saisons as $s) {
            $objs = $bySaison[$s['saison']] ?? [];
            $totalTrophees += count(trophees($objs));
            $pct = calcPct($objs, $ranking);
            if ($pct !== null) { $sumPct += $pct; $countPct++; }
        }
        $avgPct = $countPct > 0 ? round($sumPct / $countPct) : null;

        $chartSaisons = []; $chartPct = []; $chartTitres = [];
        foreach (array_reverse($saisons) as $s) {
            $objs = $bySaison[$s['saison']] ?? [];
            $chartSaisons[] = $s['saison'];
            $chartPct[]     = calcPct($objs, $ranking) ?? 0;
            $chartTitres[]  = count(trophees($objs));
        }
        ?>
        <div class="table-panel mb-4">
            <div class="stat-bar">
                <div class="stat-item">
                    <div class="stat-value text-warning"><?= $totalTrophees ?></div>
                    <div class="stat-label"><?= $t['pal_trophies'] ?></div>
                </div>
                <div class="stat-item">
                    <div class="stat-value text-primary"><?= $totalSaisons ?></div>
                    <div class="stat-label"><?= $t['pal_seasons'] ?></div>
                </div>
                <div class="stat-item">
                    <?php $avgPctColor = $avgPct === null ? 'text-secondary' : ($avgPct >= 75 ? 'text-success' : ($avgPct >= 50 ? 'text-warning' : 'text-danger')); ?>
                    <div class="stat-value <?= $avgPctColor ?>"><?= $avgPct !== null ? $avgPct . ' %' : '—' ?></div>
                    <div class="stat-label"><?= $t['pal_avg_success'] ?></div>
                </div>
            </div>
        </div>

        <?php if (count($chartSaisons) > 1): ?>
        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h6 class="fw-bold text-muted mb-3"><?= $t['pal_chart_pct'] ?></h6>
                        <canvas id="chartPct" height="50"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h6 class="fw-bold text-muted mb-3"><?= $t['pal_chart_trophies'] ?></h6>
                        <canvas id="chartTitres" height="50"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <script>
        const saisonLabels = <?= json_encode($chartSaisons) ?>;
        const pctData      = <?= json_encode($chartPct) ?>;
        const titresData   = <?= json_encode($chartTitres) ?>;

        new Chart(document.getElementById('chartPct'), {
            type: 'line',
            data: {
                labels: saisonLabels,
                datasets: [{
                    label: <?= json_encode($t['pal_success_rate']) ?>,
                    data: pctData,
                    borderColor: '#0d6efd',
                    backgroundColor: 'rgba(13,110,253,0.1)',
                    fill: true,
                    tension: 0.3,
                    pointRadius: 5,
                }]
            },
            options: {
                scales: { y: { min: 0, max: 100, ticks: { callback: v => v + ' %' } } },
                plugins: { legend: { display: false } }
            }
        });

        new Chart(document.getElementById('chartTitres'), {
            type: 'bar',
            data: {
                labels: saisonLabels,
                datasets: [{
                    label: <?= json_encode($t['pal_trophies']) ?>,
                    data: titresData,
                    backgroundColor: '#ffc107',
                    borderRadius: 4,
                }]
            },
            options: {
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } },
                plugins: { legend: { display: false } }
            }
        });
        </script>
        <?php endif; ?>

        <?php
        $typeLabels = [
            'Championnat'  => $t['obj_type_league'],
            'Ligue'        => $t['obj_type_cup_league'],
            'Nationale'    => $t['obj_type_cup_national'],
            'Continentale' => $t['obj_type_cup_continental'],
        ];
        ?>
        <?php foreach ($saisons as $s):
            $objs   = $bySaison[$s['saison']] ?? [];
            $pct    = calcPct($objs, $ranking);
            $trophs = trophees($objs);
            $pctColor = $pct === null ? '' : ($pct >= 75 ? 'pill-success' : ($pct >= 50 ? 'pill-warning' : 'pill-danger'));
        ?>
        <div class="table-panel mb-3">
            <div class="table-panel-head">
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <span class="section-title"><span style="color:var(--heading); font-size:1.05rem;"><?= htmlspecialchars($s['saison']) ?></span></span>
                    <?php if ($s['club']): ?>
                        <span class="pill"><?= htmlspecialchars($s['club']) ?></span>
                    <?php endif; ?>
                    <?php if ($s['nomPays']): ?>
                        <span class="text-muted small">
                            <?= htmlspecialchars($s['nomPays']) ?> — <?= $s['division'] ?> — <?= $s['genre'] === 'F' ? $t['pal_female'] : $t['pal_male'] ?>
                        </span>
                    <?php endif; ?>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <?php $tc = count($trophs); if ($tc > 0): ?>
                        <span class="pill pill-success">🏆 <?= $tc ?> <?= $tc > 1 ? $t['pal_trophy_pl'] : $t['pal_trophy_s'] ?></span>
                    <?php endif; ?>
                    <?php if ($pct !== null): ?>
                        <span class="pill <?= $pctColor ?>"><?= $pct ?> <?= $t['pal_success_rate'] ?></span>
                    <?php endif; ?>
                </div>
            </div>
                <?php if (empty($objs)): ?>
                    <span class="text-muted small p-3 d-block"><?= $t['pal_no_objectives'] ?></span>
                <?php else: ?>
                    <div class="objectives" style="border:none; border-radius:0;">
                        <?php foreach ($objs as $o):
                            $label = $typeLabels[$o['typeCompetition']] ?? $o['typeCompetition'];
                            $rObj  = $ranking[$o['objectif']] ?? null;
                            $rRes  = $ranking[$o['resultat']]  ?? null;
                            $won   = in_array($o['resultat'], ['1er', 'Gagner']);
                            if ($rObj && $rRes) {
                                $statusClass = $rRes <= $rObj ? 'status-success' : 'status-danger';
                                $statusLabel = $rRes <= $rObj ? ($rRes < $rObj ? $t['obj_status_exceeded'] : $t['obj_status_success']) : $t['obj_status_failed'];
                            } elseif ($o['resultat']) {
                                $statusClass = 'status-pending';
                                $statusLabel = $o['resultat'];
                            } else {
                                $statusClass = 'status-pending';
                                $statusLabel = $t['obj_status_pending'];
                            }
                        ?>
                        <div class="objective-row" style="grid-template-columns: 1.4fr 1fr 1fr auto;">
                            <div class="objective-comp">
                                <span class="objective-type"><?= $label ?></span>
                                <span class="objective-name"><?= htmlspecialchars($o['nomCompetition']) ?><?= $won ? ' 🏆' : '' ?></span>
                            </div>
                            <div>
                                <div class="field-label"><?= $t['pal_obj_label'] ?></div>
                                <div class="field-value"><?= $o['objectif'] ?: '—' ?></div>
                            </div>
                            <div>
                                <div class="field-label"><?= $t['obj_result'] ?></div>
                                <div class="field-value"><?= $o['resultat'] ?: '—' ?></div>
                            </div>
                            <span class="status-chip <?= $statusClass ?>">
                                <?php if ($statusClass === 'status-success'): ?>
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                                <?php endif; ?>
                                <?= $statusLabel ?>
                            </span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
        </div>
        <?php endforeach; ?>

    <?php endif; ?>
</div>
<?php require_once("footer.php"); ?>
