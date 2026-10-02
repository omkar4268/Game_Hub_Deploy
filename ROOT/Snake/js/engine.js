// =========================================================
// CYBER SNAKE // NEURAL VECTOR MATRIX v3.0 ENGINE
// =========================================================

// Background Canvas (Fullscreen Cyber Matrix & Star Circuit Simulation)
(function initSnakeBackground() {
  const bgCanvas = document.getElementById('snakeBgCanvas');
  if (!bgCanvas) return;
  const bctx = bgCanvas.getContext('2d');
  if (!bctx) return;

  let W = 0, H = 0;
  const particles = [];
  const PARTICLE_COUNT = 45;
  const rays = [];

  function resize() {
    W = bgCanvas.width = window.innerWidth;
    H = bgCanvas.height = window.innerHeight;
  }
  window.addEventListener('resize', resize);
  resize();

  // Create ambient cyber particles
  for (let i = 0; i < PARTICLE_COUNT; i++) {
    particles.push({
      x: Math.random() * window.innerWidth,
      y: Math.random() * window.innerHeight,
      vx: (Math.random() - 0.5) * 0.4,
      vy: (Math.random() - 0.5) * 0.4,
      r: Math.random() * 1.8 + 0.8,
      alpha: Math.random() * 0.6 + 0.2
    });
  }

  // Create roaming circuit ray pulses
  for (let i = 0; i < 6; i++) {
    rays.push({
      x: Math.random() * window.innerWidth,
      y: Math.random() * window.innerHeight,
      len: Math.random() * 80 + 40,
      dir: Math.random() > 0.5 ? 'h' : 'v',
      speed: Math.random() * 1.5 + 0.8,
      alpha: Math.random() * 0.4 + 0.15
    });
  }

  function frame() {
    bctx.clearRect(0, 0, W, H);

    // Subtle matrix cyber grid lines
    bctx.strokeStyle = 'rgba(16, 230, 168, 0.035)';
    bctx.lineWidth = 1;
    const step = 48;
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

    // Draw & update roaming circuit ray pulses
    rays.forEach(ray => {
      bctx.strokeStyle = 'rgba(16, 230, 168, ' + ray.alpha + ')';
      bctx.lineWidth = 1.5;
      bctx.beginPath();
      if (ray.dir === 'h') {
        bctx.moveTo(ray.x, ray.y);
        bctx.lineTo(ray.x + ray.len, ray.y);
        ray.x += ray.speed;
        if (ray.x > W) ray.x = -ray.len;
      } else {
        bctx.moveTo(ray.x, ray.y);
        bctx.lineTo(ray.x, ray.y + ray.len);
        ray.y += ray.speed;
        if (ray.y > H) ray.y = -ray.len;
      }
      bctx.stroke();
    });

    // Draw & update floating cyber particles
    particles.forEach(p => {
      p.x += p.vx;
      p.y += p.vy;
      if (p.x < 0) p.x = W;
      if (p.x > W) p.x = 0;
      if (p.y < 0) p.y = H;
      if (p.y > H) p.y = 0;

      bctx.beginPath();
      bctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      bctx.fillStyle = 'rgba(16, 230, 168, ' + p.alpha + ')';
      bctx.fill();
    });

    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
})();

// =========================================================
// CORE GAME LOGIC & CANVAS GRAPHICS
// =========================================================
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
dpad.style.display = 'none';

// Crisp 20x20 grid on internal 400x400 canvas
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

// Food collection particles
let foodBursts = [];

// Persistent stats
let highScore = parseInt(localStorage.getItem('hub_snake_high') || '0', 10);
let totalNodes = parseInt(localStorage.getItem('hub_snake_nodes') || '0', 10);

highScoreVal.innerText = highScore;
splashBest.innerText = highScore + ' pts';
splashNodes.innerText = totalNodes;

let isPlaying = false;
let lastTick = 0;
let tickRate = 145; // Balanced default

// Food pulse animation timing
let foodAnimTimer = 0;

function setSpeed(ms, btnId) {
  tickRate = ms;
  document.querySelectorAll('.speed-btn').forEach(b => b.classList.remove('active'));
  const target = document.getElementById(btnId);
  if (target) target.classList.add('active');
}

function openManual() { 
  manualModal.classList.add('active'); 
  dpad.style.display = 'none';
  animateModalIn(manualModal);
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
  animateModalIn(startScreen);
}

function animateModalIn(el) {
  const Motion = (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;
  if (Motion && typeof Motion.animate === 'function') {
    Motion.animate(el, { opacity: [0, 1], scale: [0.94, 1] }, { duration: 0.28, ease: [0.16, 1, 0.3, 1] });
  }
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

function spawnFoodBurst(gx, gy) {
  const cx = (gx + 0.5) * grid;
  const cy = (gy + 0.5) * grid;
  for (let i = 0; i < 14; i++) {
    const angle = (Math.PI * 2 * i) / 14 + Math.random() * 0.4;
    const speed = Math.random() * 3.5 + 1.5;
    foodBursts.push({
      x: cx,
      y: cy,
      vx: Math.cos(angle) * speed,
      vy: Math.sin(angle) * speed,
      life: 1,
      r: Math.random() * 2.2 + 1.2,
      color: Math.random() > 0.5 ? '#f43f5e' : '#10e6a8'
    });
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
  foodBursts = [];
  scoreVal.innerText = score;
  nodesVal.innerText = runNodes;
  spawnFood();
  isPlaying = true;
  lastTick = performance.now();
  requestAnimationFrame(gameLoop);

  if (window.RansomHorror) {
    RansomHorror.init('snake', {
      onGameOver: () => triggerGameOver(),
      onPurgeBonus: (bonus) => {
        score += bonus;
        scoreVal.innerText = score;
      }
    });
  }
}

function setDirection(newX, newY) {
  if (newX !== -dir.x && newY !== -dir.y) {
    nextDir = { x: newX, y: newY };
  }
}

function update() {
  dir = { ...nextDir };
  const head = { x: snake[0].x + dir.x, y: snake[0].y + dir.y };

  // Wall collisions
  if (head.x < 0 || head.x >= cols || head.y < 0 || head.y >= rows) {
    return triggerGameOver();
  }

  // Self collisions
  for (let i = 0; i < snake.length; i++) {
    if (head.x === snake[i].x && head.y === snake[i].y) {
      return triggerGameOver();
    }
  }

  snake.unshift(head);

  // Food pickup
  if (head.x === food.x && head.y === food.y) {
    score += 10;
    runNodes++;
    totalNodes++;
    scoreVal.innerText = score;
    nodesVal.innerText = runNodes;
    localStorage.setItem('hub_snake_nodes', totalNodes);

    spawnFoodBurst(food.x, food.y);

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
  if (window.RansomHorror) {
    if (RansomHorror.state === 'lurking') RansomHorror.evadeLurker();
    clearTimeout(RansomHorror.lurkTimer);
  }
  finalScoreVal.innerText = score + ' pts';
  finalNodesVal.innerText = runNodes;
  gameOverScreen.style.display = 'flex';
  dpad.style.display = 'none';
  animateModalIn(gameOverScreen);

  if (score > 0) {
    syncScoreToCloud('snake', score);
  }
}

async function syncScoreToCloud(gameName, finalScore) {
  try {
    const res = await fetch('../save_score.jsp', {
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

// =========================================================
// HIGH-FIDELITY CANVAS RENDERING
// =========================================================
function render() {
  foodAnimTimer += 0.05;

  // Obsidian Arena Interior
  ctx.fillStyle = '#06080e';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Precision Matrix Grid Coordinates
  ctx.fillStyle = 'rgba(255, 255, 255, 0.035)';
  for (let x = 0; x < cols; x++) {
    for (let y = 0; y < rows; y++) {
      ctx.fillRect(x * grid + grid / 2 - 0.5, y * grid + grid / 2 - 0.5, 1, 1);
    }
  }

  // Draw Pulsating Crimson Quantum Food Node
  const foodCx = (food.x + 0.5) * grid;
  const foodCy = (food.y + 0.5) * grid;
  const pulseScale = 1 + Math.sin(foodAnimTimer * 2) * 0.15;
  const baseFoodR = grid * 0.34;

  // Outer Aura
  ctx.shadowColor = '#f43f5e';
  ctx.shadowBlur = 16 * pulseScale;
  ctx.fillStyle = 'rgba(244, 63, 94, 0.85)';
  ctx.beginPath();
  ctx.arc(foodCx, foodCy, baseFoodR * pulseScale, 0, Math.PI * 2);
  ctx.fill();

  // Core Specular Center
  ctx.fillStyle = '#ffffff';
  ctx.beginPath();
  ctx.arc(foodCx, foodCy, baseFoodR * 0.45, 0, Math.PI * 2);
  ctx.fill();

  // Orbiting Electron Ring
  ctx.strokeStyle = 'rgba(255, 255, 255, 0.5)';
  ctx.lineWidth = 1.2;
  ctx.beginPath();
  ctx.arc(foodCx, foodCy, baseFoodR * 1.5, foodAnimTimer * 1.5, foodAnimTimer * 1.5 + Math.PI * 1.2);
  ctx.stroke();

  // Draw Snake with Fluid Gradient & Rounded Cyber Plates
  ctx.shadowBlur = 0;
  const snakeLen = snake.length;

  for (let i = snakeLen - 1; i >= 0; i--) {
    const seg = snake[i];
    const segX = seg.x * grid;
    const segY = seg.y * grid;
    const pad = 2;
    const w = grid - pad * 2;
    const h = grid - pad * 2;
    const r = 5;

    if (i === 0) {
      // Serpent Head (Vibrant White-Cyan with Eye Sensors)
      ctx.shadowColor = '#10e6a8';
      ctx.shadowBlur = 14;
      ctx.fillStyle = '#ffffff';

      drawRoundedRect(ctx, segX + pad, segY + pad, w, h, 6);
      ctx.fill();

      // Optical Eye Sensors
      ctx.fillStyle = '#06080e';
      const eyeOffset = 4;
      const eyeR = 2.2;
      let eye1X, eye1Y, eye2X, eye2Y;

      if (dir.x === 1) { // Moving Right
        eye1X = segX + w - eyeOffset; eye1Y = segY + pad + eyeOffset;
        eye2X = segX + w - eyeOffset; eye2Y = segY + h - eyeOffset;
      } else if (dir.x === -1) { // Moving Left
        eye1X = segX + pad + eyeOffset; eye1Y = segY + pad + eyeOffset;
        eye2X = segX + pad + eyeOffset; eye2Y = segY + h - eyeOffset;
      } else if (dir.y === -1) { // Moving Up
        eye1X = segX + pad + eyeOffset; eye1Y = segY + pad + eyeOffset;
        eye2X = segX + w - eyeOffset; eye2Y = segY + pad + eyeOffset;
      } else { // Moving Down
        eye1X = segX + pad + eyeOffset; eye1Y = segY + h - eyeOffset;
        eye2X = segX + w - eyeOffset; eye2Y = segY + h - eyeOffset;
      }

      ctx.beginPath();
      ctx.arc(eye1X, eye1Y, eyeR, 0, Math.PI * 2);
      ctx.arc(eye2X, eye2Y, eyeR, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = '#10e6a8';
      ctx.beginPath();
      ctx.arc(eye1X, eye1Y, eyeR * 0.5, 0, Math.PI * 2);
      ctx.arc(eye2X, eye2Y, eyeR * 0.5, 0, Math.PI * 2);
      ctx.fill();

    } else {
      // Body Segments with Smooth Color Falloff
      const ratio = 1 - (i / snakeLen);
      const alpha = 0.5 + 0.5 * ratio;
      ctx.shadowColor = 'rgba(16, 230, 168, 0.4)';
      ctx.shadowBlur = 6 * ratio;

      // Color transition from #34d399 down to #059669
      const g = Math.round(211 * ratio + 150 * (1 - ratio));
      ctx.fillStyle = 'rgba(16, ' + g + ', 168, ' + alpha.toFixed(2) + ')';

      drawRoundedRect(ctx, segX + pad, segY + pad, w, h, r);
      ctx.fill();
    }
  }

  // Render & Update Food Bursts
  for (let i = foodBursts.length - 1; i >= 0; i--) {
    const p = foodBursts[i];
    p.x += p.vx;
    p.y += p.vy;
    p.life -= 0.035;
    if (p.life <= 0) {
      foodBursts.splice(i, 1);
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

function drawRoundedRect(ctx, x, y, width, height, radius) {
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.lineTo(x + width - radius, y);
  ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
  ctx.lineTo(x + width, y + height - radius);
  ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
  ctx.lineTo(x + radius, y + height);
  ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
  ctx.lineTo(x, y + radius);
  ctx.quadraticCurveTo(x, y, x + radius, y);
  ctx.closePath();
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

// Keyboard controls
window.addEventListener('keydown', (e) => {
  switch (e.key) {
    case 'ArrowUp': case 'w': case 'W': setDirection(0, -1); e.preventDefault(); break;
    case 'ArrowDown': case 's': case 'S': setDirection(0, 1); e.preventDefault(); break;
    case 'ArrowLeft': case 'a': case 'A': setDirection(-1, 0); e.preventDefault(); break;
    case 'ArrowRight': case 'd': case 'D': setDirection(1, 0); e.preventDefault(); break;
  }
});

// Mobile D-Pad listeners
document.querySelectorAll('#mobileDpad .d-btn').forEach(btn => {
  btn.addEventListener('touchstart', (e) => {
    e.preventDefault();
    const d = btn.getAttribute('data-dir');
    if (d === 'UP') setDirection(0, -1);
    if (d === 'DOWN') setDirection(0, 1);
    if (d === 'LEFT') setDirection(-1, 0);
    if (d === 'RIGHT') setDirection(1, 0);
  }, { passive: false });
});

// Touch Swipe Gesture Navigation
let touchStartX = 0, touchStartY = 0;
window.addEventListener('touchstart', (e) => {
  if (e.touches.length > 0) {
    touchStartX = e.touches[0].clientX;
    touchStartY = e.touches[0].clientY;
  }
}, { passive: true });

window.addEventListener('touchend', (e) => {
  if (!isPlaying || e.changedTouches.length === 0) return;
  const dx = e.changedTouches[0].clientX - touchStartX;
  const dy = e.changedTouches[0].clientY - touchStartY;
  if (Math.abs(dx) > 30 || Math.abs(dy) > 30) {
    if (Math.abs(dx) > Math.abs(dy)) {
      setDirection(dx > 0 ? 1 : -1, 0);
    } else {
      setDirection(0, dy > 0 ? 1 : -1);
    }
  }
}, { passive: true });

/* =========================================================
   NAVIGATION & WIPE TRANSITION
   ========================================================= */
function cyberNavigate(url) {
  const overlay = document.getElementById('cyberWipeOverlay');
  document.body.style.transform = 'scale(0.975)';
  document.body.style.filter = 'blur(4px)';
  document.body.style.opacity = '0.6';
  document.body.style.transition = 'all 0.22s cubic-bezier(0.16, 1, 0.3, 1)';

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
  document.body.style.transform = '';
  document.body.style.filter = '';
  document.body.style.opacity = '';
});