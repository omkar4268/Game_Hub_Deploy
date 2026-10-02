/* =========================================================
   CIPHER GUESSER // CRYPTOGRAPHIC MATRIX ENGINE v3.0
   ========================================================= */

/* =========================================================
   FULLSCREEN ANIMATED CRYPTOGRAPHIC MATRIX & DIALS CANVAS
   ========================================================= */
class CipherMatrixEngine {
  constructor() {
    this.canvas = document.getElementById('cipherBgCanvas');
    if (!this.canvas) return;
    this.ctx = this.canvas.getContext('2d');
    this.columns = [];
    this.glyphs = '0123456789ABCDEF!#%&*+=-<>~Ø§‡ΔΨΩ';
    this.tags = ['0x8F', '0x2A', '0xEE', '0x42', '0x99', '0xC1', '[SHA-256]', '[KEY-GEN]', '[AES-GCM]', '[PROBE]', '[CIPHER]'];
    this.dialAngle = 0;
    this.isWon = window.cipherGameWon || false;
    this.init();
  }

  init() {
    this.resize();
    window.addEventListener('resize', () => this.resize());

    const colWidth = 26;
    const colCount = Math.floor(this.width / colWidth);
    this.columns = [];

    for (let i = 0; i < colCount; i++) {
      this.columns.push({
        x: i * colWidth,
        y: Math.random() * -this.height,
        speed: 1.2 + Math.random() * 2.2,
        length: 8 + Math.floor(Math.random() * 12),
        chars: []
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

  animate() {
    if (!this.ctx) return;
    this.ctx.fillStyle = '#000000';
    this.ctx.fillRect(0, 0, this.width, this.height);

    const cx = this.width / 2;
    const cy = this.height / 2;
    const primaryColor = this.isWon ? '34, 197, 94' : '56, 189, 248';

    // 1. Perspective Background Radar / Dial Grids
    this.dialAngle += 0.005;
    const maxR = Math.min(this.width, this.height) * 0.42;

    this.ctx.save();
    this.ctx.translate(cx, cy);

    // Rotating Dials
    [0.35, 0.65, 0.95].forEach((ratio, idx) => {
      const r = maxR * ratio;
      const dir = idx % 2 === 0 ? 1 : -1;
      this.ctx.save();
      this.ctx.rotate(this.dialAngle * dir * (0.8 + idx * 0.3));
      this.ctx.strokeStyle = `rgba(${primaryColor}, ${0.12 + idx * 0.05})`;
      this.ctx.lineWidth = 1.2;
      this.ctx.setLineDash([8, 12, 4, 12]);
      this.ctx.beginPath();
      this.ctx.arc(0, 0, r, 0, Math.PI * 2);
      this.ctx.stroke();

      // Tick markers
      const ticks = 16;
      for (let t = 0; t < ticks; t++) {
        const theta = (t * Math.PI * 2) / ticks;
        const tx1 = Math.cos(theta) * (r - 4);
        const ty1 = Math.sin(theta) * (r - 4);
        const tx2 = Math.cos(theta) * (r + 4);
        const ty2 = Math.sin(theta) * (r + 4);
        this.ctx.beginPath();
        this.ctx.moveTo(tx1, ty1);
        this.ctx.lineTo(tx2, ty2);
        this.ctx.stroke();
      }
      this.ctx.restore();
    });

    this.ctx.restore();

    // 2. Cryptographic Matrix Streams
    this.ctx.font = '10px "Courier New", monospace';
    this.columns.forEach((col) => {
      col.y += col.speed;
      if (col.y - col.length * 16 > this.height) {
        col.y = Math.random() * -120;
        col.speed = 1.2 + Math.random() * 2.2;
      }

      for (let j = 0; j < col.length; j++) {
        const charY = col.y - j * 16;
        if (charY < 0 || charY > this.height) continue;

        const isHead = j === 0;
        const alpha = Math.max(0, 1 - j / col.length) * 0.28;

        if (isHead) {
          this.ctx.fillStyle = '#ffffff';
          this.ctx.shadowColor = `rgba(${primaryColor}, 0.8)`;
          this.ctx.shadowBlur = 8;
        } else {
          this.ctx.fillStyle = `rgba(${primaryColor}, ${alpha})`;
          this.ctx.shadowBlur = 0;
        }

        const char = Math.random() < 0.05 ? this.glyphs[Math.floor(Math.random() * this.glyphs.length)] : (col.chars[j] || this.glyphs[0]);
        col.chars[j] = char;
        this.ctx.fillText(char, col.x, charY);
      }
      this.ctx.shadowBlur = 0;
    });

    requestAnimationFrame(this.animate);
  }
}

/* =========================================================
   MODAL CONTROLS & PROTOCOLS
   ========================================================= */
function openRules() {
  const modal = document.getElementById('rulesModal');
  if (!modal) return;
  modal.classList.add('active');
  const box = modal.querySelector('.rules-box');
  if (box && window.Motion) {
    window.Motion.animate(box, { opacity: [0, 1], scale: [0.92, 1], y: [20, 0] }, { duration: 0.3, ease: [0.16, 1, 0.3, 1] });
  }
}

function closeRules() {
  const modal = document.getElementById('rulesModal');
  if (!modal) return;
  const box = modal.querySelector('.rules-box');
  if (box && window.Motion) {
    window.Motion.animate(box, { opacity: [1, 0], scale: [1, 0.94], y: [0, 15] }, { duration: 0.2 }).then(() => {
      modal.classList.remove('active');
    });
  } else {
    modal.classList.remove('active');
  }
}

function dismissGuesserStartup() {
  const startup = document.getElementById('guesserStartup');
  if (!startup) return;

  if (window.Motion) {
    window.Motion.animate(startup, { opacity: [1, 0], scale: [1, 0.94] }, { duration: 0.25 }).then(() => {
      startup.classList.add('dismissed');
      startup.style.display = 'none';
      const input = document.getElementById('guessInput');
      if (input) input.focus();
    });
  } else {
    startup.classList.add('dismissed');
    startup.style.display = 'none';
    const input = document.getElementById('guessInput');
    if (input) input.focus();
  }

  if (window.RansomHorror) {
    RansomHorror.init('number_guess', {
      onGameOver: () => triggerGuesserLoss()
    });
  }
}

function triggerGuesserLoss() {
  const input = document.getElementById('guessInput');
  if (input) input.disabled = true;
  const submitBtn = document.querySelector('.btn-cyber-primary');
  if (submitBtn) {
    submitBtn.innerHTML = '<span>CIRCUIT LOCKED // RESTART REQUIRED</span>';
    submitBtn.style.background = 'var(--danger)';
    submitBtn.style.color = '#ffffff';
  }
}

/* =========================================================
   TELEMETRY & CLOUD PERSISTENCE
   ========================================================= */
window.addEventListener('DOMContentLoaded', () => {
  new CipherMatrixEngine();

  const bestAttemptsVal = document.getElementById('bestAttemptsVal');
  const splashGuessBest = document.getElementById('splashGuessBest');
  let savedBest = parseInt(localStorage.getItem('hub_guess_best') || '0', 10);
  if (savedBest > 0) {
    if (bestAttemptsVal) bestAttemptsVal.innerText = savedBest + ' probes';
    if (splashGuessBest) splashGuessBest.innerText = savedBest + ' probes';
  }

  if (window.cipherGameWon) {
    const currentTries = window.cipherFinalAttempts || 1;
    if (savedBest === 0 || currentTries < savedBest) {
      localStorage.setItem('hub_guess_best', currentTries);
      if (bestAttemptsVal) bestAttemptsVal.innerText = currentTries + ' probes';
    }

    const calcScore = Math.max(50, (20 - currentTries) * 50);
    fetch('../save_score.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ game: 'number_guess', score: calcScore })
    }).catch(() => console.log('Offline score preserved.'));
  }

  const startup = document.getElementById('guesserStartup');
  if (startup && startup.classList.contains('dismissed')) {
    if (window.RansomHorror) {
      RansomHorror.init('number_guess', { onGameOver: () => triggerGuesserLoss() });
    }
  } else if (startup && !startup.classList.contains('dismissed')) {
    if (window.Motion) {
      window.Motion.animate(startup, { opacity: [0, 1], scale: [0.96, 1] }, { duration: 0.35, ease: [0.16, 1, 0.3, 1] });
    }
  }
});

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