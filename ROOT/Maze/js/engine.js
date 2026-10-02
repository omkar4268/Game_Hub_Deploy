// =========================================================
// CYBER MAZE // HOLOGRAPHIC LABYRINTH v3.0 ENGINE
// =========================================================

// Background Canvas (Fullscreen Holographic Vector Labyrinth & Sonar Simulation)
(function initMazeBackground() {
  const bgCanvas = document.getElementById('mazeBgCanvas');
  if (!bgCanvas) return;
  const bctx = bgCanvas.getContext('2d');
  if (!bctx) return;

  let W = 0, H = 0;
  const corridorBeams = [];
  let sweepAngle = 0;

  function resize() {
    W = bgCanvas.width = window.innerWidth;
    H = bgCanvas.height = window.innerHeight;
  }
  window.addEventListener('resize', resize);
  resize();

  // Create ambient holographic corridor laser beams
  for (let i = 0; i < 7; i++) {
    corridorBeams.push({
      x: Math.random() * window.innerWidth,
      y: Math.random() * window.innerHeight,
      len: Math.random() * 120 + 60,
      dir: Math.random() > 0.5 ? 'h' : 'v',
      speed: Math.random() * 1.6 + 0.6,
      alpha: Math.random() * 0.45 + 0.15,
      color: Math.random() > 0.5 ? '#a855f7' : '#38bdf8'
    });
  }

  function frame() {
    bctx.clearRect(0, 0, W, H);
    sweepAngle += 0.015;

    // Subtle isometric holographic grid lines
    bctx.strokeStyle = 'rgba(168, 85, 247, 0.032)';
    bctx.lineWidth = 1;
    const step = 52;
    bctx.beginPath();
    for (let x = 0; x < W; x += step) {
      bctx.moveTo(x, 0);
      bctx.lineTo(x, H);
    }
    for (let y = 0; y < H; y += step) {
      bctx.moveTo(0, y);
      bctx.lineTo(W, y);
    }
    bctx.stroke();

    // Ambient sweeping tactical radar rings from center
    const cx = W / 2;
    const cy = H / 2;
    bctx.strokeStyle = 'rgba(56, 189, 248, 0.04)';
    bctx.lineWidth = 1.2;
    bctx.beginPath();
    bctx.arc(cx, cy, 220, 0, Math.PI * 2);
    bctx.arc(cx, cy, 400, 0, Math.PI * 2);
    bctx.stroke();

    // Draw & update roaming corridor laser beams
    corridorBeams.forEach(b => {
      bctx.strokeStyle = b.color === '#a855f7' ? 'rgba(168, 85, 247, ' + b.alpha + ')' : 'rgba(56, 189, 248, ' + b.alpha + ')';
      bctx.lineWidth = 1.5;
      bctx.beginPath();
      if (b.dir === 'h') {
        bctx.moveTo(b.x, b.y);
        bctx.lineTo(b.x + b.len, b.y);
        b.x += b.speed;
        if (b.x > W) b.x = -b.len;
      } else {
        bctx.moveTo(b.x, b.y);
        bctx.lineTo(b.x, b.y + b.len);
        b.y += b.speed;
        if (b.y > H) b.y = -b.len;
      }
      bctx.stroke();
    });

    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
})();

// =========================================================
// CORE MAZE ENGINE & HIGH-FIDELITY CANVAS RENDERING
// =========================================================
const canvas = document.getElementById('mazeCanvas');
const ctx = canvas.getContext('2d');
const splashScreen = document.getElementById('splashScreen');
const winScreen = document.getElementById('winScreen');
const intelModal = document.getElementById('intelModal');
const loadingOverlay = document.getElementById('loadingOverlay');

const timerVal = document.getElementById('timerVal');
const clearedVal = document.getElementById('clearedVal');
const winTimeVal = document.getElementById('winTimeVal');
const winClearsVal = document.getElementById('winClearsVal');
const splashClears = document.getElementById('splashClears');
const splashBestTime = document.getElementById('splashBestTime');

let cols = 21, rows = 21;
let cellSize = 0;
let grid = [];
let player = { x: 1, y: 1 };
let goal = { x: 1, y: 1 };

let timerInterval = null;
let secondsElapsed = 0;
let isGameOver = true;

// Player breadcrumb motion trail
let playerTrail = [];
// Win particle burst
let winParticles = [];
let goalPulseTimer = 0;

let totalClears = parseInt(localStorage.getItem('hub_maze_clears') || '0', 10);
let bestSeconds = parseInt(localStorage.getItem('hub_maze_best_time') || '99999', 10);

clearedVal.innerText = totalClears;
splashClears.innerText = totalClears;
splashBestTime.innerText = bestSeconds === 99999 ? '--' : formatTime(bestSeconds);

function formatTime(sec) {
  const m = Math.floor(sec / 60);
  const s = sec % 60;
  return (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
}

function animateModalIn(el) {
  const Motion = (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;
  if (Motion && typeof Motion.animate === 'function') {
    Motion.animate(el, { opacity: [0, 1], scale: [0.94, 1] }, { duration: 0.28, ease: [0.16, 1, 0.3, 1] });
  }
}

function showSplashScreen() {
  winScreen.style.display = 'none';
  intelModal.classList.remove('active');
  splashScreen.style.display = 'flex';
  splashClears.innerText = totalClears;
  splashBestTime.innerText = bestSeconds === 99999 ? '--' : formatTime(bestSeconds);
  animateModalIn(splashScreen);
}

function openIntel() { 
  intelModal.classList.add('active'); 
  animateModalIn(intelModal);
}

function closeIntel() { 
  intelModal.classList.remove('active'); 
}

function onDiffChange() {
  const diff = document.getElementById('difficulty').value;
  if (diff === 'easy') { cols = 13; rows = 13; }
  else if (diff === 'medium') { cols = 21; rows = 21; }
  else { cols = 31; rows = 31; }

  if (!isGameOver) {
    startNewGame();
  }
}

function startNewGame() {
  splashScreen.style.display = 'none';
  winScreen.style.display = 'none';
  intelModal.classList.remove('active');
  loadingOverlay.style.display = 'flex';

  setTimeout(() => {
    generateMaze();
    placeEntities();
    resizeCanvas();
    loadingOverlay.style.display = 'none';
    isGameOver = false;
    playerTrail = [];
    winParticles = [];

    clearInterval(timerInterval);
    secondsElapsed = 0;
    updateTimerDisplay();
    timerInterval = setInterval(() => {
      secondsElapsed++;
      updateTimerDisplay();
    }, 1000);

    draw();

    if (window.RansomHorror) {
      RansomHorror.init('maze', {
        onGameOver: () => triggerMazeFailure(),
        onPurgeBonus: () => {
          totalClears += 5;
          clearedVal.innerText = totalClears;
        }
      });
    }
  }, 220);
}

function updateTimerDisplay() {
  timerVal.innerText = formatTime(secondsElapsed);
}

// Procedural Recursive Backtracker Maze Generator
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
    playerTrail.push({ x: player.x, y: player.y, alpha: 0.6 });
    if (playerTrail.length > 8) playerTrail.shift();

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

    if (secondsElapsed < bestSeconds) {
      bestSeconds = secondsElapsed;
      localStorage.setItem('hub_maze_best_time', bestSeconds);
    }

    winTimeVal.innerText = formatTime(secondsElapsed);
    winClearsVal.innerText = totalClears;

    spawnWinBurst();

    syncScoreToCloud('maze', totalClears);

    setTimeout(() => {
      winScreen.style.display = 'flex';
      animateModalIn(winScreen);
    }, 400);
  }
}

function spawnWinBurst() {
  const cx = (goal.x + 0.5) * cellSize;
  const cy = (goal.y + 0.5) * cellSize;
  for (let i = 0; i < 20; i++) {
    const angle = (Math.PI * 2 * i) / 20;
    const speed = Math.random() * 3.5 + 2.0;
    winParticles.push({
      x: cx,
      y: cy,
      vx: Math.cos(angle) * speed,
      vy: Math.sin(angle) * speed,
      life: 1.0,
      r: Math.random() * 2.5 + 1.5,
      color: Math.random() > 0.5 ? '#22c55e' : '#38bdf8'
    });
  }
}

async function syncScoreToCloud(gameName, clears) {
  try {
    const res = await fetch('../save_score.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ game: gameName, score: clears })
    });
    const data = await res.json();
    if (data.success) {
      console.log("☁ High score synced to database:", clears);
    }
  } catch (err) {
    console.log("Local score preserved; cloud unreachable.");
  }
}

function resizeCanvas() {
  const container = document.getElementById('gameContainer');
  if (!container) return;
  const size = Math.min(container.clientWidth, container.clientHeight);
  canvas.width = size;
  canvas.height = size;
  cellSize = size / cols;
}
window.addEventListener('resize', () => {
  resizeCanvas();
  draw();
});

// High-Fidelity Vector Labyrinth Rendering
function draw() {
  if (cellSize <= 0) return;
  goalPulseTimer += 0.06;

  // Background
  ctx.fillStyle = '#06080e';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Draw Maze Walls with Rounded Cyber Blocks & Specular Neon Edges
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] === 1) {
        ctx.fillStyle = 'rgba(168, 85, 247, 0.16)';
        ctx.fillRect(c * cellSize, r * cellSize, cellSize, cellSize);

        ctx.strokeStyle = 'rgba(192, 132, 252, 0.45)';
        ctx.lineWidth = 1;
        ctx.strokeRect(c * cellSize + 0.5, r * cellSize + 0.5, cellSize - 1, cellSize - 1);
      } else {
        // Corridor Subtle Node Dot
        ctx.fillStyle = 'rgba(255, 255, 255, 0.03)';
        ctx.fillRect((c + 0.5) * cellSize - 0.5, (r + 0.5) * cellSize - 0.5, 1, 1);
      }
    }
  }

  // Draw Player Movement Trail
  playerTrail.forEach(t => {
    t.alpha -= 0.05;
    if (t.alpha > 0) {
      ctx.fillStyle = 'rgba(56, 189, 248, ' + (t.alpha * 0.4).toFixed(2) + ')';
      ctx.beginPath();
      ctx.arc((t.x + 0.5) * cellSize, (t.y + 0.5) * cellSize, cellSize * 0.22, 0, Math.PI * 2);
      ctx.fill();
    }
  });

  // Draw Holographic Extraction Goal
  const gcx = (goal.x + 0.5) * cellSize;
  const gcy = (goal.y + 0.5) * cellSize;
  const gPulse = 1 + Math.sin(goalPulseTimer * 2) * 0.18;

  ctx.shadowColor = '#22c55e';
  ctx.shadowBlur = 14 * gPulse;

  ctx.fillStyle = '#22c55e';
  ctx.beginPath();
  ctx.arc(gcx, gcy, cellSize * 0.34 * gPulse, 0, Math.PI * 2);
  ctx.fill();

  ctx.fillStyle = '#ffffff';
  ctx.beginPath();
  ctx.arc(gcx, gcy, cellSize * 0.16, 0, Math.PI * 2);
  ctx.fill();

  ctx.strokeStyle = 'rgba(255, 255, 255, 0.6)';
  ctx.lineWidth = 1.2;
  ctx.beginPath();
  ctx.arc(gcx, gcy, cellSize * 0.48, goalPulseTimer, goalPulseTimer + Math.PI * 1.3);
  ctx.stroke();

  // Draw Operative Player Avatar (Cyan Glow Cyber Cube)
  const pcx = (player.x + 0.5) * cellSize;
  const pcy = (player.y + 0.5) * cellSize;
  const pr = cellSize * 0.36;

  ctx.shadowColor = '#38bdf8';
  ctx.shadowBlur = 12;
  ctx.fillStyle = '#ffffff';
  ctx.beginPath();
  ctx.arc(pcx, pcy, pr, 0, Math.PI * 2);
  ctx.fill();

  ctx.fillStyle = '#38bdf8';
  ctx.beginPath();
  ctx.arc(pcx, pcy, pr * 0.65, 0, Math.PI * 2);
  ctx.fill();

  // Render & Update Win Particles
  for (let i = winParticles.length - 1; i >= 0; i--) {
    const p = winParticles[i];
    p.x += p.vx;
    p.y += p.vy;
    p.life -= 0.03;
    if (p.life <= 0) {
      winParticles.splice(i, 1);
      continue;
    }

    ctx.shadowColor = p.color;
    ctx.shadowBlur = 8;
    ctx.fillStyle = p.color;
    ctx.globalAlpha = p.life;
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.r * p.life, 0, Math.PI * 2);
    ctx.fill();
    ctx.globalAlpha = 1.0;
  }

  ctx.shadowBlur = 0;
}

// Continuous redraw for pulsing beacon
function animationLoop() {
  if (!isGameOver) {
    draw();
  }
  requestAnimationFrame(animationLoop);
}
requestAnimationFrame(animationLoop);

// Keyboard controls
window.addEventListener('keydown', (e) => {
  switch (e.key) {
    case 'ArrowUp': case 'w': case 'W': movePlayer(0, -1); e.preventDefault(); break;
    case 'ArrowDown': case 's': case 'S': movePlayer(0, 1); e.preventDefault(); break;
    case 'ArrowLeft': case 'a': case 'A': movePlayer(-1, 0); e.preventDefault(); break;
    case 'ArrowRight': case 'd': case 'D': movePlayer(1, 0); e.preventDefault(); break;
  }
});

// Touch Swipe Navigation
let touchStartX = 0, touchStartY = 0;
window.addEventListener('touchstart', (e) => {
  if (e.touches.length > 0) {
    touchStartX = e.touches[0].clientX;
    touchStartY = e.touches[0].clientY;
  }
}, { passive: true });

window.addEventListener('touchend', (e) => {
  if (isGameOver || e.changedTouches.length === 0) return;
  const dx = e.changedTouches[0].clientX - touchStartX;
  const dy = e.changedTouches[0].clientY - touchStartY;
  if (Math.abs(dx) > 25 || Math.abs(dy) > 25) {
    if (Math.abs(dx) > Math.abs(dy)) {
      movePlayer(dx > 0 ? 1 : -1, 0);
    } else {
      movePlayer(0, dy > 0 ? 1 : -1);
    }
  }
}, { passive: true });