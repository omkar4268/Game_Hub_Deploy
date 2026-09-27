<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Maze // Procedural Labyrinth</title>

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
        <h1>CYBER MAZE</h1>
        <span class="badge">LABYRINTH PROTOCOL</span>
      </div>
      <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-hub">‹ Hub</a>
    </div>

    <div class="controls-bar">
      <div>Time: <span id="timerVal">00:00</span></div>
      <div>Cleared: <span id="clearedVal">0</span></div>
      <div>
        <select id="difficulty" onchange="onDiffChange()">
          <option value="easy">Easy (13x13)</option>
          <option value="medium" selected>Medium (21x21)</option>
          <option value="hard">Hard (31x31)</option>
        </select>
      </div>
    </div>

    <div class="game-container">
      <!-- Standardized Pre-Game Interactive Startup Screen -->
      <div id="splashScreen" class="overlay-screen">
        <div class="overlay-icon">⚡</div>
        <h2 class="overlay-title">
          CYBER MAZE
          <span class="badge">v2.5</span>
        </h2>
        <p class="overlay-sub">Solve procedurally generated labyrinth nodes, navigate recursive backtracker corridors, and locate the green extraction portal.</p>
        
        <div class="overlay-stats">
          <div>Mazes Cleared<span id="splashClears">0</span></div>
          <div>Fastest Escape<span id="splashBestTime">--</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startNewGame()">▶ INITIATE RUN</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="openIntel()">⚙ PROTOCOL & CONTROLS</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Win Screen -->
      <div id="winScreen" class="overlay-screen" style="display: none;">
        <div class="overlay-icon" style="color: var(--accent);">🏆</div>
        <h2 class="overlay-title" style="color: var(--accent); text-shadow: 0 0 20px var(--accent-glow);">MAZE CLEARED</h2>
        <p class="overlay-sub">Extraction portal reached. Neural telemetry verified.</p>
        
        <div class="overlay-stats">
          <div>Escape Time<span id="winTimeVal">00:00</span></div>
          <div>Total Cleared<span id="winClearsVal">1</span></div>
        </div>

        <div class="menu-actions">
          <button class="btn-cyber btn-cyber-primary" onclick="startNewGame()">↻ NEXT MAZE</button>
          <div class="menu-actions-row">
            <button class="btn-cyber btn-cyber-secondary" onclick="showSplashScreen()">☰ MAIN MENU</button>
            <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
          </div>
        </div>
      </div>

      <!-- Intel Modal -->
      <div id="intelModal" class="intel-modal">
        <div class="intel-title">
          <span>SECURITY DIRECTIVE</span>
          <button class="btn-hub" onclick="closeIntel()">✕ Close</button>
        </div>

        <div class="intel-row">
          <strong>🎮 CONTROLS</strong>
          Use Arrow Keys or W/A/S/D on desktop, or the on-screen tactical D-Pad on mobile viewports.
        </div>

        <div class="intel-row">
          <strong>⚡ OBJECTIVE</strong>
          Navigate your cyan runner block through randomized walls to reach the pulsing emerald extraction portal.
        </div>

        <div class="intel-row">
          <strong>🎯 TELEMETRY TRACKING</strong>
          Total labyrinth clears and fastest escape seconds automatically synchronize with your Cyber Hub profile and global leaderboards.
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeIntel(); startNewGame();">
          ▶ COMMENCE MISSION
        </button>
      </div>

      <!-- Loading Overlay -->
      <div id="loadingOverlay">
        <div class="spinner"></div>
        <div>Synthesizing Maze Architecture...</div>
      </div>

      <canvas id="mazeCanvas"></canvas>
    </div>

    <!-- Mobile Touch Controls -->
    <div class="dpad" id="mobileDpad">
      <button class="dpad-up" onclick="movePlayer(0, -1)">▲</button>
      <button class="dpad-left" onclick="movePlayer(-1, 0)">◀</button>
      <button class="dpad-down" onclick="movePlayer(0, 1)">▼</button>
      <button class="dpad-right" onclick="movePlayer(1, 0)">▶</button>
    </div>
  </div>

<script src="js/engine.js"></script>
<script src="../js/ransom_horror.js"></script>
</body>
</html>