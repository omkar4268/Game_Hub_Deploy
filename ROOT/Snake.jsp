<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Snake // Neon Protocol</title>
<style>
  :root {
    --bg-base: #030712;
    --card-bg: rgba(15, 23, 42, 0.88);
    --primary: #10b981;
    --primary-glow: rgba(16, 185, 129, 0.45);
    --accent: #38bdf8;
    --accent-glow: rgba(56, 189, 248, 0.4);
    --food: #f43f5e;
    --food-glow: rgba(244, 63, 94, 0.55);
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --border-glow: rgba(16, 185, 129, 0.35);
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    -webkit-tap-highlight-color: transparent;
  }

  body {
    background: radial-gradient(circle at top, #0f172a, var(--bg-base));
    color: var(--text-main);
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.2rem;
    overflow-x: hidden;
    position: relative;
  }

  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 20% 20%, rgba(16, 185, 129, 0.09) 0%, transparent 40%),
      radial-gradient(circle at 80% 80%, rgba(56, 189, 248, 0.09) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 32px 32px, 32px 32px;
    z-index: -1;
    pointer-events: none;
  }

  /* Main Game Arena Container */
  .game-arena {
    width: 100%;
    max-width: 580px;
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

  .header h1 {
    font-size: 1.5rem;
    color: var(--primary);
    letter-spacing: 2px;
    font-weight: 900;
    text-shadow: 0 0 15px var(--primary-glow);
  }

  .header-badge {
    background: rgba(16, 185, 129, 0.15);
    border: 1px solid rgba(16, 185, 129, 0.4);
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
    color: var(--text-main);
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

  .scoreboard {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    background: var(--card-bg);
    padding: 0.65rem 1.6rem;
    border-radius: 14px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    font-size: 0.95rem;
    margin-bottom: 0.8rem;
    backdrop-filter: blur(10px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
  }
  .scoreboard span { color: var(--primary); font-weight: 800; font-size: 1.1rem; }
  .scoreboard .best-label span { color: #facc15; }

  /* Canvas Container with responsive PC/Mobile scaling */
  .canvas-wrapper {
    position: relative;
    width: 100%;
    max-width: 580px;
    aspect-ratio: 1 / 1;
    border-radius: 20px;
    border: 2px solid var(--border-glow);
    box-shadow: 0 0 35px rgba(16, 185, 129, 0.18), 0 20px 50px rgba(0, 0, 0, 0.8);
    background: #020617;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  canvas {
    width: 100%;
    height: 100%;
    display: block;
    image-rendering: pixelated;
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

  .overlay-subtitle {
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
    background: #34d399;
    box-shadow: 0 0 30px rgba(16, 185, 129, 0.7);
    transform: translateY(-2px);
  }
  .btn-cyber-secondary {
    background: rgba(255, 255, 255, 0.08);
    color: var(--text-main);
    border: 1px solid rgba(255, 255, 255, 0.12);
  }
  .btn-cyber-secondary:hover {
    background: rgba(255, 255, 255, 0.16);
    border-color: rgba(56, 189, 248, 0.4);
    color: var(--accent);
    transform: translateY(-1px);
  }

  /* Manual / Controls Drawer */
  .manual-modal {
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
  .manual-modal.active { display: flex; }

  .manual-title {
    font-size: 1.25rem;
    color: var(--accent);
    font-weight: 800;
    margin-bottom: 1.2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .manual-row {
    margin-bottom: 1rem;
    font-size: 0.88rem;
    line-height: 1.5;
    color: var(--text-muted);
  }
  .manual-row strong {
    color: var(--text-main);
    display: block;
    margin-bottom: 4px;
    font-size: 0.95rem;
  }

  .speed-picker {
    display: flex;
    gap: 8px;
    margin-top: 8px;
  }
  .speed-btn {
    flex: 1;
    padding: 8px 0;
    font-size: 0.8rem;
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(15, 23, 42, 0.8);
    color: var(--text-muted);
    cursor: pointer;
    font-weight: 700;
    transition: 0.2s;
  }
  .speed-btn.active {
    background: rgba(16, 185, 129, 0.2);
    border-color: var(--primary);
    color: var(--primary);
    box-shadow: 0 0 10px rgba(16, 185, 129, 0.25);
  }

  /* Mobile Virtual D-Pad (Context-aware display) */
  #mobileDpad {
    display: none;
    grid-template-columns: repeat(3, 52px);
    grid-template-rows: repeat(3, 46px);
    gap: 6px;
    margin-top: 0.8rem;
  }

  .d-btn {
    background: rgba(15, 23, 42, 0.9);
    border: 1px solid rgba(56, 189, 248, 0.3);
    color: var(--accent);
    border-radius: 12px;
    font-size: 1.25rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    user-select: none;
    transition: background 0.1s, transform 0.1s;
    box-shadow: 0 4px 12px rgba(0,0,0,0.5);
  }
  .d-btn:active {
    background: var(--accent);
    color: #000;
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.5);
    transform: scale(0.93);
  }
  .d-up    { grid-column: 2; grid-row: 1; }
  .d-left  { grid-column: 1; grid-row: 2; }
  .d-down  { grid-column: 2; grid-row: 2; }
  .d-right { grid-column: 3; grid-row: 2; }

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
    .scoreboard { padding: 0.5rem 1rem; font-size: 0.82rem; margin-bottom: 0.6rem; }
    .canvas-wrapper { max-width: min(380px, 94vw); width: 100%; aspect-ratio: 1 / 1; border-radius: 16px; }
    .overlay-screen { padding: 1.1rem 0.9rem; }
    .overlay-icon { font-size: 2.1rem; margin-bottom: 2px; }
    .overlay-title { font-size: 1.25rem; margin-bottom: 2px; gap: 6px; }
    .overlay-subtitle { font-size: 0.78rem; line-height: 1.35; margin-bottom: 0.65rem; max-width: 300px; }
    .overlay-stats { gap: 1rem; padding: 0.35rem 0.9rem; margin-bottom: 0.75rem; border-radius: 10px; }
    .overlay-stats div { font-size: 0.72rem; }
    .overlay-stats div span { font-size: 1.05rem; }
    .menu-actions { gap: 0.55rem; width: 100%; max-width: 320px; }
    .menu-actions-row { display: flex; flex-direction: row; gap: 0.55rem; width: 100%; }
    .btn-cyber { min-height: 44px; padding: 0.55rem 0.75rem; font-size: 0.8rem; border-radius: 10px; }
    #mobileDpad { grid-template-columns: repeat(3, 50px); grid-template-rows: repeat(3, 44px); gap: 5px; margin-top: 0.6rem; }
    .d-btn { font-size: 1.15rem; border-radius: 10px; }
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
        <h1>CYBER SNAKE</h1>
        <span class="header-badge">ARCADE PROTOCOL</span>
      </div>
      <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-hub">‹ Hub</a>
    </div>

    <div class="scoreboard">
      <div>Score: <span id="scoreVal">0</span></div>
      <div class="best-label">Record: <span id="highScoreVal">0</span></div>
      <div>Data Nodes: <span id="nodesVal">0</span></div>
    </div>

    <div class="canvas-wrapper">
      <!-- Screen 1: Pre-Game Interactive Splash Screen -->
      <div id="startScreen" class="overlay-screen">
        <div class="overlay-icon">🐍</div>
        <h2 class="overlay-title">
          CYBER SNAKE
          <span class="header-badge">v2.5</span>
        </h2>
        <p class="overlay-subtitle">Navigate your neural serpent across the digital vector matrix, devour rogue data packets, and set the all-time high score.</p>
        
        <div class="overlay-stats">
          <div>High Score<span id="splashBest">0 pts</span></div>
          <div>Nodes Consumed<span id="splashNodes">0</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startGame()">▶ INITIATE RUN</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="openManual()">⚙ PROTOCOL & CONTROLS</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 2: Game Over Screen -->
      <div id="gameOverScreen" class="overlay-screen" style="display: none;">
        <div class="overlay-icon" style="color: var(--food);">💥</div>
        <h2 class="overlay-title" style="color: var(--food); text-shadow: 0 0 20px var(--food-glow);">SYSTEM CRASH</h2>
        <p class="overlay-subtitle" id="gameOverSub">Sub-routine terminated. Vector collision detected.</p>
        
        <div class="overlay-stats">
          <div>Run Score<span id="finalScoreVal" style="color: var(--primary);">0 pts</span></div>
          <div>Nodes Collected<span id="finalNodesVal" style="color: var(--accent);">0</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startGame()">↻ RETRY RUN</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="showStartScreen()">☰ MAIN MENU</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 3: Settings & Controls Modal -->
      <div id="manualModal" class="manual-modal">
        <div class="manual-title">
          <span>SECURITY DIRECTIVE</span>
          <button class="btn-hub" onclick="closeManual()">✕ Close</button>
        </div>

        <div class="manual-row">
          <strong>🎮 PC KEYBOARD CONTROLS</strong>
          Use Arrow Keys or W/A/S/D to steer your serpent. Responsive direction buffer prevents 180° self-reversals.
        </div>

        <div class="manual-row">
          <strong>📱 MOBILE TOUCH CONTROLS</strong>
          Swipe anywhere across the grid or tap the tactical on-screen D-Pad.
        </div>

        <div class="manual-row">
          <strong>⚡ NEURAL TICK SPEED (BALANCED)</strong>
          Select game clock frequency:
          <div class="speed-picker">
            <button class="speed-btn" id="spdScout" onclick="setSpeed(175, 'spdScout')">Scout (Chill)</button>
            <button class="speed-btn active" id="spdAgent" onclick="setSpeed(145, 'spdAgent')">Agent (Balanced)</button>
            <button class="speed-btn" id="spdOver" onclick="setSpeed(110, 'spdOver')">Overclock</button>
          </div>
        </div>

        <div class="manual-row">
          <strong>🎯 SCORING TELEMETRY</strong>
          Each crimson data node awards +10 points. High scores automatically persist to your cloud profile!
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeManual(); startGame();">
          ▶ START PLAYING
        </button>
      </div>

      <canvas id="gameCanvas" width="400" height="400"></canvas>
    </div>

    <!-- On-Screen Controls for Mobile Devices -->
    <div id="mobileDpad">
      <div class="d-btn d-up" data-dir="UP">▲</div>
      <div class="d-btn d-left" data-dir="LEFT">◀</div>
      <div class="d-btn d-down" data-dir="DOWN">▼</div>
      <div class="d-btn d-right" data-dir="RIGHT">▶</div>
    </div>
  </div>

<script>
  const canvas = document.getElementById('gameCanvas');
  const ctx = canvas.getContext('2d');
  const startScreen = document.getElementById('startScreen');
  const gameOverScreen = document.getElementById('gameOverScreen');
  const manualModal = document.getElementById('manualModal');

  const scoreVal = document.getElementById('scoreVal');
  const highScoreVal = document.getElementById('highScoreVal');
  const nodesVal = document.getElementById('nodesVal');
  const splashBest = document.getElementById('splashBest');
  const splashNodes = document.getElementById('splashNodes');
  const finalScoreVal = document.getElementById('finalScoreVal');
  const finalNodesVal = document.getElementById('finalNodesVal');
  const dpad = document.getElementById('mobileDpad');

  const isMobile = ('ontouchstart' in window) || 
                   (navigator.maxTouchPoints > 0) || 
                   /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);
  // Keep D-pad hidden on initial startup screen
  dpad.style.display = 'none';

  // Crisp 20x20 grid on a 400x400 internal canvas
  const grid = 20; 
  const cols = 20; 
  const rows = 20;
  canvas.width = cols * grid;
  canvas.height = rows * grid;

  let snake = [];
  let dir = { x: 1, y: 0 };
  let nextDir = { x: 1, y: 0 };
  let food = { x: 0, y: 0 };
  let score = 0;
  let runNodes = 0;

  // Persistent stats
  let highScore = parseInt(localStorage.getItem('hub_snake_high') || '0', 10);
  let totalNodes = parseInt(localStorage.getItem('hub_snake_nodes') || '0', 10);
  
  highScoreVal.innerText = highScore;
  splashBest.innerText = highScore + ' pts';
  splashNodes.innerText = totalNodes;

  let isPlaying = false;
  let lastTick = 0;
  
  // Balanced 145ms tick rate
  let tickRate = 145; 

  function setSpeed(ms, btnId) {
    tickRate = ms;
    document.querySelectorAll('.speed-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(btnId).classList.add('active');
  }

  function openManual() { 
    manualModal.classList.add('active'); 
    dpad.style.display = 'none';
  }
  function closeManual() { 
    manualModal.classList.remove('active'); 
    if (isPlaying && isMobile) dpad.style.display = 'grid';
  }

  function showStartScreen() {
    gameOverScreen.style.display = 'none';
    manualModal.classList.remove('active');
    startScreen.style.display = 'flex';
    splashBest.innerText = highScore + ' pts';
    splashNodes.innerText = totalNodes;
    dpad.style.display = 'none';
  }

  function spawnFood() {
    let valid = false;
    while (!valid) {
      food = {
        x: Math.floor(Math.random() * cols),
        y: Math.floor(Math.random() * rows)
      };
      valid = !snake.some(seg => seg.x === food.x && seg.y === food.y);
    }
  }

  function startGame() {
    startScreen.style.display = 'none';
    gameOverScreen.style.display = 'none';
    manualModal.classList.remove('active');
    if (isMobile) dpad.style.display = 'grid';

    snake = [
      { x: 8, y: 10 },
      { x: 7, y: 10 },
      { x: 6, y: 10 }
    ];
    dir = { x: 1, y: 0 };
    nextDir = { x: 1, y: 0 };
    score = 0;
    runNodes = 0;
    scoreVal.innerText = score;
    nodesVal.innerText = runNodes;
    spawnFood();
    isPlaying = true;
    lastTick = performance.now();
    requestAnimationFrame(gameLoop);
  }

  function setDirection(newX, newY) {
    if (newX !== -dir.x && newY !== -dir.y) {
      nextDir = { x: newX, y: newY };
    }
  }

  function update() {
    dir = { ...nextDir };
    const head = { x: snake[0].x + dir.x, y: snake[0].y + dir.y };

    // Wall collision checks
    if (head.x < 0 || head.x >= cols || head.y < 0 || head.y >= rows) {
      return triggerGameOver();
    }

    // Body collision checks
    for (let i = 0; i < snake.length; i++) {
      if (head.x === snake[i].x && head.y === snake[i].y) {
        return triggerGameOver();
      }
    }

    snake.unshift(head);

    // Food consumption
    if (head.x === food.x && head.y === food.y) {
      score += 10;
      runNodes++;
      totalNodes++;
      scoreVal.innerText = score;
      nodesVal.innerText = runNodes;

      localStorage.setItem('hub_snake_nodes', totalNodes);

      if (score > highScore) {
        highScore = score;
        highScoreVal.innerText = highScore;
        localStorage.setItem('hub_snake_high', highScore);
      }
      spawnFood();
    } else {
      snake.pop();
    }
  }

  function triggerGameOver() {
    isPlaying = false;
    finalScoreVal.innerText = score + ' pts';
    finalNodesVal.innerText = runNodes;
    gameOverScreen.style.display = 'flex';
    dpad.style.display = 'none';

    if (score > 0) {
      syncScoreToCloud('snake', score);
    }
  }

  async function syncScoreToCloud(gameName, finalScore) {
    try {
      const res = await fetch('save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ game: gameName, score: finalScore })
      });
      const data = await res.json();
      if (data.success) {
        console.log("☁ High score synced to database:", finalScore);
      }
    } catch (err) {
      console.log("Local score preserved; cloud unreachable.");
    }
  }

  function render() {
    ctx.fillStyle = '#020617';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = 'rgba(255, 255, 255, 0.04)';
    for (let x = 0; x < cols; x++) {
      for (let y = 0; y < rows; y++) {
        ctx.fillRect(x * grid + grid/2 - 0.5, y * grid + grid/2 - 0.5, 1, 1);
      }
    }

    // Draw Neon Food
    ctx.fillStyle = '#f43f5e';
    ctx.shadowColor = '#f43f5e';
    ctx.shadowBlur = 12;
    ctx.beginPath();
    ctx.arc((food.x + 0.5) * grid, (food.y + 0.5) * grid, grid * 0.38, 0, Math.PI * 2);
    ctx.fill();

    // Draw Snake Segments
    snake.forEach((seg, index) => {
      ctx.fillStyle = (index === 0) ? '#34d399' : '#10b981';
      ctx.shadowColor = '#10b981';
      ctx.shadowBlur = (index === 0) ? 12 : 5;
      ctx.fillRect(seg.x * grid + 2, seg.y * grid + 2, grid - 4, grid - 4);
    });

    ctx.shadowBlur = 0;
  }

  function gameLoop(timestamp) {
    if (!isPlaying) return;
    if (timestamp - lastTick >= tickRate) {
      update();
      lastTick = timestamp;
    }
    render();
    if (isPlaying) requestAnimationFrame(gameLoop);
  }

  window.addEventListener('keydown', (e) => {
    switch (e.key) {
      case 'ArrowUp': case 'w': case 'W': setDirection(0, -1); e.preventDefault(); break;
      case 'ArrowDown': case 's': case 'S': setDirection(0, 1); e.preventDefault(); break;
      case 'ArrowLeft': case 'a': case 'A': setDirection(-1, 0); e.preventDefault(); break;
      case 'ArrowRight': case 'd': case 'D': setDirection(1, 0); e.preventDefault(); break;
    }
  });

  // Touch D-Pad
  document.querySelectorAll('.d-btn').forEach(btn => {
    const handlePress = (e) => {
      e.preventDefault();
      const dirStr = btn.getAttribute('data-dir');
      if (dirStr === 'UP') setDirection(0, -1);
      if (dirStr === 'DOWN') setDirection(0, 1);
      if (dirStr === 'LEFT') setDirection(-1, 0);
      if (dirStr === 'RIGHT') setDirection(1, 0);
    };
    btn.addEventListener('touchstart', handlePress, { passive: false });
    btn.addEventListener('mousedown', handlePress);
  });

  // Swipe detection
  let touchStartX = 0;
  let touchStartY = 0;

  canvas.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });

  canvas.addEventListener('touchend', (e) => {
    const dx = e.changedTouches[0].screenX - touchStartX;
    const dy = e.changedTouches[0].screenY - touchStartY;
    const absX = Math.abs(dx);
    const absY = Math.abs(dy);

    if (Math.max(absX, absY) > 25) {
      if (absX > absY) {
        setDirection(dx > 0 ? 1 : -1, 0);
      } else {
        setDirection(0, dy > 0 ? 1 : -1);
      }
    }
  }, { passive: true });

  // Initial draw
  render();

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