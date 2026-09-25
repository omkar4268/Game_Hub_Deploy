<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%
    String currentUser = null;
    if (session != null) {
        currentUser = (String) session.getAttribute("user_session");
        if (currentUser == null || currentUser.trim().isEmpty()) {
            currentUser = (String) session.getAttribute("user");
        }
    }
    boolean isGuest = (session != null && session.getAttribute("isGuest") != null && (Boolean) session.getAttribute("isGuest"));
    boolean isLoggedIn = (currentUser != null && !currentUser.trim().isEmpty());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Hub // Reactor Meltdown</title>
<!-- Modular External Stylesheet -->
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Universal Cyber-Scanner Wipe Transition -->
<div id="cyberWipeOverlay" class="cyber-wipe-overlay">
  <div class="cyber-wipe-beam"></div>
</div>

<div class="game-arena">
  
  <!-- Header Navigation Bar -->
  <div class="header">
    <div class="header-left">
      <span class="header-title">REACTOR MELTDOWN</span>
      <span class="header-badge" id="sectorBadge">3x3 SECTOR</span>
    </div>
    <div class="header-controls">
      <button class="btn-icon" id="soundBtn" title="Toggle Sound" onclick="toggleSound()">🔊</button>
      <button class="btn-hub" onclick="cyberNavigate('../index.jsp')">‹ HUB</button>
    </div>
  </div>

  <!-- Countdown Timer Bar -->
  <div class="timer-bar-wrap">
    <div class="timer-bar-fill" id="timerBar"></div>
  </div>

  <!-- Containment HUD Panel -->
  <div class="hud-panel">
    <div class="hud-stat">
      <span class="hud-label">SCORE</span>
      <span class="hud-value glow-accent" id="scoreDisplay">0000</span>
    </div>

    <div class="reactor-status-box">
      <div class="reactor-status-title">
        <span>CORE STABILIZATION</span>
        <span id="sequenceProgressPill">1 TILE</span>
      </div>
      <div class="reactor-status-text" id="statusMessage">AWAITING SEQUENCE</div>
      <div class="shields-container" id="shieldsContainer">
        <div class="shield-pip" id="shield1"></div>
        <div class="shield-pip" id="shield2"></div>
        <div class="shield-pip" id="shield3"></div>
      </div>
    </div>

    <div class="hud-stat" style="align-items: flex-end;">
      <span class="hud-label">COOLANT TIME</span>
      <span class="hud-value glow-warning" id="timeDisplay">10.0s</span>
    </div>
  </div>

  <!-- Reactor Core Console Chassis -->
  <div class="reactor-chassis" id="reactorChassis">
    <!-- Screen Flash Shockwave -->
    <div class="reactor-shockwave" id="shockwave"></div>

    <!-- Active Reactor Keypad Grid -->
    <div class="reactor-grid" id="reactorGrid"></div>

    <!-- PRE-GAME STARTUP SCREEN OVERLAY -->
    <div class="overlay-screen" id="startupOverlay">
      <div class="overlay-tag">CRITICAL ALERT // PROTOCOL ALPHA</div>
      <div class="overlay-icon">☢️</div>
      <div class="overlay-title">REACTOR MELTDOWN</div>
      <div class="overlay-subtitle">
        Observe the random glowing reactor sequence and replicate it before containment collapses. Starts on 3x3 and progressively auto-expands into larger matrices.
      </div>

      <div class="overlay-stats-card">
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">RECORD SCORE</span>
          <span class="overlay-stat-val" id="startBestScore">0 pts</span>
        </div>
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">DEEPEST SECTOR</span>
          <span class="overlay-stat-val" id="startBestSector" style="color: var(--primary);">Sector 1</span>
        </div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-primary" onclick="initiateGameRun()">
          ▶ INITIATE OVERRIDE
        </button>
        <div class="menu-actions-row">
          <button class="btn-cyber btn-secondary" onclick="openProtocolModal()">
            ⚙ PROTOCOL & INTEL
          </button>
          <button class="btn-cyber btn-secondary" onclick="cyberNavigate('../index.jsp')">
            ‹ HUB
          </button>
        </div>
      </div>
    </div>

    <!-- CORE MELTDOWN (GAME OVER) OVERLAY -->
    <div class="overlay-screen" id="gameOverOverlay" style="display: none;">
      <div class="overlay-tag" style="color: var(--danger); border-color: rgba(244, 63, 94, 0.4); background: rgba(244, 63, 94, 0.1);">
        CRITICAL FAILURE // CORE MELTDOWN
      </div>
      <div class="overlay-icon">💥</div>
      <div class="overlay-title" style="background: linear-gradient(135deg, #fff, #f43f5e);">MELTDOWN IMMINENT</div>
      <div class="overlay-subtitle" id="gameOverReason">
        Coolant reserves exhausted. Reactor containment was breached.
      </div>

      <div class="overlay-stats-card">
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">FINAL SCORE</span>
          <span class="overlay-stat-val" id="finalScoreVal">0 pts</span>
        </div>
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">SECTOR REACHED</span>
          <span class="overlay-stat-val" id="finalSectorVal" style="color: var(--primary);">Sector 1</span>
        </div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-primary" onclick="initiateGameRun()">
          ↻ REBOOT COOLANT
        </button>
        <div class="menu-actions-row">
          <button class="btn-cyber btn-secondary" onclick="openProtocolModal()">
            ⚙ PROTOCOL
          </button>
          <button class="btn-cyber btn-secondary" onclick="cyberNavigate('../index.jsp')">
            ‹ RETURN TO HUB
          </button>
        </div>
      </div>
    </div>

    <!-- EXPANSION NOTIFICATION BANNER -->
    <div class="expansion-banner" id="expansionBanner">
      <div style="font-size: 2.2rem; margin-bottom: 4px;">⚡</div>
      <div style="font-size: 1.35rem; font-weight: 900; color: var(--primary); letter-spacing: 1px;">REACTOR EXPANDING!</div>
      <div style="font-size: 0.82rem; color: var(--text-muted); margin: 6px 0;" id="expansionText">Upgrading to 4x4 Core Matrix...</div>
      <div style="font-size: 0.72rem; color: var(--accent); font-weight: 800; letter-spacing: 1px;">+1.0s COOLANT EXTENSION</div>
    </div>

  </div>
</div>

<!-- PROTOCOL & INTEL MODAL -->
<div class="modal-wrapper" id="protocolModal">
  <div class="modal-box">
    <div class="modal-title">
      <span>☢️</span> REACTOR PROTOCOL INTEL
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>👁</span> OBSERVATION & SEQUENCE REPLICATION</div>
      <div class="intel-text">
        At the start of each stage, random reactor blocks flash with bright cyan radiation and emit distinct frequency chimes. Memorize the pattern, then tap the blocks in the exact same sequence to stabilize the core.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>⏱</span> 10-SECOND TIMER & +1s EXTENSION</div>
      <div class="intel-text">
        You begin with 10.0 seconds of emergency coolant. Every time you successfully complete a sequence puzzle, 1.0 second is added to your clock! Maintain your tempo to keep the reactor from melting down.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>📈</span> DYNAMIC PROGRESSION & 4x4 UPGRADE</div>
      <div class="intel-text">
        The challenge starts with 1 glowing tile, then 2, 3, 4, up to 5 tiles. Once you clear 5 tiles (one more than half of the 3x3 grid's 9 tiles), the core automatically upgrades into a 4x4 grid starting from 6 glowing tiles!
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>🛡</span> CONTAINMENT INTEGRITY SHIELDS</div>
      <div class="intel-text">
        You have 3 reactor containment shields. Clicking an incorrect block incurs a strike and triggers an emergency alarm, giving you a chance to recover. Three strikes cause an immediate catastrophic meltdown.
      </div>
    </div>

    <button class="btn-cyber btn-primary" style="width: 100%; margin-top: 0.8rem;" onclick="closeProtocolModal()">
      ACKNOWLEDGE & RETURN
    </button>
  </div>
</div>

<!-- Modular External Game Engine -->
<script src="js/engine.js"></script>
</body>
</html>
