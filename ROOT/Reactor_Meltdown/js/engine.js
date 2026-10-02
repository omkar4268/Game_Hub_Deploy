/* =========================================================
   REACTOR MELTDOWN // QUANTUM CORE ENGINE v3.0
   ========================================================= */

/* =========================================================
   FULLSCREEN ANIMATED QUANTUM CORE & PLASMA FUSION BACKGROUND
   ========================================================= */
class ReactorFusionEngine {
  constructor() {
    this.canvas = document.getElementById('reactorBgCanvas');
    if (!this.canvas) return;
    this.ctx = this.canvas.getContext('2d');
    this.particles = [];
    this.numParticles = 55;
    this.lightningArcs = [];
    this.arcTimer = 0;
    this.alertIntensity = 0; // 0 = stable cyan, 1 = critical hazard crimson
    this.rotationAngle = 0;
    this.init();
  }

  init() {
    this.resize();
    window.addEventListener('resize', () => this.resize());

    // Populate ambient quantum particles
    this.particles = [];
    for (let i = 0; i < this.numParticles; i++) {
      this.particles.push({
        x: Math.random() * this.width,
        y: Math.random() * this.height,
        vx: (Math.random() - 0.5) * 0.4,
        vy: (Math.random() - 0.5) * 0.4,
        size: Math.random() * 2.2 + 0.8,
        alpha: Math.random() * 0.6 + 0.2,
        pulseSpeed: 0.02 + Math.random() * 0.03,
        pulseOffset: Math.random() * Math.PI * 2
      });
    }

    this.animate = this.animate.bind(this);
    requestAnimationFrame(this.animate);
  }

  resize() {
    if (!this.canvas) return;
    this.dpr = Math.min(window.devicePixelRatio || 1, 2);
    this.width = window.innerWidth;
    this.height = window.innerHeight;
    this.canvas.width = this.width * this.dpr;
    this.canvas.height = this.height * this.dpr;
    this.ctx.scale(this.dpr, this.dpr);
  }

  triggerAlert(intensity = 1.0) {
    this.alertIntensity = intensity;
  }

  createArc(cx, cy, r1, r2) {
    const angle = Math.random() * Math.PI * 2;
    const steps = 6;
    const points = [];
    const x1 = cx + Math.cos(angle) * r1;
    const y1 = cy + Math.sin(angle) * r1;
    const x2 = cx + Math.cos(angle + (Math.random() - 0.5) * 0.4) * r2;
    const y2 = cy + Math.sin(angle + (Math.random() - 0.5) * 0.4) * r2;

    points.push({ x: x1, y: y1 });
    for (let i = 1; i < steps; i++) {
      const t = i / steps;
      const lx = x1 + (x2 - x1) * t + (Math.random() - 0.5) * 16;
      const ly = y1 + (y2 - y1) * t + (Math.random() - 0.5) * 16;
      points.push({ x: lx, y: ly });
    }
    points.push({ x: x2, y: y2 });

    this.lightningArcs.push({
      points,
      life: 1.0,
      decay: 0.12 + Math.random() * 0.08
    });
  }

  animate() {
    if (!this.ctx) return;
    this.ctx.fillStyle = '#000000';
    this.ctx.fillRect(0, 0, this.width, this.height);

    const cx = this.width / 2;
    const cy = this.height / 2;
    const maxR = Math.min(this.width, this.height) * 0.44;

    // Decay alert intensity
    if (this.alertIntensity > 0) {
      this.alertIntensity = Math.max(0, this.alertIntensity - 0.015);
    }

    // Color interpolations based on alert
    const rVal = Math.round(56 + (244 - 56) * this.alertIntensity);
    const gVal = Math.round(189 + (63 - 189) * this.alertIntensity);
    const bVal = Math.round(248 + (94 - 248) * this.alertIntensity);
    const coreColor = `rgba(${rVal}, ${gVal}, ${bVal}, `;

    // 1. Perspective Grid Lines (Subtle)
    this.ctx.strokeStyle = `rgba(255, 255, 255, 0.025)`;
    this.ctx.lineWidth = 1;
    const gridStep = 48;
    for (let x = 0; x < this.width; x += gridStep) {
      this.ctx.beginPath();
      this.ctx.moveTo(x, 0);
      this.ctx.lineTo(x, this.height);
      this.ctx.stroke();
    }
    for (let y = 0; y < this.height; y += gridStep) {
      this.ctx.beginPath();
      this.ctx.moveTo(0, y);
      this.ctx.lineTo(this.width, y);
      this.ctx.stroke();
    }

    // 2. Central Fusion Core Radial Glow
    const glowGrad = this.ctx.createRadialGradient(cx, cy, 0, cx, cy, maxR * 1.4);
    glowGrad.addColorStop(0, coreColor + '0.18)');
    glowGrad.addColorStop(0.4, coreColor + '0.06)');
    glowGrad.addColorStop(1, 'transparent');
    this.ctx.fillStyle = glowGrad;
    this.ctx.beginPath();
    this.ctx.arc(cx, cy, maxR * 1.4, 0, Math.PI * 2);
    this.ctx.fill();

    // 3. Rotating Plasma Rings
    this.rotationAngle += 0.006;
    const rings = [
      { r: maxR * 0.28, rot: this.rotationAngle * 1.5, dashes: [12, 10], width: 1.5, alpha: 0.4 },
      { r: maxR * 0.52, rot: -this.rotationAngle * 1.0, dashes: [24, 16, 8, 16], width: 1.8, alpha: 0.5 },
      { r: maxR * 0.78, rot: this.rotationAngle * 0.7, dashes: [40, 20, 10, 20], width: 2.2, alpha: 0.35 },
      { r: maxR * 1.05, rot: -this.rotationAngle * 0.4, dashes: [60, 30], width: 1.5, alpha: 0.25 }
    ];

    rings.forEach((ring) => {
      this.ctx.save();
      this.ctx.translate(cx, cy);
      this.ctx.rotate(ring.rot);
      this.ctx.setLineDash(ring.dashes);
      this.ctx.strokeStyle = coreColor + ring.alpha + ')';
      this.ctx.lineWidth = ring.width;
      this.ctx.beginPath();
      this.ctx.arc(0, 0, ring.r, 0, Math.PI * 2);
      this.ctx.stroke();

      // Small quantum energy nodes on ring
      const nodeCount = 3;
      for (let n = 0; n < nodeCount; n++) {
        const nodeAngle = (n * Math.PI * 2) / nodeCount;
        const nx = Math.cos(nodeAngle) * ring.r;
        const ny = Math.sin(nodeAngle) * ring.r;
        this.ctx.fillStyle = '#ffffff';
        this.ctx.beginPath();
        this.ctx.arc(nx, ny, 2.5, 0, Math.PI * 2);
        this.ctx.fill();
      }
      this.ctx.restore();
    });

    // 4. Random Lightning Energy Discharges between rings
    this.arcTimer++;
    if (this.arcTimer > 35) {
      this.arcTimer = 0;
      this.createArc(cx, cy, maxR * 0.28, maxR * 0.78);
    }

    for (let i = this.lightningArcs.length - 1; i >= 0; i--) {
      const arc = this.lightningArcs[i];
      arc.life -= arc.decay;
      if (arc.life <= 0) {
        this.lightningArcs.splice(i, 1);
        continue;
      }
      this.ctx.strokeStyle = `rgba(255, 255, 255, ${arc.life * 0.8})`;
      this.ctx.lineWidth = 1.6;
      this.ctx.shadowColor = coreColor + '1)';
      this.ctx.shadowBlur = 10;
      this.ctx.beginPath();
      arc.points.forEach((p, idx) => {
        if (idx === 0) this.ctx.moveTo(p.x, p.y);
        else this.ctx.lineTo(p.x, p.y);
      });
      this.ctx.stroke();
      this.ctx.shadowBlur = 0;
    }

    // 5. Floating Quantum Plasma Particles
    const time = Date.now() * 0.001;
    this.particles.forEach((p) => {
      p.x += p.vx;
      p.y += p.vy;

      if (p.x < 0) p.x = this.width;
      if (p.x > this.width) p.x = 0;
      if (p.y < 0) p.y = this.height;
      if (p.y > this.height) p.y = 0;

      const alphaPulse = p.alpha * (0.6 + 0.4 * Math.sin(time * 3 + p.pulseOffset));
      this.ctx.fillStyle = coreColor + alphaPulse + ')';
      this.ctx.beginPath();
      this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
      this.ctx.fill();
    });

    requestAnimationFrame(this.animate);
  }
}

/* =========================================================
   AUDIO SYNTHESIZER (WEB AUDIO API - ZERO ASSETS)
   ========================================================= */
let audioCtx = null;
let soundEnabled = true;

function initAudio() {
  if (!audioCtx) {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) audioCtx = new AudioContext();
  }
  if (audioCtx && audioCtx.state === 'suspended') {
    audioCtx.resume();
  }
}

function toggleSound() {
  soundEnabled = !soundEnabled;
  const onSvg = document.getElementById('soundOnSvg');
  const offSvg = document.getElementById('soundOffSvg');
  if (onSvg && offSvg) {
    onSvg.style.display = soundEnabled ? 'block' : 'none';
    offSvg.style.display = soundEnabled ? 'none' : 'block';
  }
}

function playSynth(type, param = 0) {
  if (!soundEnabled) return;
  initAudio();
  if (!audioCtx) return;

  try {
    const now = audioCtx.currentTime;

    if (type === 'beep') {
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = 'sine';

      const baseFreqs = [261.63, 293.66, 329.63, 392.00, 440.00, 523.25, 587.33, 659.25, 783.99, 880.00, 987.77, 1046.50, 1174.66, 1318.51, 1396.91, 1567.98];
      const freq = baseFreqs[param % baseFreqs.length] || 440;

      osc.frequency.setValueAtTime(freq, now);
      gain.gain.setValueAtTime(0.2, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.18);

      osc.connect(gain);
      gain.connect(audioCtx.destination);
      osc.start(now);
      osc.stop(now + 0.18);

    } else if (type === 'tap') {
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(600, now);
      osc.frequency.exponentialRampToValueAtTime(800, now + 0.05);

      gain.gain.setValueAtTime(0.15, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.05);

      osc.connect(gain);
      gain.connect(audioCtx.destination);
      osc.start(now);
      osc.stop(now + 0.05);

    } else if (type === 'strike') {
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(140, now);
      osc.frequency.setValueAtTime(110, now + 0.1);

      gain.gain.setValueAtTime(0.3, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.25);

      osc.connect(gain);
      gain.connect(audioCtx.destination);
      osc.start(now);
      osc.stop(now + 0.25);

    } else if (type === 'stage_clear') {
      [523.25, 659.25, 783.99].forEach((freq, idx) => {
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(freq, now + idx * 0.04);

        gain.gain.setValueAtTime(0.18, now + idx * 0.04);
        gain.gain.exponentialRampToValueAtTime(0.01, now + idx * 0.04 + 0.2);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now + idx * 0.04);
        osc.stop(now + idx * 0.04 + 0.2);
      });

    } else if (type === 'expand') {
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(220, now);
      osc.frequency.exponentialRampToValueAtTime(880, now + 0.4);

      gain.gain.setValueAtTime(0.25, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.4);

      osc.connect(gain);
      gain.connect(audioCtx.destination);
      osc.start(now);
      osc.stop(now + 0.4);

    } else if (type === 'meltdown') {
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(160, now);
      osc.frequency.exponentialRampToValueAtTime(30, now + 0.6);

      gain.gain.setValueAtTime(0.35, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.6);

      osc.connect(gain);
      gain.connect(audioCtx.destination);
      osc.start(now);
      osc.stop(now + 0.6);
    }
  } catch (e) {
    // Audio fallback
  }
}

/* =========================================================
   GAME CONFIGURATION & PROGRESSIVE STATE
   ========================================================= */
let currentGridSize = 3;  // Starts 3x3, upgrades to 4x4, then 5x5
let sequenceLength = 1;   // Starts with 1 glowing tile, increments by 1
let currentSequence = []; // Array of tile indices [0..(N*N-1)]
let playerInputIndex = 0; // Current position in sequence user is typing

let score = 0;
let remainingTime = 20.0; // Starts at 20.0s, +3.0s per puzzle
let maxTimeRef = 20.0;
let timerInterval = null;

let shields = 3;          // 3 containment integrity shields
let isBroadcasting = false;
let isGameOver = false;
let tileElements = [];

// DOM Elements & Canvas Engine Reference
let bgEngine = null;
let reactorGrid, timerBar, timeDisplay, scoreDisplay, sectorBadge, statusMessage;
let sequenceProgressPill, shockwave, expansionBanner, expansionText;
let startupOverlay, gameOverOverlay, protocolModal;

/* =========================================================
   LIFECYCLE & STATS
   ========================================================= */
window.addEventListener('DOMContentLoaded', () => {
  bgEngine = new ReactorFusionEngine();

  reactorGrid = document.getElementById('reactorGrid');
  timerBar = document.getElementById('timerBar');
  timeDisplay = document.getElementById('timeDisplay');
  scoreDisplay = document.getElementById('scoreDisplay');
  sectorBadge = document.getElementById('sectorBadge');
  statusMessage = document.getElementById('statusMessage');
  sequenceProgressPill = document.getElementById('sequenceProgressPill');
  shockwave = document.getElementById('shockwave');
  expansionBanner = document.getElementById('expansionBanner');
  expansionText = document.getElementById('expansionText');

  startupOverlay = document.getElementById('startupOverlay');
  gameOverOverlay = document.getElementById('gameOverOverlay');
  protocolModal = document.getElementById('protocolModal');

  loadCachedStats();

  // Framer Motion entry for startup screen
  if (window.Motion && startupOverlay) {
    window.Motion.animate(startupOverlay, { opacity: [0, 1], scale: [0.96, 1] }, { duration: 0.4, ease: [0.16, 1, 0.3, 1] });
  }
});

function loadCachedStats() {
  const high = localStorage.getItem('hub_reactor_high') || '0';
  const sector = localStorage.getItem('hub_reactor_stage') || 'Sector 1';
  const sBest = document.getElementById('startBestScore');
  const sSec = document.getElementById('startBestSector');
  if (sBest) sBest.innerText = high + ' pts';
  if (sSec) sSec.innerText = sector;
}

function initiateGameRun() {
  initAudio();
  if (startupOverlay) {
    if (window.Motion) {
      window.Motion.animate(startupOverlay, { opacity: [1, 0], scale: [1, 0.95] }, { duration: 0.25 }).then(() => {
        startupOverlay.style.display = 'none';
      });
    } else {
      startupOverlay.style.display = 'none';
    }
  }

  if (gameOverOverlay) {
    if (window.Motion) {
      window.Motion.animate(gameOverOverlay, { opacity: [1, 0], scale: [1, 0.95] }, { duration: 0.25 }).then(() => {
        gameOverOverlay.style.display = 'none';
      });
    } else {
      gameOverOverlay.style.display = 'none';
    }
  }

  if (expansionBanner) expansionBanner.classList.remove('active');

  score = 0;
  currentGridSize = 3;
  sequenceLength = 1;
  remainingTime = 20.0;
  maxTimeRef = 20.0;
  shields = 3;
  isGameOver = false;

  updateShieldsUI();
  setupStage();

  if (window.RansomHorror) {
    RansomHorror.init('reactor_meltdown', {
      onGameOver: () => triggerMeltdown('Fatal RANS0M intrusion: reactor coolant completely drained.'),
      onPurgeBonus: (bonus) => {
        score += bonus;
        if (scoreDisplay) scoreDisplay.innerText = score;
      }
    });
  }
}

/* =========================================================
   STAGE SETUP & PROGRESSIVE GRID UPGRADE LOGIC
   ========================================================= */
function setupStage() {
  stopTimer();

  const totalTiles = currentGridSize * currentGridSize;
  const upgradeThreshold = Math.floor(totalTiles / 2) + 1;

  if (sequenceLength > upgradeThreshold && currentGridSize < 5) {
    currentGridSize++;
    document.documentElement.style.setProperty('--grid-size', currentGridSize);
    if (sectorBadge) sectorBadge.innerText = currentGridSize + 'x' + currentGridSize + ' SECTOR';

    showExpansionBanner();
    playSynth('expand');

    setTimeout(() => {
      renderReactorGrid();
      startStageSequence();
    }, 1500);
    return;
  }

  document.documentElement.style.setProperty('--grid-size', currentGridSize);
  if (sectorBadge) sectorBadge.innerText = currentGridSize + 'x' + currentGridSize + ' SECTOR';

  renderReactorGrid();
  startStageSequence();
}

function showExpansionBanner() {
  if (expansionText) expansionText.innerText = 'Upgrading to ' + currentGridSize + 'x' + currentGridSize + ' Core Matrix...';
  if (expansionBanner) {
    expansionBanner.classList.add('active');
    if (window.Motion) {
      window.Motion.animate(expansionBanner, { scale: [0.85, 1], opacity: [0, 1] }, { duration: 0.35, ease: [0.16, 1, 0.3, 1] });
    }
    setTimeout(() => {
      if (window.Motion) {
        window.Motion.animate(expansionBanner, { scale: [1, 0.9], opacity: [1, 0] }, { duration: 0.25 }).then(() => {
          expansionBanner.classList.remove('active');
        });
      } else {
        expansionBanner.classList.remove('active');
      }
    }, 1400);
  }
}

function renderReactorGrid() {
  if (!reactorGrid) return;
  reactorGrid.innerHTML = '';
  reactorGrid.className = 'reactor-grid grid-' + currentGridSize;
  tileElements = [];
  const totalTiles = currentGridSize * currentGridSize;

  for (let i = 0; i < totalTiles; i++) {
    const tile = document.createElement('div');
    tile.className = 'reactor-tile';
    tile.dataset.index = i;

    tile.addEventListener('click', () => handleTileClick(i));
    reactorGrid.appendChild(tile);
    tileElements.push(tile);
  }
}

/* =========================================================
   SEQUENCE GENERATION & BROADCAST PLAYBACK
   ========================================================= */
async function startStageSequence() {
  isBroadcasting = true;
  playerInputIndex = 0;
  updateHUD();

  if (statusMessage) {
    statusMessage.innerText = 'MEMORIZING SYSTEM SEQUENCE...';
    statusMessage.style.color = 'var(--primary)';
  }
  if (sequenceProgressPill) {
    sequenceProgressPill.innerText = sequenceLength + (sequenceLength > 1 ? ' TILES' : ' TILE');
  }

  currentSequence = [];
  const totalTiles = currentGridSize * currentGridSize;
  for (let i = 0; i < sequenceLength; i++) {
    const randomTileIndex = Math.floor(Math.random() * totalTiles);
    currentSequence.push(randomTileIndex);
  }

  await delay(600);

  for (let i = 0; i < currentSequence.length; i++) {
    if (isGameOver) return;
    const tileIndex = currentSequence[i];
    if (statusMessage) {
      statusMessage.innerText = 'BROADCASTING: TILE ' + (i + 1) + ' / ' + currentSequence.length;
      statusMessage.style.color = 'var(--primary)';
    }
    await flashTile(tileIndex, 420, 180);
  }

  if (isGameOver) return;

  isBroadcasting = false;
  if (statusMessage) {
    statusMessage.innerText = 'AWAITING INPUT (0 / ' + currentSequence.length + ')';
    statusMessage.style.color = 'var(--accent)';
  }

  startTimer();
}

async function flashTile(tileIndex, onDuration = 420, offDuration = 180) {
  const tileEl = (tileElements && tileElements[tileIndex]) || document.querySelector('.reactor-tile[data-index="' + tileIndex + '"]');
  if (!tileEl) return;

  tileEl.classList.add('flash-active');
  playSynth('beep', tileIndex);

  await delay(onDuration);
  tileEl.classList.remove('flash-active');
  await delay(offDuration);
}

/* =========================================================
   OPERATOR INPUT & REPLICATION VERIFICATION
   ========================================================= */
async function handleTileClick(clickedIndex) {
  if (isBroadcasting || isGameOver) return;

  const tileEl = (tileElements && tileElements[clickedIndex]) || document.querySelector('.reactor-tile[data-index="' + clickedIndex + '"]');
  const expectedIndex = currentSequence[playerInputIndex];

  if (clickedIndex === expectedIndex) {
    playSynth('tap');
    playSynth('beep', clickedIndex);

    if (tileEl) {
      tileEl.classList.add('player-tap');
      setTimeout(() => tileEl.classList.remove('player-tap'), 200);
    }

    playerInputIndex++;
    if (statusMessage) {
      statusMessage.innerText = 'INPUT ACCEPTED: ' + playerInputIndex + ' / ' + currentSequence.length;
      statusMessage.style.color = 'var(--accent)';
    }

    if (playerInputIndex >= currentSequence.length) {
      await handleSequenceSuccess();
    }

  } else {
    await handleSequenceFailure(clickedIndex);
  }
}

async function handleSequenceSuccess() {
  isBroadcasting = true;
  stopTimer();
  playSynth('stage_clear');

  if (statusMessage) {
    statusMessage.innerText = 'STABILIZED! +3.0s EXTENSION';
    statusMessage.style.color = 'var(--accent)';
  }

  remainingTime += 3.0;
  maxTimeRef = Math.max(maxTimeRef, remainingTime);

  const points = sequenceLength * 50 + Math.floor(remainingTime * 10);
  score += points;
  updateHUD();

  if (shockwave) {
    shockwave.className = 'reactor-shockwave flash-correct';
    setTimeout(() => shockwave.className = 'reactor-shockwave', 350);
  }

  await delay(600);
  sequenceLength++;
  setupStage();
}

async function handleSequenceFailure(wrongIndex) {
  isBroadcasting = true;
  stopTimer();
  playSynth('strike');

  if (bgEngine) bgEngine.triggerAlert(1.0);

  if (shockwave) {
    shockwave.className = 'reactor-shockwave flash-strike';
    setTimeout(() => shockwave.className = 'reactor-shockwave', 400);
  }

  const tileEl = (tileElements && tileElements[wrongIndex]) || document.querySelector('.reactor-tile[data-index="' + wrongIndex + '"]');
  if (tileEl) {
    tileEl.classList.add('strike-active');
    setTimeout(() => tileEl.classList.remove('strike-active'), 400);
  }

  shields--;
  updateShieldsUI();

  if (shields <= 0) {
    await delay(300);
    triggerMeltdown('Reactor containment shields collapsed under repeated input anomalies.');
    return;
  }

  if (statusMessage) {
    statusMessage.innerText = 'INPUT ERROR // RE-BROADCASTING';
    statusMessage.style.color = 'var(--danger)';
  }

  await delay(700);

  playerInputIndex = 0;
  for (let i = 0; i < currentSequence.length; i++) {
    if (isGameOver) return;
    if (statusMessage) {
      statusMessage.innerText = 'RE-BROADCASTING: ' + (i + 1) + ' / ' + currentSequence.length;
      statusMessage.style.color = 'var(--warning)';
    }
    await flashTile(currentSequence[i], 420, 180);
  }

  if (isGameOver) return;
  isBroadcasting = false;
  if (statusMessage) {
    statusMessage.innerText = 'AWAITING INPUT (0 / ' + currentSequence.length + ')';
    statusMessage.style.color = 'var(--accent)';
  }

  startTimer();
}

/* =========================================================
   TIMER TICK & HUD TELEMETRY
   ========================================================= */
function startTimer() {
  stopTimer();
  const tickMs = 100;
  timerInterval = setInterval(() => {
    remainingTime -= (tickMs / 1000);
    if (remainingTime <= 0) {
      remainingTime = 0;
      updateHUD();
      stopTimer();
      triggerMeltdown('Coolant reserves exhausted. The reactor entered runaway thermal feedback.');
    } else {
      updateHUD();
    }
  }, tickMs);
}

function stopTimer() {
  if (timerInterval) {
    clearInterval(timerInterval);
    timerInterval = null;
  }
}

function updateHUD() {
  if (scoreDisplay) scoreDisplay.innerText = String(score).padStart(4, '0');
  if (timeDisplay) timeDisplay.innerText = remainingTime.toFixed(1) + 's';

  if (timerBar) {
    const pct = Math.max(0, Math.min(100, (remainingTime / maxTimeRef) * 100));
    timerBar.style.width = pct + '%';

    if (remainingTime <= 5.0) {
      timeDisplay.className = 'hud-value glow-danger';
      timerBar.style.background = 'var(--danger)';
      if (bgEngine && Math.random() < 0.2) bgEngine.triggerAlert(0.4);
    } else if (remainingTime <= 10.0) {
      timeDisplay.className = 'hud-value glow-warning';
      timerBar.style.background = 'linear-gradient(90deg, var(--danger), var(--warning))';
    } else {
      timeDisplay.className = 'hud-value glow-accent';
      timerBar.style.background = 'linear-gradient(90deg, var(--danger), var(--warning), var(--primary))';
    }
  }
}

function updateShieldsUI() {
  const s1 = document.getElementById('shield1');
  const s2 = document.getElementById('shield2');
  const s3 = document.getElementById('shield3');
  if (s1) s1.className = 'shield-pip ' + (shields < 1 ? 'lost' : '');
  if (s2) s2.className = 'shield-pip ' + (shields < 2 ? 'lost' : '');
  if (s3) s3.className = 'shield-pip ' + (shields < 3 ? 'lost' : '');
}

/* =========================================================
   MELTDOWN (GAME OVER) & CLOUD LEADERBOARD TELEMETRY
   ========================================================= */
function triggerMeltdown(reason) {
  isGameOver = true;
  stopTimer();
  playSynth('meltdown');

  if (bgEngine) bgEngine.triggerAlert(1.0);

  if (window.RansomHorror) {
    if (RansomHorror.state === 'lurking') RansomHorror.evadeLurker();
    clearTimeout(RansomHorror.lurkTimer);
  }

  const fScore = document.getElementById('finalScoreVal');
  const fSec = document.getElementById('finalSectorVal');
  const fReason = document.getElementById('gameOverReason');

  if (fScore) fScore.innerText = score + ' pts';
  if (fSec) fSec.innerText = 'Sector ' + sequenceLength + ' (' + currentGridSize + 'x' + currentGridSize + ')';
  if (fReason) fReason.innerText = reason;

  if (gameOverOverlay) {
    gameOverOverlay.style.display = 'flex';
    if (window.Motion) {
      window.Motion.animate(gameOverOverlay, { opacity: [0, 1], scale: [0.94, 1] }, { duration: 0.35, ease: [0.16, 1, 0.3, 1] });
    }
  }

  saveScoreRecords(score);
}

function saveScoreRecords(finalScore) {
  const prevBest = parseInt(localStorage.getItem('hub_reactor_high') || '0', 10);
  if (finalScore > prevBest) {
    localStorage.setItem('hub_reactor_high', finalScore);
  }
  const prevSec = localStorage.getItem('hub_reactor_stage') || 'Sector 1';
  const prevSecNum = parseInt(prevSec.replace(/\D/g, '') || '1', 10);
  if (sequenceLength > prevSecNum) {
    localStorage.setItem('hub_reactor_stage', 'Sector ' + sequenceLength);
  }

  saveScoreToDatabase(finalScore);
}

async function saveScoreToDatabase(finalScore) {
  try {
    const params = new URLSearchParams();
    params.append('game', 'reactor_meltdown');
    params.append('score', finalScore);

    const response = await fetch('../save_score.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: params.toString()
    });

    if (response.ok) {
      const data = await response.json();
      const reasonEl = document.getElementById('gameOverReason');
      if (reasonEl && data.success) {
        reasonEl.innerHTML = '<span style="color: var(--accent);">✓ High score synchronized to cloud leaderboard!</span>';
      }
    }
  } catch (e) {
    console.warn('Cloud sync offline; stored in local storage.');
  }
}

/* =========================================================
   HELPERS & MODALS
   ========================================================= */
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function openProtocolModal() {
  if (protocolModal) {
    protocolModal.classList.add('active');
    const box = protocolModal.querySelector('.modal-box');
    if (box && window.Motion) {
      window.Motion.animate(box, { opacity: [0, 1], scale: [0.92, 1], y: [20, 0] }, { duration: 0.3, ease: [0.16, 1, 0.3, 1] });
    }
  }
}

function closeProtocolModal() {
  if (protocolModal) {
    const box = protocolModal.querySelector('.modal-box');
    if (box && window.Motion) {
      window.Motion.animate(box, { opacity: [1, 0], scale: [1, 0.94], y: [0, 15] }, { duration: 0.2 }).then(() => {
        protocolModal.classList.remove('active');
      });
    } else {
      protocolModal.classList.remove('active');
    }
  }
}

/* Kinetic Camera Depth Navigation Transition Handler */
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
