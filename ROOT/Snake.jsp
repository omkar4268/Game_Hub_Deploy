<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Snake // Neon Edition</title>
<style>
  :root {
    --bg-base: #030712;
    --card-bg: rgba(15, 23, 42, 0.85);
    --primary: #10b981;
    --primary-glow: rgba(16, 185, 129, 0.4);
    --accent: #38bdf8;
    --food: #f43f5e;
    --food-glow: rgba(244, 63, 94, 0.5);
    --text-main: #f8fafc;
    --text-muted: #64748b;
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', system-ui, sans-serif;
    -webkit-tap-highlight-color: transparent;
  }

  body {
    background: radial-gradient(circle at top, #0f172a, var(--bg-base));
    color: var(--text-main);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 0.8rem;
    overflow: hidden;
    touch-action: none;
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    max-width: 420px;
    margin-bottom: 0.8rem;
  }

  .header h1 {
    font-size: 1.3rem;
    color: var(--primary);
    letter-spacing: 1px;
    text-shadow: 0 0 10px var(--primary-glow);
  }

  .btn-hub {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    padding: 0.35rem 0.8rem;
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.85rem;
    text-decoration: none;
    transition: 0.2s;
  }
  .btn-hub:hover { background: rgba(255, 255, 255, 0.15); }

  .scoreboard {
    display: flex;
    gap: 1.2rem;
    background: var(--card-bg);
    padding: 0.4rem 1.2rem;
    border-radius: 9999px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    font-size: 0.9rem;
    margin-bottom: 0.8rem;
  }
  .scoreboard span { color: var(--primary); font-weight: 700; }
  .scoreboard .best-label span { color: #facc15; }

  /* Game Canvas Wrapper */
  .canvas-wrapper {
    position: relative;
    border-radius: 16px;
    border: 2px solid rgba(16, 185, 129, 0.3);
    box-shadow: 0 0 25px rgba(16, 185, 129, 0.15);
    background: #020617;
    overflow: hidden;
  }

  canvas {
    display: block;
    background: #020617;
  }

  /* Overlay Screens (Start & Game Over) */
  .game-overlay {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.85);
    backdrop-filter: blur(6px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.8rem;
    z-index: 10;
  }
  .game-overlay h2 {
    font-size: 1.8rem;
    color: var(--primary);
    text-shadow: 0 0 15px var(--primary-glow);
  }
  .game-overlay p {
    color: var(--text-muted);
    font-size: 0.85rem;
  }
  .btn-play {
    background: var(--primary);
    color: #000;
    font-weight: 700;
    padding: 0.6rem 1.5rem;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    font-size: 0.95rem;
    box-shadow: 0 0 15px var(--primary-glow);
    transition: 0.2s;
  }
  .btn-play:active { transform: scale(0.96); }

  /* Mobile Virtual D-Pad */
  #mobileDpad {
    display: none; /* Auto-enabled via JS on mobile detection */
    grid-template-columns: repeat(3, 56px);
    grid-template-rows: repeat(3, 52px);
    gap: 6px;
    margin-top: 1rem;
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
    <h1>CYBER SNAKE</h1>
    <a href="index.jsp" class="btn-hub">Exit Hub</a>
  </div>

  <div class="scoreboard">
    <div>Score: <span id="scoreVal">0</span></div>
    <div class="best-label">Best: <span id="highScoreVal">0</span></div>
  </div>

  <div class="canvas-wrapper">
    <div id="overlay" class="game-overlay">
      <h2 id="overlayTitle">CYBER SNAKE</h2>
      <p id="overlayDesc">Use Arrows / Swipe / D-Pad</p>
      <button class="btn-play" onclick="startGame()">PRESS TO PLAY</button>
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
  const overlay = document.getElementById('overlay');
  const overlayTitle = document.getElementById('overlayTitle');
  const scoreVal = document.getElementById('scoreVal');
  const highScoreVal = document.getElementById('highScoreVal');
  const dpad = document.getElementById('mobileDpad');

  // Detect mobile user agent or touch capability
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
  let highScore = parseInt(localStorage.getItem('hub_snake_high') || '0', 10);
  highScoreVal.innerText = highScore;

  let isPlaying = false;
  let lastTick = 0;
  const tickRate = 95; // Fixed tick rate for smooth, responsive movement

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
    snake = [
      { x: 8, y: 10 },
      { x: 7, y: 10 },
      { x: 6, y: 10 }
    ];
    dir = { x: 1, y: 0 };
    nextDir = { x: 1, y: 0 };
    score = 0;
    scoreVal.innerText = score;
    spawnFood();
    overlay.style.display = 'none';
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
      scoreVal.innerText = score;
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
    overlayTitle.innerText = "SYSTEM CRASH";
    overlayTitle.style.color = "#f43f5e";
    overlay.style.display = 'flex';
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

    // Draw Neon Food
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

    if (Math.max(absX, absY) > 25) { // Minimum swipe threshold
      if (absX > absY) {
        setDirection(dx > 0 ? 1 : -1, 0);
      } else {
        setDirection(0, dy > 0 ? 1 : -1);
      }
    }
  }, { passive: true });

  // Initial render
  render();
</script>
</body>
</html>