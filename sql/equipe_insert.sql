-- Généré par import_teams_from_dumps.php le 2026-06-16 21:44:05
-- Vérifier ce fichier avant de l'injecter en base.

-- de_frauen_bundesliga.json  (DE / F / D1)  — 12 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1899 Hoffenheim W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayer Leverkusen W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayern Munich W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfL Wolfsburg W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Freiburg W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SGS Essen W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Turbine Potsdam W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Werder Bremen W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Koln W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eintracht Frankfurt W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Carl Zeiss Jena  W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RB Leipzig W', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'F', 'D1');

-- gb_wsl.json  (GB / F / D1)  — 12 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Liverpool W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arsenal W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chelsea W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester City W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Everton W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('West Ham W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brighton W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester United W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tottenham Hotspur W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aston Villa W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leicester City FC W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Crystal Palace W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D1');

-- gb_wsl2.json  (GB / F / D2)  — 11 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Birmingham City W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bristol City W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sunderland W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blackburn Rovers W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charlton Athletic W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Durham W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('London City Lionesses W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sheffield United W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portsmouth W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Southampton W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newcastle United W', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'F', 'D2');

-- es_liga_f.json  (ES / F / D1)  — 16 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athletic Club W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Betis W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valencia W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atletico Madrid W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Levante W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Sociedad W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granad. Tenerife W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barcelona W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Espanyol W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sevilla W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Madrid CFF W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Deportivo de La Coruña W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Madrid W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eibar W', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Levante Badalona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granada', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'F', 'D1');

-- us_nwsl.json  (US / F / D1)  — 14 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chicago Red Stars W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Houston Dash W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('North Carolina Courage W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Orlando Pride W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portland Thorns W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Seattle Reign FC W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('NJ/NY Gotham FC W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Utah Royals W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Washington Spirit W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kansas City W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Racing Louisville W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Angel City W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('San Diego Wave W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bay FC W', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'F', 'D1');

-- fr_d1_feminine.json  (FR / F / D1)  — 12 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris Saint Germain W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guingamp W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lyon W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Montpellier W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris FC W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Fleury 91 W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dijon W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stade de Reims W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Havre W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Étienne W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nantes W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Strasbourg W', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'F', 'D1');

-- it_serie_a_women.json  (IT / F / D1)  — 10 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fiorentina W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juventus W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sassuolo W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Roma W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AC Milan W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inter Milano W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Napoli W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lazio W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sampdoria W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Como W', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'F', 'D1');

-- jp_we_league.json  (JP / F / D1)  — 12 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elfen Saitama W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('INAC Kobe Leonessa W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('JEF United W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nojima Stella W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Omiya Ardija Ventus W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tokyo Verdy Beleza W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Urawa Reds W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Albirex Niigata W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Parceiro Nagano W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sanfrecce Hiroshima W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vegalta Sendai W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cerezo Osaka W', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'F', 'D1');

-- se_damallsvenskan.json  (SE / F / D1)  — 15 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Piteå W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rosengård W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Djurgården W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KIF Örebro W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kristianstad W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Linköping W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Umeå W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vittsjö W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Växjö W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AIK W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hammarby W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brommapojkarna W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Norrköping W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Häcken W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trelleborg W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D1');

-- se_elitettan.json  (SE / F / D2)  — 14 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eskilstuna United W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Umeå W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Uppsala W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alingsås W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bollstanäs W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jitex W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kalmar W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mallbacken W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sundsvall W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lidköping W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Örebro SK W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gamla Upsala W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sunnanå W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Malmö FF W', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'F', 'D2');

-- de_bundesliga.json  (DE / M / D1)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayern München', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Freiburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfL Wolfsburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Werder Bremen', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Borussia Mönchengladbach', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FSV Mainz 05', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Borussia Dortmund', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1899 Hoffenheim', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bayer Leverkusen', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eintracht Frankfurt', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Augsburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfB Stuttgart', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RB Leipzig', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VfL Bochum', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1. FC Heidenheim', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Union Berlin', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC St. Pauli', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Holstein Kiel', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SV Elversberg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D1');

-- de_2_bundesliga.json  (DE / M / D2)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fortuna Düsseldorf', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hertha BSC', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hannover 96', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1. FC Nürnberg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Schalke 04', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hamburger SV', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SSV Jahn Regensburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SpVgg Greuther Fürth', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1. FC Magdeburg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SV Darmstadt 98', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Paderborn 07', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1. FC Köln', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eintracht Braunschweig', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('1. FC Kaiserslautern', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Karlsruher SC', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Preußen Münster', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Saarbrücken', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SSV Ulm 1846', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SV Elversberg', (SELECT idPays FROM pays WHERE paysA2C = 'DE' LIMIT 1), 'M', 'D2');

-- gb_premier_league.json  (GB / M / D1)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newcastle', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bournemouth', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fulham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wolves', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Liverpool', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Southampton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arsenal', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Everton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leicester', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tottenham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('West Ham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chelsea', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manchester City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brighton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Crystal Palace', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brentford', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ipswich', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nottingham Forest', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aston Villa', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D1');

-- gb_championship.json  (GB / M / D2)  — 24 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Watford', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burnley', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bristol City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Millwall', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Preston', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('West Brom', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sheffield Utd', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leeds', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hull City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blackburn', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Derby', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Middlesbrough', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Norwich', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('QPR', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sheffield Wednesday', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stoke City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Swansea', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sunderland', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oxford United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Coventry', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portsmouth', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Plymouth', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Luton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D2');

-- gb_league_one.json  (GB / M / D3)  — 24 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Huddersfield', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Reading', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Birmingham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wigan', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bolton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rotherham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barnsley', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burton Albion', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bristol Rovers', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charlton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Northampton', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Peterborough', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shrewsbury', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blackpool', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wycombe', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Crawley Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Exeter City', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stevenage', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cambridge United', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leyton Orient', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mansfield Town', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lincoln', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wrexham', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stockport County', (SELECT idPays FROM pays WHERE paysA2C = 'GB' LIMIT 1), 'M', 'D3');

-- at_bundesliga.json  (AT / M / D1)  — 12 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Red Bull Salzburg', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austria Vienna', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SCR Altach', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sturm Graz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rapid Vienna', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wolfsberger AC', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lask Linz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('TSV Hartberg', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC BW Linz', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('WSG Wattens', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austria Klagenfurt', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Grazer AK', (SELECT idPays FROM pays WHERE paysA2C = 'AT' LIMIT 1), 'M', 'D1');

-- be_pro_league.json  (BE / M / D1)  — 17 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('OH Leuven', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KVC Westerlo', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Beerschot VA', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KV Mechelen', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Anderlecht', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Club Brugge KV', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gent', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Standard Liege', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kortrijk', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Truiden', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charleroi', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Antwerp', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cercle Brugge', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Genk', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Union St. Gilloise', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dender', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Patro Eisden', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D1');

-- be_challenger_pro.json  (BE / M / D2)  — 16 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lommel United', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Zulte Waregem', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SK Beveren', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AS Eupen', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Francs Borains', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RAAL La Louvière', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Deinze', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('K. Lierse S.K.', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Liège', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Patro Eisden', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RWDM', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Seraing United', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lokeren-Temse', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Club Brugge II', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('KRC Genk II', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RSC Anderlecht II', (SELECT idPays FROM pays WHERE paysA2C = 'BE' LIMIT 1), 'M', 'D2');

-- br_serie_a.json  (BR / M / D1)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bahia', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Internacional', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Botafogo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Palmeiras', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fluminense', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sao Paulo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Flamengo', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gremio', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Corinthians', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vasco DA Gama', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atletico Paranaense', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cruzeiro', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vitoria', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Criciuma', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atletico Goianiense', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juventude', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fortaleza EC', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RB Bragantino', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atletico-MG', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cuiaba', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D1');

-- br_serie_b.json  (BR / M / D2)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sport Recife', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('America Mineiro', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Santos', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ceara', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chapecoense-sc', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guarani Campinas', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ponte Preta', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vila Nova', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avai', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('CRB', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Coritiba', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paysandu', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Goias', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brusque', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Operario-PR', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Botafogo SP', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ituano', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Novorizontino', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mirassol', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amazonas', (SELECT idPays FROM pays WHERE paysA2C = 'BR' LIMIT 1), 'M', 'D2');

-- es_la_liga.json  (ES / M / D1)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barcelona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atletico Madrid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Athletic Club', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valencia', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Villarreal', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Las Palmas', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sevilla', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leganes', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Celta Vigo', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Espanyol', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Madrid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alaves', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Betis', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Getafe', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Girona', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Sociedad', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valladolid', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Osasuna', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rayo Vallecano', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mallorca', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D1');

-- es_la_liga_2.json  (ES / M / D2)  — 22 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Malaga', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Levante', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Deportivo La Coruna', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eibar', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cordoba', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granada CF', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oviedo', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tenerife', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Albacete', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Almeria', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cadiz', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Huesca', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting Gijon', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Zaragoza', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Elche', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mirandes', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Racing Santander', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Castellón', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Cartagena', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Racing Ferrol', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Burgos', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eldense', (SELECT idPays FROM pays WHERE paysA2C = 'ES' LIMIT 1), 'M', 'D2');

-- us_mls.json  (US / M / D1)  — 29 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Seattle Sounders', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('San Jose Earthquakes', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Dallas', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Orlando City SC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Philadelphia Union', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Houston Dynamo', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toronto FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('New York Red Bulls', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vancouver Whitecaps', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('New York City FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Los Angeles Galaxy', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Real Salt Lake', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chicago Fire', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atlanta United FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('New England Revolution', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Colorado Rapids', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting Kansas City', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Minnesota United FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Columbus Crew', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('CF Montreal', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('DC United', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Los Angeles FC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portland Timbers', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Cincinnati', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inter Miami', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nashville SC', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Austin', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Charlotte', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St. Louis City', (SELECT idPays FROM pays WHERE paysA2C = 'US' LIMIT 1), 'M', 'D1');

-- fr_ligue_1.json  (FR / M / D1)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Angers', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lille', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lyon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Marseille', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Montpellier', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nantes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nice', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris Saint Germain', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Monaco', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Reims', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rennes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Strasbourg', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toulouse', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stade Brestois 29', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Auxerre', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Havre', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Metz', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lens', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint Etienne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D1');

-- fr_ligue_2.json  (FR / M / D2)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amiens', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caen', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guingamp', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lorient', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ajaccio', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Clermont Foot', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Grenoble', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('RED Star FC 93', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Estac Troyes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Metz', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Paris FC', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Laval', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('PAU', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boulogne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rodez', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dunkerque', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bastia', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Annecy', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Martigues', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D2');

-- fr_national.json  (FR / M / D3)  — 17 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dijon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nimes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nancy', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Orleans', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Valenciennes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chateauroux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sochaux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bourg-en-bresse 01', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Quevilly', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Mans', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boulogne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Concarneau', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Villefranche', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Versailles', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rouen', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gobelins', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aubagne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D3');

-- fr_national_2_a.json  (FR / M / D4)  — 16 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Marignane', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Andrézieux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Anglet Genets', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Angoulême', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bergerac', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fréjus St-Raphaël', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hyères', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Puy Foot', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Toulon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Istres', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Priest', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chasselay MDA', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jura Sud Foot', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Grasse', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cannes', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rumilly Vallières', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');

-- fr_national_2_b.json  (FR / M / D4)  — 16 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bordeaux', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avranches', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Les Herbiers', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blois', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Le Poiré sur Vie', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Poitiers', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Malo', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('St-Pryvé St-Hilaire', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Granville', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saint-Colomban Locminé', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Saumur', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Stade Briochin', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Châteaubriant', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dinan Léhon', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('La Roche VF', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bourges Foot 18', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');

-- fr_national_2_c.json  (FR / M / D4)  — 16 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chambly Thelle FC', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Creteil', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Epinal', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Biesheim', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bobigny', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Haguenau', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Villers Houlgate CF', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Wasquehal', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aubervilliers', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Beauvais', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chantilly', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Feignies-Aulnoye', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fleury 91', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Furiani-Agliani', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Balagne', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Thionville Lusitanos', (SELECT idPays FROM pays WHERE paysA2C = 'FR' LIMIT 1), 'M', 'D4');

-- it_serie_a.json  (IT / M / D1)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lazio', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AC Milan', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cagliari', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Napoli', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Udinese', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Genoa', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juventus', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AS Roma', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Atalanta', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bologna', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fiorentina', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Torino', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hellas Verona', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Inter', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Empoli', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Venezia', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Parma', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Lecce', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Como', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Monza', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D1');

-- it_serie_b.json  (IT / M / D2)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sassuolo', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sampdoria', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bari', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cesena', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cittadella', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Frosinone', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Salernitana', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Spezia', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Brescia', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cremonese', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Palermo', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pisa', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Juve Stabia', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Reggiana', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Modena', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sudtirol', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Carrarese', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Catanzaro', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mantova', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cosenza', (SELECT idPays FROM pays WHERE paysA2C = 'IT' LIMIT 1), 'M', 'D2');

-- jp_j1.json  (JP / M / D1)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Consadole Sapporo', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jubilo Iwata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kashiwa Reysol', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sanfrecce Hiroshima', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shonan Bellmare', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Urawa', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nagoya Grampus', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vissel Kobe', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kashima', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cerezo Osaka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Tokyo', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gamba Osaka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kawasaki Frontale', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sagan Tosu', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Yokohama F. Marinos', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kyoto Sanga', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Machida Zelvia', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tokyo Verdy', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Albirex Niigata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Avispa Fukuoka', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D1');

-- jp_j2.json  (JP / M / D2)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Shimizu S-pulse', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('V-varen Nagasaki', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vegalta Sendai', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oita Trinita', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tokushima Vortis', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('JEF United Chiba', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mito Hollyhock', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Yokohama FC', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ventforet Kofu', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Renofa Yamaguchi', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fagiano Okayama', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Montedio Yamagata', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Roasso Kumamoto', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tochigi SC', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ehime FC', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Thespakusatsu Gunma', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kagoshima United', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Blaublitz Akita', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fujieda MYFC', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Iwaki', (SELECT idPays FROM pays WHERE paysA2C = 'JP' LIMIT 1), 'M', 'D2');

-- wl_cymru_premier.json  (WL / M / D1)  — 12 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Aberystwyth Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bala Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cardiff MET', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('The New Saints', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caernarfon Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('GAP Connah S Quay FC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newtown AFC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Barry Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penybont', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Haverfordwest County AFC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Briton Ferry', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Flint Town United', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D1');

-- wl_faw_championship.json  (WL / M / D2)  — 32 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('llanelli AFC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Carmarthen Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llandudno', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Goytre United', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ammanford AFC', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cwmbran Celtic', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pontypridd Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llantwit Major', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Taffs Well', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Afan Lido', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cambrian & Clydach', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Airbus UK', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Buckley Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caerau (Ely)', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Colwyn Bay', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gresford Athletic', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guilsfield', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penrhyncoch', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Prestatyn Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ruthin Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Caersws', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Denbigh Town', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Holywell', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Llay Miners Welfare', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mold Alexandra', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trefelin', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bangor 1876', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trethomas Bluebirds', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penrhiwceiber Rangers', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Baglan Dragons', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Flint Mountain', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Newport City', (SELECT idPays FROM pays WHERE paysA2C = 'WL' LIMIT 1), 'M', 'D2');

-- nl_eredivisie.json  (NL / M / D1)  — 24 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('PEC Zwolle', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ajax', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Willem II', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('PSV Eindhoven', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('ADO Den Haag', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('De Graafschap', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AZ Alkmaar', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Groningen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('NAC Breda', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fortuna Sittard', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Heracles', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Utrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Feyenoord', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Heerenveen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dordrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('GO Ahead Eagles', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('NEC Nijmegen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Twente', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Waalwijk', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Almere City FC', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cambuur', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Den Bosch', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sparta Rotterdam', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Telstar', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D1');

-- nl_eerste_divisie.json  (NL / M / D2)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Excelsior', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('ADO Den Haag', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('De Graafschap', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vitesse', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('VVV Venlo', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Emmen', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Dordrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong PSV U21', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('MVV', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Roda', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Volendam', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong AZ', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Cambuur', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Den Bosch', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Eindhoven', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC OSS', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Helmond Sport', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong Ajax', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Telstar', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Jong Utrecht', (SELECT idPays FROM pays WHERE paysA2C = 'NL' LIMIT 1), 'M', 'D2');

-- pt_primeira_liga.json  (PT / M / D1)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Benfica', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Porto', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Moreirense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('SC Braga', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boavista', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Guimaraes', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Nacional', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rio Ave', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Santa Clara', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sporting CP', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Estoril', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Farense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Arouca', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Famalicao', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('GIL Vicente', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vizela', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Casa Pia', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Estrela', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AVS', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D1');

-- pt_liga_portugal_2.json  (PT / M / D2)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Feirense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Maritimo', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Portimonense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Tondela', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Chaves', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Benfica B', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Oliveirense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pacos Ferreira', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Penafiel', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Academico Viseu', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('FC Porto B', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Leixoes', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mafra', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vizela', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('União de Leiria', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alverca', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Felgueiras 1932', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Torreense', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('CF Os Belenenses', (SELECT idPays FROM pays WHERE paysA2C = 'PT' LIMIT 1), 'M', 'D2');

-- tr_super_lig.json  (TR / M / D1)  — 19 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Beşiktaş', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Başakşehir', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Konyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fenerbahçe', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Galatasaray', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Göztepe', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Alanyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Trabzonspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kayserispor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sivasspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kasımpaşa', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Antalyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Rizespor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Adana Demirspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gaziantep FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hatayspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bodrum FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Eyüpspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Samsunspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D1');

-- tr_1_lig.json  (TR / M / D2)  — 20 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gençlerbirliği S.K.', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Yeni Malatyaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Erzurumspor FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ankaragücü', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Adanaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Boluspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Ümraniyespor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('İstanbulspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Amed', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Bandırmaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Fatih Karagümrük', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Keçiörengücü', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Manisa F.K.', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Pendikspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sakaryaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Şanlıurfaspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Çorum FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Esenler Erokspor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kocaelispor', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Iğdır FK', (SELECT idPays FROM pays WHERE paysA2C = 'TR' LIMIT 1), 'M', 'D2');

-- se_allsvenskan.json  (SE / M / D1)  — 17 équipes
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Hammarby FF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Djurgardens IF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IFK Goteborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('BK Hacken', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Sirius', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IF Brommapojkarna', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IF Elfsborg', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Kalmar FF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Malmo FF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('AIK Stockholm', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IFK Norrkoping', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Halmstad', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('IFK Varnamo', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Gais', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Landskrona BoIS', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Mjallby AIF', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');
INSERT INTO equipe (nomEquipe, idPays, genre, division) VALUES ('Vasteras SK FK', (SELECT idPays FROM pays WHERE paysA2C = 'SE' LIMIT 1), 'M', 'D1');

