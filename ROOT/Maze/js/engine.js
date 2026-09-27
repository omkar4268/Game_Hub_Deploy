const canvas = document.getElementById('mazeCanvas');
  const ctx = canvas.getContext('2d');
  const loadingOverlay = document.getElementById('loadingOverlay');
  const splashScreen = document.getElementById('splashScreen');
  const winScreen = document.getElementById('winScreen');
  const intelModal = document.getElementById('intelModal');
  const difficultySelect = document.getElementById('difficulty');
  const timerVal = document.getElementById('timerVal');
  const clearedVal = document.getElementById('clearedVal');
  const splashClears = document.getElementById('splashClears');
  const splashBestTime = document.getElementById('splashBestTime');
  const winTimeVal = document.getElementById('winTimeVal');
  const winClearsVal = document.getElementById('winClearsVal');
  const dpadElem = document.getElementById('mobileDpad');

  const isMobile = ('ontouchstart' in window) || 
                   (navigator.maxTouchPoints > 0) || 
                   /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);
  if (dpadElem) dpadElem.style.display = 'none';

  let grid = [];
  let rows, cols;
  let cellSize = 20;
  let player = { x: 1, y: 1 };
  let goal = { x: 1, y: 1 };
  let isGameOver = true;
  let timerInterval = null;
  let secondsElapsed = 0;

  let totalClears = parseInt(localStorage.getItem('hub_maze_clears') || '0', 10);
  let bestTime = parseInt(localStorage.getItem('hub_maze_best_time') || '0', 10);

  clearedVal.innerText = totalClears;
  splashClears.innerText = totalClears;
  splashBestTime.innerText = bestTime > 0 ? bestTime + 's' : '--';

  function openIntel() { 
    intelModal.classList.add('active'); 
    if (dpadElem) dpadElem.style.display = 'none';
  }
  function closeIntel() { 
    intelModal.classList.remove('active'); 
    if (!isGameOver && isMobile && dpadElem) dpadElem.style.display = 'grid';
  }

  function showSplashScreen() {
    winScreen.style.display = 'none';
    intelModal.classList.remove('active');
    splashScreen.style.display = 'flex';
    splashClears.innerText = totalClears;
    splashBestTime.innerText = bestTime > 0 ? bestTime + 's' : '--';
    if (dpadElem) dpadElem.style.display = 'none';
  }

  function onDiffChange() {
    if (!isGameOver) {
      startNewGame();
    }
  }

  function startNewGame() {
    splashScreen.style.display = 'none';
    winScreen.style.display = 'none';
    intelModal.classList.remove('active');
    loadingOverlay.style.display = 'flex';
    isGameOver = true;

    clearInterval(timerInterval);
    secondsElapsed = 0;
    updateTimerDisplay();

    const diff = difficultySelect.value;
    if (diff === 'easy') { rows = cols = 15; cellSize = 28; }
    else if (diff === 'medium') { rows = cols = 25; cellSize = 18; }
    else { rows = cols = 35; cellSize = 13; }

    canvas.width = cols * cellSize;
    canvas.height = rows * cellSize;

    setTimeout(() => {
      generateMaze();
      placeEntities();
      loadingOverlay.style.display = 'none';
      isGameOver = false;
      if (isMobile && dpadElem) dpadElem.style.display = 'grid';
      draw();

      timerInterval = setInterval(() => {
        secondsElapsed++;
        updateTimerDisplay();
      }, 1000);

      if (window.RansomHorror) {
        RansomHorror.init('maze', {
          onGameOver: () => triggerMazeFailure(),
          onPurgeBonus: () => {
            totalClears += 5;
            clearedVal.innerText = totalClears;
          }
        });
      }
    }, 250);
  }

  function updateTimerDisplay() {
    const m = Math.floor(secondsElapsed / 60);
    const s = secondsElapsed % 60;
    timerVal.innerText = (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
  }

  function generateMaze() {
    grid = Array.from({ length: rows }, () => Array(cols).fill(1));

    function carve(x, y) {
      grid[y][x] = 0;
      const dirs = [
        [0, -2], [2, 0], [0, 2], [-2, 0]
      ].sort(() => Math.random() - 0.5);

      for (let [dx, dy] of dirs) {
        const nx = x + dx;
        const ny = y + dy;
        if (nx > 0 && nx < cols - 1 && ny > 0 && ny < rows - 1 && grid[ny][nx] === 1) {
          grid[y + dy / 2][x + dx / 2] = 0;
          carve(nx, ny);
        }
      }
    }
    carve(1, 1);
  }

  function placeEntities() {
    const openPaths = [];
    for (let r = 1; r < rows - 1; r++) {
      for (let c = 1; c < cols - 1; c++) {
        if (grid[r][c] === 0) openPaths.push({ x: c, y: r });
      }
    }

    const startIdx = Math.floor(Math.random() * openPaths.length);
    player = { ...openPaths[startIdx] };

    let bestGoal = openPaths[0];
    let maxDist = -1;
    for (let p of openPaths) {
      const dist = Math.abs(p.x - player.x) + Math.abs(p.y - player.y);
      if (dist > maxDist) {
        maxDist = dist;
        bestGoal = p;
      }
    }
    goal = { ...bestGoal };
  }

  function movePlayer(dx, dy) {
    if (isGameOver) return;
    const nx = player.x + dx;
    const ny = player.y + dy;

    if (nx >= 0 && nx < cols && ny >= 0 && ny < rows && grid[ny][nx] === 0) {
      player.x = nx;
      player.y = ny;
      draw();
      checkWin();
    }
  }

  function checkWin() {
    if (player.x === goal.x && player.y === goal.y) {
      isGameOver = true;
      clearInterval(timerInterval);

      if (window.RansomHorror) {
        if (RansomHorror.state === 'lurking') RansomHorror.evadeLurker();
        clearTimeout(RansomHorror.lurkTimer);
      }

      totalClears++;
      localStorage.setItem('hub_maze_clears', totalClears);
      clearedVal.innerText = totalClears;

      if (bestTime === 0 || secondsElapsed < bestTime) {
        bestTime = secondsElapsed;
        localStorage.setItem('hub_maze_best_time', bestTime);
      }

      const mazeScore = totalClears * 100;
      fetch('../save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ game: 'maze', score: mazeScore })
      }).catch(() => console.log('Offline score saved.'));

      winTimeVal.innerText = timerVal.innerText;
      winClearsVal.innerText = totalClears;
      if (dpadElem) dpadElem.style.display = 'none';
      setTimeout(() => { winScreen.style.display = 'flex'; }, 150);
    }
  }

  function triggerMazeFailure() {
    isGameOver = true;
    clearInterval(timerInterval);
    if (dpadElem) dpadElem.style.display = 'none';
    splashScreen.style.display = 'flex';
    const splashTitle = document.querySelector('.splash-title') || document.querySelector('.overlay-title');
    if (splashTitle) {
      splashTitle.innerText = 'SYSTEM COMPROMISED // MAZE TERMINATED';
      splashTitle.style.color = 'var(--danger)';
    }
  }

  function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        if (grid[r][c] === 1) {
          ctx.fillStyle = '#1e293b';
          ctx.fillRect(c * cellSize, r * cellSize, cellSize, cellSize);
        } else {
          ctx.fillStyle = '#020617';
          ctx.fillRect(c * cellSize, r * cellSize, cellSize, cellSize);
        }
      }
    }

    // Extraction Portal
    ctx.fillStyle = '#22c55e';
    ctx.shadowColor = '#22c55e';
    ctx.shadowBlur = 12;
    ctx.beginPath();
    ctx.arc((goal.x + 0.5) * cellSize, (goal.y + 0.5) * cellSize, cellSize * 0.38, 0, Math.PI * 2);
    ctx.fill();

    // Runner Block
    ctx.fillStyle = '#38bdf8';
    ctx.shadowColor = '#38bdf8';
    ctx.shadowBlur = 10;
    ctx.fillRect(player.x * cellSize + 2, player.y * cellSize + 2, cellSize - 4, cellSize - 4);
    ctx.shadowBlur = 0;
  }

  window.addEventListener('keydown', (e) => {
    switch(e.key) {
      case 'ArrowUp': case 'w': case 'W': movePlayer(0, -1); e.preventDefault(); break;
      case 'ArrowDown': case 's': case 'S': movePlayer(0, 1); e.preventDefault(); break;
      case 'ArrowLeft': case 'a': case 'A': movePlayer(-1, 0); e.preventDefault(); break;
      case 'ArrowRight': case 'd': case 'D': movePlayer(1, 0); e.preventDefault(); break;
    }
  });

  canvas.width = 25 * 18;
  canvas.height = 25 * 18;
  ctx.fillStyle = '#020617';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Cyber-Scanner Navigation Wipe Handler
  function cyberNavigate(url) {
    const overlay = document.getElementById('cyberWipeOverlay');
    if (overlay) {
      overlay.classList.add('active');
      setTimeout(() => {
        window.location.href = url;
      }, 220);
    } else {
      window.location.href = url;
    }
  }

  window.addEventListener('pageshow', () => {
    const overlay = document.getElementById('cyberWipeOverlay');
    if (overlay) overlay.classList.remove('active');
  });