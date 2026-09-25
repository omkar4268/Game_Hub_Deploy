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
  const btn = document.getElementById('soundBtn');
  if (btn) btn.innerText = soundEnabled ? '🔊' : '🔇';
}

function playSynth(type, param = 0) {
  if (!soundEnabled) return;
  initAudio();
  if (!audioCtx) return;

  try {
    const now = audioCtx.currentTime;

    if (type === 'beep') {
      // High-tech reactor tile flash tone (pitch varies by tile index)
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = 'sine';

      // Pentatonic-inspired frequency ladder
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
      // Crisp touch click
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
      // Emergency hazard klaxon
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
      // Stabilization chime chord
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
      // Matrix expansion sweep
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
      // Descending low catastrophic explosion drone
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

// DOM Elements
let reactorGrid, timerBar, timeDisplay, scoreDisplay, sectorBadge, statusMessage;
let sequenceProgressPill, shockwave, expansionBanner, expansionText;
let startupOverlay, gameOverOverlay, protocolModal;

/* =========================================================
   LIFECYCLE & STATS
   ========================================================= */
window.addEventListener('DOMContentLoaded', () => {
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
  if (startupOverlay) startupOverlay.style.display = 'none';
  if (gameOverOverlay) gameOverOverlay.style.display = 'none';
  if (expansionBanner) expansionBanner.classList.remove('show');

  score = 0;
  currentGridSize = 3;
  sequenceLength = 1;
  remainingTime = 20.0;
  maxTimeRef = 20.0;
  shields = 3;
  isGameOver = false;

  updateShieldsUI();
  setupStage();
}

/* =========================================================
   STAGE SETUP & PROGRESSIVE GRID UPGRADE LOGIC
   ========================================================= */
function setupStage() {
  stopTimer();

  // Check if sequenceLength exceeds "at least one more than half the tiles" of the current grid
  // For 3x3: total tiles = 9. Half = 4.5. One more than half = 5.
  // If sequenceLength > 5 (i.e. was 5, now advancing), upgrade to 4x4!
  const totalTiles = currentGridSize * currentGridSize;
  const upgradeThreshold = Math.floor(totalTiles / 2) + 1;

  if (sequenceLength > upgradeThreshold && currentGridSize < 5) {
    // Upgrade Grid Size!
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
    expansionBanner.classList.add('show');
    setTimeout(() => {
      expansionBanner.classList.remove('show');
    }, 1400);
  }
}

function renderReactorGrid() {
  if (!reactorGrid) return;
  reactorGrid.innerHTML = '';
  tileElements = [];
  const totalTiles = currentGridSize * currentGridSize;

  for (let i = 0; i < totalTiles; i++) {
    const tile = document.createElement('div');
    tile.className = 'reactor-tile';
    tile.dataset.index = i;
    tile.innerText = (i + 1);

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

  // Generate random sequence of tile indices
  currentSequence = [];
  const totalTiles = currentGridSize * currentGridSize;
  for (let i = 0; i < sequenceLength; i++) {
    const randomTileIndex = Math.floor(Math.random() * totalTiles);
    currentSequence.push(randomTileIndex);
  }

  await delay(600);

  // Broadcast Phase: Flash tiles one by one
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

  // Operator Input Phase Starts!
  isBroadcasting = false;
  if (statusMessage) {
    statusMessage.innerText = 'AWAITING INPUT: CLICK IN SEQUENCE (0 / ' + currentSequence.length + ')';
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
    // Correct Input!
    playSynth('tap');
    playSynth('beep', clickedIndex);

    if (tileEl) {
      tileEl.classList.add('correct-tap');
      setTimeout(() => tileEl.classList.remove('correct-tap'), 200);
    }

    playerInputIndex++;
    if (statusMessage) {
      statusMessage.innerText = 'INPUT ACCEPTED: ' + playerInputIndex + ' / ' + currentSequence.length;
      statusMessage.style.color = 'var(--accent)';
    }

    // Check if sequence completed
    if (playerInputIndex >= currentSequence.length) {
      await handleSequenceSuccess();
    }

  } else {
    // Wrong Input!
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

  // Add +3 seconds to timer
  remainingTime += 3.0;
  maxTimeRef = Math.max(maxTimeRef, remainingTime);

  // Calculate score
  const points = sequenceLength * 50 + Math.floor(remainingTime * 10);
  score += points;
  updateHUD();

  await delay(600);

  // Advance sequence length
  sequenceLength++;
  setupStage();
}

async function handleSequenceFailure(wrongIndex) {
  isBroadcasting = true;
  stopTimer();
  playSynth('strike');

  // Trigger visual shockwave & shake wrong tile
  if (shockwave) shockwave.classList.add('active');
  const tileEl = (tileElements && tileElements[wrongIndex]) || document.querySelector('.reactor-tile[data-index="' + wrongIndex + '"]');
  if (tileEl) tileEl.classList.add('wrong-tap');

  shields--;
  updateShieldsUI();

  await delay(400);
  if (shockwave) shockwave.classList.remove('active');
  if (tileEl) tileEl.classList.remove('wrong-tap');

  // Check Meltdown (Game Over if shields depleted)
  if (shields <= 0) {
    triggerMeltdown('Reactor containment shields collapsed under repeated input anomalies.');
    return;
  }

  if (statusMessage) {
    statusMessage.innerText = 'INPUT ERROR // RE-BROADCASTING';
    statusMessage.style.color = 'var(--danger)';
  }

  await delay(700);

  // Replay current sequence so player can try again
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
    statusMessage.innerText = 'AWAITING INPUT: CLICK IN SEQUENCE (0 / ' + currentSequence.length + ')';
    statusMessage.style.color = 'var(--accent)';
  }

  startTimer();
}

/* =========================================================
   COUNTDOWN TIMER SYSTEM
   ========================================================= */
function startTimer() {
  stopTimer();
  const tickRate = 50; // ms

  timerInterval = setInterval(() => {
    if (isGameOver || isBroadcasting) return;

    remainingTime -= (tickRate / 1000);
    if (remainingTime <= 0) {
      remainingTime = 0;
      updateHUD();
      stopTimer();
      triggerMeltdown('Coolant exhausted. Temperature spike caused immediate core meltdown.');
      return;
    }
    updateHUD();
  }, tickRate);
}

function stopTimer() {
  if (timerInterval) {
    clearInterval(timerInterval);
    timerInterval = null;
  }
}

/* =========================================================
   UI UPDATES & SHIELD GAUGES
   ========================================================= */
function updateHUD() {
  if (scoreDisplay) scoreDisplay.innerText = score.toString().padStart(4, '0');
  if (timeDisplay) timeDisplay.innerText = remainingTime.toFixed(1) + 's';

  // Timer Bar Percentage
  if (timerBar) {
    const pct = Math.min(100, Math.max(0, (remainingTime / maxTimeRef) * 100));
    timerBar.style.width = pct + '%';

    if (remainingTime <= 5.0) {
      timeDisplay.className = 'hud-value glow-danger';
      timerBar.style.background = 'var(--danger)';
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

  const fScore = document.getElementById('finalScoreVal');
  const fSec = document.getElementById('finalSectorVal');
  const fReason = document.getElementById('gameOverReason');

  if (fScore) fScore.innerText = score + ' pts';
  if (fSec) fSec.innerText = 'Sector ' + sequenceLength + ' (' + currentGridSize + 'x' + currentGridSize + ')';
  if (fReason) fReason.innerText = reason;
  if (gameOverOverlay) gameOverOverlay.style.display = 'flex';

  saveScoreRecords(score);
}

function saveScoreRecords(finalScore) {
  // Local telemetry
  const prevBest = parseInt(localStorage.getItem('hub_reactor_high') || '0', 10);
  if (finalScore > prevBest) {
    localStorage.setItem('hub_reactor_high', finalScore);
  }
  const prevSec = localStorage.getItem('hub_reactor_stage') || 'Sector 1';
  const prevSecNum = parseInt(prevSec.replace(/\D/g, '') || '1', 10);
  if (sequenceLength > prevSecNum) {
    localStorage.setItem('hub_reactor_stage', 'Sector ' + sequenceLength);
  }

  // Database cloud sync (uses relative path to root save_score.jsp)
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
  if (protocolModal) protocolModal.classList.add('active');
}

function closeProtocolModal() {
  if (protocolModal) protocolModal.classList.remove('active');
}

/* Cyber-Scanner Navigation Wipe Handler */
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
