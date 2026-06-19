function placerJoueurs(formation) {
  const terrain = document.getElementById('terrain');
  terrain.innerHTML = ''; // Effacer les joueurs précédents

  let positions = [];

  if (formation === '4-4-2') {
    positions = [
      // Défense
      {x: '25%', y: '85%'},
      {x: '75%', y: '85%'},
      {x: '10%', y: '70%'},
      {x: '90%', y: '70%'},
      // Milieu
      {x: '25%', y: '50%'},
      {x: '75%', y: '50%'},
      {x: '50%', y: '50%'},
      {x: '50%', y: '35%'},
      // Attaque
      {x: '33%', y: '20%'},
      {x: '66%', y: '20%'},
    ];
  } else if (formation === '4-3-3') {
    // Définissez les positions pour 4-3-3
  } else if (formation === '3-5-2') {
    // Définissez les positions pour 3-5-2
  }

  // Créer et placer les points des joueurs
  positions.forEach(pos => {
    const joueur = document.createElement('div');
    joueur.style.position = 'absolute';
    joueur.style.width = '10px';
    joueur.style.height = '10px';
    joueur.style.backgroundColor = 'red';
    joueur.style.borderRadius = '50%';
    joueur.style.left = pos.x;
    joueur.style.top = pos.y;
    terrain.appendChild(joueur);
  });
}