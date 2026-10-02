// ==========================================================================
// RANS0M // 1-TO-1 PSYCHOLOGICAL VIRUS & DEFUSAL SIMULATION ENGINE
// Accurate Replica of GameMaker "RANS0M" by YellowAfterlife & Team
// ==========================================================================

const RANSOM_TITLES = [
    "WHATWOULDSHETHINK?",
    "IMG.JPG",
    "ENCRYPTION",
    "INCOMPETENT",
    "I FOUND YOU",
    "RANASOM",
    "KEY",
    "RNA0SM",
    "ERROR",
    "AJWBXV",
    "times up",
    "YOU ARE AN IDIOT",
    "RRAANNSSOOMM",
    "Untitled (1)",
    "Untitled (2)",
    "Untitled (3)",
    "MOSNAR",
    "RANSOM.exe",
    "_ _ _ _ _"
];

const POPUP_SPRITES = [
    "spr_encrypted_popup_1.png",
    "spr_encrypted_popup_2.png",
    "spr_encrypted_popup_3.png",
    "spr_encrypted_popup_4.png",
    "spr_encrypted_popup_5.png",
    "spr_encrypted_popup_6.png",
    "spr_encrypted_popup.png",
    "spr_default_ransom.png"
];

const VALID_KEYS = ["RANSOM", "MOSNAR", "KEY"];

// Game State
let gameState = "BOOT"; // BOOT, RANSOM, JUMPSCARE, VICTORY
let timerSeconds = 120; // 02:00
let timerInterval = null;
let popupInterval = null;
let shakeInterval = null;
let activePopups = [];
let popupCountTotal = 0;
let audioTheme = null;
let audioSpawn = null;
let audioJumpscare = null;
let audioGoodEnding = null;
let audioFirstJumpscare = null;
let soundEnabled = true;

// Sound Initialization
function initAudio() {
    audioTheme = new Audio('assets/audio/snd_theme.wav');
    audioTheme.loop = true;
    audioTheme.volume = 0.55;

    audioSpawn = new Audio('assets/audio/snd_spawn.wav');
    audioSpawn.volume = 0.6;

    audioJumpscare = new Audio('assets/audio/snd_jumpscare.wav');
    audioJumpscare.volume = 0.95;

    audioGoodEnding = new Audio('assets/audio/snd_good_ending.wav');
    audioGoodEnding.volume = 0.7;

    audioFirstJumpscare = new Audio('assets/audio/snd_first_jumpscare.wav');
    audioFirstJumpscare.volume = 0.8;
}

function playSound(snd) {
    if (!soundEnabled || !snd) return;
    try {
        snd.currentTime = 0;
        snd.play().catch(() => {});
    } catch (e) {}
}

// Fullscreen Animated Red Alert Glitch Matrix Canvas
class RansomBgGlitchEngine {
  constructor() {
    this.canvas = document.getElementById('ransomBgCanvas');
    if (!this.canvas) return;
    this.ctx = this.canvas.getContext('2d');
    this.columns = [];
    this.chars = '0123456789ABCDEF!#%&*+=-<>~💀☣️☠️ERROR_CORRUPT_NULL';
    this.glitchSpike = 0;
    this.init();
  }

  init() {
    this.resize();
    window.addEventListener('resize', () => this.resize());

    const colWidth = 24;
    const colCount = Math.floor(this.width / colWidth);
    this.columns = [];

    for (let i = 0; i < colCount; i++) {
      this.columns.push({
        x: i * colWidth,
        y: Math.random() * -this.height,
        speed: 1.5 + Math.random() * 2.8,
        length: 10 + Math.floor(Math.random() * 14),
        data: []
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

  triggerGlitch() {
    this.glitchSpike = 1.0;
  }

  animate() {
    if (!this.ctx) return;
    this.ctx.fillStyle = '#000000';
    this.ctx.fillRect(0, 0, this.width, this.height);

    if (this.glitchSpike > 0) {
      this.glitchSpike = Math.max(0, this.glitchSpike - 0.03);
    }

    // Perspective / Cyber Threat Grid
    this.ctx.strokeStyle = `rgba(244, 63, 94, ${0.03 + this.glitchSpike * 0.1})`;
    this.ctx.lineWidth = 1;
    const gridStep = 44;
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

    // Red Glitch Matrix Rain
    this.ctx.font = '11px "Share Tech Mono", monospace';
    this.columns.forEach((col) => {
      col.y += col.speed * (1 + this.glitchSpike * 1.5);
      if (col.y - col.length * 16 > this.height) {
        col.y = Math.random() * -100;
        col.speed = 1.5 + Math.random() * 2.8;
      }

      for (let j = 0; j < col.length; j++) {
        const charY = col.y - j * 16;
        if (charY < 0 || charY > this.height) continue;

        const isHead = j === 0;
        const alpha = Math.max(0, 1 - j / col.length) * 0.35;

        if (isHead) {
          this.ctx.fillStyle = '#ffffff';
          this.ctx.shadowColor = '#f43f5e';
          this.ctx.shadowBlur = 10;
        } else {
          this.ctx.fillStyle = `rgba(244, 63, 94, ${alpha})`;
          this.ctx.shadowBlur = 0;
        }

        const ch = Math.random() < 0.08 ? this.chars[Math.floor(Math.random() * this.chars.length)] : (col.data[j] || '0');
        col.data[j] = ch;
        this.ctx.fillText(ch, col.x, charY);
      }
      this.ctx.shadowBlur = 0;
    });

    requestAnimationFrame(this.animate);
  }
}

let ransomBgEngine = null;

// Window Onload
window.addEventListener('DOMContentLoaded', () => {
    ransomBgEngine = new RansomBgGlitchEngine();
    initAudio();
    startDownloadPhase();

    // Key input listener
    const keyInput = document.getElementById('keyInput');
    if (keyInput) {
        keyInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                submitKey();
            }
        });
    }

    // Dragging setup for windows
    makeDraggable(document.getElementById('downloadWindow'));
    makeDraggable(document.getElementById('ransomWindow'));
});

// Phase 1: Trojan Download
function startDownloadPhase() {
    gameState = "BOOT";
    const fill = document.getElementById('downloadProgressFill');
    const pct = document.getElementById('downloadPercent');
    const title = document.getElementById('downloadTitle');
    
    let progress = 0;
    const dots = [".", "..", "..."];
    let dotIdx = 0;

    const dotTimer = setInterval(() => {
        if (gameState !== "BOOT") {
            clearInterval(dotTimer);
            return;
        }
        title.innerText = "DOWNLOADING" + dots[dotIdx % dots.length];
        dotIdx++;
    }, 450);

    const progTimer = setInterval(() => {
        progress += Math.floor(Math.random() * 4) + 1;
        if (progress > 100) progress = 100;

        fill.style.width = progress + '%';
        pct.innerText = progress + '%';

        if (progress >= 100) {
            clearInterval(progTimer);
            clearInterval(dotTimer);
            setTimeout(triggerInfection, 500);
        }
    }, 80);
}

// Phase 2: Infection Takeover
function triggerInfection() {
    const flash = document.getElementById('flashOverlay');
    const dlWin = document.getElementById('downloadWindow');
    const rWin = document.getElementById('ransomWindow');

    // White flash
    flash.style.display = 'block';
    playSound(audioFirstJumpscare);

    setTimeout(() => {
        flash.style.display = 'none';
        dlWin.style.display = 'none';
        rWin.style.display = 'flex';
        
        // Start atmospheric drone
        if (audioTheme) {
            audioTheme.play().catch(() => {});
        }

        // Switch State
        startRansomPhase();
    }, 280);
}

// Phase 2: Ransomware Countdown & Hijack
function startRansomPhase() {
    gameState = "RANSOM";
    timerSeconds = 120;
    updateTimerDisplay();

    // Timer countdown
    timerInterval = setInterval(() => {
        timerSeconds--;
        updateTimerDisplay();

        if (timerSeconds <= 0) {
            triggerJumpscare("TIMEOUT: TIME EXPIRED - DATA PURGED");
        } else if (timerSeconds === 30) {
            // Intense warning shake
            triggerGlitchShake(1200);
        }
    }, 1000);

    // Initial first 2 popups
    setTimeout(spawnRandomPopup, 1200);
    setTimeout(spawnRandomPopup, 2400);

    // Recurring popup swarm every 4.5 seconds
    popupInterval = setInterval(() => {
        if (gameState === "RANSOM") {
            spawnRandomPopup();
            // Random chance to jitter the main window
            if (Math.random() < 0.4) {
                jitterMainWindow();
            }
        }
    }, 4200);

    // Periodic screenshake
    shakeInterval = setInterval(() => {
        if (gameState === "RANSOM" && Math.random() < 0.35) {
            triggerGlitchShake(600);
        }
    }, 5000);
}

function updateTimerDisplay() {
    const el = document.getElementById('timerDigits');
    if (!el) return;
    const mins = Math.floor(timerSeconds / 60);
    const secs = timerSeconds % 60;
    const mStr = String(mins).padStart(2, '0');
    const sStr = String(secs).padStart(2, '0');
    el.innerText = `${mStr}:${sStr}`;
}

// Multi-Window Popup Swarm (obj_encrypted_popup)
function spawnRandomPopup() {
    if (gameState !== "RANSOM") return;

    playSound(audioSpawn);

    const desktop = document.getElementById('desktop');
    const popup = document.createElement('div');
    popup.className = 'os-window popup-window';

    const pId = 'popup_' + Date.now() + '_' + Math.floor(Math.random() * 1000);
    popup.id = pId;

    // Pick random sprite & title
    const sprite = POPUP_SPRITES[Math.floor(Math.random() * POPUP_SPRITES.length)];
    let title = RANSOM_TITLES[Math.floor(Math.random() * RANSOM_TITLES.length)];

    // Every 5th popup has a chance to carry the secret clue MOSNAR or KEY
    popupCountTotal++;
    if (popupCountTotal % 5 === 0 && Math.random() < 0.7) {
        title = Math.random() < 0.5 ? "MOSNAR" : "KEY";
    }

    // Dimensions based on sprite
    let w = 320;
    let h = 180;
    if (sprite.includes('popup_1')) { w = 371; h = 137; }
    else if (sprite.includes('popup_2')) { w = 235; h = 196; }
    else if (sprite.includes('popup_3')) { w = 337; h = 221; }
    else if (sprite.includes('popup_4')) { w = 228; h = 184; }
    else if (sprite.includes('popup_5')) { w = 424; h = 131; }
    else if (sprite.includes('popup_6')) { w = 279; h = 153; }
    else if (sprite.includes('default_ransom')) { w = 318; h = 327; }

    // Random desktop coordinates (stay in bounds)
    const maxX = Math.max(10, window.innerWidth - w - 20);
    const maxY = Math.max(50, window.innerHeight - h - 30);
    const rx = Math.floor(Math.random() * maxX);
    const ry = Math.floor(Math.random() * maxY) + 40;

    popup.style.width = w + 'px';
    popup.style.height = h + 'px';
    popup.style.left = rx + 'px';
    popup.style.top = ry + 'px';

    popup.innerHTML = `
        <div class="win-titlebar">
            <span>${title}</span>
            <div class="win-buttons">
                <button class="win-btn close" onclick="handlePopupClose('${pId}', '${title}')">✕</button>
            </div>
        </div>
        <img class="popup-img" src="assets/sprites/${sprite}" alt="${title}" onclick="handlePopupClick('${title}')" />
    `;

    desktop.appendChild(popup);
    makeDraggable(popup);
    activePopups.push(pId);

    // Limit maximum onscreen popups to 12
    if (activePopups.length > 12) {
        const oldestId = activePopups.shift();
        const oldEl = document.getElementById(oldestId);
        if (oldEl) oldEl.remove();
    }
}

// Popup Close Logic
function handlePopupClose(popupId, title) {
    const el = document.getElementById(popupId);
    if (!el) return;

    // 50% chance the malicious popup resists and duplicates or shakes!
    if (Math.random() < 0.45 && activePopups.length < 10) {
        triggerGlitchShake(400);
        playSound(audioSpawn);
        setTimeout(spawnRandomPopup, 200);
    } else {
        el.remove();
        activePopups = activePopups.filter(id => id !== popupId);
    }
}

// Popup Click - Clue Detection
function handlePopupClick(title) {
    if (title === "MOSNAR" || title === "KEY" || title === "RANSOM") {
        const input = document.getElementById('keyInput');
        if (input) {
            input.value = title === "MOSNAR" ? "MOSNAR" : "RANSOM";
            input.focus();
            const label = document.getElementById('decryptHint');
            if (label) label.innerText = `[CLUE CAPTURED: ${input.value} - PRESS DECRYPT NOW]`;
        }
    }
}

// Window Jitter / Screen Shake (scr_shake_window)
function jitterMainWindow() {
    const rWin = document.getElementById('ransomWindow');
    if (!rWin) return;
    const curX = parseInt(rWin.style.left || (window.innerWidth / 2 - 265));
    const curY = parseInt(rWin.style.top || (window.innerHeight / 2 - 185));
    const ox = (Math.random() - 0.5) * 30;
    const oy = (Math.random() - 0.5) * 30;
    rWin.style.left = Math.max(10, Math.min(window.innerWidth - 540, curX + ox)) + 'px';
    rWin.style.top = Math.max(50, Math.min(window.innerHeight - 380, curY + oy)) + 'px';
}

function triggerGlitchShake(durationMs) {
    const desktop = document.getElementById('desktop');
    if (!desktop) return;
    desktop.classList.add('shake-active');
    setTimeout(() => {
        desktop.classList.remove('shake-active');
    }, durationMs);
}

// Decryption Key Submission
function submitKey() {
    if (gameState !== "RANSOM") return;
    const input = document.getElementById('keyInput');
    if (!input) return;

    const val = input.value.trim().toUpperCase();
    if (VALID_KEYS.includes(val)) {
        triggerGoodEnding();
    } else {
        // Wrong key penalty
        playSound(audioSpawn);
        timerSeconds = Math.max(5, timerSeconds - 15);
        updateTimerDisplay();
        triggerGlitchShake(800);
        const hint = document.getElementById('decryptHint');
        if (hint) {
            hint.innerHTML = `<span style="color:#ef4444;">INVALID DECRYPTION HASH! -15s PENALTY</span>`;
        }
        input.value = "";
        jitterMainWindow();
        spawnRandomPopup();
    }
}

// Phase 4: Jumpscare / Loss Screen (rm_jumpscare)
function triggerJumpscare(reason) {
    gameState = "JUMPSCARE";
    clearInterval(timerInterval);
    clearInterval(popupInterval);
    clearInterval(shakeInterval);

    if (audioTheme) audioTheme.pause();
    playSound(audioJumpscare);

    const jumpscareEl = document.getElementById('jumpscareScreen');
    if (jumpscareEl) {
        jumpscareEl.style.display = 'flex';
    }

    // Auto show recovery after 4 seconds of jumpscare
    setTimeout(() => {
        jumpscareEl.style.display = 'none';
        showGameOver(reason);
    }, 3800);
}

function showGameOver(reason) {
    const desktop = document.getElementById('desktop');
    // Clear all popups
    activePopups.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.remove();
    });
    activePopups = [];

    const rWin = document.getElementById('ransomWindow');
    if (rWin) {
        rWin.innerHTML = `
            <div class="win-titlebar">
                <span>SYSTEM CRASH // FATAL ERROR</span>
            </div>
            <div class="ransom-body" style="padding: 30px; text-align: center;">
                <img src="assets/sprites/spr_stop_sign.png" style="width: 80px; height: 80px;" />
                <h2 style="color: #ef4444; font-family: 'Orbitron'; margin-top: 10px;">CONTAINMENT FAILED</h2>
                <p style="color: #94a3b8; font-size: 13px; margin: 10px 0 20px;">${reason || 'The ransomware executed all payloads.'}</p>
                <div class="action-btn-row">
                    <button class="btn-primary" onclick="restartGame()">RETRY CONTAINMENT</button>
                    <button class="btn-secondary" onclick="exitToHub()">RETURN TO HUB</button>
                </div>
            </div>
        `;
        rWin.style.left = 'calc(50% - 265px)';
        rWin.style.top = 'calc(50% - 185px)';
        rWin.style.display = 'flex';
    }
}

// Phase 5: Good Ending / Win Screen
function triggerGoodEnding() {
    gameState = "VICTORY";
    clearInterval(timerInterval);
    clearInterval(popupInterval);
    clearInterval(shakeInterval);

    if (audioTheme) audioTheme.pause();
    playSound(audioGoodEnding);

    // Remove all popup windows
    activePopups.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.remove();
    });
    activePopups = [];

    const goodScreen = document.getElementById('goodEndingScreen');
    const statsEl = document.getElementById('goodEndingStats');
    if (statsEl) {
        const timeTaken = 120 - timerSeconds;
        statsEl.innerHTML = `
            DECRYPTION CIPHER VERIFIED: <span>SUCCESS</span><br>
            TIME ELAPSED: <span>${timeTaken}s</span> (REMAINING: <span>${timerSeconds}s</span>)<br>
            VIRUS PAYLOADS PURGED: <span>${popupCountTotal} POPUPS</span><br>
            THREAT NEUTRALIZED!
        `;
    }
    if (goodScreen) {
        goodScreen.style.display = 'flex';
    }

    // Save score if player is logged in
    saveScoreToDatabase(120 - timerSeconds);
}

// Save Score to Game Hub Database
function saveScoreToDatabase(timeTaken) {
    const scoreVal = Math.max(10, (120 - timeTaken) * 50);
    fetch('../save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `game=Ransom&score=${scoreVal}`
    }).catch(() => {});
}

// Restart
function restartGame() {
    location.reload();
}

// Exit to Hub
function exitToHub() {
    window.location.href = '../index.jsp';
}

// Toggle Audio
function toggleSound() {
    soundEnabled = !soundEnabled;
    const btn = document.getElementById('soundToggleBtn');
    if (btn) {
        btn.innerText = soundEnabled ? '🔊 SOUND: ON' : '🔇 SOUND: OFF';
    }
    if (!soundEnabled && audioTheme) {
        audioTheme.pause();
    } else if (soundEnabled && audioTheme && gameState === "RANSOM") {
        audioTheme.play().catch(() => {});
    }
}

// Draggable Window Utility
function makeDraggable(el) {
    if (!el) return;
    const header = el.querySelector('.win-titlebar') || el;
    let isDragging = false;
    let startX = 0, startY = 0, initialLeft = 0, initialTop = 0;

    header.onmousedown = (e) => {
        if (e.target.classList.contains('win-btn')) return;
        isDragging = true;
        startX = e.clientX;
        startY = e.clientY;
        initialLeft = el.offsetLeft;
        initialTop = el.offsetTop;

        // Bring to front
        document.querySelectorAll('.os-window').forEach(w => w.style.zIndex = '150');
        el.style.zIndex = '300';

        document.onmousemove = (e2) => {
            if (!isDragging) return;
            const dx = e2.clientX - startX;
            const dy = e2.clientY - startY;
            el.style.left = (initialLeft + dx) + 'px';
            el.style.top = (initialTop + dy) + 'px';
        };

        document.onmouseup = () => {
            isDragging = false;
            document.onmousemove = null;
            document.onmouseup = null;
        };
    };
}
