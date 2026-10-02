<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Snake // Neural Vector Matrix</title>

<!-- Framer Motion Browser Engine -->
<script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>
  <!-- Fullscreen Animated Cyber Matrix & Circuit Background Canvas -->
  <canvas id="snakeBgCanvas" class="snake-bg-canvas"></canvas>

  <!-- Universal Cyber-Scanner Wipe Transition -->
  <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
    <div class="cyber-wipe-beam"></div>
  </div>

  <div class="game-arena">
    <header class="header">
      <div class="header-left">
        <h1>CYBER <span class="hollow-text">SNAKE</span></h1>
        <span class="header-badge">NEURAL VECTOR v3.0</span>
      </div>
      <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-hub">
        <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        <span>Hub</span>
      </a>
    </header>

    <div class="scoreboard">
      <div class="score-pill">
        <span class="pill-label">LIVE SCORE</span>
        <span class="pill-value" id="scoreVal">0</span>
      </div>
      <div class="score-pill best-label">
        <span class="pill-label">RECORD</span>
        <span class="pill-value" id="highScoreVal">0</span>
      </div>
      <div class="score-pill">
        <span class="pill-label">DATA NODES</span>
        <span class="pill-value" id="nodesVal">0</span>
      </div>
    </div>

    <div class="canvas-wrapper" id="canvasWrapper">
      <!-- Animated Traveling Light Beam Perimeter Circuit -->
      <div class="card-beam-perimeter">
        <div class="beam-runner beam-top"></div>
        <div class="beam-runner beam-right"></div>
        <div class="beam-runner beam-bottom"></div>
        <div class="beam-runner beam-left"></div>
        <div class="beam-corner-dot dot-tl"></div>
        <div class="beam-corner-dot dot-tr"></div>
        <div class="beam-corner-dot dot-br"></div>
        <div class="beam-corner-dot dot-bl"></div>
      </div>

      <!-- Screen 1: Pre-Game Interactive Splash Screen (Obsidian Space Glass) -->
      <div id="startScreen" class="overlay-screen">
        <div class="overlay-badge">
          <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="#10e6a8" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          HIGH-SPEED SYNAPSE RUNNER
        </div>

        <div class="overlay-icon-wrap">
          <svg class="serpent-icon-svg" viewBox="0 0 48 48" fill="none">
            <path d="M34 10 C34 5 26 5 24 9 C22 13 14 13 14 19 C14 25 21 26 24 29 C28 32 32 34 32 39 C32 43 27 44 24 44 C18 44 14 40 14 35" stroke="url(#serpentGrad)" stroke-width="4" stroke-linecap="round" fill="none" />
            <circle cx="34" cy="10" r="4.5" fill="url(#serpentGrad)" />
            <circle cx="35.5" cy="9" r="1.5" fill="#000" />
            <circle cx="20" cy="22" r="1.8" fill="#ffffff" />
            <circle cx="29" cy="35" r="1.8" fill="#ffffff" />
            <defs>
              <linearGradient id="serpentGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stop-color="#ffffff" />
                <stop offset="35%" stop-color="#34d399" />
                <stop offset="100%" stop-color="#10e6a8" />
              </linearGradient>
            </defs>
          </svg>
        </div>

        <h2 class="overlay-title">
          CYBER <span class="hollow-text">SNAKE</span>
        </h2>
        <p class="overlay-subtitle">Steer your neural serpent through the cyber-spatial matrix. Devour high-energy memory nodes, evade boundaries, and set the arcade high score.</p>
        
        <div class="overlay-stats">
          <div class="stat-box">
            <span class="stat-title">RECORD SCORE</span>
            <span class="stat-num" id="splashBest">0 pts</span>
          </div>
          <div class="stat-box">
            <span class="stat-title">NODES CONSUMED</span>
            <span class="stat-num" id="splashNodes">0</span>
          </div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startGame()">
            <span class="btn-shimmer-sweep"></span>
            <span>▶ INITIATE RUN</span>
          </button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="openManual()">⚙ DIRECTIVE & CONTROLS</button>
            <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">‹ HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 2: Game Over Screen -->
      <div id="gameOverScreen" class="overlay-screen" style="display: none;">
        <div class="overlay-badge badge-danger">
          <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="#f43f5e" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
          NEURAL SIGNAL LOST
        </div>

        <div class="overlay-icon-wrap icon-crash">
          <svg viewBox="0 0 48 48" width="44" height="44" fill="none" stroke="#f43f5e" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polygon points="24 4 44 40 4 40 24 4"/>
            <line x1="24" y1="18" x2="24" y2="28" stroke-width="3"/>
            <circle cx="24" cy="34" r="2" fill="#f43f5e"/>
          </svg>
        </div>

        <h2 class="overlay-title title-crash">SYSTEM CRASH</h2>
        <p class="overlay-subtitle" id="gameOverSub">Sub-routine terminated. Vector perimeter collision detected.</p>
        
        <div class="overlay-stats">
          <div class="stat-box">
            <span class="stat-title">RUN SCORE</span>
            <span class="stat-num stat-highlight" id="finalScoreVal">0 pts</span>
          </div>
          <div class="stat-box">
            <span class="stat-title">NODES COLLECTED</span>
            <span class="stat-num" id="finalNodesVal">0</span>
          </div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startGame()">
            <span class="btn-shimmer-sweep"></span>
            <span>↻ RETRY RUN</span>
          </button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="showStartScreen()">☰ MAIN MENU</button>
            <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 3: Settings & Controls Modal -->
      <div id="manualModal" class="manual-modal">
        <div class="manual-title">
          <span>OPERATIVE DIRECTIVE</span>
          <button class="btn-hub" onclick="closeManual()">✕</button>
        </div>

        <div class="manual-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#10e6a8" stroke-width="2"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="M6 8h.01M10 8h.01M14 8h.01M18 8h.01M6 12h.01M18 12h.01M8 16h8"/></svg>
            PC KEYBOARD CONTROLS
          </strong>
          Use Arrow Keys or W / A / S / D to steer. Sub-millisecond buffer prevents 180° self-reversal fatalities.
        </div>

        <div class="manual-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><rect x="5" y="2" width="14" height="20" rx="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>
            MOBILE TOUCH CONTROLS
          </strong>
          Swipe anywhere on the matrix grid or tap the tactical low-profile D-Pad.
        </div>

        <div class="manual-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#facc15" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            NEURAL TICK FREQUENCY
          </strong>
          Select clock interval:
          <div class="speed-picker">
            <button class="speed-btn" id="spdScout" onclick="setSpeed(175, 'spdScout')">Scout (175ms)</button>
            <button class="speed-btn active" id="spdAgent" onclick="setSpeed(145, 'spdAgent')">Agent (145ms)</button>
            <button class="speed-btn" id="spdOver" onclick="setSpeed(110, 'spdOver')">Overclock (110ms)</button>
          </div>
        </div>

        <div class="manual-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#ffffff" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            SCORING TELEMETRY
          </strong>
          Each crimson data node awards +10 points. High scores automatically persist to cloud profile.
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeManual(); startGame();">
          <span class="btn-shimmer-sweep"></span>
          <span>▶ COMMENCE RUN</span>
        </button>
      </div>

      <canvas id="gameCanvas" width="400" height="400"></canvas>
    </div>

    <!-- Low-profile Tactile D-Pad for Mobile Devices -->
    <div id="mobileDpad">
      <button type="button" class="d-btn d-up" data-dir="UP">▲</button>
      <button type="button" class="d-btn d-left" data-dir="LEFT">◀</button>
      <button type="button" class="d-btn d-down" data-dir="DOWN">▼</button>
      <button type="button" class="d-btn d-right" data-dir="RIGHT">▶</button>
    </div>
  </div>

<script src="js/engine.js"></script>
<script src="../js/ransom_horror.js"></script>
</body>
</html>