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
    --primary-glow: rgba(16, 185, 129, 0.4);
    --accent: #38bdf8;
    --accent-glow: rgba(56, 189, 248, 0.4);
    --food: #f43f5e;
    --food-glow: rgba(244, 63, 94, 0.5);
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --border-glow: rgba(16, 185, 129, 0.25);
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
    padding: 0.8rem;
    overflow: hidden;
    touch-action: none;
    position: relative;
  }

  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 20% 20%, rgba(16, 185, 129, 0.08) 0%, transparent 40%),
      radial-gradient(circle at 80% 80%, rgba(56, 189, 248, 0.08) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 28px 28px, 28px 28px;
    z-index: -1;
    pointer-events: none;
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    max-width: 380px;
    margin-bottom: 0.6rem;
  }

  .header-title-box {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .header h1 {
    font-size: 1.25rem;
    color: var(--primary);
    letter-spacing: 1.5px;
    font-weight: 900;
    text-shadow: 0 0 12px var(--primary-glow);
  }

  .header-badge {
    background: rgba(16, 185, 129, 0.15);
    border: 1px solid rgba(16, 185, 129, 0.4);
    color: var(--primary);
    font-size: 0.65rem;
    padding: 2px 6px;
    border-radius: 4px;
    font-weight: 700;
    letter-spacing: 0.5px;
  }

  .btn-hub {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    padding: 0.4rem 0.85rem;
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.8rem;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }
  .btn-hub:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.25);
  }

  .scoreboard {
    display: flex;
    gap: 1.2rem;
    background: var(--card-bg);
    padding: 0.4rem 1.2rem;
    border-radius: 9999px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    font-size: 0.88rem;
    margin-bottom: 0.6rem;
    backdrop-filter: blur(8px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
  }
  .scoreboard span { color: var(--primary); font-weight: 700; }
  .scoreboard .best-label span { color: #facc15; }

  /* Canvas Container */
  .canvas-wrapper {
    position: relative;
    border-radius: 16px;
    border: 2px solid var(--border-glow);
    box-shadow: 0 0 30px rgba(16, 185, 129, 0.15);
    background: #020617;
    overflow: hidden;
  }

  canvas {
    display: block;
    background: #020617;
  }

  /* Full Screen Pre-Game Menu & Overlays */
  .overlay-screen {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.92);
    backdrop-filter: blur(10px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
    z-index: 20;
    text-align: center;
    transition: all 0.3s ease;
  }

  .overlay-icon {
    font-size: 3rem;
    margin-bottom: 0.5rem;
    filter: drop-shadow(0 0 15px var(--primary-glow));
    animation: bounce 2s infinite ease-in-out;
  }
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-6px); }
  }

  .overlay-title {
    font-size: 1.6rem;
    font-weight: 900;
    letter-spacing: 2px;
    color: var(--primary);
    text-shadow: 0 0 18px var(--primary-glow);
    margin-bottom: 0.3rem;
  }

  .overlay-subtitle {
    font-size: 0.8rem;
    color: var(--text-muted);
    max-width: 280px;
    line-height: 1.4;
    margin-bottom: 1.2rem;
  }

  .overlay-stats {
    display: flex;
    gap: 1.2rem;
    background: rgba(15, 23, 42, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.08);
    padding: 0.5rem 1rem;
    border-radius: 10px;
    margin-bottom: 1.2rem;
    font-size: 0.78rem;
  }
  .overlay-stats div span {
    display: block;
    font-weight: 800;
    font-size: 1rem;
    color: var(--accent);
  }

  .menu-actions {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
    width: 100%;
    max-width: 240px;
  }

  .btn-cyber {
    padding: 0.7rem 1.4rem;
    border-radius: 10px;
    border: none;
    font-weight: 800;
    font-size: 0.88rem;
    letter-spacing: 1px;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    text-decoration: none;
  }
  .btn-cyber-primary {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 18px var(--primary-glow);
  }
  .btn-cyber-primary:hover {
    background: #34d399;
    box-shadow: 0 0 25px rgba(16, 185, 129, 0.6);
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
  }

  /* Settings / Controls Modal */
  .manual-modal {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.96);
    backdrop-filter: blur(12px);
    display: none;
    flex-direction: column;
    padding: 1.4rem;
    z-index: 30;
    text-align: left;
    overflow-y: auto;
  }
  .manual-modal.active { display: flex; }

  .manual-title {
    font-size: 1.15rem;
    color: var(--accent);
    font-weight: 800;
    margin-bottom: 0.8rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .manual-row {
    margin-bottom: 0.8rem;
    font-size: 0.82rem;
    line-height: 1.4;
    color: var(--text-muted);
  }
  .manual-row strong {
    color: var(--text-main);
    display: block;
    margin-bottom: 2px;
  }

  .speed-picker {
    display: flex;
    gap: 6px;
    margin-top: 6px;
  }
  .speed-btn {
    flex: 1;
    padding: 6px 0;
    font-size: 0.75rem;
    border-radius: 6px;
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
  }

  /* Mobile Virtual D-Pad */
  #mobileDpad {
    display: none;
    grid-template-columns: repeat(3, 56px);
    grid-template-rows: repeat(3, 48px);
    gap: 6px;
    margin-top: 0.8rem;
  }

  .d-btn {
    background: rgba(15, 23, 42, 0.9);
    border: 1px solid rgba(56, 189, 248, 0.3);
    color: var(--accent);
    border-radius: 12px;
    font-size: 1.3rem;
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
</style>
</head>
<body>

  <div class="header">
    <div class="header-title-box">
      <h1>CYBER SNAKE</h1>
      <span class="header-badge">v2.4</span>
    </div>
    <a href="index.jsp" class="btn-hub">
      <span>‹</span> Hub
    </a>
  </div>

  <div class="scoreboard">
    <div>Score: <span id="scoreVal">0</span></div>
    <div class="best-label">Best: <span id="highScoreVal">0</span></div>
    <div>Nodes: <span id="nodesVal">0</span></div>
  </div>

  <div class="canvas-wrapper">
    <!-- Screen 1: Pre-Game Interactive Splash Menu -->
    <div id="startScreen" class="overlay-screen">
      <div class="overlay-icon">🐍</div>
      <h2 class="overlay-title">CYBER SNAKE</h2>
      <p class="overlay-subtitle">Steer your serpent through the digital grid, consume rogue data nodes, and set the ultimate record.</p>
      
      <div class="overlay-stats">
        <div>High Score<span id="splashBest">0 pts</span></div>
        <div>Nodes Consumed<span id="splashNodes">0</span></div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-cyber-primary" onclick="startGame()">▶ INITIATE RUN</button>
        <button class="btn-cyber btn-cyber-secondary" onclick="openManual()">⚙ PROTOCOL & CONTROLS</button>
        <a href="index.jsp" class="btn-cyber btn-cyber-secondary">✕ EXIT TO HUB</a>
      </div>
    </div>

    <!-- Screen 2: Game Over Screen -->
    <div id="gameOverScreen" class="overlay-screen" style="display: none;">
      <div class="overlay-icon" style="color: var(--food);">💥</div>
      <h2 class="overlay-title" style="color: var(--food); text-shadow: 0 0 18px var(--food-glow);">SYSTEM CRASH</h2>
      <p class="overlay-subtitle" id="gameOverSub">Sub-routine terminated. Vector collision detected.</p>
      
      <div class="overlay-stats">
        <div>Run Score<span id="finalScoreVal" style="color: var(--primary);">0 pts</span></div>
        <div>Nodes Collected<span id="finalNodesVal" style="color: var(--accent);">0</span></div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-cyber-primary" onclick="startGame()">↻ RETRY RUN</button>
        <button class="btn-cyber btn-cyber-secondary" onclick="showStartScreen()">☰ MAIN MENU</button>
        <a href="index.jsp" class="btn-cyber btn-cyber-secondary">✕ EXIT TO HUB</a>
      </div>
    </div>

    <!-- Screen 3: Settings & Controls Modal -->
    <div id="manualModal" class="manual-modal">
      <div class="manual-title">
        <span>SECURITY MANUAL</span>
        <button class="btn-hub" onclick="closeManual()">✕ Close</button>
      </div>

      <div class="manual-row">
        <strong>🎮 PC CONTROLS</strong>
        Arrow Keys or W/A/S/D to steer your serpent. Instant response with zero 180° self-reversals.
      </div>

      <div class="manual-row">
        <strong>📱 MOBILE CONTROLS</strong>
        Swipe across the playfield or use the tactical on-screen D-Pad below.
      </div>

      <div class="manual-row">
        <strong>⚡ GAMEPLAY SPEED (BALANCED)</strong>
        Select your neural clock rate:
        <div class="speed-picker">
          <button class="speed-btn" id="spdScout" onclick="setSpeed(165, 'spdScout')">Scout (Chill)</button>
          <button class="speed-btn active" id="spdAgent" onclick="setSpeed(135, 'spdAgent')">Agent (Balanced)</button>
          <button class="speed-btn" id="spdOver" onclick="setSpeed(100, 'spdOver')">Overclock</button>
        </div>
      </div>

      <div class="manual-row">
        <strong>🎯 SCORING FORMULA</strong>
        Each glowing crimson data packet awards +10 points and elongates your chassis. High scores persist in your cloud profile!
      </div>

      <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeManual(); startGame();">
        ▶ START PLAYING
      </button>
    </div>

    <canvas id="gameCanvas" width="340" height="340"></canvas>
  </div>

  <!-- On-Screen Controls for Mobile Devices -->
  <div id="mobileDpad">
    <div class="d-btn d-up" data-dir="UP">▲</div>
    <div class="d-btn d-left" data-dir="LEFT">◀</div>
    <div class="d-btn d-down" data-dir="DOWN">▼</div>
    <div class="d-btn d-right" data-dir="RIGHT">▶</div>
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

  // Mobile detection
  const isMobile = ('ontouchstart' in window) || 
                   (navigator.maxTouchPoints > 0) || 
                   /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);
  if (isMobile) {
    dpad.style.display = 'grid';
  }

  // Grid sizing
  const grid = 17; 
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
  
  // BALANCED GAME TICK (FEATURE 4):
  // Changed from aggressive 95ms to a comfortable, fluid 135ms default tick interval
  let tickRate = 135; 

  function setSpeed(ms, btnId) {
    tickRate = ms;
    document.querySelectorAll('.speed-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(btnId).classList.add('active');
  }

  function openManual() {
    manualModal.classList.add('active');
  }
  function closeManual() {
    manualModal.classList.remove('active');
  }

  function showStartScreen() {
    gameOverScreen.style.display = 'none';
    manualModal.classList.remove('active');
    startScreen.style.display = 'flex';
    splashBest.innerText = highScore + ' pts';
    splashNodes.innerText = totalNodes;
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
    // Prevent immediate 180-degree self-reversals
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

      // Update LocalStorage stats
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

    // Subtle matrix-style background dots
    ctx.fillStyle = 'rgba(255, 255, 255, 0.04)';
    for (let x = 0; x < cols; x++) {
      for (let y = 0; y < rows; y++) {
        ctx.fillRect(x * grid + grid/2 - 0.5, y * grid + grid/2 - 0.5, 1, 1);
      }
    }

    // Draw Neon Food (Glowing Packet)
    ctx.fillStyle = '#f43f5e';
    ctx.shadowColor = '#f43f5e';
    ctx.shadowBlur = 10;
    ctx.beginPath();
    ctx.arc((food.x + 0.5) * grid, (food.y + 0.5) * grid, grid * 0.38, 0, Math.PI * 2);
    ctx.fill();

    // Draw Snake Segments
    snake.forEach((seg, index) => {
      ctx.fillStyle = (index === 0) ? '#34d399' : '#10b981';
      ctx.shadowColor = '#10b981';
      ctx.shadowBlur = (index === 0) ? 10 : 4;
      ctx.fillRect(seg.x * grid + 1.5, seg.y * grid + 1.5, grid - 3, grid - 3);
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

  // Keyboard navigation for desktop
  window.addEventListener('keydown', (e) => {
    switch (e.key) {
      case 'ArrowUp': case 'w': case 'W': setDirection(0, -1); e.preventDefault(); break;
      case 'ArrowDown': case 's': case 'S': setDirection(0, 1); e.preventDefault(); break;
      case 'ArrowLeft': case 'a': case 'A': setDirection(-1, 0); e.preventDefault(); break;
      case 'ArrowRight': case 'd': case 'D': setDirection(1, 0); e.preventDefault(); break;
    }
  });

  // D-Pad Touch Listeners
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

  // Canvas Swipe Detection
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
</script>
</body>
</html>