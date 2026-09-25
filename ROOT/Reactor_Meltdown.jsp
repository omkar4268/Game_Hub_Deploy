<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<style>
  :root {
    --bg-base: #030712;
    --card-bg: rgba(13, 19, 36, 0.88);
    --border-glow: rgba(56, 189, 248, 0.35);
    --primary: #38bdf8;
    --primary-rgb: 56, 189, 248;
    --accent: #22c55e;
    --accent-glow: rgba(34, 197, 94, 0.45);
    --warning: #facc15;
    --danger: #f43f5e;
    --danger-glow: rgba(244, 63, 94, 0.55);
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --grid-size: 3;
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    -webkit-tap-highlight-color: transparent;
    user-select: none;
  }

  body {
    background-color: var(--bg-base);
    color: var(--text-main);
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 0.6rem;
    overflow-x: hidden;
    position: relative;
  }

  /* Nuclear Reactor Ambient Background */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 50% 30%, rgba(56, 189, 248, 0.12) 0%, transparent 60%),
      radial-gradient(circle at 50% 80%, rgba(244, 63, 94, 0.08) 0%, transparent 50%),
      linear-gradient(rgba(255,255,255,0.015) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.015) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 32px 32px, 32px 32px;
    z-index: -1;
    pointer-events: none;
  }

  .game-arena {
    width: 100%;
    max-width: 480px;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
  }

  /* Header Bar */
  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-bottom: 0.5rem;
  }

  .header-left {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .header-title {
    font-size: 1.25rem;
    font-weight: 900;
    letter-spacing: 1.5px;
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--accent) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .header-badge {
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.4);
    color: var(--primary);
    font-size: 0.68rem;
    padding: 3px 8px;
    border-radius: 6px;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
  }

  .header-controls {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .btn-icon {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    width: 38px;
    height: 38px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.05rem;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  .btn-icon:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: var(--primary);
    transform: translateY(-1px);
  }

  .btn-hub {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    padding: 0.42rem 0.85rem;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.82rem;
    font-weight: 700;
    text-decoration: none;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    gap: 5px;
  }
  .btn-hub:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: var(--primary);
    transform: translateY(-1px);
  }

  /* Containment HUD Panel */
  .hud-panel {
    width: 100%;
    background: var(--card-bg);
    border: 1px solid rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(12px);
    border-radius: 14px;
    padding: 0.6rem 0.9rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
    gap: 8px;
  }

  .hud-stat {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
  }
  .hud-label {
    font-size: 0.65rem;
    font-weight: 800;
    color: var(--text-muted);
    letter-spacing: 1px;
    text-transform: uppercase;
  }
  .hud-value {
    font-size: 1.25rem;
    font-weight: 900;
    color: var(--text-main);
    letter-spacing: 0.5px;
    font-variant-numeric: tabular-nums;
  }
  .hud-value.glow-accent {
    color: var(--primary);
    text-shadow: 0 0 10px rgba(56, 189, 248, 0.4);
  }
  .hud-value.glow-warning {
    color: var(--warning);
    text-shadow: 0 0 10px rgba(250, 204, 21, 0.4);
  }
  .hud-value.glow-danger {
    color: var(--danger);
    text-shadow: 0 0 12px var(--danger-glow);
    animation: criticalPulse 0.8s infinite alternate;
  }
  @keyframes criticalPulse {
    from { opacity: 0.75; transform: scale(1); }
    to { opacity: 1; transform: scale(1.08); }
  }

  .reactor-status-box {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: rgba(0, 0, 0, 0.35);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    padding: 0.35rem 0.65rem;
  }
  .reactor-status-title {
    font-size: 0.65rem;
    font-weight: 800;
    color: var(--text-muted);
    letter-spacing: 1px;
    display: flex;
    align-items: center;
    gap: 5px;
    margin-bottom: 2px;
  }
  .reactor-status-text {
    font-size: 0.85rem;
    font-weight: 900;
    color: var(--accent);
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }

  /* Reactor Shields / Strikes */
  .shields-container {
    display: flex;
    gap: 4px;
    margin-top: 3px;
  }
  .shield-pip {
    width: 14px;
    height: 5px;
    border-radius: 2px;
    background: var(--accent);
    box-shadow: 0 0 6px var(--accent);
    transition: all 0.2s ease;
  }
  .shield-pip.lost {
    background: rgba(244, 63, 94, 0.3);
    box-shadow: none;
    border: 1px solid rgba(244, 63, 94, 0.5);
  }

  /* Countdown Timer Bar */
  .timer-bar-wrap {
    width: 100%;
    height: 6px;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 999px;
    margin-bottom: 0.6rem;
    overflow: hidden;
    position: relative;
  }
  .timer-bar-fill {
    height: 100%;
    width: 100%;
    background: linear-gradient(90deg, var(--danger), var(--warning), var(--primary));
    box-shadow: 0 0 10px var(--primary);
    transition: width 0.1s linear;
  }

  /* Reactor Core Console Chassis */
  .reactor-chassis {
    position: relative;
    width: 100%;
    max-width: 440px;
    aspect-ratio: 1 / 1;
    background: rgba(8, 14, 28, 0.92);
    border: 2px solid rgba(56, 189, 248, 0.35);
    border-radius: 20px;
    padding: 12px;
    box-shadow: 0 12px 45px rgba(0, 0, 0, 0.8), inset 0 0 30px rgba(56, 189, 248, 0.06);
    backdrop-filter: blur(16px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    overflow: hidden;
  }

  /* Dynamic Reactor Tile Grid */
  .reactor-grid {
    display: grid;
    grid-template-columns: repeat(var(--grid-size), 1fr);
    grid-template-rows: repeat(var(--grid-size), 1fr);
    gap: 8px;
    width: 100%;
    height: 100%;
  }

  /* Individual Reactor Tile Key */
  .reactor-tile {
    position: relative;
    background: radial-gradient(circle at 35% 35%, rgba(15, 23, 42, 0.9) 0%, rgba(3, 7, 18, 0.95) 100%);
    border: 2px solid rgba(56, 189, 248, 0.2);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: clamp(1.1rem, 4vw, 1.6rem);
    font-weight: 900;
    color: rgba(255, 255, 255, 0.2);
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5), inset 0 0 10px rgba(0, 0, 0, 0.6);
    transition: transform 0.15s cubic-bezier(0.2, 0.8, 0.2, 1), border-color 0.15s ease, background 0.15s ease;
    touch-action: manipulation;
  }

  .reactor-tile::before {
    content: '';
    position: absolute;
    inset: 4px;
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.04);
    pointer-events: none;
  }

  .reactor-tile:active {
    transform: scale(0.92);
  }

  /* SYSTEM BROADCAST / GLOWING STATE */
  .reactor-tile.flash-active {
    background: radial-gradient(circle at 50% 50%, #38bdf8 0%, #0284c7 60%, #0369a1 100%);
    border-color: #ffffff;
    box-shadow: 0 0 30px #38bdf8, 0 0 50px rgba(56, 189, 248, 0.8), inset 0 0 20px #ffffff;
    transform: scale(1.05);
    color: #ffffff;
    z-index: 5;
  }

  /* CORRECT PLAYER TAP FEEDBACK */
  .reactor-tile.correct-tap {
    background: radial-gradient(circle at 50% 50%, #22c55e 0%, #16a34a 60%, #15803d 100%);
    border-color: #ffffff;
    box-shadow: 0 0 30px #22c55e, inset 0 0 15px #ffffff;
    transform: scale(1.04);
    color: #ffffff;
    z-index: 5;
  }

  /* WRONG PLAYER TAP HAZARD FLASH */
  .reactor-tile.wrong-tap {
    background: radial-gradient(circle at 50% 50%, #f43f5e 0%, #dc2626 60%, #991b1b 100%);
    border-color: #ffffff;
    box-shadow: 0 0 35px #f43f5e, inset 0 0 20px #ffffff;
    transform: scale(1.06);
    color: #ffffff;
    animation: wrongShake 0.3s ease-in-out;
    z-index: 10;
  }
  @keyframes wrongShake {
    0%, 100% { transform: translate(0, 0) scale(1.06); }
    25% { transform: translate(-8px, 0) scale(1.06); }
    50% { transform: translate(8px, 0) scale(1.06); }
    75% { transform: translate(-5px, 0) scale(1.06); }
  }

  /* Screen Shockwave Flash on Strike */
  .reactor-shockwave {
    position: absolute;
    inset: 0;
    background: rgba(244, 63, 94, 0.25);
    z-index: 20;
    pointer-events: none;
    opacity: 0;
    transition: opacity 0.2s ease;
  }
  .reactor-shockwave.active {
    opacity: 1;
  }

  /* Expansion Notification Banner */
  .expansion-banner {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.9);
    background: rgba(8, 14, 28, 0.96);
    border: 2px solid var(--primary);
    box-shadow: 0 0 45px rgba(56, 189, 248, 0.7);
    border-radius: 18px;
    padding: 1.4rem 2rem;
    text-align: center;
    z-index: 40;
    opacity: 0;
    pointer-events: none;
    transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  }
  .expansion-banner.show {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
    pointer-events: all;
  }

  /* Overlays: Startup, Meltdown (Game Over), Protocol */
  .overlay-screen {
    position: absolute;
    inset: 0;
    background: rgba(3, 5, 10, 0.95);
    backdrop-filter: blur(14px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.4rem 1.2rem;
    text-align: center;
    z-index: 50;
    border-radius: 20px;
    animation: fadeIn 0.25s ease forwards;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: scale(0.97); }
    to { opacity: 1; transform: scale(1); }
  }

  .overlay-tag {
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: var(--primary);
    background: rgba(56, 189, 248, 0.12);
    border: 1px solid rgba(56, 189, 248, 0.35);
    padding: 4px 12px;
    border-radius: 999px;
    text-transform: uppercase;
    margin-bottom: 0.6rem;
  }

  .overlay-icon {
    font-size: 2.8rem;
    margin-bottom: 0.3rem;
    filter: drop-shadow(0 0 15px rgba(56, 189, 248, 0.6));
  }

  .overlay-title {
    font-size: 1.55rem;
    font-weight: 900;
    letter-spacing: 1.5px;
    margin-bottom: 0.35rem;
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--accent) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .overlay-subtitle {
    font-size: 0.85rem;
    color: var(--text-muted);
    line-height: 1.45;
    margin-bottom: 1.1rem;
    max-width: 360px;
  }

  .overlay-stats-card {
    display: flex;
    justify-content: space-around;
    background: rgba(15, 23, 42, 0.75);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 12px;
    padding: 0.65rem 1.2rem;
    margin-bottom: 1.2rem;
    width: 100%;
    max-width: 360px;
  }
  .overlay-stat-col {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .overlay-stat-label {
    font-size: 0.65rem;
    font-weight: 800;
    color: var(--text-muted);
    letter-spacing: 1px;
    text-transform: uppercase;
  }
  .overlay-stat-val {
    font-size: 1.35rem;
    font-weight: 900;
    color: var(--primary);
  }

  /* Action Buttons & Side-by-Side Mobile Layout */
  .menu-actions {
    display: flex;
    flex-direction: column;
    gap: 0.65rem;
    width: 100%;
    max-width: 360px;
  }

  .menu-actions-row {
    display: flex;
    flex-direction: row;
    gap: 0.65rem;
    width: 100%;
  }

  .btn-cyber {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 0.88rem;
    font-weight: 800;
    letter-spacing: 1px;
    padding: 0.75rem 1.2rem;
    min-height: 48px;
    border-radius: 12px;
    cursor: pointer;
    text-decoration: none;
    transition: all 0.2s cubic-bezier(0.2, 0.8, 0.2, 1);
    border: 1px solid transparent;
    text-transform: uppercase;
  }

  .btn-primary {
    background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
    color: #ffffff;
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.4);
  }
  .btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 0 25px rgba(56, 189, 248, 0.6);
  }

  .btn-secondary {
    background: rgba(255, 255, 255, 0.06);
    border-color: rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    flex: 1;
  }
  .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.14);
    border-color: var(--primary);
    transform: translateY(-2px);
  }

  /* Universal Cyber-Scanner Wipe Transition */
  .cyber-wipe-overlay {
    position: fixed;
    inset: 0;
    pointer-events: none;
    z-index: 99999;
    opacity: 0;
    overflow: hidden;
  }
  .cyber-wipe-overlay.active {
    pointer-events: all;
    opacity: 1;
  }
  .cyber-wipe-beam {
    position: absolute;
    top: 0;
    left: -100vw;
    width: 100vw;
    height: 100vh;
    height: 100dvh;
    background: linear-gradient(90deg, transparent 0%, rgba(56, 189, 248, 0.1) 60%, rgba(56, 189, 248, 0.5) 92%, #38bdf8 98%, #ffffff 100%);
    box-shadow: 12px 0 35px rgba(56, 189, 248, 0.8), 2px 0 15px #22c55e;
    transform: translate3d(0, 0, 0);
  }
  .cyber-wipe-overlay.active .cyber-wipe-beam {
    animation: cyberBeamSweep 0.26s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  @keyframes cyberBeamSweep {
    0% { transform: translateX(0); }
    100% { transform: translateX(200vw); }
  }

  /* Protocol & Intel Modal */
  .modal-wrapper {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.85);
    backdrop-filter: blur(12px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    padding: 1rem;
  }
  .modal-wrapper.active {
    display: flex;
  }
  .modal-box {
    background: #0d1324;
    border: 1px solid var(--primary);
    box-shadow: 0 0 35px rgba(56, 189, 248, 0.35);
    border-radius: 18px;
    padding: 1.4rem;
    max-width: 480px;
    width: 100%;
    max-height: 85vh;
    overflow-y: auto;
  }
  .modal-title {
    font-size: 1.3rem;
    font-weight: 900;
    color: var(--primary);
    margin-bottom: 0.8rem;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .intel-item {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.07);
    border-radius: 10px;
    padding: 0.75rem;
    margin-bottom: 0.65rem;
    text-align: left;
  }
  .intel-head {
    font-weight: 800;
    font-size: 0.85rem;
    color: var(--accent);
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .intel-text {
    font-size: 0.78rem;
    color: var(--text-muted);
    line-height: 1.4;
  }

  /* Mobile Responsive Polish (Max-Width: 640px) */
  @media (max-width: 640px) {
    body { padding: 0.4rem; }
    .game-arena { max-width: 100%; width: 100%; }
    .header-title { font-size: 1.15rem; }
    .hud-panel { padding: 0.5rem 0.75rem; gap: 6px; }
    .hud-value { font-size: 1.1rem; }
    .reactor-chassis { max-width: min(390px, 94vw); padding: 8px; border-radius: 16px; }
    .reactor-grid { gap: 6px; }
    .reactor-tile { border-radius: 8px; font-size: clamp(0.95rem, 4.5vw, 1.35rem); }
    .overlay-screen { padding: 1rem 0.85rem; }
    .overlay-icon { font-size: 2.2rem; margin-bottom: 0.2rem; }
    .overlay-title { font-size: 1.3rem; margin-bottom: 0.2rem; }
    .overlay-subtitle { font-size: 0.78rem; line-height: 1.35; margin-bottom: 0.8rem; }
    .overlay-stats-card { padding: 0.45rem 0.9rem; margin-bottom: 0.9rem; }
    .overlay-stat-val { font-size: 1.15rem; }
    .btn-cyber { min-height: 44px; padding: 0.6rem 0.8rem; font-size: 0.8rem; border-radius: 10px; }
    .menu-actions-row { display: flex; flex-direction: row; gap: 0.5rem; width: 100%; }
  }
</style>
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
      <button class="btn-hub" onclick="cyberNavigate('index.jsp')">‹ HUB</button>
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
          <button class="btn-cyber btn-secondary" onclick="cyberNavigate('index.jsp')">
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
          <button class="btn-cyber btn-secondary" onclick="cyberNavigate('index.jsp')">
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

<script>
  /* =========================================================
     AUDIO SYNTHESIZER (WEB AUDIO API - ZERO ASSETS)
     ========================================================= */
  let audioCtx = null;
  let soundEnabled = true;

  function initAudio() {
    if (!audioCtx) {
      const AudioContext = window.AudioContext || window.webkitAudioContext;
      if (AudioContext) audioCtx = new AudioContext();
    }
    if (audioCtx && audioCtx.state === 'suspended') {
      audioCtx.resume();
    }
  }

  function toggleSound() {
    soundEnabled = !soundEnabled;
    const btn = document.getElementById('soundBtn');
    if (btn) btn.innerText = soundEnabled ? '🔊' : '🔇';
  }

  function playSynth(type, param = 0) {
    if (!soundEnabled) return;
    initAudio();
    if (!audioCtx) return;

    try {
      const now = audioCtx.currentTime;

      if (type === 'beep') {
        // High-tech reactor tile flash tone (pitch varies by tile index)
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sine';

        // Pentatonic-inspired frequency ladder
        const baseFreqs = [261.63, 293.66, 329.63, 392.00, 440.00, 523.25, 587.33, 659.25, 783.99, 880.00, 987.77, 1046.50, 1174.66, 1318.51, 1396.91, 1567.98];
        const freq = baseFreqs[param % baseFreqs.length] || 440;

        osc.frequency.setValueAtTime(freq, now);
        gain.gain.setValueAtTime(0.2, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.18);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.18);

      } else if (type === 'tap') {
        // Crisp touch click
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(600, now);
        osc.frequency.exponentialRampToValueAtTime(800, now + 0.05);

        gain.gain.setValueAtTime(0.15, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.05);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.05);

      } else if (type === 'strike') {
        // Emergency hazard klaxon
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(140, now);
        osc.frequency.setValueAtTime(110, now + 0.1);

        gain.gain.setValueAtTime(0.3, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.25);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.25);

      } else if (type === 'stage_clear') {
        // Stabilization chime chord
        [523.25, 659.25, 783.99].forEach((freq, idx) => {
          const osc = audioCtx.createOscillator();
          const gain = audioCtx.createGain();
          osc.type = 'sine';
          osc.frequency.setValueAtTime(freq, now + idx * 0.04);

          gain.gain.setValueAtTime(0.18, now + idx * 0.04);
          gain.gain.exponentialRampToValueAtTime(0.01, now + idx * 0.04 + 0.2);

          osc.connect(gain);
          gain.connect(audioCtx.destination);
          osc.start(now + idx * 0.04);
          osc.stop(now + idx * 0.04 + 0.2);
        });

      } else if (type === 'expand') {
        // Matrix expansion sweep
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(220, now);
        osc.frequency.exponentialRampToValueAtTime(880, now + 0.4);

        gain.gain.setValueAtTime(0.25, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.4);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.4);

      } else if (type === 'meltdown') {
        // Descending low catastrophic explosion drone
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(160, now);
        osc.frequency.exponentialRampToValueAtTime(30, now + 0.6);

        gain.gain.setValueAtTime(0.35, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.6);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.6);
      }
    } catch (e) {
      // Audio fallback
    }
  }

  /* =========================================================
     GAME CONFIGURATION & PROGRESSIVE STATE
     ========================================================= */
  let currentGridSize = 3;  // Starts 3x3, upgrades to 4x4, then 5x5
  let sequenceLength = 1;   // Starts with 1 glowing tile, increments by 1
  let currentSequence = []; // Array of tile indices [0..(N*N-1)]
  let playerInputIndex = 0; // Current position in sequence user is typing

  let score = 0;
  let remainingTime = 10.0; // Starts at 10.0s, +1.0s per puzzle
  let maxTimeRef = 10.0;
  let timerInterval = null;

  let shields = 3;          // 3 containment integrity shields
  let isBroadcasting = false;
  let isGameOver = false;

  // DOM Elements
  const reactorGrid = document.getElementById('reactorGrid');
  const timerBar = document.getElementById('timerBar');
  const timeDisplay = document.getElementById('timeDisplay');
  const scoreDisplay = document.getElementById('scoreDisplay');
  const sectorBadge = document.getElementById('sectorBadge');
  const statusMessage = document.getElementById('statusMessage');
  const sequenceProgressPill = document.getElementById('sequenceProgressPill');
  const shockwave = document.getElementById('shockwave');
  const expansionBanner = document.getElementById('expansionBanner');
  const expansionText = document.getElementById('expansionText');

  const startupOverlay = document.getElementById('startupOverlay');
  const gameOverOverlay = document.getElementById('gameOverOverlay');
  const protocolModal = document.getElementById('protocolModal');

  /* =========================================================
     LIFECYCLE & STATS
     ========================================================= */
  window.addEventListener('DOMContentLoaded', () => {
    loadCachedStats();
  });

  function loadCachedStats() {
    const high = localStorage.getItem('hub_reactor_high') || '0';
    const sector = localStorage.getItem('hub_reactor_stage') || 'Sector 1';
    const sBest = document.getElementById('startBestScore');
    const sSec = document.getElementById('startBestSector');
    if (sBest) sBest.innerText = high + ' pts';
    if (sSec) sSec.innerText = sector;
  }

  function initiateGameRun() {
    initAudio();
    startupOverlay.style.display = 'none';
    gameOverOverlay.style.display = 'none';
    expansionBanner.classList.remove('show');

    score = 0;
    currentGridSize = 3;
    sequenceLength = 1;
    remainingTime = 10.0;
    maxTimeRef = 10.0;
    shields = 3;
    isGameOver = false;

    updateShieldsUI();
    setupStage();
  }

  /* =========================================================
     STAGE SETUP & PROGRESSIVE GRID UPGRADE LOGIC
     ========================================================= */
  function setupStage() {
    stopTimer();

    // Check if sequenceLength exceeds "at least one more than half the tiles" of the current grid
    // For 3x3: total tiles = 9. Half = 4.5. One more than half = 5.
    // If sequenceLength > 5 (i.e. was 5, now advancing), upgrade to 4x4!
    const totalTiles = currentGridSize * currentGridSize;
    const upgradeThreshold = Math.floor(totalTiles / 2) + 1;

    if (sequenceLength > upgradeThreshold && currentGridSize < 5) {
      // Upgrade Grid Size!
      currentGridSize++;
      document.documentElement.style.setProperty('--grid-size', currentGridSize);
      sectorBadge.innerText = `${currentGridSize}x${currentGridSize} SECTOR`;

      showExpansionBanner();
      playSynth('expand');

      setTimeout(() => {
        renderReactorGrid();
        startStageSequence();
      }, 1500);
      return;
    }

    document.documentElement.style.setProperty('--grid-size', currentGridSize);
    sectorBadge.innerText = `${currentGridSize}x${currentGridSize} SECTOR`;

    renderReactorGrid();
    startStageSequence();
  }

  function showExpansionBanner() {
    expansionText.innerText = `Upgrading to ${currentGridSize}x${currentGridSize} Core Matrix...`;
    expansionBanner.classList.add('show');
    setTimeout(() => {
      expansionBanner.classList.remove('show');
    }, 1400);
  }

  function renderReactorGrid() {
    reactorGrid.innerHTML = '';
    const totalTiles = currentGridSize * currentGridSize;

    for (let i = 0; i < totalTiles; i++) {
      const tile = document.createElement('div');
      tile.className = 'reactor-tile';
      tile.dataset.index = i;
      tile.innerText = (i + 1);

      tile.addEventListener('click', () => handleTileClick(i));
      reactorGrid.appendChild(tile);
    }
  }

  /* =========================================================
     SEQUENCE GENERATION & BROADCAST PLAYBACK
     ========================================================= */
  async function startStageSequence() {
    isBroadcasting = true;
    playerInputIndex = 0;
    updateHUD();

    statusMessage.innerText = 'MEMORIZING SYSTEM SEQUENCE...';
    statusMessage.style.color = 'var(--primary)';
    sequenceProgressPill.innerText = `${sequenceLength} TILE${sequenceLength > 1 ? 'S' : ''}`;

    // Generate random sequence of tile indices
    currentSequence = [];
    const totalTiles = currentGridSize * currentGridSize;
    for (let i = 0; i < sequenceLength; i++) {
      const randomTileIndex = Math.floor(Math.random() * totalTiles);
      currentSequence.push(randomTileIndex);
    }

    await delay(500);

    // Broadcast Phase: Flash tiles one by one
    for (let i = 0; i < currentSequence.length; i++) {
      if (isGameOver) return;
      const tileIndex = currentSequence[i];
      await flashTile(tileIndex, 360, 160);
    }

    if (isGameOver) return;

    // Operator Input Phase Starts!
    isBroadcasting = false;
    statusMessage.innerText = 'AWAITING INPUT: CLICK IN SEQUENCE';
    statusMessage.style.color = 'var(--accent)';

    startTimer();
  }

  async function flashTile(tileIndex, onDuration = 350, offDuration = 150) {
    const tileEl = document.querySelector(`.reactor-tile[data-index='${tileIndex}']`);
    if (!tileEl) return;

    tileEl.classList.add('flash-active');
    playSynth('beep', tileIndex);

    await delay(onDuration);
    tileEl.classList.remove('flash-active');
    await delay(offDuration);
  }

  /* =========================================================
     OPERATOR INPUT & REPLICATION VERIFICATION
     ========================================================= */
  async function handleTileClick(clickedIndex) {
    if (isBroadcasting || isGameOver) return;

    const tileEl = document.querySelector(`.reactor-tile[data-index='${clickedIndex}']`);
    const expectedIndex = currentSequence[playerInputIndex];

    if (clickedIndex === expectedIndex) {
      // Correct Input!
      playSynth('tap');
      playSynth('beep', clickedIndex);

      if (tileEl) {
        tileEl.classList.add('correct-tap');
        setTimeout(() => tileEl.classList.remove('correct-tap'), 180);
      }

      playerInputIndex++;

      // Check if sequence completed
      if (playerInputIndex >= currentSequence.length) {
        await handleSequenceSuccess();
      }

    } else {
      // Wrong Input!
      await handleSequenceFailure(clickedIndex);
    }
  }

  async function handleSequenceSuccess() {
    isBroadcasting = true;
    stopTimer();
    playSynth('stage_clear');

    statusMessage.innerText = 'STABILIZED! +1.0s EXTENSION';
    statusMessage.style.color = 'var(--accent)';

    // Add +1 second to timer
    remainingTime += 1.0;
    maxTimeRef = Math.max(maxTimeRef, remainingTime);

    // Calculate score
    const points = sequenceLength * 50 + Math.floor(remainingTime * 10);
    score += points;
    updateHUD();

    await delay(600);

    // Advance sequence length
    sequenceLength++;
    setupStage();
  }

  async function handleSequenceFailure(wrongIndex) {
    isBroadcasting = true;
    playSynth('strike');

    // Trigger visual shockwave & shake wrong tile
    shockwave.classList.add('active');
    const tileEl = document.querySelector(`.reactor-tile[data-index='${wrongIndex}']`);
    if (tileEl) tileEl.classList.add('wrong-tap');

    shields--;
    updateShieldsUI();

    await delay(350);
    shockwave.classList.remove('active');
    if (tileEl) tileEl.classList.remove('wrong-tap');

    // Check Meltdown (Game Over if shields depleted)
    if (shields <= 0) {
      triggerMeltdown('Reactor containment shields collapsed under repeated input anomalies.');
      return;
    }

    statusMessage.innerText = 'INPUT ERROR // RE-BROADCASTING';
    statusMessage.style.color = 'var(--danger)';

    await delay(700);

    // Replay current sequence so player can try again
    playerInputIndex = 0;
    for (let i = 0; i < currentSequence.length; i++) {
      if (isGameOver) return;
      await flashTile(currentSequence[i], 340, 140);
    }

    if (isGameOver) return;
    isBroadcasting = false;
    statusMessage.innerText = 'AWAITING INPUT: CLICK IN SEQUENCE';
    statusMessage.style.color = 'var(--accent)';
  }

  /* =========================================================
     COUNTDOWN TIMER SYSTEM
     ========================================================= */
  function startTimer() {
    stopTimer();
    const tickRate = 50; // ms

    timerInterval = setInterval(() => {
      if (isGameOver || isBroadcasting) return;

      remainingTime -= (tickRate / 1000);
      if (remainingTime <= 0) {
        remainingTime = 0;
        updateHUD();
        stopTimer();
        triggerMeltdown('Coolant exhausted. Temperature spike caused immediate core meltdown.');
        return;
      }
      updateHUD();
    }, tickRate);
  }

  function stopTimer() {
    if (timerInterval) {
      clearInterval(timerInterval);
      timerInterval = null;
    }
  }

  /* =========================================================
     UI UPDATES & SHIELD GAUGES
     ========================================================= */
  function updateHUD() {
    scoreDisplay.innerText = score.toString().padStart(4, '0');
    timeDisplay.innerText = remainingTime.toFixed(1) + 's';

    // Timer Bar Percentage
    const pct = Math.min(100, Math.max(0, (remainingTime / maxTimeRef) * 100));
    timerBar.style.width = pct + '%';

    if (remainingTime <= 3.0) {
      timeDisplay.className = 'hud-value glow-danger';
      timerBar.style.background = 'var(--danger)';
    } else if (remainingTime <= 6.0) {
      timeDisplay.className = 'hud-value glow-warning';
      timerBar.style.background = 'linear-gradient(90deg, var(--danger), var(--warning))';
    } else {
      timeDisplay.className = 'hud-value glow-accent';
      timerBar.style.background = 'linear-gradient(90deg, var(--danger), var(--warning), var(--primary))';
    }
  }

  function updateShieldsUI() {
    document.getElementById('shield1').className = 'shield-pip ' + (shields < 1 ? 'lost' : '');
    document.getElementById('shield2').className = 'shield-pip ' + (shields < 2 ? 'lost' : '');
    document.getElementById('shield3').className = 'shield-pip ' + (shields < 3 ? 'lost' : '');
  }

  /* =========================================================
     MELTDOWN (GAME OVER) & CLOUD LEADERBOARD TELEMETRY
     ========================================================= */
  function triggerMeltdown(reason) {
    isGameOver = true;
    stopTimer();
    playSynth('meltdown');

    document.getElementById('finalScoreVal').innerText = score + ' pts';
    document.getElementById('finalSectorVal').innerText = `Sector ${sequenceLength} (${currentGridSize}x${currentGridSize})`;
    document.getElementById('gameOverReason').innerText = reason;
    gameOverOverlay.style.display = 'flex';

    saveScoreRecords(score);
  }

  function saveScoreRecords(finalScore) {
    // Local telemetry
    const prevBest = parseInt(localStorage.getItem('hub_reactor_high') || '0', 10);
    if (finalScore > prevBest) {
      localStorage.setItem('hub_reactor_high', finalScore);
    }
    const prevSec = localStorage.getItem('hub_reactor_stage') || 'Sector 1';
    const prevSecNum = parseInt(prevSec.replace(/\D/g, '') || '1', 10);
    if (sequenceLength > prevSecNum) {
      localStorage.setItem('hub_reactor_stage', 'Sector ' + sequenceLength);
    }

    // Database cloud sync
    saveScoreToDatabase(finalScore);
  }

  async function saveScoreToDatabase(finalScore) {
    try {
      const params = new URLSearchParams();
      params.append('game', 'reactor_meltdown');
      params.append('score', finalScore);

      const response = await fetch('save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
      });

      if (response.ok) {
        const data = await response.json();
        const reasonEl = document.getElementById('gameOverReason');
        if (reasonEl && data.success) {
          reasonEl.innerHTML = '<span style="color: var(--accent);">✓ High score synchronized to cloud leaderboard!</span>';
        }
      }
    } catch (e) {
      console.warn('Cloud sync offline; stored in local storage.');
    }
  }

  /* =========================================================
     HELPERS & MODALS
     ========================================================= */
  function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  function openProtocolModal() {
    protocolModal.classList.add('active');
  }

  function closeProtocolModal() {
    protocolModal.classList.remove('active');
  }

  /* Cyber-Scanner Navigation Wipe Handler */
  function cyberNavigate(url) {
    const overlay = document.getElementById('cyberWipeOverlay');
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
  });
</script>
</body>
</html>
