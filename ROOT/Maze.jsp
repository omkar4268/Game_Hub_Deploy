<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Maze // Procedural Labyrinth</title>
<style>
  :root {
    --bg-dark: #070b14;
    --card-bg: rgba(15, 23, 42, 0.88);
    --primary: #38bdf8;
    --primary-glow: rgba(56, 189, 248, 0.45);
    --accent: #22c55e;
    --accent-glow: rgba(34, 197, 94, 0.4);
    --danger: #ef4444;
    --text: #f8fafc;
    --text-muted: #94a3b8;
    --border-glow: rgba(56, 189, 248, 0.35);
  }
  * { 
    box-sizing: border-box; 
    margin: 0; 
    padding: 0; 
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
    -webkit-tap-highlight-color: transparent;
  }
  body {
    background: radial-gradient(circle at top, #1e293b, var(--bg-dark));
    color: var(--text);
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.2rem;
    user-select: none;
    touch-action: none;
    overflow-x: hidden;
    position: relative;
  }

  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.09) 0%, transparent 40%),
      radial-gradient(circle at 85% 80%, rgba(34, 197, 94, 0.09) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 32px 32px, 32px 32px;
    z-index: -1;
    pointer-events: none;
  }

  /* Main Game Arena Container */
  .game-arena {
    width: 100%;
    max-width: 600px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-bottom: 0.8rem;
  }
  .header-left {
    display: flex;
    align-items: center;
    gap: 10px;
  }
  h1 { 
    color: var(--primary); 
    font-size: 1.5rem; 
    letter-spacing: 2px; 
    font-weight: 900;
    text-shadow: 0 0 15px var(--primary-glow);
  }
  .badge {
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.4);
    color: var(--primary);
    font-size: 0.72rem;
    padding: 3px 8px;
    border-radius: 6px;
    font-weight: 800;
    letter-spacing: 1px;
  }

  .btn-hub {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text);
    padding: 0.45rem 1rem;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.85rem;
    font-weight: 700;
    text-decoration: none;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }
  .btn-hub:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(56, 189, 248, 0.4);
    transform: translateY(-1px);
  }

  .controls-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    margin-bottom: 0.8rem;
    background: var(--card-bg);
    padding: 0.65rem 1.6rem;
    border-radius: 14px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    font-size: 0.95rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(10px);
  }
  .controls-bar span { color: var(--accent); font-weight: 800; font-size: 1.1rem; }

  select {
    background: #0f172a;
    color: var(--text);
    border: 1px solid #475569;
    padding: 0.4rem 0.8rem;
    border-radius: 8px;
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    outline: none;
    transition: 0.2s;
  }
  select:focus {
    border-color: var(--primary);
  }

  /* Responsive Game Container */
  .game-container {
    position: relative;
    width: 100%;
    max-width: 600px;
    aspect-ratio: 1 / 1;
    border-radius: 20px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.8), 0 0 35px rgba(56, 189, 248, 0.2);
    background: #020617;
    border: 2px solid var(--border-glow);
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  canvas { 
    width: 100%; 
    height: 100%; 
    display: block; 
  }

  /* Pre-Game Startup Overlay - Fully Centered, Zero Scrollbars */
  .overlay-screen {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.94);
    backdrop-filter: blur(14px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 2rem 1.8rem;
    z-index: 30;
    text-align: center;
    box-sizing: border-box;
  }

  .overlay-icon {
    font-size: clamp(2.5rem, 5vw, 3.4rem);
    margin-bottom: 0.4rem;
    filter: drop-shadow(0 0 20px var(--primary-glow));
    animation: bounce 2.2s infinite ease-in-out;
  }
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }

  .overlay-title {
    font-size: clamp(1.4rem, 4vw, 1.9rem);
    font-weight: 900;
    letter-spacing: 2px;
    color: var(--primary);
    text-shadow: 0 0 20px var(--primary-glow);
    margin-bottom: 0.4rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    flex-wrap: wrap;
  }
  .overlay-sub {
    font-size: clamp(0.82rem, 2vw, 0.95rem);
    color: var(--text-muted);
    max-width: 440px;
    line-height: 1.6;
    margin-bottom: 1.4rem;
  }

  .overlay-stats {
    display: flex;
    gap: 2rem;
    background: rgba(15, 23, 42, 0.85);
    border: 1px solid rgba(255, 255, 255, 0.1);
    padding: 0.75rem 2rem;
    border-radius: 14px;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
  }
  .overlay-stats div {
    font-size: 0.8rem;
    color: var(--text-muted);
  }
  .overlay-stats div span {
    display: block;
    font-weight: 900;
    font-size: 1.3rem;
    color: var(--accent);
    margin-top: 2px;
  }

  .menu-actions {
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
    width: 100%;
    max-width: 400px;
  }

  .menu-actions-row {
    display: flex;
    gap: 0.8rem;
    width: 100%;
  }

  .btn-cyber {
    min-height: 48px;
    padding: 0.75rem 1.4rem;
    border-radius: 12px;
    border: none;
    font-weight: 800;
    font-size: 0.92rem;
    letter-spacing: 1px;
    cursor: pointer;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    text-decoration: none;
    box-sizing: border-box;
    flex: 1;
  }
  .btn-cyber-primary {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 20px var(--primary-glow);
  }
  .btn-cyber-primary:hover {
    background: #7dd3fc;
    box-shadow: 0 0 30px rgba(56, 189, 248, 0.7);
    transform: translateY(-2px);
  }
  .btn-cyber-secondary {
    background: rgba(255, 255, 255, 0.08);
    color: var(--text);
    border: 1px solid rgba(255, 255, 255, 0.12);
  }
  .btn-cyber-secondary:hover {
    background: rgba(255, 255, 255, 0.16);
    border-color: rgba(56, 189, 248, 0.4);
    color: var(--primary);
    transform: translateY(-1px);
  }

  /* Intel & Rules Drawer */
  .intel-modal {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.97);
    backdrop-filter: blur(16px);
    display: none;
    flex-direction: column;
    padding: 2rem;
    z-index: 40;
    text-align: left;
    box-sizing: border-box;
    overflow-y: auto;
  }
  .intel-modal.active { display: flex; }

  .intel-title {
    font-size: 1.25rem;
    color: var(--accent);
    font-weight: 800;
    margin-bottom: 1.2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .intel-row {
    margin-bottom: 1rem;
    font-size: 0.88rem;
    line-height: 1.5;
    color: var(--text-muted);
  }
  .intel-row strong {
    color: var(--text);
    display: block;
    margin-bottom: 4px;
    font-size: 0.95rem;
  }

  /* Loading Overlay */
  #loadingOverlay {
    position: absolute;
    inset: 0;
    background: rgba(15, 23, 42, 0.92);
    display: none;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 25;
    gap: 1rem;
    font-size: 0.9rem;
    color: var(--primary);
  }
  .spinner {
    width: 44px;
    height: 44px;
    border: 4px solid #334155;
    border-top: 4px solid var(--primary);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }
  @keyframes spin { 100% { transform: rotate(360deg); } }

  /* Mobile Touch D-Pad (Context-aware display) */
  .dpad {
    display: none;
    grid-template-columns: repeat(3, 52px);
    grid-template-rows: repeat(3, 46px);
    gap: 6px;
    margin-top: 0.8rem;
  }
  .dpad button {
    background: rgba(15, 23, 42, 0.9);
    border: 1px solid rgba(56, 189, 248, 0.3);
    color: var(--primary);
    border-radius: 12px;
    font-size: 1.25rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(0,0,0,0.5);
  }
  .dpad button:active {
    background: var(--primary);
    color: #000;
  }
  .dpad-up { grid-column: 2; grid-row: 1; }
  .dpad-left { grid-column: 1; grid-row: 2; }
  .dpad-down { grid-column: 2; grid-row: 2; }
  .dpad-right { grid-column: 3; grid-row: 2; }

  /* Universal Cyber-Scanner Wipe Transition */
  .cyber-wipe-overlay {
    position: fixed;
    inset: 0;
    pointer-events: none;
    z-index: 99999;
    opacity: 0;
    overflow: hidden;
  }
  .cyber-wipe-overlay.active {
    pointer-events: all;
    opacity: 1;
  }
  .cyber-wipe-beam {
    position: absolute;
    top: 0;
    left: -100vw;
    width: 100vw;
    height: 100vh;
    height: 100dvh;
    background: linear-gradient(90deg, transparent 0%, rgba(56, 189, 248, 0.1) 60%, rgba(56, 189, 248, 0.5) 92%, #38bdf8 98%, #ffffff 100%);
    box-shadow: 12px 0 35px rgba(56, 189, 248, 0.8), 2px 0 15px #22c55e;
    transform: translate3d(0, 0, 0);
  }
  .cyber-wipe-overlay.active .cyber-wipe-beam {
    animation: cyberBeamSweep 0.26s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  @keyframes cyberBeamSweep {
    0% { transform: translateX(0); }
    100% { transform: translateX(200vw); }
  }

  /* Compact Mobile Viewports (No Clipping, Perfect Proportions) */
  @media (max-width: 640px) {
    body { padding: 0.6rem; }
    .game-arena { max-width: 100%; width: 100%; }
    .header h1 { font-size: 1.25rem; }
    .controls-bar { padding: 0.5rem 1rem; font-size: 0.82rem; margin-bottom: 0.6rem; }
    .game-container { max-width: min(380px, 94vw); width: 100%; aspect-ratio: 1 / 1; border-radius: 16px; }
    .overlay-screen { padding: 1.1rem 0.9rem; }
    .overlay-icon { font-size: 2.1rem; margin-bottom: 2px; }
    .overlay-title { font-size: 1.25rem; margin-bottom: 2px; gap: 6px; }
    .overlay-sub { font-size: 0.78rem; line-height: 1.35; margin-bottom: 0.65rem; max-width: 300px; }
    .overlay-stats { gap: 1rem; padding: 0.35rem 0.9rem; margin-bottom: 0.75rem; border-radius: 10px; }
    .overlay-stats div { font-size: 0.72rem; }
    .overlay-stats div span { font-size: 1.05rem; }
    .menu-actions { gap: 0.55rem; width: 100%; max-width: 320px; }
    .menu-actions-row { display: flex; flex-direction: row; gap: 0.55rem; width: 100%; }
    .btn-cyber { min-height: 44px; padding: 0.55rem 0.75rem; font-size: 0.8rem; border-radius: 10px; }
    .dpad { grid-template-columns: repeat(3, 50px); grid-template-rows: repeat(3, 44px); gap: 5px; margin-top: 0.6rem; }
    .dpad button { font-size: 1.15rem; border-radius: 10px; }
  }
</style>
</head>
<body>
  <!-- Universal Cyber-Scanner Wipe Transition -->
  <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
    <div class="cyber-wipe-beam"></div>
  </div>

  <div class="game-arena">
    <div class="header">
      <div class="header-left">
        <h1>CYBER MAZE</h1>
        <span class="badge">LABYRINTH PROTOCOL</span>
      </div>
      <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-hub">‹ Hub</a>
    </div>

    <div class="controls-bar">
      <div>Time: <span id="timerVal">00:00</span></div>
      <div>Cleared: <span id="clearedVal">0</span></div>
      <div>
        <select id="difficulty" onchange="onDiffChange()">
          <option value="easy">Easy (13x13)</option>
          <option value="medium" selected>Medium (21x21)</option>
          <option value="hard">Hard (31x31)</option>
        </select>
      </div>
    </div>

    <div class="game-container">
      <!-- Standardized Pre-Game Interactive Startup Screen -->
      <div id="splashScreen" class="overlay-screen">
        <div class="overlay-icon">⚡</div>
        <h2 class="overlay-title">
          CYBER MAZE
          <span class="badge">v2.5</span>
        </h2>
        <p class="overlay-sub">Solve procedurally generated labyrinth nodes, navigate recursive backtracker corridors, and locate the green extraction portal.</p>
        
        <div class="overlay-stats">
          <div>Mazes Cleared<span id="splashClears">0</span></div>
          <div>Fastest Escape<span id="splashBestTime">--</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startNewGame()">▶ INITIATE RUN</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="openIntel()">⚙ PROTOCOL & CONTROLS</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Win Screen -->
      <div id="winScreen" class="overlay-screen" style="display: none;">
        <div class="overlay-icon" style="color: var(--accent);">🏆</div>
        <h2 class="overlay-title" style="color: var(--accent); text-shadow: 0 0 20px var(--accent-glow);">MAZE CLEARED</h2>
        <p class="overlay-sub">Extraction portal reached. Neural telemetry verified.</p>
        
        <div class="overlay-stats">
          <div>Escape Time<span id="winTimeVal">00:00</span></div>
          <div>Total Cleared<span id="winClearsVal">1</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startNewGame()">↻ NEXT MAZE</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="showSplashScreen()">☰ MAIN MENU</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Intel Modal -->
      <div id="intelModal" class="intel-modal">
        <div class="intel-title">
          <span>SECURITY DIRECTIVE</span>
          <button class="btn-hub" onclick="closeIntel()">✕ Close</button>
        </div>

        <div class="intel-row">
          <strong>🎮 CONTROLS</strong>
          Use Arrow Keys or W/A/S/D on desktop, or the on-screen tactical D-Pad on mobile viewports.
        </div>

        <div class="intel-row">
          <strong>⚡ OBJECTIVE</strong>
          Navigate your cyan runner block through randomized walls to reach the pulsing emerald extraction portal.
        </div>

        <div class="intel-row">
          <strong>🎯 TELEMETRY TRACKING</strong>
          Total labyrinth clears and fastest escape seconds automatically synchronize with your Cyber Hub profile and global leaderboards.
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeIntel(); startNewGame();">
          ▶ COMMENCE MISSION
        </button>
      </div>

      <!-- Loading Overlay -->
      <div id="loadingOverlay">
        <div class="spinner"></div>
        <div>Synthesizing Maze Architecture...</div>
      </div>

      <canvas id="mazeCanvas"></canvas>
    </div>

    <!-- Mobile Touch Controls -->
    <div class="dpad" id="mobileDpad">
      <button class="dpad-up" onclick="movePlayer(0, -1)">▲</button>
      <button class="dpad-left" onclick="movePlayer(-1, 0)">◀</button>
      <button class="dpad-down" onclick="movePlayer(0, 1)">▼</button>
      <button class="dpad-right" onclick="movePlayer(1, 0)">▶</button>
    </div>
  </div>

<script>
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

      totalClears++;
      localStorage.setItem('hub_maze_clears', totalClears);
      clearedVal.innerText = totalClears;

      if (bestTime === 0 || secondsElapsed < bestTime) {
        bestTime = secondsElapsed;
        localStorage.setItem('hub_maze_best_time', bestTime);
      }

      const mazeScore = totalClears * 100;
      fetch('save_score.jsp', {
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
</script>
</body>
</html>