// =========================================================
// DEFUSAL PROTOCOL // TACTICAL CRISIS SIM v3.0
// Multi-Module Engine & 3-Charge Integrity Containment System
// =========================================================

// --- Web Audio API Procedural Synthesizer ---
let audioCtx = null;

function getAudioContext() {
    if (!audioCtx) {
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        if (AudioContext) {
            audioCtx = new AudioContext();
        }
    }
    if (audioCtx && audioCtx.state === 'suspended') {
        audioCtx.resume();
    }
    return audioCtx;
}

function playBeep(freq = 440, type = 'sine', duration = 0.08, vol = 0.15) {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = type;
        osc.frequency.setValueAtTime(freq, ctx.currentTime);
        gain.gain.setValueAtTime(vol, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + duration);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + duration);
    } catch (e) {}
}

function playTapSound() {
    playBeep(620, 'sine', 0.04, 0.12);
}

function playEatSound() {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(440, ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.09);
        gain.gain.setValueAtTime(0.2, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.1);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.1);
    } catch (e) {}
}

function playWireSnipSound() {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const now = ctx.currentTime;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'square';
        osc.frequency.setValueAtTime(1400, now);
        osc.frequency.exponentialRampToValueAtTime(300, now + 0.06);
        gain.gain.setValueAtTime(0.3, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 0.07);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(now + 0.07);
    } catch (e) {}
}

function playStrikeZapSound() {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const now = ctx.currentTime;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(160, now);
        osc.frequency.linearRampToValueAtTime(45, now + 0.28);
        gain.gain.setValueAtTime(0.4, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 0.3);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(now + 0.3);
    } catch (e) {}
}

function playDisarmSuccessSound() {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const now = ctx.currentTime;
        [523.25, 659.25, 783.99, 1046.50].forEach((freq, i) => {
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(freq, now + i * 0.07);
            gain.gain.setValueAtTime(0.2, now + i * 0.07);
            gain.gain.exponentialRampToValueAtTime(0.001, now + i * 0.07 + 0.2);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(now + i * 0.07);
            osc.stop(now + i * 0.07 + 0.22);
        });
    } catch (e) {}
}

function playExplosionSound() {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const now = ctx.currentTime;
        const bufferSize = ctx.sampleRate * 1.2;
        const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
        const data = buffer.getChannelData(0);
        for (let i = 0; i < bufferSize; i++) {
            data[i] = Math.random() * 2 - 1;
        }
        const noise = ctx.createBufferSource();
        noise.buffer = buffer;

        const filter = ctx.createBiquadFilter();
        filter.type = 'lowpass';
        filter.frequency.setValueAtTime(450, now);
        filter.frequency.exponentialRampToValueAtTime(30, now + 1.1);

        const gain = ctx.createGain();
        gain.gain.setValueAtTime(0.8, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 1.2);

        noise.connect(filter);
        filter.connect(gain);
        gain.connect(ctx.destination);
        noise.start(now);
    } catch (e) {}
}

function playWaveResonanceSound() {
    try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const now = ctx.currentTime;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(440, now);
        osc.frequency.exponentialRampToValueAtTime(880, now + 0.35);
        gain.gain.setValueAtTime(0.25, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 0.4);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(now + 0.4);
    } catch (e) {}
}

// --- Level Configuration & Module Security Tiers ---
const levelData = [
    {
        id: 1,
        title: "Tier 01: Training Routine",
        modules: [{ type: 'reactor', diff: 'easy' }]
    },
    {
        id: 2,
        title: "Tier 02: Dual Sentinel",
        modules: [
            { type: 'snake', diff: 'easy' },
            { type: 'wires', diff: 'easy' }
        ]
    },
    {
        id: 3,
        title: "Tier 03: Resonance Routing",
        modules: [
            { type: 'maze', diff: 'easy' },
            { type: 'freq', diff: 'easy' }
        ]
    },
    {
        id: 4,
        title: "Tier 04: Tri-System Perimeter",
        modules: [
            { type: 'reactor', diff: 'easy' },
            { type: 'snake', diff: 'easy' },
            { type: 'wires', diff: 'med' }
        ]
    },
    {
        id: 5,
        title: "Tier 05: Core Vector Infiltration",
        modules: [
            { type: 'maze', diff: 'med' },
            { type: 'freq', diff: 'med' },
            { type: 'reactor', diff: 'med' }
        ]
    },
    {
        id: 6,
        title: "Tier 06: Quad Hazard Grid",
        modules: [
            { type: 'snake', diff: 'med' },
            { type: 'wires', diff: 'med' },
            { type: 'reactor', diff: 'med' },
            { type: 'freq', diff: 'med' }
        ]
    },
    {
        id: 7,
        title: "Tier 07: Quantum Firewall",
        modules: [
            { type: 'maze', diff: 'med' },
            { type: 'reactor', diff: 'hard' },
            { type: 'snake', diff: 'med' },
            { type: 'wires', diff: 'hard' }
        ]
    },
    {
        id: 8,
        title: "Tier 08: Critical Containment",
        modules: [
            { type: 'freq', diff: 'hard' },
            { type: 'snake', diff: 'hard' },
            { type: 'maze', diff: 'hard' },
            { type: 'wires', diff: 'hard' },
            { type: 'reactor', diff: 'hard' }
        ]
    },
    {
        id: 9,
        title: "Tier 09: Apex Meltdown",
        modules: [
            { type: 'reactor', diff: 'hard' },
            { type: 'maze', diff: 'hard' },
            { type: 'snake', diff: 'hard' },
            { type: 'freq', diff: 'hard' },
            { type: 'wires', diff: 'hard' }
        ]
    },
    {
        id: 10,
        title: "Tier 10: Ghost Protocol Chassis",
        boss: true,
        modules: [
            { type: 'snake', diff: 'hard' },
            { type: 'reactor', diff: 'hard' },
            { type: 'maze', diff: 'hard' },
            { type: 'wires', diff: 'hard' },
            { type: 'freq', diff: 'hard' },
            { type: 'reactor', diff: 'hard' }
        ]
    }
];

// Module Metadata dictionary
const MODULE_META = {
    snake: {
        name: "DATA SERPENT",
        icon: "🐍",
        descEasy: "Absorb 10 data bytes to bypass module. Wall hit burns 1 charge.",
        descMed: "Absorb 25 data bytes to bypass module. Wall hit burns 1 charge.",
        descHard: "Absorb 50 data bytes to bypass module. Wall hit burns 1 charge."
    },
    reactor: {
        name: "REACTOR CORE",
        icon: "☢️",
        descEasy: "Memorize & repeat 3-tile sequence. Mis-tap burns 1 charge.",
        descMed: "Memorize & repeat 4-tile sequence. Mis-tap burns 1 charge.",
        descHard: "Memorize & repeat 5-tile sequence. Mis-tap burns 1 charge."
    },
    maze: {
        name: "FIREWALL MAZE",
        icon: "⚡",
        descEasy: "Route packet node through small 7x7 labyrinth to green terminal.",
        descMed: "Route packet node through medium 11x11 labyrinth to green terminal.",
        descHard: "Route packet node through complex 15x15 labyrinth to green terminal."
    },
    wires: {
        name: "BANANA WIRES",
        icon: "🍌",
        descEasy: "Inspect 4-wire bundle, apply BOMBANANA directive, and cut target wire.",
        descMed: "Inspect 5-wire bundle, apply BOMBANANA directive, and cut target wire.",
        descHard: "Inspect 6-wire bundle, apply BOMBANANA directive, and cut target wire."
    },
    freq: {
        name: "FREQ TUNER",
        icon: "📡",
        descEasy: "Align frequency & phase sliders to match golden carrier wave (≥90%).",
        descMed: "Calibrate frequency & phase against shifting carrier wave (≥90%).",
        descHard: "Precision lock oscillating carrier wave within tight tolerance (≥90%)."
    }
};

// Global Gameplay State
let currentLevel = 0;
let currentLvlConfig = null;
let activeModulesState = [];
let timeRemaining = 180;
let timerInterval = null;
let remainingCharges = 3;
let modulesToSolve = 0;
let activeModuleIndex = -1;

// --- Containment Charges (3-Strike System) ---
function updateChargesDisplay() {
    // Top Chassis LEDs (strike1, strike2, strike3)
    const s1 = document.getElementById('strike1');
    const s2 = document.getElementById('strike2');
    const s3 = document.getElementById('strike3');
    if (s1) s1.className = remainingCharges >= 1 ? 'led active' : 'led lost';
    if (s2) s2.className = remainingCharges >= 2 ? 'led active' : 'led lost';
    if (s3) s3.className = remainingCharges >= 3 ? 'led active' : 'led lost';

    // Minigame Workstation Pips (chPip1, chPip2, chPip3)
    const p1 = document.getElementById('chPip1');
    const p2 = document.getElementById('chPip2');
    const p3 = document.getElementById('chPip3');
    if (p1) p1.className = remainingCharges >= 1 ? 'charge-pip active' : 'charge-pip lost';
    if (p2) p2.className = remainingCharges >= 2 ? 'charge-pip active' : 'charge-pip lost';
    if (p3) p3.className = remainingCharges >= 3 ? 'charge-pip active' : 'charge-pip lost';
}

function deductCharge(reason) {
    if (remainingCharges <= 0) return true;
    remainingCharges--;
    playStrikeZapSound();

    // Workstation Shockwave & Shake
    const sw = document.getElementById('mgShockwave');
    if (sw) {
        sw.classList.add('active');
        setTimeout(() => sw.classList.remove('active'), 320);
    }
    const box = document.getElementById('minigameBox');
    if (box) {
        box.style.transform = 'translateY(4px)';
        setTimeout(() => { if (box) box.style.transform = 'none'; }, 180);
    }

    updateChargesDisplay();

    if (remainingCharges <= 0) {
        closeMiniGame(false, false);
        triggerExplosion(reason || "INTEGRITY BREACH: ALL 3 CONTAINMENT CHARGES DEPLETED");
        return true;
    }
    return false;
}

// --- Menu & Level Selection ---
function initMenu() {
    const grid = document.getElementById('levelGrid');
    if (!grid) return;
    grid.innerHTML = '';
    levelData.forEach(lvl => {
        const btn = document.createElement('button');
        btn.className = `level-btn ${lvl.boss ? 'boss' : ''}`;
        btn.innerText = `LVL ${lvl.id < 10 ? '0' + lvl.id : lvl.id}`;
        btn.onclick = () => {
            getAudioContext();
            startLevel(lvl.id);
        };
        grid.appendChild(btn);
    });
}

function startLevel(levelId) {
    currentLevel = levelId;
    currentLvlConfig = levelData.find(l => l.id === levelId);
    if (!currentLvlConfig) return;

    remainingCharges = 3;
    timeRemaining = 180;
    modulesToSolve = currentLvlConfig.modules.length;
    document.body.classList.remove('panic-mode');

    // Clone state
    activeModulesState = currentLvlConfig.modules.map((m, idx) => ({
        index: idx,
        type: m.type,
        diff: m.diff,
        solved: false
    }));

    updateChargesDisplay();
    renderBriefcaseModules();

    document.getElementById('screen-menu').classList.remove('active');
    document.getElementById('screen-result').classList.remove('active');
    document.getElementById('screen-game').classList.add('active');

    clearInterval(timerInterval);
    timerInterval = setInterval(gameTick, 1000);
    updateTimerDisplay();
}

function renderBriefcaseModules() {
    const grid = document.getElementById('moduleGrid');
    if (!grid) return;
    grid.innerHTML = '';

    for (let i = 0; i < 6; i++) {
        const modDiv = document.createElement('div');

        if (i < activeModulesState.length) {
            const modState = activeModulesState[i];
            const meta = MODULE_META[modState.type] || { name: 'MODULE', icon: '⚡' };
            const diffClass = `diff-${modState.diff}`;
            const diffText = modState.diff.toUpperCase();

            modDiv.className = `module ${modState.solved ? 'solved' : ''}`;
            modDiv.id = `mod-${i}`;
            modDiv.innerHTML = `
                <div class="module-title">${meta.icon} ${meta.name}</div>
                <div class="module-diff ${diffClass}">${diffText}</div>
                <div class="module-status">${modState.solved ? '[ BYPASSED ]' : '[ ACTIVE ]'}</div>
            `;
            if (!modState.solved) {
                modDiv.onclick = () => openMiniGame(i);
            }
        } else {
            modDiv.className = 'module empty';
            modDiv.innerHTML = `<div class="module-title">SLOT 0${i + 1}</div><div class="module-status">[ OFFLINE ]</div>`;
        }
        grid.appendChild(modDiv);
    }
}

// Timer Loop
function gameTick() {
    timeRemaining--;
    updateTimerDisplay();

    if (timeRemaining === 60) {
        document.body.classList.add('panic-mode');
        playBeep(220, 'sawtooth', 0.2, 0.25);
    }

    if (timeRemaining <= 0) {
        triggerExplosion("DETONATION TIMER ELAPSED: ZERO REACHED");
    }
}

function updateTimerDisplay() {
    const m = Math.floor(timeRemaining / 60);
    const s = timeRemaining % 60;
    const ms = Math.floor(Math.random() * 99);
    const disp = document.getElementById('timerDisplay');
    if (disp) {
        disp.innerText = `0${m}:${s < 10 ? '0' + s : s}:${ms < 10 ? '0' + ms : ms}`;
    }
}

// =========================================================
// MINI-GAME WORKSTATION CONTROLLER & MODAL ROUTING
// =========================================================

function hideAllMiniGameContainers() {
    ['mgSnakeContainer', 'mgReactorContainer', 'mgMazeContainer', 'mgWiresContainer', 'mgFreqContainer'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.style.display = 'none';
    });
}

function openMiniGame(index) {
    activeModuleIndex = index;
    const mod = activeModulesState[index];
    if (!mod || mod.solved) return;

    const meta = MODULE_META[mod.type];
    const diffUpper = mod.diff.toUpperCase();

    // Populate workstation header
    const iconEl = document.getElementById('mgIcon');
    const titleEl = document.getElementById('mgTitle');
    const subEl = document.getElementById('mgSub');
    const diffBadge = document.getElementById('mgDiffBadge');
    const descEl = document.getElementById('mgDesc');

    if (iconEl) iconEl.innerText = meta.icon;
    if (titleEl) titleEl.innerText = meta.name;
    if (subEl) subEl.innerText = `SECURITY CLEARANCE // MODULE 0${index + 1}`;
    if (diffBadge) {
        diffBadge.innerText = diffUpper;
        diffBadge.className = `mg-diff-badge diff-${mod.diff}`;
    }

    let desc = meta.descEasy;
    if (mod.diff === 'med') desc = meta.descMed;
    if (mod.diff === 'hard') desc = meta.descHard;
    if (descEl) descEl.innerText = desc;

    updateChargesDisplay();
    hideAllMiniGameContainers();

    // Launch targeted mini-game
    if (mod.type === 'snake') {
        initSnakeGame(mod.diff);
    } else if (mod.type === 'reactor') {
        initReactorGame(mod.diff);
    } else if (mod.type === 'maze') {
        initMazeGame(mod.diff);
    } else if (mod.type === 'wires') {
        initBananaWires(mod.diff);
    } else if (mod.type === 'freq') {
        initFrequencyTuner(mod.diff);
    }

    const overlay = document.getElementById('miniGameOverlay');
    if (overlay) overlay.style.display = 'flex';
}

function closeMiniGame(success = false, causedStrike = false) {
    // Teardown any running game loops
    cleanupSnakeGame();
    cleanupReactorGame();
    cleanupMazeGame();
    cleanupFreqTuner();

    const overlay = document.getElementById('miniGameOverlay');
    if (overlay) overlay.style.display = 'none';

    if (success && activeModuleIndex >= 0) {
        const modState = activeModulesState[activeModuleIndex];
        if (modState && !modState.solved) {
            modState.solved = true;
            modulesToSolve--;
            playDisarmSuccessSound();

            const modEl = document.getElementById(`mod-${activeModuleIndex}`);
            if (modEl) {
                modEl.classList.add('solved');
                modEl.onclick = null;
                const statusEl = modEl.querySelector('.module-status');
                if (statusEl) statusEl.innerText = '[ BYPASSED ]';
            }

            if (modulesToSolve <= 0) {
                setTimeout(triggerSuccess, 400);
            }
        }
    } else if (causedStrike) {
        deductCharge("MODULE INTEGRITY BREACH");
    }
}

// =========================================================
// MINI-GAME 1: DATA SERPENT (SNAKE)
// Target score: Easy: 10 pts, Med: 25 pts, Hard: 50 pts
// Dying costs 1 charge!
// =========================================================
let snakeTimer = null;
let snakeScore = 0;
let snakeTargetScore = 10;
let snakeGridSize = 14;
let snakeCellSize = 20;
let snakeBody = [];
let snakeDir = { x: 1, y: 0 };
let snakeNextDir = { x: 1, y: 0 };
let snakeFood = { x: 5, y: 5 };
let snakeCanvas = null;
let snakeCtx = null;

function initSnakeGame(diff) {
    const container = document.getElementById('mgSnakeContainer');
    if (container) container.style.display = 'flex';

    snakeCanvas = document.getElementById('snakeCanvas');
    if (!snakeCanvas) return;
    snakeCtx = snakeCanvas.getContext('2d');

    // Canvas internal resolution
    snakeCanvas.width = 280;
    snakeCanvas.height = 280;
    snakeCellSize = 280 / snakeGridSize; // 20px

    if (diff === 'easy') snakeTargetScore = 10;
    else if (diff === 'med') snakeTargetScore = 25;
    else if (diff === 'hard') snakeTargetScore = 50;

    snakeScore = 0;
    updateSnakeHud();
    spawnSnake();
    spawnSnakeFood();

    window.removeEventListener('keydown', handleSnakeKey);
    window.addEventListener('keydown', handleSnakeKey);

    clearInterval(snakeTimer);
    const speed = diff === 'hard' ? 100 : (diff === 'med' ? 120 : 135);
    snakeTimer = setInterval(snakeLoop, speed);
}

function spawnSnake() {
    snakeBody = [
        { x: 5, y: 7 },
        { x: 4, y: 7 },
        { x: 3, y: 7 }
    ];
    snakeDir = { x: 1, y: 0 };
    snakeNextDir = { x: 1, y: 0 };
}

function spawnSnakeFood() {
    let valid = false;
    let attempts = 0;
    while (!valid && attempts < 100) {
        attempts++;
        const fx = Math.floor(Math.random() * snakeGridSize);
        const fy = Math.floor(Math.random() * snakeGridSize);
        const collision = snakeBody.some(seg => seg.x === fx && seg.y === fy);
        if (!collision) {
            snakeFood = { x: fx, y: fy };
            valid = true;
        }
    }
}

function updateSnakeHud() {
    const disp = document.getElementById('snakeScoreDisplay');
    if (disp) {
        disp.innerText = `${snakeScore} / ${snakeTargetScore} pts`;
    }
}

function handleSnakeKey(e) {
    if (e.key === 'ArrowUp' || e.key === 'w' || e.key === 'W') {
        snakeInput('UP');
        e.preventDefault();
    } else if (e.key === 'ArrowDown' || e.key === 's' || e.key === 'S') {
        snakeInput('DOWN');
        e.preventDefault();
    } else if (e.key === 'ArrowLeft' || e.key === 'a' || e.key === 'A') {
        snakeInput('LEFT');
        e.preventDefault();
    } else if (e.key === 'ArrowRight' || e.key === 'd' || e.key === 'D') {
        snakeInput('RIGHT');
        e.preventDefault();
    }
}

function snakeInput(dir) {
    if (dir === 'UP' && snakeDir.y === 0) snakeNextDir = { x: 0, y: -1 };
    if (dir === 'DOWN' && snakeDir.y === 0) snakeNextDir = { x: 0, y: 1 };
    if (dir === 'LEFT' && snakeDir.x === 0) snakeNextDir = { x: -1, y: 0 };
    if (dir === 'RIGHT' && snakeDir.x === 0) snakeNextDir = { x: 1, y: 0 };
    playTapSound();
}

function snakeLoop() {
    snakeDir = snakeNextDir;
    const head = { x: snakeBody[0].x + snakeDir.x, y: snakeBody[0].y + snakeDir.y };

    // Wall collision
    if (head.x < 0 || head.x >= snakeGridSize || head.y < 0 || head.y >= snakeGridSize) {
        handleSnakeCrash();
        return;
    }

    // Self collision
    if (snakeBody.some(seg => seg.x === head.x && seg.y === head.y)) {
        handleSnakeCrash();
        return;
    }

    snakeBody.unshift(head);

    // Food eaten
    if (head.x === snakeFood.x && head.y === snakeFood.y) {
        snakeScore += 1;
        playEatSound();
        updateSnakeHud();

        if (snakeScore >= snakeTargetScore) {
            clearInterval(snakeTimer);
            renderSnakeCanvas();
            setTimeout(() => closeMiniGame(true), 400);
            return;
        }
        spawnSnakeFood();
    } else {
        snakeBody.pop();
    }

    renderSnakeCanvas();
}

function handleSnakeCrash() {
    const dead = deductCharge("DATA SERPENT CORRUPTED: WALL / TAIL COLLISION");
    if (!dead) {
        spawnSnake();
        spawnSnakeFood();
    }
}

function renderSnakeCanvas() {
    if (!snakeCtx) return;
    const ctx = snakeCtx;
    ctx.fillStyle = '#020617';
    ctx.fillRect(0, 0, 280, 280);

    // Subtle grid
    ctx.strokeStyle = 'rgba(56, 189, 248, 0.08)';
    ctx.lineWidth = 1;
    for (let i = 0; i <= snakeGridSize; i++) {
        ctx.beginPath();
        ctx.moveTo(i * snakeCellSize, 0);
        ctx.lineTo(i * snakeCellSize, 280);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(0, i * snakeCellSize);
        ctx.lineTo(280, i * snakeCellSize);
        ctx.stroke();
    }

    // Draw Food (glowing byte)
    ctx.fillStyle = '#facc15';
    ctx.shadowColor = '#facc15';
    ctx.shadowBlur = 10;
    ctx.fillRect(
        snakeFood.x * snakeCellSize + 3,
        snakeFood.y * snakeCellSize + 3,
        snakeCellSize - 6,
        snakeCellSize - 6
    );
    ctx.shadowBlur = 0;

    // Draw Snake
    snakeBody.forEach((seg, i) => {
        if (i === 0) {
            // Head
            ctx.fillStyle = '#38bdf8';
            ctx.shadowColor = '#38bdf8';
            ctx.shadowBlur = 10;
        } else {
            // Body
            ctx.fillStyle = i % 2 === 0 ? '#0284c7' : '#0369a1';
            ctx.shadowBlur = 0;
        }
        ctx.fillRect(
            seg.x * snakeCellSize + 2,
            seg.y * snakeCellSize + 2,
            snakeCellSize - 4,
            snakeCellSize - 4
        );
    });
    ctx.shadowBlur = 0;
}

function cleanupSnakeGame() {
    clearInterval(snakeTimer);
    window.removeEventListener('keydown', handleSnakeKey);
}

// =========================================================
// MINI-GAME 2: REACTOR CORE (PROGRESSIVE MEMORY SEQUENCE)
// Starting already at 3 tiles glowing (Easy: 3, Med: 4, Hard: 5)
// Mis-tap costs 1 charge!
// =========================================================
let reactorSequence = [];
let reactorUserIndex = 0;
let reactorSequenceLength = 3;
let reactorAcceptInput = false;
let reactorReplayTimer = null;

function initReactorGame(diff) {
    const container = document.getElementById('mgReactorContainer');
    if (container) container.style.display = 'flex';

    if (diff === 'easy') reactorSequenceLength = 3;
    else if (diff === 'med') reactorSequenceLength = 4;
    else if (diff === 'hard') reactorSequenceLength = 5;

    renderReactorKeypad();
    startReactorSequence();
}

function renderReactorKeypad() {
    const keypad = document.getElementById('reactorKeypad');
    if (!keypad) return;
    keypad.innerHTML = '';

    for (let i = 0; i < 9; i++) {
        const tile = document.createElement('button');
        tile.className = 'mg-reactor-tile';
        tile.id = `rtile-${i}`;
        tile.innerText = `${i + 1}`;
        tile.onclick = () => handleReactorTileClick(i);
        keypad.appendChild(tile);
    }
}

function startReactorSequence() {
    reactorSequence = [];
    reactorUserIndex = 0;
    reactorAcceptInput = false;

    // Generate random sequence of length
    for (let i = 0; i < reactorSequenceLength; i++) {
        reactorSequence.push(Math.floor(Math.random() * 9));
    }

    updateReactorHud(`BROADCASTING SEQUENCE...`, 0);
    broadcastReactorSequence();
}

function updateReactorHud(status, step) {
    const stEl = document.getElementById('reactorStatusText');
    const scEl = document.getElementById('reactorStepDisplay');
    if (stEl) stEl.innerText = status;
    if (scEl) scEl.innerText = `${step} / ${reactorSequenceLength}`;
}

function broadcastReactorSequence() {
    reactorAcceptInput = false;
    let step = 0;

    function playNext() {
        if (step >= reactorSequence.length) {
            setTimeout(() => {
                reactorAcceptInput = true;
                updateReactorHud("ENTER SEQUENCE", 0);
            }, 300);
            return;
        }

        const tileIndex = reactorSequence[step];
        const tile = document.getElementById(`rtile-${tileIndex}`);
        if (tile) {
            tile.classList.add('flash');
            playBeep(350 + tileIndex * 60, 'sine', 0.18, 0.22);
            setTimeout(() => {
                tile.classList.remove('flash');
                step++;
                setTimeout(playNext, 220);
            }, 320);
        } else {
            step++;
            setTimeout(playNext, 220);
        }
    }

    setTimeout(playNext, 450);
}

function handleReactorTileClick(tileIndex) {
    if (!reactorAcceptInput) return;

    const tile = document.getElementById(`rtile-${tileIndex}`);
    if (tileIndex === reactorSequence[reactorUserIndex]) {
        // Correct step
        playBeep(450 + tileIndex * 70, 'sine', 0.15, 0.2);
        if (tile) {
            tile.classList.add('correct');
            setTimeout(() => tile.classList.remove('correct'), 250);
        }
        reactorUserIndex++;
        updateReactorHud("ENTER SEQUENCE", reactorUserIndex);

        if (reactorUserIndex >= reactorSequence.length) {
            reactorAcceptInput = false;
            updateReactorHud("MATRIX STABILIZED", reactorSequenceLength);
            playDisarmSuccessSound();
            for (let i = 0; i < 9; i++) {
                const t = document.getElementById(`rtile-${i}`);
                if (t) t.classList.add('correct');
            }
            setTimeout(() => closeMiniGame(true), 550);
        }
    } else {
        // Mis-tap!
        reactorAcceptInput = false;
        if (tile) {
            tile.classList.add('wrong');
            setTimeout(() => tile.classList.remove('wrong'), 350);
        }
        const dead = deductCharge("REACTOR MATRIX DESYNC: INCORRECT TILE SEQUENCE");
        if (!dead) {
            updateReactorHud("DESYNC! RE-BROADCASTING...", 0);
            clearTimeout(reactorReplayTimer);
            reactorReplayTimer = setTimeout(() => {
                reactorUserIndex = 0;
                broadcastReactorSequence();
            }, 900);
        }
    }
}

function cleanupReactorGame() {
    clearTimeout(reactorReplayTimer);
    reactorAcceptInput = false;
}

// =========================================================
// MINI-GAME 3: FIREWALL MAZE RUNNER
// Labyrinth sizes: Easy: 7x7, Med: 11x11, Hard: 15x15
// =========================================================
let mazeGrid = [];
let mazeCols = 7;
let mazeRows = 7;
let mazePlayer = { x: 1, y: 1 };
let mazeGoal = { x: 5, y: 5 };
let mazeTraps = [];
let mazeCanvas = null;
let mazeCtx = null;

function initMazeGame(diff) {
    const container = document.getElementById('mgMazeContainer');
    if (container) container.style.display = 'flex';

    mazeCanvas = document.getElementById('mazeCanvas');
    if (!mazeCanvas) return;
    mazeCtx = mazeCanvas.getContext('2d');

    mazeCanvas.width = 280;
    mazeCanvas.height = 280;

    if (diff === 'easy') {
        mazeCols = 7;
        mazeRows = 7;
    } else if (diff === 'med') {
        mazeCols = 11;
        mazeRows = 11;
    } else if (diff === 'hard') {
        mazeCols = 15;
        mazeRows = 15;
    }

    generateMaze();
    mazePlayer = { x: 1, y: 1 };
    mazeGoal = { x: mazeCols - 2, y: mazeRows - 2 };

    // Place traps
    placeMazeTraps(diff);

    window.removeEventListener('keydown', handleMazeKey);
    window.addEventListener('keydown', handleMazeKey);

    renderMazeCanvas();
}

function generateMaze() {
    mazeGrid = Array(mazeRows).fill(0).map(() => Array(mazeCols).fill(1));

    function carve(x, y) {
        mazeGrid[y][x] = 0;
        const dirs = [
            { dx: 0, dy: -2 },
            { dx: 0, dy: 2 },
            { dx: -2, dy: 0 },
            { dx: 2, dy: 0 }
        ].sort(() => Math.random() - 0.5);

        for (const d of dirs) {
            const nx = x + d.dx;
            const ny = y + d.dy;
            if (nx > 0 && nx < mazeCols - 1 && ny > 0 && ny < mazeRows - 1 && mazeGrid[ny][nx] === 1) {
                mazeGrid[y + d.dy / 2][x + d.dx / 2] = 0;
                carve(nx, ny);
            }
        }
    }

    carve(1, 1);
    mazeGrid[mazeRows - 2][mazeCols - 2] = 0;
}

function placeMazeTraps(diff) {
    mazeTraps = [];
    const count = diff === 'hard' ? 3 : (diff === 'med' ? 2 : 1);
    let attempts = 0;

    while (mazeTraps.length < count && attempts < 100) {
        attempts++;
        const rx = Math.floor(Math.random() * (mazeCols - 2)) + 1;
        const ry = Math.floor(Math.random() * (mazeRows - 2)) + 1;
        if (mazeGrid[ry][rx] === 0 && !(rx === 1 && ry === 1) && !(rx === mazeCols - 2 && ry === mazeRows - 2)) {
            if (!mazeTraps.some(t => t.x === rx && t.y === ry)) {
                mazeTraps.push({ x: rx, y: ry });
            }
        }
    }
}

function handleMazeKey(e) {
    if (e.key === 'ArrowUp' || e.key === 'w' || e.key === 'W') {
        mazeInput(0, -1);
        e.preventDefault();
    } else if (e.key === 'ArrowDown' || e.key === 's' || e.key === 'S') {
        mazeInput(0, 1);
        e.preventDefault();
    } else if (e.key === 'ArrowLeft' || e.key === 'a' || e.key === 'A') {
        mazeInput(-1, 0);
        e.preventDefault();
    } else if (e.key === 'ArrowRight' || e.key === 'd' || e.key === 'D') {
        mazeInput(1, 0);
        e.preventDefault();
    }
}

function mazeInput(dx, dy) {
    const nx = mazePlayer.x + dx;
    const ny = mazePlayer.y + dy;

    if (nx >= 0 && nx < mazeCols && ny >= 0 && ny < mazeRows && mazeGrid[ny][nx] === 0) {
        mazePlayer = { x: nx, y: ny };
        playBeep(520, 'triangle', 0.04, 0.1);

        // Check Trap collision
        const trapHit = mazeTraps.some(t => t.x === nx && t.y === ny);
        if (trapHit) {
            const dead = deductCharge("FIREWALL DEFENSIVE NODE TRIGGERED");
            if (!dead) {
                mazePlayer = { x: 1, y: 1 };
            }
        }

        // Check Goal
        if (mazePlayer.x === mazeGoal.x && mazePlayer.y === mazeGoal.y) {
            renderMazeCanvas();
            window.removeEventListener('keydown', handleMazeKey);
            playDisarmSuccessSound();
            setTimeout(() => closeMiniGame(true), 400);
            return;
        }

        renderMazeCanvas();
    }
}

function renderMazeCanvas() {
    if (!mazeCtx) return;
    const ctx = mazeCtx;
    const cellW = 280 / mazeCols;
    const cellH = 280 / mazeRows;

    ctx.fillStyle = '#020617';
    ctx.fillRect(0, 0, 280, 280);

    // Draw Walls
    for (let r = 0; r < mazeRows; r++) {
        for (let c = 0; c < mazeCols; c++) {
            if (mazeGrid[r][c] === 1) {
                ctx.fillStyle = '#0f172a';
                ctx.fillRect(c * cellW, r * cellH, cellW, cellH);
                ctx.strokeStyle = 'rgba(56, 189, 248, 0.25)';
                ctx.strokeRect(c * cellW, r * cellH, cellW, cellH);
            }
        }
    }

    // Draw Traps
    mazeTraps.forEach(trap => {
        ctx.fillStyle = '#f43f5e';
        ctx.shadowColor = '#f43f5e';
        ctx.shadowBlur = 8;
        ctx.beginPath();
        ctx.arc((trap.x + 0.5) * cellW, (trap.y + 0.5) * cellH, cellW * 0.28, 0, Math.PI * 2);
        ctx.fill();
    });

    // Draw Goal (Green Exit Terminal)
    ctx.fillStyle = '#22c55e';
    ctx.shadowColor = '#22c55e';
    ctx.shadowBlur = 12;
    ctx.beginPath();
    ctx.arc((mazeGoal.x + 0.5) * cellW, (mazeGoal.y + 0.5) * cellH, cellW * 0.35, 0, Math.PI * 2);
    ctx.fill();

    // Draw Player (Cyan Packet Node)
    ctx.fillStyle = '#38bdf8';
    ctx.shadowColor = '#38bdf8';
    ctx.shadowBlur = 10;
    ctx.beginPath();
    ctx.arc((mazePlayer.x + 0.5) * cellW, (mazePlayer.y + 0.5) * cellH, cellW * 0.32, 0, Math.PI * 2);
    ctx.fill();
    ctx.shadowBlur = 0;
}

function cleanupMazeGame() {
    window.removeEventListener('keydown', handleMazeKey);
}

// =========================================================
// MINI-GAME 4: BANANA WIRE MATRIX (BOMBANANA INSPIRED)
// Dynamic colored physical wires with deterministic protocol rules
// Wrong snip burns 1 charge!
// =========================================================
const WIRE_PALETTE = [
    { key: 'gold', name: 'Banana Gold', color: '#facc15' },
    { key: 'lime', name: 'Radioactive Lime', color: '#22c55e' },
    { key: 'cyan', name: 'Cyan Pulse', color: '#06b6d4' },
    { key: 'ruby', name: 'Hazard Ruby', color: '#ef4444' },
    { key: 'purple', name: 'Carbon Purple', color: '#a855f7' }
];

let generatedWires = [];
let correctWireIndex = 0;

function initBananaWires(diff) {
    const container = document.getElementById('mgWiresContainer');
    if (container) container.style.display = 'flex';

    const count = diff === 'hard' ? 6 : (diff === 'med' ? 5 : 4);
    generatedWires = [];

    for (let i = 0; i < count; i++) {
        const item = WIRE_PALETTE[Math.floor(Math.random() * WIRE_PALETTE.length)];
        generatedWires.push({
            id: i,
            key: item.key,
            name: item.name,
            color: item.color,
            cut: false
        });
    }

    evaluateBananaWireRules();
    renderWiresBoard();
}

function evaluateBananaWireRules() {
    const counts = { gold: 0, lime: 0, cyan: 0, ruby: 0, purple: 0 };
    generatedWires.forEach(w => counts[w.key]++);

    const ruleEl = document.getElementById('wiresRuleText');
    let directive = "";

    // BOMBANANA Rules Hierarchy
    if (counts.ruby === 0) {
        correctWireIndex = 1;
        directive = "RULE 1: IF ZERO HAZARD RUBY WIRES EXIST → SEVER THE 2ND WIRE.";
    } else if (counts.gold === 1 && counts.cyan >= 2) {
        correctWireIndex = generatedWires.findIndex(w => w.key === 'cyan');
        directive = "RULE 2: IF EXACTLY 1 BANANA GOLD & ≥2 CYAN PULSE → SEVER THE 1ST CYAN WIRE.";
    } else if (generatedWires[generatedWires.length - 1].key === 'lime') {
        correctWireIndex = generatedWires.length - 1;
        directive = "RULE 3: IF TERMINAL WIRE IS RADIOACTIVE LIME → SEVER THE LAST WIRE.";
    } else if (counts.purple >= 2) {
        let lastPurple = -1;
        generatedWires.forEach((w, i) => { if (w.key === 'purple') lastPurple = i; });
        correctWireIndex = lastPurple;
        directive = "RULE 4: IF MULTIPLE CARBON PURPLE PRESENT → SEVER THE LAST PURPLE WIRE.";
    } else if (counts.gold >= 1) {
        correctWireIndex = generatedWires.findIndex(w => w.key === 'gold');
        directive = "RULE 5: IF ANY BANANA GOLD REMAIN → SEVER THE FIRST GOLD WIRE.";
    } else {
        correctWireIndex = 0;
        directive = "RULE 6: DEFAULT PROTOCOL → SEVER THE 1ST ANCHOR WIRE.";
    }

    if (correctWireIndex < 0 || correctWireIndex >= generatedWires.length) {
        correctWireIndex = 0;
    }

    if (ruleEl) ruleEl.innerText = directive;
}

function renderWiresBoard() {
    const board = document.getElementById('wiresBoard');
    if (!board) return;
    board.innerHTML = '';

    generatedWires.forEach((wire, i) => {
        const row = document.createElement('div');
        row.className = 'wire-row';
        row.id = `wire-row-${i}`;
        row.onclick = () => snipWire(i);

        row.innerHTML = `
            <span class="wire-tag">W-0${i + 1}</span>
            <div class="wire-terminal"></div>
            <div class="wire-cable-wrap">
                <div class="wire-cable ${wire.cut ? 'cut' : ''}" style="color: ${wire.color}; background: ${wire.color};"></div>
            </div>
            <div class="wire-terminal"></div>
        `;
        board.appendChild(row);
    });
}

function snipWire(index) {
    const wire = generatedWires[index];
    if (!wire || wire.cut) return;

    wire.cut = true;
    playWireSnipSound();
    renderWiresBoard();

    if (index === correctWireIndex) {
        playDisarmSuccessSound();
        const ruleEl = document.getElementById('wiresRuleText');
        if (ruleEl) ruleEl.innerText = "CIRCUIT SAFELY BYPASSED! SECURING CHARGE...";
        setTimeout(() => closeMiniGame(true), 550);
    } else {
        const dead = deductCharge("WRONG WIRE SEVERED: CATASTROPHIC SHORT CIRCUIT");
        if (!dead) {
            const row = document.getElementById(`wire-row-${index}`);
            if (row) {
                row.style.opacity = '0.35';
            }
        }
    }
}

// =========================================================
// MINI-GAME 5: FREQUENCY OSCILLOSCOPE TUNER
// Modulate Frequency & Phase to reach ≥ 90% resonance lock
// =========================================================
let freqAnimFrame = null;
let freqTargetF = 3.5;
let freqTargetPhase = 120;
let freqPlayerF = 1.0;
let freqPlayerPhase = 0;
let freqOscTime = 0;
let freqLocked = false;

function initFrequencyTuner(diff) {
    const container = document.getElementById('mgFreqContainer');
    if (container) container.style.display = 'flex';

    const canvas = document.getElementById('freqCanvas');
    if (!canvas) return;

    if (diff === 'easy') {
        freqTargetF = 2.5;
        freqTargetPhase = 90;
    } else if (diff === 'med') {
        freqTargetF = 4.2;
        freqTargetPhase = 180;
    } else if (diff === 'hard') {
        freqTargetF = 6.4;
        freqTargetPhase = 270;
    }

    freqPlayerF = 1.0;
    freqPlayerPhase = 0;
    freqLocked = false;

    const fSlider = document.getElementById('freqSlider');
    const pSlider = document.getElementById('phaseSlider');
    if (fSlider) { fSlider.value = "1.0"; fSlider.disabled = false; }
    if (pSlider) { pSlider.value = "0"; pSlider.disabled = false; }

    updateFreqSlider();
    updatePhaseSlider();

    cancelAnimationFrame(freqAnimFrame);
    freqLoop();
}

function updateFreqSlider() {
    const slider = document.getElementById('freqSlider');
    const label = document.getElementById('freqValText');
    if (slider) freqPlayerF = parseFloat(slider.value);
    if (label) label.innerText = `${freqPlayerF.toFixed(1)}x`;
}

function updatePhaseSlider() {
    const slider = document.getElementById('phaseSlider');
    const label = document.getElementById('phaseValText');
    if (slider) freqPlayerPhase = parseInt(slider.value, 10);
    if (label) label.innerText = `${freqPlayerPhase}°`;
}

function freqLoop() {
    freqOscTime += 0.04;
    renderFreqOscilloscope();

    if (!freqLocked) {
        const fErr = Math.abs(freqPlayerF - freqTargetF) / 7.0;
        const pDiff = Math.abs(freqPlayerPhase - freqTargetPhase);
        const pErr = Math.min(pDiff, 360 - pDiff) / 180.0;

        let match = 1.0 - (fErr * 0.6 + pErr * 0.4);
        match = Math.max(0, Math.min(1, match));
        const matchPercent = Math.round(match * 100);

        const meter = document.getElementById('freqMeterFill');
        const text = document.getElementById('freqMatchPercent');
        if (meter) meter.style.width = `${matchPercent}%`;
        if (text) text.innerText = `${matchPercent}%`;

        if (matchPercent >= 92) {
            freqLocked = true;
            if (meter) meter.style.width = '100%';
            if (text) text.innerText = '100% [LOCKED]';
            playWaveResonanceSound();

            const fSlider = document.getElementById('freqSlider');
            const pSlider = document.getElementById('phaseSlider');
            if (fSlider) fSlider.disabled = true;
            if (pSlider) pSlider.disabled = true;

            setTimeout(() => {
                cancelAnimationFrame(freqAnimFrame);
                closeMiniGame(true);
            }, 650);
            return;
        }
    }

    freqAnimFrame = requestAnimationFrame(freqLoop);
}

function renderFreqOscilloscope() {
    const canvas = document.getElementById('freqCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;
    const mid = h / 2;

    ctx.fillStyle = '#020617';
    ctx.fillRect(0, 0, w, h);

    // Grid
    ctx.strokeStyle = 'rgba(56, 189, 248, 0.12)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, mid);
    ctx.lineTo(w, mid);
    ctx.stroke();

    for (let x = 0; x < w; x += 32) {
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, h);
        ctx.stroke();
    }

    // 1. Target Wave (Golden Yellow Dashed)
    ctx.strokeStyle = '#facc15';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 4]);
    ctx.shadowColor = '#facc15';
    ctx.shadowBlur = 6;
    ctx.beginPath();
    for (let x = 0; x < w; x++) {
        const rad = (x / w) * Math.PI * 2 * freqTargetF + (freqTargetPhase * Math.PI / 180) + freqOscTime;
        const y = mid + Math.sin(rad) * 45;
        if (x === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
    }
    ctx.stroke();
    ctx.setLineDash([]);

    // 2. Player Wave (Cyan Solid, turns green when locked)
    ctx.strokeStyle = freqLocked ? '#22c55e' : '#38bdf8';
    ctx.shadowColor = freqLocked ? '#22c55e' : '#38bdf8';
    ctx.shadowBlur = 10;
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    for (let x = 0; x < w; x++) {
        const rad = (x / w) * Math.PI * 2 * freqPlayerF + (freqPlayerPhase * Math.PI / 180) + freqOscTime;
        const y = mid + Math.sin(rad) * 45;
        if (x === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
    }
    ctx.stroke();
    ctx.shadowBlur = 0;
}

function cleanupFreqTuner() {
    cancelAnimationFrame(freqAnimFrame);
    freqLocked = false;
}

// =========================================================
// GAME OVER & SUCCESS ENDINGS
// =========================================================
function triggerExplosion(reason) {
    clearInterval(timerInterval);
    playExplosionSound();

    const gameScreen = document.getElementById('screen-game');
    if (gameScreen) gameScreen.classList.remove('active');
    document.body.classList.remove('panic-mode');

    const resBox = document.getElementById('resultBox');
    if (resBox) resBox.className = 'ending-box explosion';

    const tEl = document.getElementById('resultTitle');
    const sEl = document.getElementById('resultSub');
    if (tEl) tEl.innerText = "DETONATION";
    if (sEl) sEl.innerText = `CATASTROPHIC FAILURE: ${reason}`;

    const resScreen = document.getElementById('screen-result');
    if (resScreen) resScreen.classList.add('active');
}

function triggerSuccess() {
    clearInterval(timerInterval);
    playDisarmSuccessSound();

    const gameScreen = document.getElementById('screen-game');
    if (gameScreen) gameScreen.classList.remove('active');
    document.body.classList.remove('panic-mode');

    const resBox = document.getElementById('resultBox');

    const chargeBonus = remainingCharges * 50;
    const levelScore = (currentLevel * 100) + timeRemaining + chargeBonus;

    const existingHigh = parseInt(localStorage.getItem('hub_defuse_high') || '0', 10);
    if (levelScore > existingHigh) {
        localStorage.setItem('hub_defuse_high', levelScore);
    }

    const currentDisarms = parseInt(localStorage.getItem('hub_defuse_disarms') || '0', 10) + 1;
    localStorage.setItem('hub_defuse_disarms', currentDisarms);

    const currentMaxLvl = parseInt(localStorage.getItem('hub_defuse_level') || '0', 10);
    if (currentLevel > currentMaxLvl) {
        localStorage.setItem('hub_defuse_level', currentLevel);
    }

    fetch('../save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ game: 'bomb_defuse', score: levelScore })
    }).catch(() => console.log("Offline mode"));

    const tEl = document.getElementById('resultTitle');
    const sEl = document.getElementById('resultSub');

    if (currentLevel === 10) {
        if (resBox) resBox.className = 'ending-box secret-ending';
        if (tEl) tEl.innerText = "GHOST PROTOCOL UNLOCKED";
        if (sEl) sEl.innerHTML = `
            You defused the impossible chassis.<br><br>
            [ FINAL SCORE: ${levelScore} PTS ]<br>
            [ TIME REMAINING: ${timeRemaining}s ]<br>
            [ INTEGRITY CHARGES PRESERVED: ${remainingCharges}/3 ]<br>
            [ SYSTEM ARCHIVE ACCESS GRANTED ]<br>
            "The architect left a backdoor in Sector 7."
        `;
    } else {
        if (resBox) resBox.className = 'ending-box success';
        if (tEl) tEl.innerText = "CHASSIS DEFUSED";
        if (sEl) sEl.innerHTML = `
            THREAT NEUTRALIZED // SECTOR CLEAR<br><br>
            [ SCORE: ${levelScore} PTS ]<br>
            [ TIME BONUS: +${timeRemaining} PTS ]<br>
            [ CHARGE BONUS: +${chargeBonus} PTS ]
        `;
    }

    const resScreen = document.getElementById('screen-result');
    if (resScreen) resScreen.classList.add('active');
}

function abortToMenu() {
    clearInterval(timerInterval);
    cleanupSnakeGame();
    cleanupReactorGame();
    cleanupMazeGame();
    cleanupFreqTuner();

    document.body.classList.remove('panic-mode');
    document.getElementById('screen-game').classList.remove('active');
    document.getElementById('screen-result').classList.remove('active');
    document.getElementById('miniGameOverlay').style.display = 'none';
    document.getElementById('screen-menu').classList.add('active');
}

// Startup Screen Controls
function openLevelSelect() {
    document.getElementById('screen-startup').classList.remove('active');
    document.getElementById('defuseIntelModal').classList.remove('active');
    document.getElementById('screen-menu').classList.add('active');
}

function showStartupScreen() {
    document.getElementById('screen-menu').classList.remove('active');
    document.getElementById('defuseIntelModal').classList.remove('active');
    document.getElementById('screen-startup').classList.add('active');
    loadDefusalTelemetry();
}

function openDefuseIntel() {
    document.getElementById('defuseIntelModal').classList.add('active');
}

function closeDefuseIntel() {
    document.getElementById('defuseIntelModal').classList.remove('active');
}

function loadDefusalTelemetry() {
    const high = localStorage.getItem('hub_defuse_high') || '0';
    const disarms = localStorage.getItem('hub_defuse_disarms') || '0';
    const sScore = document.getElementById('splashDefuseScore');
    const sDisarms = document.getElementById('splashDefuseDisarms');
    if (sScore) sScore.innerText = high + ' pts';
    if (sDisarms) sDisarms.innerText = disarms;
}

// Initial Boot
window.addEventListener('DOMContentLoaded', () => {
    initMenu();
    loadDefusalTelemetry();
});

initMenu();
loadDefusalTelemetry();