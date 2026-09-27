<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Snake // Neon Protocol</title>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>
  <!-- Universal Cyber-Scanner Wipe Transition -->
  <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
    <div class="cyber-wipe-beam"></div>
  </div>

  <div class="game-arena">
    <div class="header">
      <div class="header-left">
        <h1>CYBER SNAKE</h1>
        <span class="header-badge">ARCADE PROTOCOL</span>
      </div>
      <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-hub">‹ Hub</a>
    </div>

    <div class="scoreboard">
      <div>Score: <span id="scoreVal">0</span></div>
      <div class="best-label">Record: <span id="highScoreVal">0</span></div>
      <div>Data Nodes: <span id="nodesVal">0</span></div>
    </div>

    <div class="canvas-wrapper">
      <!-- Screen 1: Pre-Game Interactive Splash Screen -->
      <div id="startScreen" class="overlay-screen">
        <div class="overlay-icon">🐍</div>
        <h2 class="overlay-title">
          CYBER SNAKE
          <span class="header-badge">v2.5</span>
        </h2>
        <p class="overlay-subtitle">Navigate your neural serpent across the digital vector matrix, devour rogue data packets, and set the all-time high score.</p>
        
        <div class="overlay-stats">
          <div>High Score<span id="splashBest">0 pts</span></div>
          <div>Nodes Consumed<span id="splashNodes">0</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startGame()">▶ INITIATE RUN</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="openManual()">⚙ PROTOCOL & CONTROLS</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 2: Game Over Screen -->
      <div id="gameOverScreen" class="overlay-screen" style="display: none;">
        <div class="overlay-icon" style="color: var(--food);">💥</div>
        <h2 class="overlay-title" style="color: var(--food); text-shadow: 0 0 20px var(--food-glow);">SYSTEM CRASH</h2>
        <p class="overlay-subtitle" id="gameOverSub">Sub-routine terminated. Vector collision detected.</p>
        
        <div class="overlay-stats">
          <div>Run Score<span id="finalScoreVal" style="color: var(--primary);">0 pts</span></div>
          <div>Nodes Collected<span id="finalNodesVal" style="color: var(--accent);">0</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startGame()">↻ RETRY RUN</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="showStartScreen()">☰ MAIN MENU</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Screen 3: Settings & Controls Modal -->
      <div id="manualModal" class="manual-modal">
        <div class="manual-title">
          <span>SECURITY DIRECTIVE</span>
          <button class="btn-hub" onclick="closeManual()">✕ Close</button>
        </div>

        <div class="manual-row">
          <strong>🎮 PC KEYBOARD CONTROLS</strong>
          Use Arrow Keys or W/A/S/D to steer your serpent. Responsive direction buffer prevents 180° self-reversals.
        </div>

        <div class="manual-row">
          <strong>📱 MOBILE TOUCH CONTROLS</strong>
          Swipe anywhere across the grid or tap the tactical on-screen D-Pad.
        </div>

        <div class="manual-row">
          <strong>⚡ NEURAL TICK SPEED (BALANCED)</strong>
          Select game clock frequency:
          <div class="speed-picker">
            <button class="speed-btn" id="spdScout" onclick="setSpeed(175, 'spdScout')">Scout (Chill)</button>
            <button class="speed-btn active" id="spdAgent" onclick="setSpeed(145, 'spdAgent')">Agent (Balanced)</button>
            <button class="speed-btn" id="spdOver" onclick="setSpeed(110, 'spdOver')">Overclock</button>
          </div>
        </div>

        <div class="manual-row">
          <strong>🎯 SCORING TELEMETRY</strong>
          Each crimson data node awards +10 points. High scores automatically persist to your cloud profile!
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeManual(); startGame();">
          ▶ START PLAYING
        </button>
      </div>

      <canvas id="gameCanvas" width="400" height="400"></canvas>
    </div>

    <!-- On-Screen Controls for Mobile Devices -->
    <div id="mobileDpad">
      <div class="d-btn d-up" data-dir="UP">▲</div>
      <div class="d-btn d-left" data-dir="LEFT">◀</div>
      <div class="d-btn d-down" data-dir="DOWN">▼</div>
      <div class="d-btn d-right" data-dir="RIGHT">▶</div>
    </div>
  </div>

<script src="js/engine.js"></script>
<script src="../js/ransom_horror.js"></script>
</body>
</html>