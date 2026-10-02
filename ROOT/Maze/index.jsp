<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Maze // Holographic Labyrinth</title>

<!-- Framer Motion Browser Engine -->
<script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>
  <!-- Fullscreen Animated Holographic Vector Labyrinth Background Canvas -->
  <canvas id="mazeBgCanvas" class="maze-bg-canvas"></canvas>

  <!-- Universal Cyber-Scanner Wipe Transition -->
  <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
    <div class="cyber-wipe-beam"></div>
  </div>

  <div class="game-arena">
    <header class="header">
      <div class="header-left">
        <h1>CYBER <span class="hollow-text">MAZE</span></h1>
        <span class="header-badge">LABYRINTH v3.0</span>
      </div>
      <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-hub">
        <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        <span>Hub</span>
      </a>
    </header>

    <div class="controls-bar">
      <div class="control-pill">
        <span class="pill-label">ELAPSED TIME</span>
        <span class="pill-value" id="timerVal">00:00</span>
      </div>
      <div class="control-pill">
        <span class="pill-label">MAZES CLEARED</span>
        <span class="pill-value" id="clearedVal">0</span>
      </div>
      <div class="control-pill select-pill">
        <span class="pill-label">GRID ARCHITECTURE</span>
        <select id="difficulty" onchange="onDiffChange()" class="neon-select">
          <option value="easy">Scout (13x13)</option>
          <option value="medium" selected>Tactical (21x21)</option>
          <option value="hard">Master (31x31)</option>
        </select>
      </div>
    </div>

    <div class="game-container" id="gameContainer">
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

      <!-- Screen 1: Pre-Game Interactive Startup Screen (Obsidian Space Glass) -->
      <div id="splashScreen" class="overlay-screen">
        <div class="overlay-badge">
          <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="#a855f7" stroke-width="2.5"><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>
          RECURSIVE SPATIAL DECRYPTION
        </div>

        <div class="overlay-icon-wrap">
          <svg class="maze-icon-svg" viewBox="0 0 48 48" fill="none">
            <rect x="6" y="6" width="36" height="36" rx="8" stroke="url(#mazeGrad)" stroke-width="3" fill="rgba(168, 85, 247, 0.12)" />
            <path d="M6 18 H24 V30 H16 V42" stroke="url(#mazeGrad)" stroke-width="2.5" stroke-linecap="round" fill="none" />
            <path d="M30 6 V22 H42" stroke="url(#mazeGrad)" stroke-width="2.5" stroke-linecap="round" fill="none" />
            <circle cx="16" cy="18" r="2.5" fill="#38bdf8" />
            <circle cx="36" cy="36" r="3" fill="#22c55e" />
            <defs>
              <linearGradient id="mazeGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stop-color="#ffffff" />
                <stop offset="40%" stop-color="#c084fc" />
                <stop offset="100%" stop-color="#a855f7" />
              </linearGradient>
            </defs>
          </svg>
        </div>

        <h2 class="overlay-title">
          CYBER <span class="hollow-text">MAZE</span>
        </h2>
        <p class="overlay-sub">Infiltrate procedurally generated labyrinth matrices. Trace optimal recursive pathways and reach the extraction beacon before telemetry cycle reset.</p>
        
        <div class="overlay-stats">
          <div class="stat-box">
            <span class="stat-title">NODES CLEARED</span>
            <span class="stat-num" id="splashClears">0</span>
          </div>
          <div class="stat-box">
            <span class="stat-title">RECORD ESCAPE</span>
            <span class="stat-num stat-highlight" id="splashBestTime">--</span>
          </div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startNewGame()">
            <span class="btn-shimmer-sweep"></span>
            <span>▶ INITIATE RUN</span>
          </button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="openIntel()">⚙ DIRECTIVE & CONTROLS</button>
            <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">‹ HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 2: Win Screen -->
      <div id="winScreen" class="overlay-screen" style="display: none;">
        <div class="overlay-badge badge-success">
          <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="#22c55e" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
          EXTRACTION ACCOMPLISHED
        </div>

        <div class="overlay-icon-wrap icon-win">
          <svg viewBox="0 0 48 48" width="44" height="44" fill="none" stroke="#22c55e" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="24" cy="24" r="18"/>
            <path d="M16 24l5 5 11-11"/>
          </svg>
        </div>

        <h2 class="overlay-title title-win">MAZE CLEARED</h2>
        <p class="overlay-sub">Extraction beacon reached. Neural telemetry verified and stored.</p>
        
        <div class="overlay-stats">
          <div class="stat-box">
            <span class="stat-title">ESCAPE DURATION</span>
            <span class="stat-num stat-highlight" id="winTimeVal">00:00</span>
          </div>
          <div class="stat-box">
            <span class="stat-title">TOTAL CLEARED</span>
            <span class="stat-num" id="winClearsVal">1</span>
          </div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startNewGame()">
            <span class="btn-shimmer-sweep"></span>
            <span>↻ NEXT MAZE</span>
          </button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="showSplashScreen()">☰ MAIN MENU</button>
            <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 3: Intel Modal -->
      <div id="intelModal" class="intel-modal">
        <div class="intel-title">
          <span>OPERATIVE DIRECTIVE</span>
          <button class="btn-hub" onclick="closeIntel()">✕</button>
        </div>

        <div class="intel-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="M6 8h.01M10 8h.01M14 8h.01M18 8h.01M6 12h.01M18 12h.01M8 16h8"/></svg>
            CONTROLS
          </strong>
          Use Arrow Keys or W / A / S / D on desktop keyboards, or swipe / on-screen D-Pad on touch viewports.
        </div>

        <div class="intel-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#a855f7" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
            OBJECTIVE
          </strong>
          Steer your cyan operative cube through randomized holographic barriers to reach the green extraction beacon.
        </div>

        <div class="intel-row">
          <strong>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#ffffff" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            TELEMETRY SYNC
          </strong>
          Total maze nodes solved and best escape records sync automatically with your cloud operative profile.
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeIntel(); startNewGame();">
          <span class="btn-shimmer-sweep"></span>
          <span>▶ COMMENCE MISSION</span>
        </button>
      </div>

      <!-- Loading Synthesis Overlay -->
      <div id="loadingOverlay">
        <div class="spinner"></div>
        <div style="font-size:0.8rem; letter-spacing:1.5px; font-weight:700; color:#c084fc;">SYNTHESIZING MATRIX ARCHITECTURE...</div>
      </div>

      <canvas id="mazeCanvas"></canvas>
    </div>

    <!-- Mobile Touch Controls -->
    <div class="dpad" id="mobileDpad">
      <button type="button" class="dpad-up" onclick="movePlayer(0, -1)">▲</button>
      <button type="button" class="dpad-left" onclick="movePlayer(-1, 0)">◀</button>
      <button type="button" class="dpad-down" onclick="movePlayer(0, 1)">▼</button>
      <button type="button" class="dpad-right" onclick="movePlayer(1, 0)">▶</button>
    </div>
  </div>

<script src="js/engine.js"></script>
<script src="../js/ransom_horror.js"></script>
</body>
</html>