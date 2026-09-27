// =========================================================
// RANS0M HORROR PROTOCOL // ROBLOX DOORS INSP. HORROR ENGINE
// Universal Cyber-Horror Injection for Game Hub
// =========================================================

(function(window) {
  'use strict';

  const RansomHorror = {
    enabled: false,
    gameType: 'generic',
    options: {},
    assetBase: '',
    
    // State machine: 'idle' | 'warning' | 'initial_jumpscare' | 'crisis' | 'final_jumpscare'
    state: 'idle',
    warningTimer: null,
    warningDurationTimeout: null,
    initialJumpscareTimeout: null,
    crisisInterval: null,
    coinMoveInterval: null,
    noiseInterval: null,
    _inputHandler: null,
    
    // Crisis countdown & purge tracking
    crisisTimeRemaining: 10,
    coinsNeeded: 5,
    coinsCollected: 0,
    
    // Audio elements
    sounds: {},

    // DOM references
    stopSignEl: null,
    initialJumpscareEl: null,
    ransomWindowEl: null,
    vignetteEl: null,
    finalJumpscareEl: null,
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
      const isSubDir = path.includes('/Snake') || path.includes('/Maze') || path.includes('/Chess') || 
                       path.includes('/Game1') || path.includes('/Bomb_Defuse') || 
                       path.includes('/Reactor_Meltdown') || path.includes('/Ransom');
      this.assetBase = isSubDir ? '../Ransom/assets/' : 'Ransom/assets/';

      this.preloadAudio();
      this.createVignette();
      this.scheduleWarning(10000, 30000); // Stop sign flashes randomly from 10 to 30 seconds
    },

    reset: function() {
      clearTimeout(this.warningTimer);
      clearTimeout(this.warningDurationTimeout);
      clearTimeout(this.initialJumpscareTimeout);
      clearInterval(this.crisisInterval);
      clearInterval(this.coinMoveInterval);
      clearInterval(this.noiseInterval);

      this.removeInputListeners();

      if (this.stopSignEl && this.stopSignEl.parentNode) {
        this.stopSignEl.parentNode.removeChild(this.stopSignEl);
      }
      this.stopSignEl = null;

      if (this.initialJumpscareEl && this.initialJumpscareEl.parentNode) {
        this.initialJumpscareEl.parentNode.removeChild(this.initialJumpscareEl);
      }
      this.initialJumpscareEl = null;

      if (this.ransomWindowEl && this.ransomWindowEl.parentNode) {
        this.ransomWindowEl.parentNode.removeChild(this.ransomWindowEl);
      }
      this.ransomWindowEl = null;

      if (this.finalJumpscareEl && this.finalJumpscareEl.parentNode) {
        this.finalJumpscareEl.parentNode.removeChild(this.finalJumpscareEl);
      }
      this.finalJumpscareEl = null;

      if (this.vignetteEl) {
        this.vignetteEl.classList.remove('active');
      }

      this.clearCoins();
      this.state = 'idle';
      this.coinsCollected = 0;
    },

    evadeLurker: function() {
      this.reset();
    },

    preloadAudio: function() {
      const audioFiles = {
        spawn: 'snd_spawn.wav',
        first_jumpscare: 'snd_first_jumpscare.wav',
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
          osc.frequency.setValueAtTime(180, ctx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(60, ctx.currentTime + 0.5);
          gain.gain.setValueAtTime(0.2, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 0.5);
          osc.start();
          osc.stop(ctx.currentTime + 0.5);
        } else if (key === 'first_jumpscare' || key === 'jumpscare') {
          osc.type = 'sawtooth';
          osc.frequency.setValueAtTime(950, ctx.currentTime);
          osc.frequency.linearRampToValueAtTime(150, ctx.currentTime + 1.2);
          gain.gain.setValueAtTime(0.6, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 1.2);
          osc.start();
          osc.stop(ctx.currentTime + 1.2);
        } else if (key === 'purged') {
          osc.type = 'sine';
          osc.frequency.setValueAtTime(523, ctx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(1046, ctx.currentTime + 0.4);
          gain.gain.setValueAtTime(0.3, ctx.currentTime);
          gain.gain.linearRampToValueAtTime(0.001, ctx.currentTime + 0.4);
          osc.start();
          osc.stop(ctx.currentTime + 0.4);
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

    // -------------------------------------------------------------
    // PHASE 1: STOP SIGN WARNING (RANDOM 10 TO 30 SECONDS)
    // -------------------------------------------------------------
    scheduleWarning: function(minMs = 10000, maxMs = 30000) {
      if (!this.enabled || this.state !== 'idle') return;
      clearTimeout(this.warningTimer);
      const delay = Math.floor(Math.random() * (maxMs - minMs + 1)) + minMs;
      this.warningTimer = setTimeout(() => {
        this.spawnStopSign();
      }, delay);
    },

    spawnStopSign: function() {
      if (!this.enabled || this.state !== 'idle') return;
      this.state = 'warning';

      // Play eerie warning buzzer sound
      this.playSound('spawn', 0.85);

      // Create Stop Sign element
      const wrapper = document.createElement('div');
      wrapper.className = 'rh-stop-sign-wrapper';

      wrapper.innerHTML = `
        <img src="${this.assetBase}sprites/spr_stop_sign.png" class="rh-stop-sign-img" alt="STOP!" />
        <div class="rh-stop-sign-banner">⚠️ FREEZE! DO NOT MAKE ANY INPUT! ⚠️</div>
      `;

      document.body.appendChild(wrapper);
      this.stopSignEl = wrapper;

      // Listen for ANY user input (Keyboard, Mouse Click, Screen Touch, Mobile Dpad)
      this.addInputListeners();

      // Safe Evasion Duration: If player provides ZERO input for 3.5 seconds, threat passes!
      clearTimeout(this.warningDurationTimeout);
      this.warningDurationTimeout = setTimeout(() => {
        if (this.state === 'warning') {
          this.evadeWarning();
        }
      }, 3500);
    },

    addInputListeners: function() {
      this.removeInputListeners();

      const onInputDetected = (e) => {
        if (this.state === 'warning') {
          if (e) {
            try { e.preventDefault(); e.stopPropagation(); } catch (err) {}
          }
          this.removeInputListeners();
          clearTimeout(this.warningDurationTimeout);
          this.triggerInitialJumpscare();
        }
      };

      this._inputHandler = onInputDetected;

      // Add capture phase listeners so ANY input is caught instantly
      window.addEventListener('keydown', onInputDetected, true);
      window.addEventListener('mousedown', onInputDetected, true);
      window.addEventListener('touchstart', onInputDetected, { capture: true, passive: false });
      window.addEventListener('pointerdown', onInputDetected, true);
    },

    removeInputListeners: function() {
      if (this._inputHandler) {
        window.removeEventListener('keydown', this._inputHandler, true);
        window.removeEventListener('mousedown', this._inputHandler, true);
        window.removeEventListener('touchstart', this._inputHandler, { capture: true, passive: false });
        window.removeEventListener('pointerdown', this._inputHandler, true);
        this._inputHandler = null;
      }
    },

    evadeWarning: function() {
      this.removeInputListeners();
      if (this.stopSignEl) {
        this.stopSignEl.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
        this.stopSignEl.style.opacity = '0';
        this.stopSignEl.style.transform = 'translate(-50%, -50%) scale(0.4)';
        setTimeout(() => {
          if (this.stopSignEl && this.stopSignEl.parentNode) {
            this.stopSignEl.parentNode.removeChild(this.stopSignEl);
          }
          this.stopSignEl = null;
        }, 400);
      }
      this.state = 'idle';
      this.scheduleWarning(10000, 30000); // Reschedule for next random 10-30s cycle
    },

    // -------------------------------------------------------------
    // PHASE 2: INITIAL JUMPSCARE (TRIGGERED IMMEDIATELY ON ANY INPUT)
    // -------------------------------------------------------------
    triggerInitialJumpscare: function() {
      if (this.state === 'initial_jumpscare' || this.state === 'crisis' || this.state === 'final_jumpscare') return;
      this.state = 'initial_jumpscare';

      // Remove stop sign immediately
      if (this.stopSignEl && this.stopSignEl.parentNode) {
        this.stopSignEl.parentNode.removeChild(this.stopSignEl);
        this.stopSignEl = null;
      }

      // Play terrifying screeching jumpscare audio
      this.playSound('first_jumpscare', 1.0);

      // Create fullscreen jump flash
      const jump = document.createElement('div');
      jump.className = 'rh-initial-jumpscare';

      jump.innerHTML = `
        <img src="${this.assetBase}sprites/spr_ransom_attack_face.png" class="rh-initial-face" alt="RANS0M Attack" />
      `;

      document.body.appendChild(jump);
      this.initialJumpscareEl = jump;

      // Hold jumpscare for 0.9s, then start the 10-second countdown crisis
      clearTimeout(this.initialJumpscareTimeout);
      this.initialJumpscareTimeout = setTimeout(() => {
        if (this.initialJumpscareEl && this.initialJumpscareEl.parentNode) {
          this.initialJumpscareEl.parentNode.removeChild(this.initialJumpscareEl);
          this.initialJumpscareEl = null;
        }
        this.startCrisisPhase();
      }, 900);
    },

    // -------------------------------------------------------------
    // PHASE 3: CRISIS PHASE (MOVING BOX + 10s COUNTDOWN + COIN PURGE)
    // -------------------------------------------------------------
    startCrisisPhase: function() {
      this.state = 'crisis';
      if (this.vignetteEl) this.vignetteEl.classList.add('active');

      // Randomly spawn between 3 and 7 tokens
      this.coinsNeeded = Math.floor(Math.random() * 5) + 3; // 3, 4, 5, 6, or 7 tokens
      this.coinsCollected = 0;
      this.crisisTimeRemaining = 10;

      // Render the Authentic Retro Ransomware Error Box
      this.renderRansomWindow();

      // Spawn Coins
      this.spawnPurgeCoins();

      // Countdown Timer & Box Movement: Ticks every 1 second (1000ms)
      clearInterval(this.crisisInterval);
      this.crisisInterval = setInterval(() => {
        this.crisisTimeRemaining--;

        if (this.crisisTimeRemaining <= 0) {
          this.crisisTimeRemaining = 0;
          this.updateWindowTimerUI();
          clearInterval(this.crisisInterval);
          clearInterval(this.coinMoveInterval);
          this.triggerFinalJumpscare('TIME EXPIRED // YOUR ITEMS HAVE BEEN ENCRYPTED');
        } else {
          this.updateWindowTimerUI();
          // Move the ransomware box to a new randomized position every second!
          this.moveRansomWindow();
        }
      }, 1000);

      // Locations of coins also change every 3 seconds randomly on screen!
      clearInterval(this.coinMoveInterval);
      this.coinMoveInterval = setInterval(() => {
        if (this.state === 'crisis') {
          this.relocateActiveCoins();
        }
      }, 3000);
    },

    renderRansomWindow: function() {
      if (this.ransomWindowEl && this.ransomWindowEl.parentNode) {
        this.ransomWindowEl.parentNode.removeChild(this.ransomWindowEl);
      }

      const win = document.createElement('div');
      win.className = 'rh-ransom-window';

      win.innerHTML = `
        <div class="rh-window-titlebar">
          <span>RANSOMWARE.EXE</span>
          <div class="rh-window-controls">
            <div class="rh-win-btn">_</div>
            <div class="rh-win-btn">□</div>
            <div class="rh-win-btn">✕</div>
          </div>
        </div>
        <div class="rh-window-header-box">
          <img src="${this.assetBase}sprites/spr_ransom_attack_face.png" class="rh-window-avatar" alt="Avatar" />
          <div class="rh-window-main-title">
            YOUR ITEMS<br>HAVE BEEN<br>ENCRYPTED
          </div>
        </div>
        <div class="rh-window-notice">
          IF YOU DO NOT PAY THIS RANSOM BEFORE THE TIMER ENDS, YOUR ITEMS WILL BE <strong>UNRECOVERABLE BY ANY MEANS</strong>.
        </div>
        <div class="rh-window-stats">
          <div class="rh-stat-coins">
            <span class="rh-coins-counter" id="rhTokensCount">0 / ${this.coinsNeeded}</span>
            <img src="${this.assetBase}sprites/spr_good_sign.png" class="rh-coin-icon-small" alt="Token" />
          </div>
          <div class="rh-stat-timer">
            TIME: <span class="rh-timer-display" id="rhTimerVal">00:10</span>
          </div>
        </div>
      `;

      document.body.appendChild(win);
      this.ransomWindowEl = win;

      // Set initial random position on screen
      this.moveRansomWindow();
    },

    updateWindowTimerUI: function() {
      const timerEl = document.getElementById('rhTimerVal');
      if (timerEl) {
        const sec = this.crisisTimeRemaining;
        timerEl.innerText = '00:' + (sec < 10 ? '0' + sec : sec);
      }
    },

    moveRansomWindow: function() {
      if (!this.ransomWindowEl) return;

      const vpW = window.innerWidth;
      const vpH = window.innerHeight;

      // Safe bounds so window stays 100% visible on any screen/mobile viewport
      const minX = 15;
      const maxX = Math.max(minX + 20, vpW - 400);
      const minY = 30;
      const maxY = Math.max(minY + 20, vpH - 320);

      const newX = Math.floor(Math.random() * (maxX - minX + 1)) + minX;
      const newY = Math.floor(Math.random() * (maxY - minY + 1)) + minY;

      this.ransomWindowEl.style.left = newX + 'px';
      this.ransomWindowEl.style.top = newY + 'px';

      // Apply quick teleport glitch flash
      this.ransomWindowEl.classList.remove('rh-box-warping');
      void this.ransomWindowEl.offsetWidth; // Trigger reflow
      this.ransomWindowEl.classList.add('rh-box-warping');
    },

    spawnPurgeCoins: function() {
      this.clearCoins();
      const vpW = window.innerWidth;
      const vpH = window.innerHeight;

      for (let i = 0; i < this.coinsNeeded; i++) {
        const coin = document.createElement('div');
        coin.className = 'rh-purge-coin';
        
        const posX = Math.max(25, Math.min(vpW - 75, Math.floor(Math.random() * (vpW - 100)) + 30));
        const posY = Math.max(70, Math.min(vpH - 85, Math.floor(Math.random() * (vpH - 140)) + 60));

        coin.style.left = posX + 'px';
        coin.style.top = posY + 'px';
        coin.innerHTML = `<img src="${this.assetBase}sprites/spr_good_sign.png" alt="Coin Token">`;

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
      this.updateCoinsCounterUI();
    },

    relocateActiveCoins: function() {
      const vpW = window.innerWidth;
      const vpH = window.innerHeight;

      this.activeCoins.forEach(coin => {
        if (!coin || coin.classList.contains('collected') || !coin.parentNode) return;

        coin.classList.add('rh-teleporting');
        const newX = Math.max(25, Math.min(vpW - 75, Math.floor(Math.random() * (vpW - 100)) + 30));
        const newY = Math.max(70, Math.min(vpH - 85, Math.floor(Math.random() * (vpH - 140)) + 60));

        setTimeout(() => {
          coin.style.left = newX + 'px';
          coin.style.top = newY + 'px';
          setTimeout(() => {
            coin.classList.remove('rh-teleporting');
          }, 150);
        }, 120);
      });
    },

    collectCoin: function(coin) {
      if (coin.classList.contains('collected')) return;
      coin.classList.add('collected');
      this.coinsCollected++;
      this.playSound('purged', 0.6);

      this.updateCoinsCounterUI();

      setTimeout(() => {
        if (coin.parentNode) coin.parentNode.removeChild(coin);
        const idx = this.activeCoins.indexOf(coin);
        if (idx !== -1) this.activeCoins.splice(idx, 1);
      }, 350);

      if (this.coinsCollected >= this.coinsNeeded) {
        this.purgeSuccess('RANSOM PAID // DECRYPTION COMPLETE (+500 BONUS SCORE)');
      }
    },

    updateCoinsCounterUI: function() {
      const counterEl = document.getElementById('rhTokensCount');
      if (counterEl) {
        counterEl.innerText = `${this.coinsCollected} / ${this.coinsNeeded}`;
      }
    },

    clearCoins: function() {
      this.activeCoins.forEach(c => {
        if (c && c.parentNode) c.parentNode.removeChild(c);
      });
      this.activeCoins = [];
    },

    // -------------------------------------------------------------
    // PHASE 4: SUCCESS // RANSOM PAID & DECRYPTED
    // -------------------------------------------------------------
    purgeSuccess: function(msg = 'RANSOM PAID // SYSTEM SECURED (+500 BONUS SCORE)') {
      clearInterval(this.crisisInterval);
      clearInterval(this.coinMoveInterval);
      this.clearCoins();
      this.state = 'idle';

      // Play victory chime
      this.playSound('purged', 0.95);

      // Deactivate red vignette
      if (this.vignetteEl) this.vignetteEl.classList.remove('active');

      // Collapse and remove ransomware window
      if (this.ransomWindowEl) {
        this.ransomWindowEl.style.transition = 'transform 0.35s ease, opacity 0.35s ease';
        this.ransomWindowEl.style.transform = 'scale(0.2) rotate(10deg)';
        this.ransomWindowEl.style.opacity = '0';
        setTimeout(() => {
          if (this.ransomWindowEl && this.ransomWindowEl.parentNode) {
            this.ransomWindowEl.parentNode.removeChild(this.ransomWindowEl);
          }
          this.ransomWindowEl = null;
        }, 350);
      }

      // Show Success Toast
      const toast = document.createElement('div');
      toast.className = 'rh-success-banner';
      toast.innerHTML = `<span>✓</span><span>${msg}</span>`;
      document.body.appendChild(toast);

      setTimeout(() => {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
      }, 3200);

      // Award +500 bonus points if host game has score function
      if (this.options.onPurgeBonus && typeof this.options.onPurgeBonus === 'function') {
        try { this.options.onPurgeBonus(500); } catch (e) {}
      } else if (typeof window.score === 'number') {
        window.score += 500;
        const scoreDisplay = document.getElementById('scoreVal') || document.getElementById('scoreDisplay');
        if (scoreDisplay) scoreDisplay.innerText = window.score;
      }

      // Schedule next Stop Sign encounter in random 10 to 30 seconds
      this.scheduleWarning(10000, 30000);
    },

    // -------------------------------------------------------------
    // PHASE 5: FAILURE // FATAL JUMPSCARE & GAME OVER
    // -------------------------------------------------------------
    triggerFinalJumpscare: function(reason = 'FATAL EXCEPTION') {
      if (this.state === 'final_jumpscare') return;
      this.state = 'final_jumpscare';

      clearInterval(this.crisisInterval);
      clearInterval(this.coinMoveInterval);
      this.clearCoins();

      if (this.ransomWindowEl && this.ransomWindowEl.parentNode) {
        this.ransomWindowEl.parentNode.removeChild(this.ransomWindowEl);
        this.ransomWindowEl = null;
      }

      // Play screeching jumpscare audio at max volume!
      this.playSound('jumpscare', 1.0);

      // Construct Fullscreen Fatal Jumpscare Takeover
      const jump = document.createElement('div');
      jump.className = 'rh-jumpscare-overlay';

      jump.innerHTML = `
        <img src="${this.assetBase}sprites/spr_ransom_attack_face.png" class="rh-jumpscare-face" alt="Fatal Jumpscare" />
        <div class="rh-jumpscare-static" id="rhNoiseStatic"></div>
        <div class="rh-jumpscare-glitchtext">SYSTEM COMPROMISED. YOUR ITEMS ARE CORRUPTED. GAME OVER.</div>
      `;

      document.body.appendChild(jump);
      this.finalJumpscareEl = jump;

      // Noise static frame animation (spr_noise_0 through 5)
      let noiseFrame = 0;
      const staticEl = document.getElementById('rhNoiseStatic');
      this.noiseInterval = setInterval(() => {
        if (staticEl) {
          staticEl.style.backgroundImage = `url('${this.assetBase}sprites/spr_noise_${noiseFrame}.png')`;
          noiseFrame = (noiseFrame + 1) % 6;
        }
      }, 50);

      // Hold jumpscare for 2.2 seconds, then trigger host Game Over
      setTimeout(() => {
        clearInterval(this.noiseInterval);
        if (jump.parentNode) jump.parentNode.removeChild(jump);
        this.finalJumpscareEl = null;
        if (this.vignetteEl) this.vignetteEl.classList.remove('active');

        // Trigger host game's game over routine
        if (this.options.onGameOver && typeof this.options.onGameOver === 'function') {
          try {
            this.options.onGameOver(reason);
          } catch (e) {
            console.error('Error invoking host gameOver:', e);
          }
        }
      }, 2200);
    }
  };

  window.RansomHorror = RansomHorror;

})(window);
