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
<title>Cyber Grid // Node Breaker</title>
<style>
  :root {
    --bg-base: #03050a;
    --card-bg: rgba(13, 19, 36, 0.85);
    --border-glow: rgba(168, 85, 247, 0.35);
    --primary: #a855f7;
    --primary-rgb: 168, 85, 247;
    --accent: #38bdf8;
    --accent-glow: rgba(56, 189, 248, 0.4);
    --success: #22c55e;
    --warning: #facc15;
    --danger: #f43f5e;
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --cols: 5;
    --rows: 5;
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
    padding: 0.8rem;
    overflow-x: hidden;
    position: relative;
  }

  /* Matrix background circuit grid */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 15% 20%, rgba(168, 85, 247, 0.12) 0%, transparent 45%),
      radial-gradient(circle at 85% 80%, rgba(56, 189, 248, 0.12) 0%, transparent 45%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 28px 28px, 28px 28px;
    z-index: -1;
    pointer-events: none;
  }

  /* Main Arena Container */
  .game-arena {
    width: 100%;
    max-width: 520px;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
  }

  /* Top Navigation & Status Bar */
  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-bottom: 0.6rem;
  }

  .header-left {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .header-title {
    font-size: 1.35rem;
    font-weight: 900;
    letter-spacing: 1.5px;
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--accent) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .header-badge {
    background: rgba(168, 85, 247, 0.15);
    border: 1px solid rgba(168, 85, 247, 0.4);
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
    border-color: var(--accent);
    transform: translateY(-1px);
  }

  /* HUD Info & Objective Bar */
  .hud-panel {
    width: 100%;
    background: var(--card-bg);
    border: 1px solid rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(12px);
    border-radius: 14px;
    padding: 0.65rem 1rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.6rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
    gap: 10px;
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
    color: var(--accent);
    text-shadow: 0 0 10px var(--accent-glow);
  }
  .hud-value.glow-warning {
    color: var(--warning);
    text-shadow: 0 0 10px rgba(250, 204, 21, 0.4);
  }
  .hud-value.glow-danger {
    color: var(--danger);
    text-shadow: 0 0 10px rgba(244, 63, 94, 0.6);
    animation: pulseWarning 1s infinite alternate;
  }

  @keyframes pulseWarning {
    from { opacity: 0.75; }
    to { opacity: 1; transform: scale(1.05); }
  }

  .objective-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: rgba(0, 0, 0, 0.35);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    padding: 0.35rem 0.75rem;
  }
  .objective-title {
    font-size: 0.68rem;
    font-weight: 800;
    color: var(--text-muted);
    letter-spacing: 0.8px;
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 3px;
  }
  .objective-target {
    font-size: 0.95rem;
    font-weight: 900;
    color: var(--success);
    letter-spacing: 0.5px;
  }
  .progress-bar-bg {
    width: 100%;
    height: 4px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 999px;
    margin-top: 4px;
    overflow: hidden;
  }
  .progress-bar-fill {
    height: 100%;
    width: 0%;
    background: linear-gradient(90deg, var(--primary), var(--accent));
    border-radius: 999px;
    transition: width 0.3s ease;
    box-shadow: 0 0 8px var(--accent);
  }

  /* Matrix Grid Wrapper */
  .grid-wrapper {
    position: relative;
    width: 100%;
    max-width: 480px;
    aspect-ratio: 1 / 1;
    background: rgba(10, 15, 29, 0.85);
    border: 1px solid var(--border-glow);
    border-radius: 18px;
    padding: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.7), inset 0 0 20px rgba(168, 85, 247, 0.05);
    backdrop-filter: blur(16px);
    overflow: hidden;
  }

  /* The Tactical Node Grid */
  .node-grid {
    display: grid;
    grid-template-columns: repeat(var(--cols), 1fr);
    grid-template-rows: repeat(var(--rows), 1fr);
    gap: 6px;
    width: 100%;
    height: 100%;
  }

  /* Individual Circuit Nodes */
  .node-cell {
    position: relative;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: clamp(1rem, 4vw, 1.6rem);
    transition: transform 0.16s cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 0.16s ease, filter 0.16s ease;
    border: 1px solid transparent;
    touch-action: manipulation;
  }

  .node-cell:active {
    transform: scale(0.92);
  }

  /* Color Schemes for Circuit Nodes */
  /* Cyan Data Node */
  .node-data {
    background: radial-gradient(circle at 35% 35%, rgba(56, 189, 248, 0.45) 0%, rgba(12, 74, 110, 0.75) 100%);
    border-color: rgba(56, 189, 248, 0.5);
    color: #38bdf8;
    box-shadow: 0 0 12px rgba(56, 189, 248, 0.25);
  }
  /* Emerald Quantum Node */
  .node-quantum {
    background: radial-gradient(circle at 35% 35%, rgba(34, 197, 94, 0.45) 0%, rgba(6, 78, 59, 0.75) 100%);
    border-color: rgba(34, 197, 94, 0.5);
    color: #22c55e;
    box-shadow: 0 0 12px rgba(34, 197, 94, 0.25);
  }
  /* Violet Neural Node */
  .node-neural {
    background: radial-gradient(circle at 35% 35%, rgba(168, 85, 247, 0.45) 0%, rgba(76, 29, 149, 0.75) 100%);
    border-color: rgba(168, 85, 247, 0.5);
    color: #a855f7;
    box-shadow: 0 0 12px rgba(168, 85, 247, 0.25);
  }
  /* Amber Core Node */
  .node-core {
    background: radial-gradient(circle at 35% 35%, rgba(250, 204, 21, 0.45) 0%, rgba(113, 63, 18, 0.75) 100%);
    border-color: rgba(250, 204, 21, 0.5);
    color: #facc15;
    box-shadow: 0 0 12px rgba(250, 204, 21, 0.25);
  }
  /* Crimson Firewall Node */
  .node-firewall {
    background: radial-gradient(circle at 35% 35%, rgba(244, 63, 94, 0.45) 0%, rgba(136, 19, 55, 0.75) 100%);
    border-color: rgba(244, 63, 94, 0.5);
    color: #f43f5e;
    box-shadow: 0 0 12px rgba(244, 63, 94, 0.25);
  }

  /* Hover / Selection Cluster Highlight */
  .node-cell.in-cluster {
    transform: scale(1.06);
    filter: brightness(1.35);
    z-index: 2;
  }
  .node-cell.node-data.in-cluster {
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.8), inset 0 0 10px #38bdf8;
    border-color: #38bdf8;
  }
  .node-cell.node-quantum.in-cluster {
    box-shadow: 0 0 20px rgba(34, 197, 94, 0.8), inset 0 0 10px #22c55e;
    border-color: #22c55e;
  }
  .node-cell.node-neural.in-cluster {
    box-shadow: 0 0 20px rgba(168, 85, 247, 0.8), inset 0 0 10px #a855f7;
    border-color: #a855f7;
  }
  .node-cell.node-core.in-cluster {
    box-shadow: 0 0 20px rgba(250, 204, 21, 0.8), inset 0 0 10px #facc15;
    border-color: #facc15;
  }
  .node-cell.node-firewall.in-cluster {
    box-shadow: 0 0 20px rgba(244, 63, 94, 0.8), inset 0 0 10px #f43f5e;
    border-color: #f43f5e;
  }

  /* SPECIAL NODE 1: EMP SURGE BOMB (Cluster >= 5) */
  .node-cell.special-emp {
    animation: empPulse 1.2s infinite alternate ease-in-out;
    border-width: 2px;
  }
  @keyframes empPulse {
    0% { transform: scale(1); filter: drop-shadow(0 0 5px #38bdf8); }
    100% { transform: scale(1.08); filter: drop-shadow(0 0 18px #ffffff); }
  }
  .special-badge-emp {
    position: absolute;
    top: 2px;
    right: 3px;
    font-size: 0.6rem;
    background: #38bdf8;
    color: #03050a;
    font-weight: 900;
    border-radius: 4px;
    padding: 1px 3px;
    line-height: 1;
  }

  /* SPECIAL NODE 2: QUANTUM OVERDRIVE (Cluster >= 7) */
  .node-cell.special-overdrive {
    animation: overdriveRainbow 2s infinite linear;
    border-width: 2px;
  }
  @keyframes overdriveRainbow {
    0% { filter: hue-rotate(0deg) drop-shadow(0 0 8px #a855f7); transform: rotate(0deg); }
    50% { transform: scale(1.1) rotate(180deg); }
    100% { filter: hue-rotate(360deg) drop-shadow(0 0 18px #38bdf8); transform: rotate(360deg); }
  }
  .special-badge-overdrive {
    position: absolute;
    top: 2px;
    right: 3px;
    font-size: 0.6rem;
    background: #ec4899;
    color: #ffffff;
    font-weight: 900;
    border-radius: 4px;
    padding: 1px 3px;
    line-height: 1;
  }

  /* Particle & Dissolve Animations */
  @keyframes nodePop {
    0% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.25); opacity: 0.8; filter: brightness(2); }
    100% { transform: scale(0); opacity: 0; }
  }
  .node-pop {
    animation: nodePop 0.2s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }

  @keyframes nodeDrop {
    0% { transform: translateY(-40px); opacity: 0; }
    100% { transform: translateY(0); opacity: 1; }
  }
  .node-drop {
    animation: nodeDrop 0.22s cubic-bezier(0.34, 1.4, 0.64, 1) forwards;
  }

  /* Floating Score Notification */
  .float-score {
    position: absolute;
    font-size: 1.1rem;
    font-weight: 900;
    color: #ffffff;
    text-shadow: 0 0 10px var(--accent);
    pointer-events: none;
    z-index: 10;
    animation: floatUp 0.75s ease-out forwards;
  }
  @keyframes floatUp {
    0% { transform: translateY(0) scale(0.9); opacity: 1; }
    100% { transform: translateY(-35px) scale(1.15); opacity: 0; }
  }

  /* Universal Overlays: Startup, Win, Game Over, Protocol */
  .overlay-screen {
    position: absolute;
    inset: 0;
    background: rgba(3, 5, 10, 0.94);
    backdrop-filter: blur(14px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.4rem 1.2rem;
    text-align: center;
    z-index: 50;
    border-radius: 18px;
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
    background: rgba(168, 85, 247, 0.12);
    border: 1px solid rgba(168, 85, 247, 0.35);
    padding: 4px 12px;
    border-radius: 999px;
    text-transform: uppercase;
    margin-bottom: 0.6rem;
  }

  .overlay-icon {
    font-size: 2.8rem;
    margin-bottom: 0.4rem;
    filter: drop-shadow(0 0 15px rgba(168, 85, 247, 0.6));
  }

  .overlay-title {
    font-size: 1.6rem;
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
    color: var(--accent);
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
    background: linear-gradient(135deg, var(--primary) 0%, #7c3aed 100%);
    color: #ffffff;
    box-shadow: 0 0 20px rgba(168, 85, 247, 0.4);
  }
  .btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 0 25px rgba(168, 85, 247, 0.6);
  }

  .btn-secondary {
    background: rgba(255, 255, 255, 0.06);
    border-color: rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    flex: 1;
  }
  .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.14);
    border-color: var(--accent);
    transform: translateY(-2px);
  }

  /* Stage Cleared Floating Banner */
  .stage-banner {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.9);
    background: rgba(13, 19, 36, 0.95);
    border: 1px solid var(--accent);
    box-shadow: 0 0 35px rgba(56, 189, 248, 0.6);
    border-radius: 16px;
    padding: 1.2rem 1.8rem;
    text-align: center;
    z-index: 60;
    pointer-events: none;
    opacity: 0;
    transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  }
  .stage-banner.show {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
    pointer-events: all;
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
    background: linear-gradient(90deg, transparent 0%, rgba(168, 85, 247, 0.1) 60%, rgba(168, 85, 247, 0.5) 92%, #38bdf8 98%, #ffffff 100%);
    box-shadow: 12px 0 35px rgba(56, 189, 248, 0.8), 2px 0 15px #a855f7;
    transform: translate3d(0, 0, 0);
  }
  .cyber-wipe-overlay.active .cyber-wipe-beam {
    animation: cyberBeamSweep 0.26s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  @keyframes cyberBeamSweep {
    0% { transform: translateX(0); }
    100% { transform: translateX(200vw); }
  }

  /* Modal Dialog for Protocol & Intel */
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
    box-shadow: 0 0 35px rgba(168, 85, 247, 0.35);
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
    body { padding: 0.5rem; }
    .game-arena { max-width: 100%; width: 100%; }
    .header-title { font-size: 1.15rem; }
    .hud-panel { padding: 0.5rem 0.75rem; gap: 6px; }
    .hud-value { font-size: 1.1rem; }
    .grid-wrapper { max-width: min(390px, 94vw); padding: 6px; border-radius: 16px; }
    .node-grid { gap: 4px; }
    .node-cell { border-radius: 8px; font-size: clamp(0.9rem, 4.2vw, 1.35rem); }
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
  
  <!-- Header Bar -->
  <div class="header">
    <div class="header-left">
      <span class="header-title">NODE BREAKER</span>
      <span class="header-badge" id="gridBadge">5x5 GRID</span>
    </div>
    <div class="header-controls">
      <button class="btn-icon" id="soundBtn" title="Toggle Sound" onclick="toggleSound()">🔊</button>
      <button class="btn-hub" onclick="cyberNavigate('index.jsp')">‹ HUB</button>
    </div>
  </div>

  <!-- HUD Status Bar -->
  <div class="hud-panel">
    <div class="hud-stat">
      <span class="hud-label">SCORE</span>
      <span class="hud-value glow-accent" id="scoreDisplay">0000</span>
    </div>

    <div class="objective-container">
      <div class="objective-title">
        <span>STAGE <span id="stageNum">01</span> TARGET:</span>
        <span id="targetIcon">⚡</span>
      </div>
      <div class="objective-target" id="targetProgress">0 / 14</div>
      <div class="progress-bar-bg">
        <div class="progress-bar-fill" id="progressBar"></div>
      </div>
    </div>

    <div class="hud-stat" style="align-items: flex-end;">
      <span class="hud-label">CYCLES</span>
      <span class="hud-value glow-warning" id="cyclesDisplay">18</span>
    </div>
  </div>

  <!-- Matrix Grid Canvas Wrapper -->
  <div class="grid-wrapper">
    <div class="node-grid" id="nodeGrid"></div>

    <!-- PRE-GAME STARTUP SCREEN OVERLAY -->
    <div class="overlay-screen" id="startupOverlay">
      <div class="overlay-tag">CYBER GRID // PROTOCOL</div>
      <div class="overlay-icon">💠</div>
      <div class="overlay-title">NODE BREAKER</div>
      <div class="overlay-subtitle">
        Neutralize cluster circuits, trigger cascading EMP reactions, and breach progressive 8x8 defense matrices.
      </div>

      <div class="overlay-stats-card">
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">RECORD SCORE</span>
          <span class="overlay-stat-val" id="startBestScore">0 pts</span>
        </div>
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">DEEPEST STAGE</span>
          <span class="overlay-stat-val" id="startBestStage" style="color: var(--primary);">Stage 1</span>
        </div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-primary" onclick="initiateGameRun()">
          ▶ INITIATE PROTOCOL
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

    <!-- SYSTEM LOCKDOWN (GAME OVER) OVERLAY -->
    <div class="overlay-screen" id="gameOverOverlay" style="display: none;">
      <div class="overlay-tag" style="color: var(--danger); border-color: rgba(244, 63, 94, 0.4); background: rgba(244, 63, 94, 0.1);">
        SYSTEM LOCKDOWN // CYCLES DEPLETED
      </div>
      <div class="overlay-icon">🔒</div>
      <div class="overlay-title" style="background: linear-gradient(135deg, #fff, #f43f5e);">RUN TERMINATED</div>
      <div class="overlay-subtitle" id="gameOverReason">
        Neural firewall locked out further cycle executions.
      </div>

      <div class="overlay-stats-card">
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">FINAL SCORE</span>
          <span class="overlay-stat-val" id="finalScoreVal">0 pts</span>
        </div>
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">STAGE REACHED</span>
          <span class="overlay-stat-val" id="finalStageVal" style="color: var(--primary);">Stage 1</span>
        </div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-primary" onclick="initiateGameRun()">
          ↻ REBOOT PROTOCOL
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

    <!-- STAGE COMPLETE TRANSITION BANNER -->
    <div class="stage-banner" id="stageBanner">
      <div style="font-size: 2.2rem; margin-bottom: 4px;">⚡</div>
      <div style="font-size: 1.35rem; font-weight: 900; color: var(--accent); letter-spacing: 1px;">STAGE CLEARED!</div>
      <div style="font-size: 0.8rem; color: var(--text-muted); margin: 6px 0;" id="stageBonusText">+350 Cycle Bonus</div>
      <div style="font-size: 0.72rem; color: var(--primary); font-weight: 800; letter-spacing: 1px;">EXPANDING MATRIX ARCHITECTURE...</div>
    </div>

  </div>
</div>

<!-- PROTOCOL & INTEL MODAL -->
<div class="modal-wrapper" id="protocolModal">
  <div class="modal-box">
    <div class="modal-title">
      <span>💠</span> TACTICAL SYSTEM MANUAL
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>⚡</span> CLUSTER NEUTRALIZATION</div>
      <div class="intel-text">
        Tap or click any connected cluster of 2 or more matching nodes. Neutralized nodes dissolve, causing cells above to cascade down with gravity while fresh sub-nodes spawn at the top.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>💣</span> EMP SURGE BOMB (CLUSTER ≥ 5)</div>
      <div class="intel-text">
        Forming a cluster of 5 or more matching nodes manufactures a high-yield EMP Surge Bomb. Detonating an EMP bomb wipes out a 3x3 radius regardless of node types.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>🌀</span> QUANTUM OVERDRIVE (CLUSTER ≥ 7)</div>
      <div class="intel-text">
        Achieving a massive cluster of 7+ nodes synthesizes a Quantum Overdrive Node. Triggering it vaporizes every node of that frequency across the entire grid matrix!
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>📈</span> DYNAMIC MATRIX SCALING (5x5 → 8x8)</div>
      <div class="intel-text">
        The system dynamically scales difficulty without manual selection. You begin on a compact 5x5 matrix, expanding to 6x6, 7x7, and reaching an intense 8x8 maximum cap for peak tactical replayability.
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

  function playSynth(type, pitchModifier = 1) {
    if (!soundEnabled) return;
    initAudio();
    if (!audioCtx) return;

    try {
      const now = audioCtx.currentTime;

      if (type === 'pop') {
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sine';
        const baseFreq = 340 * pitchModifier;
        osc.frequency.setValueAtTime(baseFreq, now);
        osc.frequency.exponentialRampToValueAtTime(110, now + 0.08);

        gain.gain.setValueAtTime(0.18, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.08);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.08);

      } else if (type === 'emp') {
        // Low explosive blast
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(180, now);
        osc.frequency.exponentialRampToValueAtTime(35, now + 0.25);

        gain.gain.setValueAtTime(0.35, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.25);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.25);

      } else if (type === 'overdrive') {
        // Prismatic sweep arpeggio
        [440, 554, 659, 880].forEach((freq, idx) => {
          const osc = audioCtx.createOscillator();
          const gain = audioCtx.createGain();
          osc.type = 'sawtooth';
          osc.frequency.setValueAtTime(freq, now + idx * 0.05);

          gain.gain.setValueAtTime(0.12, now + idx * 0.05);
          gain.gain.exponentialRampToValueAtTime(0.01, now + idx * 0.05 + 0.1);

          osc.connect(gain);
          gain.connect(audioCtx.destination);
          osc.start(now + idx * 0.05);
          osc.stop(now + idx * 0.05 + 0.1);
        });

      } else if (type === 'win') {
        // Stage victory fanfare
        [523.25, 659.25, 783.99, 1046.50].forEach((freq, idx) => {
          const osc = audioCtx.createOscillator();
          const gain = audioCtx.createGain();
          osc.type = 'sine';
          osc.frequency.setValueAtTime(freq, now + idx * 0.07);

          gain.gain.setValueAtTime(0.2, now + idx * 0.07);
          gain.gain.exponentialRampToValueAtTime(0.01, now + idx * 0.07 + 0.22);

          osc.connect(gain);
          gain.connect(audioCtx.destination);
          osc.start(now + idx * 0.07);
          osc.stop(now + idx * 0.07 + 0.22);
        });

      } else if (type === 'gameover') {
        // Descending lockdown drone
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(220, now);
        osc.frequency.exponentialRampToValueAtTime(45, now + 0.45);

        gain.gain.setValueAtTime(0.25, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.45);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.45);

      } else if (type === 'error') {
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'square';
        osc.frequency.setValueAtTime(95, now);
        gain.gain.setValueAtTime(0.12, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.06);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.06);
      }
    } catch (e) {
      // Audio fallback silent
    }
  }

  /* =========================================================
     GAME CONFIGURATION & PROGRESSIVE STATE
     ========================================================= */
  const NODE_TYPES = [
    { id: 'data', symbol: '⚡', name: 'Data Node', css: 'node-data' },
    { id: 'quantum', symbol: '⚛', name: 'Quantum Node', css: 'node-quantum' },
    { id: 'neural', symbol: '✦', name: 'Neural Node', css: 'node-neural' },
    { id: 'core', symbol: '⬡', name: 'Core Node', css: 'node-core' },
    { id: 'firewall', symbol: '🛡', name: 'Firewall Node', css: 'node-firewall' }
  ];

  let currentStage = 1;
  let currentGridDim = 5; // Scales 5 -> 6 -> 7 -> 8 cap
  let gridMatrix = [];    // 2D Array [row][col] of Node Objects
  let score = 0;
  let cyclesRemaining = 18;
  let isProcessingMove = false;
  let isGameOver = false;

  // Dynamic Objective Criteria for current stage
  let stageTargetType = 'type'; // 'type' | 'score' | 'emp'
  let targetNodeId = 'data';
  let targetNeeded = 14;
  let targetProgress = 0;

  // DOM Elements
  const nodeGridEl = document.getElementById('nodeGrid');
  const scoreDisplay = document.getElementById('scoreDisplay');
  const cyclesDisplay = document.getElementById('cyclesDisplay');
  const stageNumEl = document.getElementById('stageNum');
  const targetProgressEl = document.getElementById('targetProgress');
  const targetIconEl = document.getElementById('targetIcon');
  const progressBarEl = document.getElementById('progressBar');
  const gridBadgeEl = document.getElementById('gridBadge');

  const startupOverlay = document.getElementById('startupOverlay');
  const gameOverOverlay = document.getElementById('gameOverOverlay');
  const stageBanner = document.getElementById('stageBanner');
  const protocolModal = document.getElementById('protocolModal');

  /* =========================================================
     LIFECYCLE & TELEMETRY INITIALIZATION
     ========================================================= */
  window.addEventListener('DOMContentLoaded', () => {
    loadCachedStats();
  });

  function loadCachedStats() {
    const high = localStorage.getItem('hub_nodebreaker_high') || '0';
    const lvl = localStorage.getItem('hub_nodebreaker_level') || 'Stage 1';
    const sBest = document.getElementById('startBestScore');
    const sStage = document.getElementById('startBestStage');
    if (sBest) sBest.innerText = high + ' pts';
    if (sStage) sStage.innerText = lvl;
  }

  function initiateGameRun() {
    initAudio();
    startupOverlay.style.display = 'none';
    gameOverOverlay.style.display = 'none';
    stageBanner.classList.remove('show');

    score = 0;
    currentStage = 1;
    isGameOver = false;
    setupStage(currentStage);
  }

  /* =========================================================
     PROGRESSIVE STAGE GENERATOR
     ========================================================= */
  function setupStage(stage) {
    currentStage = stage;
    stageNumEl.innerText = stage < 10 ? '0' + stage : stage;

    // Progressive Grid Scaling: 1 -> 5x5, 2 -> 6x6, 3 -> 7x7, 4+ -> 8x8 (Capped for mobile)
    if (stage === 1) currentGridDim = 5;
    else if (stage === 2) currentGridDim = 6;
    else if (stage === 3) currentGridDim = 7;
    else currentGridDim = 8;

    document.documentElement.style.setProperty('--cols', currentGridDim);
    document.documentElement.style.setProperty('--rows', currentGridDim);
    gridBadgeEl.innerText = currentGridDim + 'x' + currentGridDim + ' GRID';

    // Color palette expansion based on stage
    let activeColorsCount = 3;
    if (stage === 2) activeColorsCount = 4;
    else if (stage >= 3) activeColorsCount = Math.min(5, 4 + (stage >= 4 ? 1 : 0));

    // Dynamic Cycle Allocations (Moves)
    cyclesRemaining = Math.max(14, 18 + Math.floor(stage * 1.5) - (currentGridDim >= 8 ? 2 : 0));
    cyclesDisplay.innerText = cyclesRemaining;
    cyclesDisplay.className = 'hud-value glow-warning';

    // Dynamic Stage Objectives
    targetProgress = 0;
    const activeTypes = NODE_TYPES.slice(0, activeColorsCount);

    if (stage === 1) {
      stageTargetType = 'type';
      targetNodeId = 'data';
      targetNeeded = 14;
    } else if (stage % 3 === 0) {
      // Score Target Stage
      stageTargetType = 'score';
      targetNeeded = 1200 + (stage * 600);
      targetNodeId = null;
    } else {
      stageTargetType = 'type';
      const picked = activeTypes[Math.floor(Math.random() * activeTypes.length)];
      targetNodeId = picked.id;
      targetNeeded = 12 + Math.floor(stage * 2.5);
    }

    updateObjectiveDisplay();

    // Generate Board Layout
    generateInitialGrid(activeColorsCount);
    renderGrid();
  }

  function updateObjectiveDisplay() {
    if (stageTargetType === 'score') {
      targetIconEl.innerText = '💎';
      targetProgressEl.innerText = targetProgress + ' / ' + targetNeeded + ' pts';
    } else {
      const typeDef = NODE_TYPES.find(t => t.id === targetNodeId) || NODE_TYPES[0];
      targetIconEl.innerText = typeDef.symbol;
      targetProgressEl.innerText = targetProgress + ' / ' + targetNeeded;
    }

    const pct = Math.min(100, Math.floor((targetProgress / targetNeeded) * 100));
    progressBarEl.style.width = pct + '%';
  }

  function getRandomNode(activeCount) {
    const activeTypes = NODE_TYPES.slice(0, activeCount);
    const chosen = activeTypes[Math.floor(Math.random() * activeTypes.length)];
    return {
      type: chosen.id,
      symbol: chosen.symbol,
      css: chosen.css,
      special: null // 'emp' | 'overdrive'
    };
  }

  function generateInitialGrid(activeCount) {
    gridMatrix = [];
    for (let r = 0; r < currentGridDim; r++) {
      gridMatrix[r] = [];
      for (let c = 0; c < currentGridDim; c++) {
        gridMatrix[r][c] = getRandomNode(activeCount);
      }
    }

    // Ensure valid moves exist at startup
    ensureValidMovesExist(activeCount);
  }

  /* =========================================================
     CLUSTER SEARCH & FLOOD-FILL ALGORITHM (BFS)
     ========================================================= */
  function getConnectedCluster(startR, startC) {
    const targetType = gridMatrix[startR][startC].type;
    const visited = Array.from({ length: currentGridDim }, () => Array(currentGridDim).fill(false));
    const cluster = [];
    const queue = [[startR, startC]];
    visited[startR][startC] = true;

    while (queue.length > 0) {
      const [r, c] = queue.shift();
      cluster.push({ r, c });

      const neighbors = [
        [r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]
      ];

      for (const [nr, nc] of neighbors) {
        if (nr >= 0 && nr < currentGridDim && nc >= 0 && nc < currentGridDim) {
          if (!visited[nr][nc] && gridMatrix[nr][nc] && gridMatrix[nr][nc].type === targetType) {
            visited[nr][nc] = true;
            queue.push([nr, nc]);
          }
        }
      }
    }

    return cluster;
  }

  function hasAnyValidMove() {
    for (let r = 0; r < currentGridDim; r++) {
      for (let c = 0; c < currentGridDim; c++) {
        const node = gridMatrix[r][c];
        if (!node) continue;
        if (node.special) return true; // Specials can always be activated
        // Check adjacent orthogonal matching
        if (r + 1 < currentGridDim && gridMatrix[r + 1][c] && gridMatrix[r + 1][c].type === node.type) return true;
        if (c + 1 < currentGridDim && gridMatrix[r][c + 1] && gridMatrix[r][c + 1].type === node.type) return true;
      }
    }
    return false;
  }

  function ensureValidMovesExist(activeCount) {
    let retries = 0;
    while (!hasAnyValidMove() && retries < 15) {
      // Reshuffle / Regenerate
      for (let r = 0; r < currentGridDim; r++) {
        for (let c = 0; c < currentGridDim; c++) {
          gridMatrix[r][c] = getRandomNode(activeCount);
        }
      }
      retries++;
    }
  }

  /* =========================================================
     GRID RENDERING & INTERACTION HANDLERS
     ========================================================= */
  function renderGrid() {
    nodeGridEl.innerHTML = '';

    for (let r = 0; r < currentGridDim; r++) {
      for (let c = 0; c < currentGridDim; c++) {
        const cellData = gridMatrix[r][c];
        const cell = document.createElement('div');
        cell.className = 'node-cell ' + (cellData ? cellData.css : '');
        cell.dataset.r = r;
        cell.dataset.c = c;

        if (cellData) {
          cell.innerText = cellData.symbol;

          if (cellData.special === 'emp') {
            cell.classList.add('special-emp');
            const badge = document.createElement('span');
            badge.className = 'special-badge-emp';
            badge.innerText = 'EMP';
            cell.appendChild(badge);
          } else if (cellData.special === 'overdrive') {
            cell.classList.add('special-overdrive');
            const badge = document.createElement('span');
            badge.className = 'special-badge-overdrive';
            badge.innerText = 'MAX';
            cell.appendChild(badge);
          }

          // Desktop hover preview
          cell.addEventListener('mouseenter', () => previewClusterHover(r, c));
          cell.addEventListener('mouseleave', clearClusterPreview);

          // Tap / Click action
          cell.addEventListener('click', (e) => {
            e.stopPropagation();
            handleCellTap(r, c);
          });
        }

        nodeGridEl.appendChild(cell);
      }
    }
  }

  function previewClusterHover(r, c) {
    if (isProcessingMove || isGameOver) return;
    const node = gridMatrix[r][c];
    if (!node) return;

    clearClusterPreview();

    if (node.special) {
      // Highlight single special or affected radius
      const cell = document.querySelector(`.node-cell[data-r='${r}'][data-c='${c}']`);
      if (cell) cell.classList.add('in-cluster');
      return;
    }

    const cluster = getConnectedCluster(r, c);
    if (cluster.length >= 2) {
      cluster.forEach(coord => {
        const cell = document.querySelector(`.node-cell[data-r='${coord.r}'][data-c='${coord.c}']`);
        if (cell) cell.classList.add('in-cluster');
      });
    }
  }

  function clearClusterPreview() {
    const highlighted = document.querySelectorAll('.node-cell.in-cluster');
    highlighted.forEach(el => el.classList.remove('in-cluster'));
  }

  /* =========================================================
     CORE MOVE EXECUTION: CLUSTER BREAKING & SPECIALS
     ========================================================= */
  async function handleCellTap(r, c) {
    if (isProcessingMove || isGameOver) return;
    const clickedNode = gridMatrix[r][c];
    if (!clickedNode) return;

    initAudio();

    // 1. SPECIAL NODE DETONATION
    if (clickedNode.special === 'emp') {
      await triggerEmpDetonation(r, c);
      return;
    } else if (clickedNode.special === 'overdrive') {
      await triggerOverdriveDetonation(r, c, clickedNode.type);
      return;
    }

    // 2. STANDARD CLUSTER BREACH
    const cluster = getConnectedCluster(r, c);
    if (cluster.length < 2) {
      playSynth('error');
      const singleCell = document.querySelector(`.node-cell[data-r='${r}'][data-c='${c}']`);
      if (singleCell) {
        singleCell.style.transform = 'scale(0.88)';
        setTimeout(() => singleCell.style.transform = '', 120);
      }
      return;
    }

    isProcessingMove = true;
    clearClusterPreview();

    // Deduct Cycle
    cyclesRemaining--;
    cyclesDisplay.innerText = cyclesRemaining;
    if (cyclesRemaining <= 5) {
      cyclesDisplay.className = 'hud-value glow-danger';
    }

    // Calculate Score & Multipliers
    // Exponential formula: count * 20 * (count - 1)
    const clusterSize = cluster.length;
    const pointsGained = clusterSize * 25 * (clusterSize >= 5 ? 2 : 1);
    addScore(pointsGained);

    // Audio pitch reflects combo scale
    const pitch = 1 + Math.min(1.2, clusterSize * 0.12);
    playSynth('pop', pitch);

    // Show floating score indicator
    showFloatScore(r, c, `+${pointsGained}`);

    // Update Objectives
    if (stageTargetType === 'score') {
      targetProgress += pointsGained;
      updateObjectiveDisplay();
    } else if (stageTargetType === 'type' && clickedNode.type === targetNodeId) {
      targetProgress += clusterSize;
      updateObjectiveDisplay();
    }

    // Check Special Node Synthesis:
    // Cluster >= 7 -> Overdrive Node at clicked position
    // Cluster >= 5 -> EMP Surge Node at clicked position
    let spawnSpecial = null;
    if (clusterSize >= 7) spawnSpecial = 'overdrive';
    else if (clusterSize >= 5) spawnSpecial = 'emp';

    // Play Dissolve Animation on grid cells
    cluster.forEach(coord => {
      const cell = document.querySelector(`.node-cell[data-r='${coord.r}'][data-c='${coord.c}']`);
      if (cell) cell.classList.add('node-pop');
    });

    await delay(180);

    // Clear nodes in matrix
    cluster.forEach(coord => {
      gridMatrix[coord.r][coord.c] = null;
    });

    // If special synthesized, place at clicked position
    if (spawnSpecial) {
      gridMatrix[r][c] = {
        type: clickedNode.type,
        symbol: spawnSpecial === 'emp' ? '💣' : '🌀',
        css: clickedNode.css,
        special: spawnSpecial
      };
      playSynth(spawnSpecial === 'emp' ? 'emp' : 'overdrive');
    }

    // Cascade Gravity Drop & Top Refill
    await applyGravityAndRefill();

    // Check Stage Clear or Game Over
    checkStageResolution();
    isProcessingMove = false;
  }

  /* =========================================================
     SPECIAL DETONATIONS: EMP BLAST & QUANTUM OVERDRIVE
     ========================================================= */
  async function triggerEmpDetonation(centerR, centerC) {
    isProcessingMove = true;
    clearClusterPreview();
    playSynth('emp');

    cyclesRemaining--;
    cyclesDisplay.innerText = cyclesRemaining;
    if (cyclesRemaining <= 5) cyclesDisplay.className = 'hud-value glow-danger';

    const clearedNodes = [];
    for (let dr = -1; dr <= 1; dr++) {
      for (let dc = -1; dc <= 1; dc++) {
        const nr = centerR + dr;
        const nc = centerC + dc;
        if (nr >= 0 && nr < currentGridDim && nc >= 0 && nc < currentGridDim && gridMatrix[nr][nc]) {
          clearedNodes.push({ r: nr, c: nc, type: gridMatrix[nr][nc].type });
          const cell = document.querySelector(`.node-cell[data-r='${nr}'][data-c='${nc}']`);
          if (cell) cell.classList.add('node-pop');
        }
      }
    }

    const points = clearedNodes.length * 50;
    addScore(points);
    showFloatScore(centerR, centerC, `EMP +${points}`);

    // Update Objectives
    if (stageTargetType === 'score') {
      targetProgress += points;
    } else if (stageTargetType === 'type') {
      const matches = clearedNodes.filter(n => n.type === targetNodeId).length;
      targetProgress += matches;
    }
    updateObjectiveDisplay();

    await delay(200);

    clearedNodes.forEach(c => {
      gridMatrix[c.r][c.c] = null;
    });

    await applyGravityAndRefill();
    checkStageResolution();
    isProcessingMove = false;
  }

  async function triggerOverdriveDetonation(centerR, centerC, targetType) {
    isProcessingMove = true;
    clearClusterPreview();
    playSynth('overdrive');

    cyclesRemaining--;
    cyclesDisplay.innerText = cyclesRemaining;
    if (cyclesRemaining <= 5) cyclesDisplay.className = 'hud-value glow-danger';

    const clearedNodes = [];
    for (let r = 0; r < currentGridDim; r++) {
      for (let c = 0; c < currentGridDim; c++) {
        if (gridMatrix[r][c] && gridMatrix[r][c].type === targetType) {
          clearedNodes.push({ r, c });
          const cell = document.querySelector(`.node-cell[data-r='${r}'][data-c='${c}']`);
          if (cell) cell.classList.add('node-pop');
        }
      }
    }

    const points = clearedNodes.length * 60;
    addScore(points);
    showFloatScore(centerR, centerC, `MAX +${points}`);

    if (stageTargetType === 'score') {
      targetProgress += points;
    } else if (stageTargetType === 'type' && targetType === targetNodeId) {
      targetProgress += clearedNodes.length;
    }
    updateObjectiveDisplay();

    await delay(220);

    clearedNodes.forEach(c => {
      gridMatrix[c.r][c.c] = null;
    });

    await applyGravityAndRefill();
    checkStageResolution();
    isProcessingMove = false;
  }

  /* =========================================================
     GRAVITATIONAL DROP & REFILL ENGINE
     ========================================================= */
  async function applyGravityAndRefill() {
    let activeColorsCount = 3;
    if (currentStage === 2) activeColorsCount = 4;
    else if (currentStage >= 3) activeColorsCount = Math.min(5, 4 + (currentStage >= 4 ? 1 : 0));

    // Shift columns downwards
    for (let c = 0; c < currentGridDim; c++) {
      let emptyRow = currentGridDim - 1;
      for (let r = currentGridDim - 1; r >= 0; r--) {
        if (gridMatrix[r][c] !== null) {
          if (r !== emptyRow) {
            gridMatrix[emptyRow][c] = gridMatrix[r][c];
            gridMatrix[r][c] = null;
          }
          emptyRow--;
        }
      }

      // Fill remaining top slots with fresh randomized nodes
      for (let r = emptyRow; r >= 0; r--) {
        gridMatrix[r][c] = getRandomNode(activeColorsCount);
      }
    }

    renderGrid();

    // Deadlock Prevention: if no cluster >= 2 and no specials, auto-reshuffle
    if (!hasAnyValidMove()) {
      await handleDeadlockReshuffle(activeColorsCount);
    }
  }

  async function handleDeadlockReshuffle(activeCount) {
    const badge = document.getElementById('gridBadge');
    badge.innerText = 'RESHUFFLING...';
    badge.style.color = 'var(--warning)';
    playSynth('error');

    await delay(300);
    ensureValidMovesExist(activeCount);
    renderGrid();

    badge.innerText = currentGridDim + 'x' + currentGridDim + ' GRID';
    badge.style.color = '';
  }

  /* =========================================================
     STAGE RESOLUTION & GAME OVER TELEMETRY
     ========================================================= */
  async function checkStageResolution() {
    // 1. Victory Check
    if (targetProgress >= targetNeeded) {
      isProcessingMove = true;
      playSynth('win');

      // Calculate cycle bonus
      const cycleBonus = cyclesRemaining * 100;
      addScore(cycleBonus);

      const bonusText = document.getElementById('stageBonusText');
      if (bonusText) bonusText.innerText = `+${cycleBonus} Cycle Bonus (${cyclesRemaining} Leftover Cycles)`;

      stageBanner.classList.add('show');
      await delay(1600);
      stageBanner.classList.remove('show');

      // Advance to next stage
      setupStage(currentStage + 1);
      isProcessingMove = false;
      return;
    }

    // 2. Defeat Check (Cycles Depleted)
    if (cyclesRemaining <= 0) {
      triggerGameOver();
    }
  }

  function triggerGameOver() {
    isGameOver = true;
    playSynth('gameover');

    document.getElementById('finalScoreVal').innerText = score + ' pts';
    document.getElementById('finalStageVal').innerText = 'Stage ' + currentStage;
    gameOverOverlay.style.display = 'flex';

    // Update Local Records
    const prevBest = parseInt(localStorage.getItem('hub_nodebreaker_high') || '0', 10);
    if (score > prevBest) {
      localStorage.setItem('hub_nodebreaker_high', score);
    }
    const prevLvl = localStorage.getItem('hub_nodebreaker_level') || 'Stage 1';
    const prevLvlNum = parseInt(prevLvl.replace(/\D/g, '') || '1', 10);
    if (currentStage > prevLvlNum) {
      localStorage.setItem('hub_nodebreaker_level', 'Stage ' + currentStage);
    }

    // Synchronize to Cloud Database via save_score.jsp
    saveScoreToDatabase(score);
  }

  async function saveScoreToDatabase(finalScore) {
    try {
      const params = new URLSearchParams();
      params.append('game', 'node_breaker');
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
      console.warn('Cloud leaderboard sync offline; cached locally.');
    }
  }

  /* =========================================================
     HELPERS & UI UTILITIES
     ========================================================= */
  function addScore(pts) {
    score += pts;
    scoreDisplay.innerText = score.toString().padStart(4, '0');
  }

  function showFloatScore(r, c, text) {
    const cell = document.querySelector(`.node-cell[data-r='${r}'][data-c='${c}']`);
    if (!cell) return;

    const rect = cell.getBoundingClientRect();
    const gridRect = nodeGridEl.getBoundingClientRect();

    const floatEl = document.createElement('div');
    floatEl.className = 'float-score';
    floatEl.innerText = text;
    floatEl.style.left = (rect.left - gridRect.left + rect.width / 2 - 20) + 'px';
    floatEl.style.top = (rect.top - gridRect.top) + 'px';

    nodeGridEl.appendChild(floatEl);
    setTimeout(() => floatEl.remove(), 750);
  }

  function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  function openProtocolModal() {
    protocolModal.classList.add('active');
  }

  function closeProtocolModal() {
    protocolModal.classList.remove('active');
  }

  /* =========================================================
     CYBER-SCANNER NAVIGATION WIPE HANDLER
     ========================================================= */
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
