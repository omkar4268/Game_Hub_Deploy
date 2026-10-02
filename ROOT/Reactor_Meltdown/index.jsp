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
<title>Reactor Meltdown // Quantum Core Matrix</title>

<!-- Framer Motion Browser Engine -->
<script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

<!-- Modular External Stylesheet -->
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>

<!-- Fullscreen Animated Quantum Core & Plasma Fusion Canvas -->
<canvas id="reactorBgCanvas" class="reactor-bg-canvas"></canvas>

<!-- Universal Cyber-Scanner Wipe Transition -->
<div id="cyberWipeOverlay" class="cyber-wipe-overlay">
  <div class="cyber-wipe-beam"></div>
</div>

<div class="game-arena">
  
  <!-- Header Navigation Bar -->
  <header class="header">
    <div class="header-left">
      <div class="core-mini-logo">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none">
          <circle cx="12" cy="12" r="3" fill="#38bdf8" />
          <path d="M12 2a10 10 0 0 0-8.66 5l3.46 2A6 6 0 0 1 12 6V2z" fill="url(#coreHdrGrad)" />
          <path d="M22 12a10 10 0 0 1-5 8.66l-2-3.46A6 6 0 0 0 18 12h4z" fill="url(#coreHdrGrad)" />
          <path d="M4 17.32a10 10 0 0 1 0-10.64l3.46 2A6 6 0 0 0 6 12a6 6 0 0 0 1.46 3.32L4 17.32z" fill="url(#coreHdrGrad)" />
          <defs>
            <linearGradient id="coreHdrGrad" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#ffffff"/>
              <stop offset="100%" stop-color="#38bdf8"/>
            </linearGradient>
          </defs>
        </svg>
      </div>
      <h1 class="header-title">REACTOR <span class="hollow-text">MELTDOWN</span></h1>
      <span class="header-badge" id="sectorBadge">3x3 SECTOR</span>
    </div>
    <div class="header-controls">
      <button class="btn-icon" id="soundBtn" title="Toggle Sound" onclick="toggleSound()">
        <svg id="soundOnSvg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
          <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path>
        </svg>
        <svg id="soundOffSvg" style="display:none;" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
          <line x1="23" y1="9" x2="17" y2="15"></line>
          <line x1="17" y1="9" x2="23" y2="15"></line>
        </svg>
      </button>
      <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-hub">
        <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        <span>Hub</span>
      </a>
    </div>
  </header>

  <!-- Coolant Depletion Timer Bar -->
  <div class="timer-bar-wrap">
    <div class="timer-bar-fill" id="timerBar"></div>
  </div>

  <!-- Containment HUD Panel -->
  <div class="hud-panel">
    <div class="hud-stat">
      <span class="hud-label">LIVE SCORE</span>
      <span class="hud-value glow-accent" id="scoreDisplay">0000</span>
    </div>

    <div class="reactor-status-box">
      <div class="reactor-status-title">
        <span>CORE STABILIZATION</span>
        <span id="sequenceProgressPill">1 TILE</span>
      </div>
      <div class="reactor-status-text" id="statusMessage">AWAITING SEQUENCE</div>
      <div class="shields-container" id="shieldsContainer">
        <div class="shield-pip" id="shield1">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <div class="shield-pip" id="shield2">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <div class="shield-pip" id="shield3">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
      </div>
    </div>

    <div class="hud-stat" style="align-items: flex-end;">
      <span class="hud-label">COOLANT TIME</span>
      <span class="hud-value glow-warning" id="timeDisplay">20.0s</span>
    </div>
  </div>

  <!-- Reactor Core Console Chassis (Obsidian Glass Arena) -->
  <div class="reactor-chassis" id="reactorChassis">
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

    <!-- Screen Flash Shockwave -->
    <div class="reactor-shockwave" id="shockwave"></div>

    <!-- Active Reactor Keypad Grid -->
    <div class="reactor-grid" id="reactorGrid"></div>

    <!-- PRE-GAME STARTUP SCREEN OVERLAY (Obsidian Space Glass) -->
    <div class="overlay-screen" id="startupOverlay">
      <div class="overlay-tag">
        <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
        <span>QUANTUM CORE STABILIZER</span>
      </div>

      <div class="overlay-icon">
        <svg class="reactor-trefoil-svg" viewBox="0 0 64 64" fill="none">
          <circle cx="32" cy="32" r="8" fill="url(#coreGlow)" />
          <circle cx="32" cy="32" r="4" fill="#ffffff" />
          <path d="M32 6 C24 6 18 12 18 19 C18 24 22 28 26 30 C28 27 30 25 32 25 C34 25 36 27 38 30 C42 28 46 24 46 19 C46 12 40 6 32 6 Z" fill="url(#bladeGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5" />
          <path d="M9 46 C5 39 8 30 15 26 C19 24 24 25 28 28 C26 31 25 33 25 36 C25 39 26 41 29 44 C26 47 22 49 17 49 C14 49 11 48 9 46 Z" fill="url(#bladeGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5" />
          <path d="M55 46 C57 39 54 30 47 26 C43 24 38 25 34 28 C36 31 37 33 37 36 C37 39 36 41 33 44 C36 47 40 49 45 49 C48 49 51 48 55 46 Z" fill="url(#bladeGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5" />
          <circle cx="32" cy="32" r="28" stroke="rgba(56,189,248,0.3)" stroke-width="1.5" stroke-dasharray="4 4" />
          <defs>
            <radialGradient id="coreGlow" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stop-color="#ffffff"/>
              <stop offset="60%" stop-color="#38bdf8"/>
              <stop offset="100%" stop-color="transparent"/>
            </radialGradient>
            <linearGradient id="bladeGrad" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#ffffff"/>
              <stop offset="50%" stop-color="#38bdf8"/>
              <stop offset="100%" stop-color="#0284c7"/>
            </linearGradient>
          </defs>
        </svg>
      </div>

      <h2 class="overlay-title">REACTOR <span class="hollow-text">MELTDOWN</span></h2>
      <p class="overlay-subtitle">
        Observe the random glowing reactor sequence and replicate it before emergency coolant is exhausted. Starts on a 3x3 matrix and dynamically expands into deeper sectors.
      </p>

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
        <button class="btn-cyber btn-cyber-primary" onclick="initiateGameRun()">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
          <span>ENGAGE REACTOR</span>
        </button>
        <div class="menu-actions-row">
          <button class="btn-cyber btn-cyber-secondary" onclick="openProtocolModal()">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
            <span>PROTOCOLS</span>
          </button>
          <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
            <span>HUB</span>
          </a>
        </div>
      </div>
    </div>

    <!-- CORE MELTDOWN (GAME OVER) OVERLAY -->
    <div class="overlay-screen" id="gameOverOverlay" style="display: none;">
      <div class="overlay-tag hazard-tag">
        <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        <span>CRITICAL FAILURE // CORE MELTDOWN</span>
      </div>

      <div class="overlay-icon hazard-glow">
        <svg viewBox="0 0 64 64" width="60" height="60" fill="none">
          <circle cx="32" cy="32" r="28" fill="rgba(244, 63, 94, 0.12)" stroke="rgba(244, 63, 94, 0.5)" stroke-width="2"/>
          <path d="M32 14 L50 48 L14 48 Z" stroke="#f43f5e" stroke-width="3" stroke-linejoin="round" fill="rgba(244, 63, 94, 0.2)"/>
          <line x1="32" y1="26" x2="32" y2="38" stroke="#ffffff" stroke-width="3" stroke-linecap="round"/>
          <circle cx="32" cy="44" r="2" fill="#ffffff"/>
        </svg>
      </div>

      <h2 class="overlay-title hazard-text">CONTAINMENT <span class="hollow-text" style="-webkit-text-stroke: 1.8px #f43f5e;">BREACHED</span></h2>
      <p class="overlay-subtitle" id="gameOverReason">
        Coolant reserves exhausted. The magnetic plasma trap collapsed and containment failed.
      </p>

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
        <button class="btn-cyber btn-cyber-primary" onclick="initiateGameRun()">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
          <span>REBOOT REACTOR</span>
        </button>
        <div class="menu-actions-row">
          <button class="btn-cyber btn-cyber-secondary" onclick="openProtocolModal()">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
            <span>PROTOCOLS</span>
          </button>
          <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
            <span>HUB</span>
          </a>
        </div>
      </div>
    </div>

    <!-- EXPANSION NOTIFICATION BANNER -->
    <div class="expansion-banner" id="expansionBanner">
      <div class="expansion-icon-wrap">
        <svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="#38bdf8" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
          <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>
        </svg>
      </div>
      <div class="expansion-title">REACTOR EXPANDING</div>
      <div class="expansion-text" id="expansionText">Upgrading to 4x4 Core Matrix...</div>
      <div class="expansion-bonus">+3.0s COOLANT EXTENSION</div>
    </div>

  </div>
</div>

<!-- PROTOCOL & INTEL MODAL (Obsidian Glass) -->
<div class="modal-wrapper" id="protocolModal">
  <div class="modal-box">
    <div class="modal-title">
      <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="#38bdf8" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      <span>REACTOR CONTAINMENT PROTOCOLS</span>
    </div>

    <div class="intel-item">
      <div class="intel-head">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="#38bdf8" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
        <span>SEQUENCE REPLICATION</span>
      </div>
      <div class="intel-text">
        At the start of each stage, reactor tiles flash with bright cyan radiation and emit distinct harmonic frequencies. Memorize the pattern, then tap the tiles in identical order to maintain equilibrium.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="#38bdf8" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
        <span>20-SECOND TIMER & COOLANT EXTENSION</span>
      </div>
      <div class="intel-text">
        You initiate with 20.0 seconds of emergency coolant. Each successful stabilization extends your reserve by 3.0 seconds! Maintain a swift tempo to prevent catastrophic core overheat.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="#38bdf8" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
        <span>PROGRESSIVE MATRIX UPGRADES</span>
      </div>
      <div class="intel-text">
        The core begins with 1 tile, escalating by 1 each round. Once you stabilize 5 tiles, the reactor expands into a 4x4 matrix starting from 6 tiles, demanding high-fidelity spatial recall.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="#f43f5e" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        <span>CONTAINMENT INTEGRITY SHIELDS</span>
      </div>
      <div class="intel-text">
        You are equipped with 3 containment shields. Striking an incorrect tile triggers an emergency alarm and destroys a shield. Three strikes trigger an immediate total meltdown.
      </div>
    </div>

    <button class="btn-cyber btn-cyber-primary" style="width: 100%; margin-top: 1rem;" onclick="closeProtocolModal()">
      <span>ACKNOWLEDGE & RETURN</span>
    </button>
  </div>
</div>

<!-- Modular External Game Engine -->
<script src="js/engine.js"></script>
<script src="../js/ransom_horror.js"></script>
</body>
</html>
