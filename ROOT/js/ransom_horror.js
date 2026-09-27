// =========================================================
// RANS0M HORROR PROTOCOL // ATMOSPHERIC CHALLENGE ENGINE
// Universal Cyber-Horror Injection for Game Hub
// =========================================================

(function(window) {
  'use strict';

  const RansomHorror = {
    enabled: false,
    gameType: 'generic',
    options: {},
    assetBase: '',
    
    // State flags
    state: 'idle', // 'idle' | 'lurking' | 'crisis' | 'jumpscare'
    lurkTimer: null,
    evasionTimeout: null,
    crisisInterval: null,
    noiseInterval: null,
    
    crisisTimeRemaining: 12.0,
    coinsNeeded: 3,
    coinsCollected: 0,
    chessMovesRemaining: 3,
    guesserProbesRemaining: 2,
    
    // Audio elements
    sounds: {},

    // DOM references
    lurkerEl: null,
    crisisHudEl: null,
    vignetteEl: null,
    jumpscareEl: null,
    activeCoins: [],

    init: function(gameType, options = {}) {
      this.reset();
      this.gameType = gameType || 'generic';
      this.options = options;
      this.enabled = localStorage.getItem('ransom_horror_mode') === 'true';

      if (!this.enabled) {
        return;
      }

      // Determine asset base path relative to current page location
      const path = window.location.pathname;
      const isSubDir = path.includes('/Reactor_Meltdown') || path.includes('/Bomb_Defuse') || path.includes('/Ransom');
      this.assetBase = isSubDir ? '../Ransom/assets/' : 'Ransom/assets/';

      this.preloadAudio();
      this.createVignette();
      this.scheduleLurk(36000, 44000); // Attacks at random interval every ~40 seconds
    },

    reset: function() {
      clearTimeout(this.lurkTimer);
      clearTimeout(this.evasionTimeout);
      clearInterval(this.crisisInterval);
      clearInterval(this.noiseInterval);

      if (this.lurkerEl && this.lurkerEl.parentNode) {
        this.lurkerEl.parentNode.removeChild(this.lurkerEl);
      }
      this.lurkerEl = null;

      if (this.crisisHudEl && this.crisisHudEl.parentNode) {
        this.crisisHudEl.parentNode.removeChild(this.crisisHudEl);
      }
      this.crisisHudEl = null;

      if (this.jumpscareEl && this.jumpscareEl.parentNode) {
        this.jumpscareEl.parentNode.removeChild(this.jumpscareEl);
      }
      this.jumpscareEl = null;

      if (this.vignetteEl) {
        this.vignetteEl.classList.remove('active');
      }

      this.clearCoins();
      this.state = 'idle';
      this.coinsCollected = 0;
      this.chessMovesRemaining = 3;
      this.guesserProbesRemaining = 2;
    },

    preloadAudio: function() {
      const audioFiles = {
        spawn: 'snd_spawn.wav',
        attack: 'snd_first_jumpscare.wav',
        jumpscare: 'snd_jumpscare.wav',
        purged: 'snd_good_ending.wav'
      };

      for (let key in audioFiles) {
        const audio = new Audio(this.assetBase + 'audio/' + audioFiles[key]);
        audio.preload = 'auto';
        this.sounds[key] = audio;
      }
    },

    playSound: function(key, volume = 0.8) {
      try {
        const audio = this.sounds[key];
        if (audio) {
          audio.currentTime = 0;
          audio.volume = volume;
          const playPromise = audio.play();
          if (playPromise !== undefined) {
            playPromise.catch(() => {
              this.fallbackSynth(key);
            });
          }
        } else {
          this.fallbackSynth(key);
        }
      } catch (e) {
        this.fallbackSynth(key);
      }
    },

    fallbackSynth: function(key) {
      try {
        const AudioCtx = window.AudioContext || window.webkitAudioContext;
        if (!AudioCtx) return;
        const ctx = new AudioCtx();
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);

        if (key === 'spawn') {
          osc.type = 'sawtooth';
          osc.frequency.setValueAtTime(140, ctx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(70, ctx.currentTime + 0.6);
          gain.gain.setValueAtTime(0.12, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 0.6);
          osc.start();
          osc.stop(ctx.currentTime + 0.6);
        } else if (key === 'attack') {
          osc.type = 'square';
          osc.frequency.setValueAtTime(220, ctx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.4);
          gain.gain.setValueAtTime(0.3, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 0.4);
          osc.start();
          osc.stop(ctx.currentTime + 0.4);
        } else if (key === 'jumpscare') {
          osc.type = 'sawtooth';
          osc.frequency.setValueAtTime(800, ctx.currentTime);
          osc.frequency.linearRampToValueAtTime(200, ctx.currentTime + 1.5);
          gain.gain.setValueAtTime(0.5, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 1.5);
          osc.start();
          osc.stop(ctx.currentTime + 1.5);
        } else if (key === 'purged') {
          osc.type = 'sine';
          osc.frequency.setValueAtTime(440, ctx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.5);
          gain.gain.setValueAtTime(0.25, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 0.5);
          osc.start();
          osc.stop(ctx.currentTime + 0.5);
        }
      } catch (e) {}
    },

    createVignette: function() {
      if (!this.vignetteEl) {
        this.vignetteEl = document.createElement('div');
        this.vignetteEl.className = 'rh-vignette-overlay';
        document.body.appendChild(this.vignetteEl);
      }
    },

    scheduleLurk: function(minMs = 36000, maxMs = 44000) {
      if (!this.enabled || this.state !== 'idle') return;
      clearTimeout(this.lurkTimer);
      const delay = Math.floor(Math.random() * (maxMs - minMs + 1)) + minMs;
      this.lurkTimer = setTimeout(() => {
        this.spawnLurker();
      }, delay);
    },

    // -------------------------------------------------------------
    // PHASE 1: LURKING ANOMALY (USER MUST NOT INTERACT!)
    // -------------------------------------------------------------
    spawnLurker: function() {
      if (!this.enabled || this.state !== 'idle') return;
      this.state = 'lurking';

      // Play eerie anomaly arrival sound
      this.playSound('spawn', 0.6);

      // Create lurker element
      const lurker = document.createElement('div');
      lurker.className = 'rh-lurker';

      // Position lurker somewhere interesting on screen (avoid extreme edges)
      const vpWidth = window.innerWidth;
      const vpHeight = window.innerHeight;
      const posX = Math.floor(Math.random() * (vpWidth - 260)) + 60;
      const posY = Math.floor(Math.random() * (vpHeight - 260)) + 60;

      lurker.style.left = posX + 'px';
      lurker.style.top = posY + 'px';

      lurker.innerHTML = `
        <div class="rh-lurker-badge">⚠️ MALWARE ANOMALY // DO NOT TOUCH!</div>
        <div class="rh-lurker-window">
          <div class="rh-lurker-header">
            <span>RANS0M.EXE</span>
            <span>☣</span>
          </div>
          <div class="rh-lurker-body">
            <img src="${this.assetBase}sprites/spr_default_ransom.png" class="rh-lurker-sprite" alt="Hostile Entity" />
          </div>
        </div>
      `;

      // Crucial mechanic: touching or clicking the lurker triggers immediate attack!
      const onTouchOrClick = (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.triggerAttack('INTERACTION DETECTED // HOSTILE PROVOCATION!');
      };

      lurker.addEventListener('click', onTouchOrClick);
      lurker.addEventListener('touchstart', onTouchOrClick, { passive: false });

      document.body.appendChild(lurker);
      this.lurkerEl = lurker;

      // Safe Evasion Timer: If untouched for 7 seconds, it quietly fades away!
      clearTimeout(this.evasionTimeout);
      this.evasionTimeout = setTimeout(() => {
        if (this.state === 'lurking') {
          this.evadeLurker();
        }
      }, 7000);
    },

    evadeLurker: function() {
      if (this.lurkerEl) {
        this.lurkerEl.style.opacity = '0';
        this.lurkerEl.style.transform = 'scale(0.7) translateY(-20px)';
        setTimeout(() => {
          if (this.lurkerEl && this.lurkerEl.parentNode) {
            this.lurkerEl.parentNode.removeChild(this.lurkerEl);
          }
          this.lurkerEl = null;
        }, 500);
      }
      this.state = 'idle';
      this.scheduleLurk(36000, 44000); // Reschedule for next ~40s cycle
    },

    // -------------------------------------------------------------
    // PHASE 2: CRISIS & ATTACK PHASE
    // -------------------------------------------------------------
    triggerAttack: function(reason) {
      if (this.state === 'crisis' || this.state === 'jumpscare') return;
      this.state = 'crisis';

      clearTimeout(this.evasionTimeout);
      if (this.lurkerEl) {
        if (this.lurkerEl.parentNode) this.lurkerEl.parentNode.removeChild(this.lurkerEl);
        this.lurkerEl = null;
      }

      // Attack sting sound & red screen border
      this.playSound('attack', 0.95);
      if (this.vignetteEl) this.vignetteEl.classList.add('active');

      this.crisisTimeRemaining = 12.0;
      this.renderCrisisHud();

      // Launch game-specific purge tasks
      if (this.gameType === 'chess') {
        this.initChessCrisis();
      } else if (this.gameType === 'number_guess') {
        this.initGuesserCrisis();
      } else {
        // Snake, Maze, Reactor Meltdown, Bomb Defuse
        this.initActionCrisis();
      }

      // Start Countdown Timer
      clearInterval(this.crisisInterval);
      this.crisisInterval = setInterval(() => {
        this.crisisTimeRemaining -= 0.1;
        if (this.crisisTimeRemaining <= 0) {
          this.crisisTimeRemaining = 0;
          this.updateCrisisTimerUI();
          clearInterval(this.crisisInterval);
          this.triggerJumpscare('TIME EXPIRED // FIREWALL BREACHED');
        } else {
          this.updateCrisisTimerUI();
        }
      }, 100);
    },

    renderCrisisHud: function() {
      if (this.crisisHudEl && this.crisisHudEl.parentNode) {
        this.crisisHudEl.parentNode.removeChild(this.crisisHudEl);
      }

      const hud = document.createElement('div');
      hud.className = 'rh-crisis-hud';

      let taskPrompt = 'COLLECT 3 PURGE DATA NODES BEFORE CRASH!';
      if (this.gameType === 'chess') {
        taskPrompt = 'TACTICAL PURGE: CAPTURE AN OPPONENT PIECE IN 3 MOVES!';
      } else if (this.gameType === 'number_guess') {
        taskPrompt = 'CIPHER OVERRIDE: SUBMIT CLOSER PROBE OR TAP 3 BYPASS NODES!';
      }

      hud.innerHTML = `
        <div class="rh-crisis-title">
          <span>☣ RANS0M SYSTEM COMPROMISE</span>
        </div>
        <div class="rh-crisis-sub" id="rhTaskDesc">${taskPrompt}</div>
        <div class="rh-timer-track">
          <div class="rh-timer-fill" id="rhTimerFill" style="width: 100%;"></div>
        </div>
      `;

      document.body.appendChild(hud);
      this.crisisHudEl = hud;
    },

    updateCrisisTimerUI: function() {
      const fill = document.getElementById('rhTimerFill');
      if (fill) {
        const pct = Math.max(0, Math.min(100, (this.crisisTimeRemaining / 12.0) * 100));
        fill.style.width = pct + '%';
      }
    },

    // --- Action Games: Purge Coins Spawner ---
    initActionCrisis: function() {
      this.coinsNeeded = 3;
      this.coinsCollected = 0;
      this.spawnPurgeCoins();
    },

    spawnPurgeCoins: function() {
      this.clearCoins();
      const vpW = window.innerWidth;
      const vpH = window.innerHeight;

      for (let i = 0; i < this.coinsNeeded; i++) {
        const coin = document.createElement('div');
        coin.className = 'rh-purge-coin';
        
        // Distribute coins in distinct quadrants
        const minX = 40 + (i * Math.floor((vpW - 120) / this.coinsNeeded));
        const maxX = minX + Math.floor((vpW - 120) / this.coinsNeeded) - 60;
        const posX = Math.max(20, Math.min(vpW - 80, Math.floor(Math.random() * (maxX - minX + 1)) + minX));
        const posY = Math.max(80, Math.min(vpH - 120, Math.floor(Math.random() * (vpH - 220)) + 110));

        coin.style.left = posX + 'px';
        coin.style.top = posY + 'px';
        coin.innerHTML = `<img src="${this.assetBase}sprites/spr_good_sign.png" alt="Purge Token">`;

        const onCollect = (e) => {
          e.preventDefault();
          e.stopPropagation();
          this.collectCoin(coin);
        };

        coin.addEventListener('click', onCollect);
        coin.addEventListener('touchstart', onCollect, { passive: false });

        document.body.appendChild(coin);
        this.activeCoins.push(coin);
      }
      this.updateActionTaskPrompt();
    },

    collectCoin: function(coin) {
      if (coin.classList.contains('collected')) return;
      coin.classList.add('collected');
      this.coinsCollected++;
      this.playSound('purged', 0.5);

      this.updateActionTaskPrompt();

      setTimeout(() => {
        if (coin.parentNode) coin.parentNode.removeChild(coin);
      }, 400);

      if (this.coinsCollected >= this.coinsNeeded) {
        this.purgeSuccess('DATA PURGED // MALWARE EXTINGUISHED (+500 PTS)');
      }
    },

    updateActionTaskPrompt: function() {
      const taskEl = document.getElementById('rhTaskDesc');
      if (taskEl) {
        taskEl.innerHTML = `COLLECT DATA PURGE NODES: <strong>${this.coinsCollected} / ${this.coinsNeeded}</strong>`;
      }
    },

    clearCoins: function() {
      this.activeCoins.forEach(c => {
        if (c.parentNode) c.parentNode.removeChild(c);
      });
      this.activeCoins = [];
    },

    // --- Chess Crisis: Piece Capture Challenge ---
    initChessCrisis: function() {
      this.chessMovesRemaining = 3;
      this.updateChessTaskPrompt();
    },

    notifyChessMove: function(move) {
      if (this.state !== 'crisis' || this.gameType !== 'chess') return;

      // Check if move captured an opponent piece
      if (move && move.captured) {
        this.purgeSuccess(`TACTICAL SACRIFICE VERIFIED! CAPTURED [${move.captured.toUpperCase()}] (+500 PTS)`);
        return;
      }

      this.chessMovesRemaining--;
      this.updateChessTaskPrompt();

      if (this.chessMovesRemaining <= 0) {
        this.triggerJumpscare('TACTICAL FAILURE // NO PIECE CAPTURED IN 3 MOVES');
      }
    },

    updateChessTaskPrompt: function() {
      const taskEl = document.getElementById('rhTaskDesc');
      if (taskEl) {
        taskEl.innerHTML = `CAPTURE AN OPPONENT PIECE! <strong>[${this.chessMovesRemaining} MOVES REMAINING]</strong>`;
      }
    },

    // --- Guesser / Cipher Crisis ---
    initGuesserCrisis: function() {
      this.guesserProbesRemaining = 2;
      // Also spawn 3 bypass nodes as alternative high-speed reflex solution
      this.coinsNeeded = 3;
      this.coinsCollected = 0;
      this.spawnPurgeCoins();
    },

    notifyGuesserProbe: function(isCorrect, isCloser) {
      if (this.state !== 'crisis' || this.gameType !== 'number_guess') return;

      if (isCorrect || isCloser) {
        this.purgeSuccess('CIPHER BYPASS CONFIRMED // SYSTEM SECURED (+500 PTS)');
        return;
      }

      this.guesserProbesRemaining--;
      if (this.guesserProbesRemaining <= 0) {
        this.triggerJumpscare('CIPHER MISALIGNMENT // MEMORY CORRUPTED');
      }
    },

    // -------------------------------------------------------------
    // PHASE 3: PURGE SUCCESS
    // -------------------------------------------------------------
    purgeSuccess: function(msg = 'ANOMALY PURGED! SYSTEM RESTORED (+500 BONUS SCORE)') {
      clearInterval(this.crisisInterval);
      this.clearCoins();
      this.state = 'idle';

      // Play victory chime
      this.playSound('purged', 0.9);

      // Deactivate red vignette
      if (this.vignetteEl) this.vignetteEl.classList.remove('active');

      // Remove crisis HUD
      if (this.crisisHudEl && this.crisisHudEl.parentNode) {
        this.crisisHudEl.parentNode.removeChild(this.crisisHudEl);
        this.crisisHudEl = null;
      }

      // Show Success Toast
      const toast = document.createElement('div');
      toast.className = 'rh-success-banner';
      toast.innerHTML = `<span>✓</span><span>${msg}</span>`;
      document.body.appendChild(toast);

      setTimeout(() => {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
      }, 3000);

      // Award +500 bonus points if host game has score function
      if (this.options.onPurgeBonus && typeof this.options.onPurgeBonus === 'function') {
        try { this.options.onPurgeBonus(500); } catch (e) {}
      } else if (typeof window.score === 'number') {
        window.score += 500;
        const scoreDisplay = document.getElementById('scoreVal') || document.getElementById('scoreDisplay');
        if (scoreDisplay) scoreDisplay.innerText = window.score;
      }

      // Schedule next lurking encounter (~40s cycle)
      this.scheduleLurk(36000, 44000);
    },

    // -------------------------------------------------------------
    // PHASE 4: FAILURE // FULLSCREEN JUMPSCARE & GAME OVER
    // -------------------------------------------------------------
    triggerJumpscare: function(reason = 'FATAL EXCEPTION') {
      if (this.state === 'jumpscare') return;
      this.state = 'jumpscare';

      clearInterval(this.crisisInterval);
      this.clearCoins();

      if (this.crisisHudEl && this.crisisHudEl.parentNode) {
        this.crisisHudEl.parentNode.removeChild(this.crisisHudEl);
        this.crisisHudEl = null;
      }

      // Play screeching jumpscare audio at max volume!
      this.playSound('jumpscare', 1.0);

      // Construct Fullscreen Jumpscare Takeover
      const jump = document.createElement('div');
      jump.className = 'rh-jumpscare-overlay';

      jump.innerHTML = `
        <img src="${this.assetBase}sprites/spr_ransom_jumpscare.png" class="rh-jumpscare-face" alt="Jumpscare" />
        <div class="rh-jumpscare-static" id="rhNoiseStatic"></div>
        <div class="rh-jumpscare-glitchtext">SYSTEM COMPROMISED. GOODBYE.</div>
      `;

      document.body.appendChild(jump);
      this.jumpscareEl = jump;

      // Noise static frame animation (spr_noise_0 through 5)
      let noiseFrame = 0;
      const staticEl = document.getElementById('rhNoiseStatic');
      this.noiseInterval = setInterval(() => {
        if (staticEl) {
          staticEl.style.backgroundImage = `url('${this.assetBase}sprites/spr_noise_${noiseFrame}.png')`;
          noiseFrame = (noiseFrame + 1) % 6;
        }
      }, 50);

      // Hold jumpscare for 2.4 seconds, then trigger Game Over
      setTimeout(() => {
        clearInterval(this.noiseInterval);
        if (jump.parentNode) jump.parentNode.removeChild(jump);
        this.jumpscareEl = null;
        if (this.vignetteEl) this.vignetteEl.classList.remove('active');

        // Trigger host game's game over routine
        if (this.options.onGameOver && typeof this.options.onGameOver === 'function') {
          try {
            this.options.onGameOver(reason);
          } catch (e) {
            console.error('Error invoking host gameOver:', e);
          }
        }
      }, 2400);
    }
  };

  window.RansomHorror = RansomHorror;

})(window);
