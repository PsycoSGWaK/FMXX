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
<body>
<div class="container-fluid px-4 py-3">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0"><?= $t['pal_title'] ?></h2>
        <a href="index.php" class="btn btn-sm btn-outline-secondary"><?= $t['pal_back'] ?></a>
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
        <div class="row g-3 mb-4">
            <div class="col-md-3 col-6">
                <div class="card text-center border-warning">
                    <div class="card-body py-2">
                        <div class="fs-3 fw-bold text-warning"><?= $totalTrophees ?></div>
                        <div class="text-muted small"><?= $t['pal_trophies'] ?></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card text-center border-primary">
                    <div class="card-body py-2">
                        <div class="fs-3 fw-bold text-primary"><?= $totalSaisons ?></div>
                        <div class="text-muted small"><?= $t['pal_seasons'] ?></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card text-center border-<?= $avgPct === null ? 'secondary' : ($avgPct >= 75 ? 'success' : ($avgPct >= 50 ? 'warning' : 'danger')) ?>">
                    <div class="card-body py-2">
                        <div class="fs-3 fw-bold"><?= $avgPct !== null ? $avgPct . ' %' : '—' ?></div>
                        <div class="text-muted small"><?= $t['pal_avg_success'] ?></div>
                    </div>
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
            'Championnat'  => ['label' => $t['obj_type_league'],          'color' => 'primary'],
            'Ligue'        => ['label' => $t['obj_type_cup_league'],       'color' => 'info'],
            'Nationale'    => ['label' => $t['obj_type_cup_national'],     'color' => 'warning'],
            'Continentale' => ['label' => $t['obj_type_cup_continental'],  'color' => 'success'],
        ];
        ?>
        <?php foreach ($saisons as $s):
            $objs   = $bySaison[$s['saison']] ?? [];
            $pct    = calcPct($objs, $ranking);
            $trophs = trophees($objs);
            $pctColor = $pct === null ? 'secondary' : ($pct >= 75 ? 'success' : ($pct >= 50 ? 'warning' : 'danger'));
        ?>
        <div class="card mb-3">
            <div class="card-header d-flex justify-content-between align-items-center py-2" style="background:#091c3e; color:#fff;">
                <div class="d-flex align-items-center gap-3">
                    <span class="fw-bold fs-5"><?= htmlspecialchars($s['saison']) ?></span>
                    <?php if ($s['club']): ?>
                        <span class="badge bg-secondary"><?= htmlspecialchars($s['club']) ?></span>
                    <?php endif; ?>
                    <?php if ($s['nomPays']): ?>
                        <span class="text-white-50 small">
                            <?= htmlspecialchars($s['nomPays']) ?> — <?= $s['division'] ?> — <?= $s['genre'] === 'F' ? $t['pal_female'] : $t['pal_male'] ?>
                        </span>
                    <?php endif; ?>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <?php $tc = count($trophs); if ($tc > 0): ?>
                        <span class="badge bg-warning text-dark">🏆 <?= $tc ?> <?= $tc > 1 ? $t['pal_trophy_pl'] : $t['pal_trophy_s'] ?></span>
                    <?php endif; ?>
                    <?php if ($pct !== null): ?>
                        <span class="badge bg-<?= $pctColor ?>"><?= $pct ?> <?= $t['pal_success_rate'] ?></span>
                    <?php endif; ?>
                </div>
            </div>
            <div class="card-body p-3">
                <?php if (empty($objs)): ?>
                    <span class="text-muted small"><?= $t['pal_no_objectives'] ?></span>
                <?php else: ?>
                    <div class="row g-2">
                        <?php foreach ($objs as $o):
                            $meta  = $typeLabels[$o['typeCompetition']] ?? ['label' => $o['typeCompetition'], 'color' => 'secondary'];
                            $rObj  = $ranking[$o['objectif']] ?? null;
                            $rRes  = $ranking[$o['resultat']]  ?? null;
                            $won   = in_array($o['resultat'], ['1er', 'Gagner']);
                            if ($rObj && $rRes)      $border = $rRes <= $rObj ? 'success' : 'danger';
                            elseif ($o['resultat'])  $border = 'secondary';
                            else                     $border = $meta['color'];
                        ?>
                        <div class="col-md-3 col-sm-6">
                            <div class="card border-<?= $border ?> h-100">
                                <div class="card-body p-2">
                                    <div class="small text-<?= $meta['color'] ?> fw-semibold"><?= $meta['label'] ?></div>
                                    <div class="fw-bold small"><?= htmlspecialchars($o['nomCompetition']) ?><?= $won ? ' 🏆' : '' ?></div>
                                    <div class="d-flex justify-content-between mt-1">
                                        <span class="text-muted" style="font-size:.75rem"><?= $t['pal_obj_label'] ?> : <?= $o['objectif'] ?: '—' ?></span>
                                        <span class="<?= $border === 'success' ? 'text-success' : ($border === 'danger' ? 'text-danger' : 'text-muted') ?> fw-semibold" style="font-size:.75rem">
                                            <?= $o['resultat'] ?: '—' ?>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
        <?php endforeach; ?>

    <?php endif; ?>
</div>
<?php require_once("footer.php"); ?>
</body>
