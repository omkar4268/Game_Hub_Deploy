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
<title>Cyber Grid // Glitch Protocol</title>
<style>
  :root {
    --bg-base: #03050a;
    --card-bg: rgba(13, 19, 36, 0.85);
    --border-glow: rgba(56, 189, 248, 0.35);
    --primary: #38bdf8;
    --primary-rgb: 56, 189, 248;
    --accent: #22c55e;
    --accent-glow: rgba(34, 197, 94, 0.4);
    --purple: #a855f7;
    --warning: #facc15;
    --danger: #f43f5e;
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --grid-size: 5;
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

  /* Matrix scanlines & cyber background */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 20% 15%, rgba(56, 189, 248, 0.12) 0%, transparent 45%),
      radial-gradient(circle at 80% 85%, rgba(168, 85, 247, 0.12) 0%, transparent 45%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 28px 28px, 28px 28px;
    z-index: -1;
    pointer-events: none;
  }

  .game-arena {
    width: 100%;
    max-width: 500px;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
  }

  /* Header Navigation Bar */
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
    font-size: 1.3rem;
    font-weight: 900;
    letter-spacing: 1.5px;
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--purple) 100%);
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

  /* HUD Info Bar */
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
    color: var(--primary);
    text-shadow: 0 0 10px rgba(56, 189, 248, 0.4);
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
    margin-bottom: 2px;
  }
  .objective-target {
    font-size: 0.95rem;
    font-weight: 900;
    color: var(--danger);
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
    background: linear-gradient(90deg, var(--danger), var(--accent));
    border-radius: 999px;
    transition: width 0.3s ease;
    box-shadow: 0 0 8px var(--accent);
  }

  /* Main Match-3 Board Chassis */
  .board-container {
    position: relative;
    width: 100%;
    max-width: 480px;
    aspect-ratio: 1 / 1;
    background: rgba(10, 15, 29, 0.88);
    border: 1px solid var(--border-glow);
    border-radius: 18px;
    padding: 8px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.75), inset 0 0 25px rgba(56, 189, 248, 0.05);
    backdrop-filter: blur(16px);
    overflow: hidden;
    touch-action: none;
  }

  /* Sub-Grid: Underneath Tiles (Clean vs. Corrupted Firewall) */
  .tiles-grid {
    position: absolute;
    inset: 8px;
    display: grid;
    grid-template-columns: repeat(var(--grid-size), 1fr);
    grid-template-rows: repeat(var(--grid-size), 1fr);
    gap: 5px;
    z-index: 1;
    pointer-events: none;
  }

  .tile-cell {
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    position: relative;
    transition: all 0.3s ease;
  }

  /* Corrupted Firewall Hazard Tile (The Goal to Purge) */
  .tile-cell.corrupted {
    background: radial-gradient(circle at 50% 50%, rgba(244, 63, 94, 0.28) 0%, rgba(136, 19, 55, 0.6) 100%);
    border: 1px solid rgba(244, 63, 94, 0.65);
    box-shadow: inset 0 0 12px rgba(244, 63, 94, 0.4), 0 0 8px rgba(244, 63, 94, 0.3);
    animation: corruptedPulse 2s infinite alternate ease-in-out;
  }
  @keyframes corruptedPulse {
    0% { border-color: rgba(244, 63, 94, 0.5); filter: brightness(1); }
    100% { border-color: rgba(250, 204, 21, 0.8); filter: brightness(1.2); }
  }
  .tile-cell.corrupted::after {
    content: '✖';
    position: absolute;
    bottom: 2px;
    right: 4px;
    font-size: 0.65rem;
    color: rgba(244, 63, 94, 0.85);
    font-weight: 900;
  }

  /* Tile Cleansed Shatter Animation */
  @keyframes tileShatter {
    0% { transform: scale(1); filter: brightness(2.5); }
    50% { transform: scale(1.15); opacity: 0.8; box-shadow: 0 0 25px #22c55e; }
    100% { transform: scale(1); opacity: 1; filter: brightness(1); }
  }
  .tile-cell.shattered {
    animation: tileShatter 0.4s ease forwards;
  }

  /* Interactive Data Node Layer */
  .nodes-layer {
    position: absolute;
    inset: 8px;
    z-index: 2;
    width: calc(100% - 16px);
    height: calc(100% - 16px);
  }

  /* Individual Data Node Token */
  .node-item {
    position: absolute;
    width: calc((100% - (var(--grid-size) - 1) * 5px) / var(--grid-size));
    height: calc((100% - (var(--grid-size) - 1) * 5px) / var(--grid-size));
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: clamp(1.1rem, 4vw, 1.6rem);
    border: 1px solid transparent;
    transition: transform 0.22s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.18s ease;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
    touch-action: none;
    z-index: 2;
  }

  /* Node Color Themes */
  .node-cyan {
    background: radial-gradient(circle at 35% 35%, rgba(56, 189, 248, 0.45) 0%, rgba(12, 74, 110, 0.8) 100%);
    border-color: rgba(56, 189, 248, 0.6);
    color: #38bdf8;
    box-shadow: 0 0 12px rgba(56, 189, 248, 0.3);
  }
  .node-green {
    background: radial-gradient(circle at 35% 35%, rgba(34, 197, 94, 0.45) 0%, rgba(6, 78, 59, 0.8) 100%);
    border-color: rgba(34, 197, 94, 0.6);
    color: #22c55e;
    box-shadow: 0 0 12px rgba(34, 197, 94, 0.3);
  }
  .node-purple {
    background: radial-gradient(circle at 35% 35%, rgba(168, 85, 247, 0.45) 0%, rgba(76, 29, 149, 0.8) 100%);
    border-color: rgba(168, 85, 247, 0.6);
    color: #a855f7;
    box-shadow: 0 0 12px rgba(168, 85, 247, 0.3);
  }
  .node-amber {
    background: radial-gradient(circle at 35% 35%, rgba(250, 204, 21, 0.45) 0%, rgba(113, 63, 18, 0.8) 100%);
    border-color: rgba(250, 204, 21, 0.6);
    color: #facc15;
    box-shadow: 0 0 12px rgba(250, 204, 21, 0.3);
  }
  .node-rose {
    background: radial-gradient(circle at 35% 35%, rgba(244, 63, 94, 0.45) 0%, rgba(136, 19, 55, 0.8) 100%);
    border-color: rgba(244, 63, 94, 0.6);
    color: #f43f5e;
    box-shadow: 0 0 12px rgba(244, 63, 94, 0.3);
  }

  /* Selection State */
  .node-item.selected {
    transform: scale(1.12);
    border-color: #ffffff;
    box-shadow: 0 0 22px #38bdf8, inset 0 0 12px #ffffff;
    z-index: 10;
    animation: selectedPulse 0.8s infinite alternate ease-in-out;
  }
  @keyframes selectedPulse {
    from { transform: scale(1.1); filter: brightness(1.2); }
    to { transform: scale(1.16); filter: brightness(1.5); }
  }

  /* Invalid Swap Glitch Revert Animation */
  @keyframes glitchBounce {
    0%, 100% { transform: translate(0, 0); }
    20% { transform: translate(-6px, 3px); filter: hue-rotate(90deg); }
    40% { transform: translate(6px, -3px); filter: hue-rotate(-90deg); }
    60% { transform: translate(-4px, -2px); }
    80% { transform: translate(4px, 2px); }
  }
  .node-item.glitch-revert {
    animation: glitchBounce 0.28s ease-in-out;
  }

  /* Charging Pulse Animation Before Purge */
  @keyframes chargePulse {
    0% { transform: scale(1); filter: brightness(1); }
    50% { transform: scale(1.22); filter: brightness(2.5) drop-shadow(0 0 15px #ffffff); }
    100% { transform: scale(0); opacity: 0; }
  }
  .node-item.charging-purge {
    animation: chargePulse 0.22s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
    z-index: 15;
  }

  /* SPECIAL POWER NODES */
  /* Line Glitcher (Match 4) */
  .node-item.special-line {
    border-width: 2px;
    animation: lineGlitchPulse 1.4s infinite alternate;
  }
  @keyframes lineGlitchPulse {
    0% { box-shadow: 0 0 10px #38bdf8; }
    100% { box-shadow: 0 0 24px #22c55e, inset 0 0 8px #ffffff; }
  }
  .line-arrows {
    position: absolute;
    font-size: 0.65rem;
    font-weight: 900;
    color: #ffffff;
    pointer-events: none;
    line-height: 1;
    text-shadow: 0 0 8px #38bdf8;
  }
  .line-arrows.horizontal { top: 2px; width: 100%; display: flex; justify-content: space-between; padding: 0 3px; }
  .line-arrows.vertical { left: 2px; height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 3px 0; }

  /* EMP Glitch Vortex (Match 5) */
  .node-item.special-vortex {
    animation: vortexSpin 3s linear infinite;
    border: 2px solid #a855f7;
    box-shadow: 0 0 25px #a855f7, inset 0 0 10px #38bdf8;
  }
  @keyframes vortexSpin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  /* Line Laser Flash FX */
  .laser-sweep-h {
    position: absolute;
    left: 0;
    width: 100%;
    height: 10px;
    background: linear-gradient(90deg, transparent, #38bdf8 30%, #ffffff 50%, #38bdf8 70%, transparent);
    box-shadow: 0 0 25px #38bdf8;
    z-index: 25;
    pointer-events: none;
    animation: laserFlash 0.3s ease-out forwards;
  }
  .laser-sweep-v {
    position: absolute;
    top: 0;
    height: 100%;
    width: 10px;
    background: linear-gradient(180deg, transparent, #22c55e 30%, #ffffff 50%, #22c55e 70%, transparent);
    box-shadow: 0 0 25px #22c55e;
    z-index: 25;
    pointer-events: none;
    animation: laserFlash 0.3s ease-out forwards;
  }
  @keyframes laserFlash {
    0% { opacity: 0; transform: scaleY(0.2); }
    50% { opacity: 1; transform: scaleY(1.8); }
    100% { opacity: 0; transform: scaleY(0.1); }
  }

  /* Data Stream Floating Particle */
  .data-stream-particle {
    position: fixed;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: #38bdf8;
    box-shadow: 0 0 10px #38bdf8, 0 0 15px #22c55e;
    pointer-events: none;
    z-index: 9999;
    transition: transform 0.42s cubic-bezier(0.2, 0.8, 0.2, 1), opacity 0.42s ease;
  }

  /* Floating Combo Banner */
  .combo-flourish {
    position: absolute;
    top: 45%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.7);
    font-size: 1.3rem;
    font-weight: 900;
    letter-spacing: 1.5px;
    color: #ffffff;
    text-shadow: 0 0 15px #38bdf8, 0 0 25px #a855f7;
    pointer-events: none;
    z-index: 40;
    opacity: 0;
    animation: comboFloat 0.75s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  @keyframes comboFloat {
    0% { transform: translate(-50%, -40%) scale(0.6); opacity: 0; }
    25% { transform: translate(-50%, -50%) scale(1.15); opacity: 1; }
    75% { transform: translate(-50%, -60%) scale(1); opacity: 1; }
    100% { transform: translate(-50%, -80%) scale(0.9); opacity: 0; }
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
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--purple) 100%);
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
    .board-container { max-width: min(390px, 94vw); padding: 6px; border-radius: 16px; }
    .tiles-grid, .nodes-layer { inset: 6px; width: calc(100% - 12px); height: calc(100% - 12px); }
    .node-item { border-radius: 8px; font-size: clamp(0.95rem, 4vw, 1.35rem); }
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
  
  <!-- Top Navigation Bar -->
  <div class="header">
    <div class="header-left">
      <span class="header-title">GLITCH PROTOCOL</span>
      <span class="header-badge" id="sectorBadge">SECTOR 01</span>
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
        <span>FIREWALL CORRUPTION</span>
        <span>🛡</span>
      </div>
      <div class="objective-target" id="targetProgress">0 / 6 CLEARED</div>
      <div class="progress-bar-bg">
        <div class="progress-bar-fill" id="progressBar"></div>
      </div>
    </div>

    <div class="hud-stat" style="align-items: flex-end;">
      <span class="hud-label">MOVES LEFT</span>
      <span class="hud-value glow-warning" id="movesDisplay">18</span>
    </div>
  </div>

  <!-- Match-3 Board Chassis -->
  <div class="board-container" id="boardContainer">
    <!-- Sub-layer for Clean vs. Corrupted Firewall Tiles -->
    <div class="tiles-grid" id="tilesGrid"></div>

    <!-- Active Swappable Data Nodes Layer -->
    <div class="nodes-layer" id="nodesLayer"></div>

    <!-- PRE-GAME STARTUP SCREEN OVERLAY -->
    <div class="overlay-screen" id="startupOverlay">
      <div class="overlay-tag">CYBER GRID // DATA STREAM MATCH-3</div>
      <div class="overlay-icon">⚡</div>
      <div class="overlay-title">GLITCH PROTOCOL</div>
      <div class="overlay-subtitle">
        Swap adjacent data packets to align 3+ frequencies. Purge firewall corruption tiles with gravitational data cascades before your move limit is traced.
      </div>

      <div class="overlay-stats-card">
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">RECORD SCORE</span>
          <span class="overlay-stat-val" id="startBestScore">0 pts</span>
        </div>
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">CURRENT SECTOR</span>
          <span class="overlay-stat-val" id="startBestSector" style="color: var(--primary);">Sector 1</span>
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

    <!-- LEVEL COMPLETE OVERLAY -->
    <div class="overlay-screen" id="winOverlay" style="display: none;">
      <div class="overlay-tag" style="color: var(--accent); border-color: rgba(34, 197, 94, 0.4); background: rgba(34, 197, 94, 0.1);">
        FIREWALL BREACHED! // ACCESS GRANTED
      </div>
      <div class="overlay-icon">🔓</div>
      <div class="overlay-title" style="background: linear-gradient(135deg, #fff, #22c55e);">SECTOR CLEARED!</div>
      <div class="overlay-subtitle" id="winSubtitle">
        All firewall corruption purged. Data stream stabilized.
      </div>

      <div class="overlay-stats-card">
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">CYCLE BONUS</span>
          <span class="overlay-stat-val" id="winBonusVal" style="color: var(--accent);">+400 pts</span>
        </div>
        <div class="overlay-stat-col">
          <span class="overlay-stat-label">TOTAL SCORE</span>
          <span class="overlay-stat-val" id="winTotalScore">0 pts</span>
        </div>
      </div>

      <div class="menu-actions">
        <button class="btn-cyber btn-primary" onclick="advanceToNextLevel()">
          ➔ ACCESS NEXT SECTOR
        </button>
        <div class="menu-actions-row">
          <button class="btn-cyber btn-secondary" onclick="cyberNavigate('index.jsp')">
            ‹ RETURN TO HUB
          </button>
        </div>
      </div>
    </div>

    <!-- GAME OVER OVERLAY -->
    <div class="overlay-screen" id="gameOverOverlay" style="display: none;">
      <div class="overlay-tag" style="color: var(--danger); border-color: rgba(244, 63, 94, 0.4); background: rgba(244, 63, 94, 0.1);">
        SYSTEM CRASH // TRACE DETECTED
      </div>
      <div class="overlay-icon">🔒</div>
      <div class="overlay-title" style="background: linear-gradient(135deg, #fff, #f43f5e);">RUN TERMINATED</div>
      <div class="overlay-subtitle" id="gameOverReason">
        Trace reached 100% before all firewall corruption could be purged.
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
          ↻ RETRY SECTOR
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

  </div>
</div>

<!-- PROTOCOL & INTEL MODAL -->
<div class="modal-wrapper" id="protocolModal">
  <div class="modal-box">
    <div class="modal-title">
      <span>⚡</span> GLITCH PROTOCOL INTEL
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>↔</span> DATA STREAM MATCH-3 SWAPPING</div>
      <div class="intel-text">
        Drag or tap to swap adjacent glowing data nodes horizontally or vertically. Align 3 or more matching colors to purge them into a cascading data stream. If no match is created, nodes glitch-bounce back!
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>🛡</span> PURGING FIREWALL CORRUPTION</div>
      <div class="intel-text">
        Sub-grid tiles with glowing red hazard markings are corrupted by the security daemon. Match nodes directly on top of these tiles to shatter and cleanse the corruption before moves run out!
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>💎</span> LINE GLITCHER (MATCH 4)</div>
      <div class="intel-text">
        Aligning 4 matching nodes manufactures a Line Glitcher diamond. When matched or swapped, it unleashes an explosive cyber laser beam that wipes out an entire row or column.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>🌀</span> EMP VORTEX (MATCH 5)</div>
      <div class="intel-text">
        Matching 5 nodes or creating T/L intersections synthesizes a high-yield EMP Vortex. Triggering it purges a 3x3 radius of sub-nodes and shatters all underlying corruption tiles.
      </div>
    </div>

    <div class="intel-item">
      <div class="intel-head"><span>📈</span> DYNAMIC SECTOR PROGRESSION</div>
      <div class="intel-text">
        Sectors auto-scale starting at a 5x5 matrix with 3 node types, expanding smoothly to 6x6, 7x7, and an intense 8x8 mobile-capped matrix with 5 node frequencies!
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

  function playSynth(type, param = 1) {
    if (!soundEnabled) return;
    initAudio();
    if (!audioCtx) return;

    try {
      const now = audioCtx.currentTime;

      if (type === 'swap') {
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(440, now);
        osc.frequency.exponentialRampToValueAtTime(700, now + 0.05);

        gain.gain.setValueAtTime(0.12, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.05);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.05);

      } else if (type === 'match') {
        // Purge chime triad based on combo multiplier
        const baseFreq = 380 * Math.min(2.0, 1 + (param - 1) * 0.25);
        [baseFreq, baseFreq * 1.25, baseFreq * 1.5].forEach((freq, idx) => {
          const osc = audioCtx.createOscillator();
          const gain = audioCtx.createGain();
          osc.type = 'sine';
          osc.frequency.setValueAtTime(freq, now + idx * 0.03);

          gain.gain.setValueAtTime(0.15, now + idx * 0.03);
          gain.gain.exponentialRampToValueAtTime(0.01, now + idx * 0.03 + 0.12);

          osc.connect(gain);
          gain.connect(audioCtx.destination);
          osc.start(now + idx * 0.03);
          osc.stop(now + idx * 0.03 + 0.12);
        });

      } else if (type === 'shatter') {
        // Digital glass shatter for corruption purged
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(800, now);
        osc.frequency.exponentialRampToValueAtTime(80, now + 0.18);

        gain.gain.setValueAtTime(0.22, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.18);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.18);

      } else if (type === 'laser') {
        // Line glitcher laser blast
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(900, now);
        osc.frequency.exponentialRampToValueAtTime(120, now + 0.22);

        gain.gain.setValueAtTime(0.25, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.22);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.22);

      } else if (type === 'vortex') {
        // EMP Vortex blast
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(200, now);
        osc.frequency.exponentialRampToValueAtTime(35, now + 0.3);

        gain.gain.setValueAtTime(0.35, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.3);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.3);

      } else if (type === 'error') {
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'square';
        osc.frequency.setValueAtTime(110, now);
        osc.frequency.setValueAtTime(85, now + 0.04);

        gain.gain.setValueAtTime(0.12, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.08);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.08);

      } else if (type === 'win') {
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
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(200, now);
        osc.frequency.exponentialRampToValueAtTime(45, now + 0.45);

        gain.gain.setValueAtTime(0.25, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.45);

        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start(now);
        osc.stop(now + 0.45);
      }
    } catch (e) {
      // Audio fallback
    }
  }

  /* =========================================================
     GAME CONFIGURATION & PROGRESSIVE STATE
     ========================================================= */
  const COLOR_PALETTES = [
    { id: 0, symbol: '⚡', name: 'Data Pulse', css: 'node-cyan' },
    { id: 1, symbol: '⚛', name: 'Quantum Cell', css: 'node-green' },
    { id: 2, symbol: '✦', name: 'Neural Core', css: 'node-purple' },
    { id: 3, symbol: '⬡', name: 'Security Token', css: 'node-amber' },
    { id: 4, symbol: '🛡', name: 'Firewall Key', css: 'node-rose' }
  ];

  let currentSector = 1;
  let gridDim = 5; // Scales 5 -> 6 -> 7 -> 8 cap
  let activeColorsCount = 3;
  let score = 0;
  let movesLeft = 18;
  let isLocked = false;
  let isGameOver = false;

  // Board Arrays
  let corruptionTiles = []; // 2D boolean array: true if corrupted
  let gridNodes = [];       // 2D node object array: { color, special: null|'line_h'|'line_v'|'vortex', id }
  let nextNodeId = 1;

  let totalCorruptedCount = 0;
  let clearedCorruptedCount = 0;

  // Swap Tracking
  let selectedCell = null; // { r, c }
  let pointerStartX = 0;
  let pointerStartY = 0;
  let pointerStartCell = null;

  // DOM Elements
  const boardContainer = document.getElementById('boardContainer');
  const tilesGrid = document.getElementById('tilesGrid');
  const nodesLayer = document.getElementById('nodesLayer');
  const scoreDisplay = document.getElementById('scoreDisplay');
  const movesDisplay = document.getElementById('movesDisplay');
  const sectorBadge = document.getElementById('sectorBadge');
  const targetProgress = document.getElementById('targetProgress');
  const progressBar = document.getElementById('progressBar');

  const startupOverlay = document.getElementById('startupOverlay');
  const winOverlay = document.getElementById('winOverlay');
  const gameOverOverlay = document.getElementById('gameOverOverlay');
  const protocolModal = document.getElementById('protocolModal');

  /* =========================================================
     LIFECYCLE & STATS
     ========================================================= */
  window.addEventListener('DOMContentLoaded', () => {
    loadCachedRecords();
  });

  function loadCachedRecords() {
    const high = localStorage.getItem('hub_glitch_high') || '0';
    const sector = localStorage.getItem('hub_glitch_sector') || 'Sector 1';
    const sBest = document.getElementById('startBestScore');
    const sSec = document.getElementById('startBestSector');
    if (sBest) sBest.innerText = high + ' pts';
    if (sSec) sSec.innerText = sector;
  }

  function initiateGameRun() {
    initAudio();
    startupOverlay.style.display = 'none';
    winOverlay.style.display = 'none';
    gameOverOverlay.style.display = 'none';

    score = 0;
    currentSector = 1;
    isGameOver = false;
    setupSector(currentSector);
  }

  /* =========================================================
     PROGRESSIVE SECTOR INITIALIZER
     ========================================================= */
  function setupSector(sector) {
    currentSector = sector;
    sectorBadge.innerText = 'SECTOR ' + (sector < 10 ? '0' + sector : sector);

    // Progressive Grid Scaling:
    // Sector 1: 5x5 (3 colors)
    // Sector 2: 6x6 (4 colors)
    // Sector 3: 7x7 (4 colors)
    // Sector 4+: 8x8 (5 colors - mobile cap)
    if (sector === 1) { gridDim = 5; activeColorsCount = 3; }
    else if (sector === 2) { gridDim = 6; activeColorsCount = 4; }
    else if (sector === 3) { gridDim = 7; activeColorsCount = 4; }
    else { gridDim = 8; activeColorsCount = 5; }

    document.documentElement.style.setProperty('--grid-size', gridDim);

    // Move limits
    movesLeft = Math.max(15, 18 + Math.floor(sector * 1.5) - (gridDim >= 8 ? 2 : 0));
    movesDisplay.innerText = movesLeft;
    movesDisplay.className = 'hud-value glow-warning';

    // Generate Corruption Tiles (Goal)
    generateCorruptionTiles(sector);

    // Generate Valid Match-3 Board (No 3-matches on startup)
    generateInitialMatch3Board();

    // Render Tiles & Nodes
    renderTilesGrid();
    renderAllNodes();

    updateHUD();
  }

  function generateCorruptionTiles(sector) {
    corruptionTiles = Array.from({ length: gridDim }, () => Array(gridDim).fill(false));
    totalCorruptedCount = 0;
    clearedCorruptedCount = 0;

    // Number of corrupted tiles scales with sector
    const numTiles = Math.min(gridDim * gridDim - 4, 6 + (sector - 1) * 4);

    let placed = 0;
    let attempts = 0;
    while (placed < numTiles && attempts < 200) {
      const r = Math.floor(Math.random() * gridDim);
      const c = Math.floor(Math.random() * gridDim);
      if (!corruptionTiles[r][c]) {
        corruptionTiles[r][c] = true;
        placed++;
      }
      attempts++;
    }
    totalCorruptedCount = placed;
  }

  function updateHUD() {
    scoreDisplay.innerText = score.toString().padStart(4, '0');
    movesDisplay.innerText = movesLeft;

    targetProgress.innerText = clearedCorruptedCount + ' / ' + totalCorruptedCount + ' CLEARED';
    const pct = totalCorruptedCount > 0 ? Math.min(100, Math.floor((clearedCorruptedCount / totalCorruptedCount) * 100)) : 100;
    progressBar.style.width = pct + '%';

    if (movesLeft <= 5) movesDisplay.className = 'hud-value glow-danger';
    else movesDisplay.className = 'hud-value glow-warning';
  }

  /* =========================================================
     MATCH-3 INITIAL BOARD GENERATION (NO ACCIDENTAL MATCHES)
     ========================================================= */
  function generateInitialMatch3Board() {
    gridNodes = Array.from({ length: gridDim }, () => Array(gridDim).fill(null));

    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        let validColors = [];
        for (let color = 0; color < activeColorsCount; color++) {
          // Avoid 3 in a row horizontally
          if (c >= 2 && gridNodes[r][c-1]?.color === color && gridNodes[r][c-2]?.color === color) continue;
          // Avoid 3 in a row vertically
          if (r >= 2 && gridNodes[r-1][c]?.color === color && gridNodes[r-2][c]?.color === color) continue;
          validColors.push(color);
        }

        const pickedColor = validColors[Math.floor(Math.random() * validColors.length)];
        gridNodes[r][c] = {
          color: pickedColor,
          special: null, // 'line_h' | 'line_v' | 'vortex'
          id: nextNodeId++
        };
      }
    }

    // Ensure at least one potential valid swap exists
    if (!findPossibleMoves().length) {
      generateInitialMatch3Board();
    }
  }

  /* =========================================================
     RENDERING: SUB-TILES & NODES
     ========================================================= */
  function renderTilesGrid() {
    tilesGrid.innerHTML = '';
    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        const tile = document.createElement('div');
        tile.className = 'tile-cell ' + (corruptionTiles[r][c] ? 'corrupted' : '');
        tile.dataset.r = r;
        tile.dataset.c = c;
        tilesGrid.appendChild(tile);
      }
    }
  }

  function renderAllNodes() {
    nodesLayer.innerHTML = '';
    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        const nodeData = gridNodes[r][c];
        if (nodeData) {
          const el = createNodeElement(nodeData, r, c);
          nodesLayer.appendChild(el);
        }
      }
    }
  }

  function createNodeElement(nodeData, r, c) {
    const palette = COLOR_PALETTES[nodeData.color] || COLOR_PALETTES[0];
    const el = document.createElement('div');
    el.className = 'node-item ' + palette.css;
    el.id = 'node-' + nodeData.id;
    el.dataset.r = r;
    el.dataset.c = c;
    el.dataset.id = nodeData.id;

    // Special node badges
    if (nodeData.special === 'line_h') {
      el.classList.add('special-line');
      el.innerHTML = palette.symbol + '<div class="line-arrows horizontal"><span>◀</span><span>▶</span></div>';
    } else if (nodeData.special === 'line_v') {
      el.classList.add('special-line');
      el.innerHTML = palette.symbol + '<div class="line-arrows vertical"><span>▲</span><span>▼</span></div>';
    } else if (nodeData.special === 'vortex') {
      el.classList.add('special-vortex');
      el.innerHTML = '🌀';
    } else {
      el.innerText = palette.symbol;
    }

    // Position node item
    positionNodeElement(el, r, c);

    // Event Listeners for Touch / Mouse
    el.addEventListener('pointerdown', handlePointerDown);

    return el;
  }

  function positionNodeElement(el, r, c) {
    el.dataset.r = r;
    el.dataset.c = c;
    const gap = 5;
    const cellSizePct = 100 / gridDim;
    el.style.left = `calc(${c} * (100% - ${(gridDim - 1) * gap}px) / ${gridDim} + ${c * gap}px)`;
    el.style.top  = `calc(${r} * (100% - ${(gridDim - 1) * gap}px) / ${gridDim} + ${r * gap}px)`;
  }

  /* =========================================================
     INTERACTION: TOUCH SWIPE & TAP-TO-SWAP
     ========================================================= */
  function handlePointerDown(e) {
    if (isLocked || isGameOver) return;
    initAudio();

    const targetEl = e.currentTarget;
    const r = parseInt(targetEl.dataset.r, 10);
    const c = parseInt(targetEl.dataset.c, 10);

    pointerStartX = e.clientX;
    pointerStartY = e.clientY;
    pointerStartCell = { r, c };

    window.addEventListener('pointerup', handlePointerUp, { once: true });

    // Handle Tap-to-Select
    if (!selectedCell) {
      selectedCell = { r, c };
      targetEl.classList.add('selected');
    } else {
      const prevEl = document.querySelector(`.node-item[data-r='${selectedCell.r}'][data-c='${selectedCell.c}']`);
      if (prevEl) prevEl.classList.remove('selected');

      const isNeighbor = Math.abs(selectedCell.r - r) + Math.abs(selectedCell.c - c) === 1;
      if (isNeighbor) {
        const from = { ...selectedCell };
        selectedCell = null;
        executeSwapAttempt(from.r, from.c, r, c);
      } else if (selectedCell.r === r && selectedCell.c === c) {
        selectedCell = null; // Deselect on double-tap
      } else {
        selectedCell = { r, c };
        targetEl.classList.add('selected');
      }
    }
  }

  function handlePointerUp(e) {
    if (!pointerStartCell || isLocked || isGameOver) return;

    const dx = e.clientX - pointerStartX;
    const dy = e.clientY - pointerStartY;
    const dist = Math.hypot(dx, dy);

    if (dist > 25) {
      // Swiped!
      let targetR = pointerStartCell.r;
      let targetC = pointerStartCell.c;

      if (Math.abs(dx) > Math.abs(dy)) {
        targetC += dx > 0 ? 1 : -1;
      } else {
        targetR += dy > 0 ? 1 : -1;
      }

      if (targetR >= 0 && targetR < gridDim && targetC >= 0 && targetC < gridDim) {
        if (selectedCell) {
          const prevEl = document.querySelector(`.node-item[data-r='${selectedCell.r}'][data-c='${selectedCell.c}']`);
          if (prevEl) prevEl.classList.remove('selected');
          selectedCell = null;
        }
        executeSwapAttempt(pointerStartCell.r, pointerStartCell.c, targetR, targetC);
      }
    }
    pointerStartCell = null;
  }

  /* =========================================================
     SWAP VALIDATION & ANIMATION ENGINE
     ========================================================= */
  async function executeSwapAttempt(r1, c1, r2, c2) {
    isLocked = true;
    playSynth('swap');

    const el1 = document.querySelector(`.node-item[data-r='${r1}'][data-c='${c1}']`);
    const el2 = document.querySelector(`.node-item[data-r='${r2}'][data-c='${c2}']`);

    // Animate visual slide
    positionNodeElement(el1, r2, c2);
    positionNodeElement(el2, r1, c1);

    // Swap data in matrix
    const temp = gridNodes[r1][c1];
    gridNodes[r1][c1] = gridNodes[r2][c2];
    gridNodes[r2][c2] = temp;

    await delay(220);

    // Check if swap activated a special vortex or created matches
    const hasVortex = (gridNodes[r1][c1]?.special === 'vortex') || (gridNodes[r2][c2]?.special === 'vortex');
    const matches = findMatches();

    if (matches.length === 0 && !hasVortex) {
      // INVALID SWAP: Glitch Bounce Back
      playSynth('error');
      el1.classList.add('glitch-revert');
      el2.classList.add('glitch-revert');

      positionNodeElement(el1, r1, c1);
      positionNodeElement(el2, r2, c2);

      // Revert matrix
      const rev = gridNodes[r1][c1];
      gridNodes[r1][c1] = gridNodes[r2][c2];
      gridNodes[r2][c2] = rev;

      await delay(280);
      el1.classList.remove('glitch-revert');
      el2.classList.remove('glitch-revert');
      isLocked = false;
      return;
    }

    // VALID SWAP: Deduct Move
    movesLeft--;
    updateHUD();

    // Trigger Vortex if swapped
    if (hasVortex) {
      await handleVortexActivation(r1, c1, r2, c2);
    }

    // Process Cascade Chain
    let comboMultiplier = 1;
    await processMatchCascadeLoop(comboMultiplier);

    // Verify Resolution
    checkSectorResolution();
    isLocked = false;
  }

  /* =========================================================
     MATCH-3 SCANNING ALGORITHM
     ========================================================= */
  function findMatches() {
    const matchedCoords = new Set();
    const matchGroups = [];

    // Horizontal Scans
    for (let r = 0; r < gridDim; r++) {
      let matchLen = 1;
      for (let c = 0; c < gridDim; c++) {
        const isMatch = (c < gridDim - 1) && 
                        gridNodes[r][c] && 
                        gridNodes[r][c + 1] && 
                        (gridNodes[r][c].color === gridNodes[r][c + 1].color);
        if (isMatch) {
          matchLen++;
        } else {
          if (matchLen >= 3) {
            const group = [];
            for (let i = c - matchLen + 1; i <= c; i++) {
              matchedCoords.add(`${r},${i}`);
              group.push({ r, c: i, color: gridNodes[r][i].color });
            }
            matchGroups.push({ type: 'h', len: matchLen, coords: group });
          }
          matchLen = 1;
        }
      }
    }

    // Vertical Scans
    for (let c = 0; c < gridDim; c++) {
      let matchLen = 1;
      for (let r = 0; r < gridDim; r++) {
        const isMatch = (r < gridDim - 1) && 
                        gridNodes[r][c] && 
                        gridNodes[r + 1][c] && 
                        (gridNodes[r][c].color === gridNodes[r + 1][c].color);
        if (isMatch) {
          matchLen++;
        } else {
          if (matchLen >= 3) {
            const group = [];
            for (let i = r - matchLen + 1; i <= r; i++) {
              matchedCoords.add(`${i},${c}`);
              group.push({ r: i, c, color: gridNodes[i][c].color });
            }
            matchGroups.push({ type: 'v', len: matchLen, coords: group });
          }
          matchLen = 1;
        }
      }
    }

    // Convert Set of coordinates to array
    const resultCoords = Array.from(matchedCoords).map(str => {
      const [r, c] = str.split(',').map(Number);
      return { r, c };
    });

    return resultCoords;
  }

  /* =========================================================
     CASCADE LOOP & "DATA STREAM" PURGING FX
     ========================================================= */
  async function processMatchCascadeLoop(comboMultiplier) {
    let currentMatches = findMatches();

    while (currentMatches.length > 0) {
      playSynth('match', comboMultiplier);

      // Display Combo Flourish if combo >= 2
      if (comboMultiplier >= 2) {
        showComboFlourish(comboMultiplier);
      }

      // Check for Special Node Creation (Match 4 -> Line Glitcher, Match 5 -> Vortex)
      const specialSpawn = evaluateSpecialSpawns(currentMatches);

      // Trigger Line Glitchers if matched
      const expandedMatches = await triggerMatchedSpecials(currentMatches);

      // 1. Matched Nodes Charging Pulse
      expandedMatches.forEach(coord => {
        const el = document.querySelector(`.node-item[data-r='${coord.r}'][data-c='${coord.c}']`);
        if (el) el.classList.add('charging-purge');
      });

      // 2. Stream Data Particles upward to HUD & Shatter Corruption
      expandedMatches.forEach(coord => {
        spawnDataStreamParticles(coord.r, coord.c);
        shatterCorruptionAt(coord.r, coord.c);
      });

      // Score Increment
      const pts = expandedMatches.length * 30 * comboMultiplier;
      score += pts;
      updateHUD();

      await delay(220);

      // 3. Remove cleared nodes from matrix and DOM
      expandedMatches.forEach(coord => {
        const el = document.querySelector(`.node-item[data-r='${coord.r}'][data-c='${coord.c}']`);
        if (el) el.remove();
        gridNodes[coord.r][coord.c] = null;
      });

      // Place newly synthesized special node
      if (specialSpawn) {
        gridNodes[specialSpawn.r][specialSpawn.c] = {
          color: specialSpawn.color,
          special: specialSpawn.special,
          id: nextNodeId++
        };
        const newSpecialEl = createNodeElement(gridNodes[specialSpawn.r][specialSpawn.c], specialSpawn.r, specialSpawn.c);
        nodesLayer.appendChild(newSpecialEl);
      }

      // 4. Realistic Gravitational Drop & Top Refill
      await applyCascadingGravityPhysics();

      // Check next cascade wave
      comboMultiplier++;
      currentMatches = findMatches();
    }

    // Deadlock Prevention: if no possible moves remain, reshuffle!
    if (!findPossibleMoves().length) {
      await handleMatrixReshuffle();
    }
  }

  function evaluateSpecialSpawns(matches) {
    // If 4 nodes match in a row/col, spawn a Line Glitcher
    if (matches.length === 4) {
      const center = matches[1] || matches[0];
      const isHorizontal = matches[0].r === matches[1].r;
      return {
        r: center.r,
        c: center.c,
        color: gridNodes[center.r]?.[center.c]?.color ?? 0,
        special: isHorizontal ? 'line_v' : 'line_h' // Perpendicular line clear
      };
    } else if (matches.length >= 5) {
      const center = matches[2] || matches[0];
      return {
        r: center.r,
        c: center.c,
        color: gridNodes[center.r]?.[center.c]?.color ?? 0,
        special: 'vortex'
      };
    }
    return null;
  }

  async function triggerMatchedSpecials(matches) {
    const fullSet = new Set(matches.map(m => `${m.r},${m.c}`));

    for (const m of matches) {
      const node = gridNodes[m.r][m.c];
      if (!node) continue;

      if (node.special === 'line_h') {
        playSynth('laser');
        spawnLaserFlash('h', m.r);
        for (let c = 0; c < gridDim; c++) fullSet.add(`${m.r},${c}`);
      } else if (node.special === 'line_v') {
        playSynth('laser');
        spawnLaserFlash('v', m.c);
        for (let r = 0; r < gridDim; r++) fullSet.add(`${r},${m.c}`);
      } else if (node.special === 'vortex') {
        playSynth('vortex');
        for (let dr = -1; dr <= 1; dr++) {
          for (let dc = -1; dc <= 1; dc++) {
            const nr = m.r + dr;
            const nc = m.c + dc;
            if (nr >= 0 && nr < gridDim && nc >= 0 && nc < gridDim) {
              fullSet.add(`${nr},${nc}`);
            }
          }
        }
      }
    }

    return Array.from(fullSet).map(s => {
      const [r, c] = s.split(',').map(Number);
      return { r, c };
    });
  }

  async function handleVortexActivation(r1, c1, r2, c2) {
    playSynth('vortex');
    const targetColor = gridNodes[r1][c1]?.special === 'vortex' ? gridNodes[r2][c2]?.color : gridNodes[r1][c1]?.color;

    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        if (gridNodes[r][c]?.color === targetColor) {
          shatterCorruptionAt(r, c);
          const el = document.querySelector(`.node-item[data-r='${r}'][data-c='${c}']`);
          if (el) el.classList.add('charging-purge');
        }
      }
    }
  }

  /* =========================================================
     CASCADING GRAVITY FALL PHYSICS
     ========================================================= */
  async function applyCascadingGravityPhysics() {
    // 1. Shift remaining nodes downward
    for (let c = 0; c < gridDim; c++) {
      let emptyRow = gridDim - 1;
      for (let r = gridDim - 1; r >= 0; r--) {
        if (gridNodes[r][c] !== null) {
          if (r !== emptyRow) {
            gridNodes[emptyRow][c] = gridNodes[r][c];
            gridNodes[r][c] = null;

            const el = document.getElementById('node-' + gridNodes[emptyRow][c].id);
            if (el) positionNodeElement(el, emptyRow, c);
          }
          emptyRow--;
        }
      }

      // 2. Spawn new nodes from top
      let dropDistance = 1;
      for (let r = emptyRow; r >= 0; r--) {
        const newColor = Math.floor(Math.random() * activeColorsCount);
        gridNodes[r][c] = {
          color: newColor,
          special: null,
          id: nextNodeId++
        };

        const newEl = createNodeElement(gridNodes[r][c], r, c);
        // Start above the board for realistic fall-in
        const gap = 5;
        newEl.style.top = `-${dropDistance * 45}px`;
        nodesLayer.appendChild(newEl);

        // Animate fall down
        requestAnimationFrame(() => {
          positionNodeElement(newEl, r, c);
        });

        dropDistance++;
      }
    }

    await delay(250);
  }

  /* =========================================================
     CORRUPTION TILE SHATTERING & DATA STREAM FX
     ========================================================= */
  function shatterCorruptionAt(r, c) {
    if (corruptionTiles[r] && corruptionTiles[r][c]) {
      corruptionTiles[r][c] = false;
      clearedCorruptedCount++;
      playSynth('shatter');

      const tileEl = document.querySelector(`.tile-cell[data-r='${r}'][data-c='${c}']`);
      if (tileEl) {
        tileEl.classList.remove('corrupted');
        tileEl.classList.add('shattered');
      }
      updateHUD();
    }
  }

  function spawnDataStreamParticles(r, c) {
    const boardRect = boardContainer.getBoundingClientRect();
    const hudRect = scoreDisplay.getBoundingClientRect();

    const cellWidth = (boardRect.width - 16) / gridDim;
    const startX = boardRect.left + 8 + c * cellWidth + cellWidth / 2;
    const startY = boardRect.top + 8 + r * cellWidth + cellWidth / 2;

    const particle = document.createElement('div');
    particle.className = 'data-stream-particle';
    particle.style.left = startX + 'px';
    particle.style.top = startY + 'px';
    document.body.appendChild(particle);

    requestAnimationFrame(() => {
      particle.style.transform = `translate(${hudRect.left - startX + 20}px, ${hudRect.top - startY + 10}px) scale(0.3)`;
      particle.style.opacity = '0';
    });

    setTimeout(() => particle.remove(), 450);
  }

  function spawnLaserFlash(dir, index) {
    const flash = document.createElement('div');
    flash.className = dir === 'h' ? 'laser-sweep-h' : 'laser-sweep-v';
    const cellWidth = (boardContainer.clientWidth - 16) / gridDim;
    if (dir === 'h') flash.style.top = (8 + index * cellWidth + cellWidth / 2 - 5) + 'px';
    else flash.style.left = (8 + index * cellWidth + cellWidth / 2 - 5) + 'px';

    boardContainer.appendChild(flash);
    setTimeout(() => flash.remove(), 350);
  }

  function showComboFlourish(combo) {
    const el = document.createElement('div');
    el.className = 'combo-flourish';
    const texts = ['GLITCH COMBO!', 'DATA PURGE!', 'QUANTUM CASCADE!', 'CYBER OVERDRIVE!'];
    const chosen = texts[Math.min(texts.length - 1, combo - 2)];
    el.innerText = `${chosen} x${combo}`;
    boardContainer.appendChild(el);
    setTimeout(() => el.remove(), 750);
  }

  /* =========================================================
     DEADLOCK DETECTION & RESHUFFLE
     ========================================================= */
  function findPossibleMoves() {
    const validMoves = [];

    // Helper to check match with simulated swap
    function checkSimulatedMatch(r1, c1, r2, c2) {
      const temp = gridNodes[r1][c1];
      gridNodes[r1][c1] = gridNodes[r2][c2];
      gridNodes[r2][c2] = temp;

      const matches = findMatches();

      // Revert
      gridNodes[r2][c2] = gridNodes[r1][c1];
      gridNodes[r1][c1] = temp;

      return matches.length > 0;
    }

    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        // Swap Right
        if (c + 1 < gridDim) {
          if (checkSimulatedMatch(r, c, r, c + 1)) validMoves.push({ r1: r, c1: c, r2: r, c2: c + 1 });
        }
        // Swap Down
        if (r + 1 < gridDim) {
          if (checkSimulatedMatch(r, c, r + 1, c)) validMoves.push({ r1: r, c1: c, r2: r + 1, c2: c });
        }
      }
    }

    return validMoves;
  }

  async function handleMatrixReshuffle() {
    playSynth('error');
    sectorBadge.innerText = 'RESHUFFLING...';
    sectorBadge.style.color = 'var(--warning)';

    await delay(350);

    // Reshuffle node colors
    const colors = [];
    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        if (gridNodes[r][c]) colors.push(gridNodes[r][c].color);
      }
    }

    // Fisher-Yates Shuffle
    for (let i = colors.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [colors[i], colors[j]] = [colors[j], colors[i]];
    }

    let idx = 0;
    for (let r = 0; r < gridDim; r++) {
      for (let c = 0; c < gridDim; c++) {
        gridNodes[r][c].color = colors[idx++];
      }
    }

    renderAllNodes();
    sectorBadge.innerText = 'SECTOR ' + (currentSector < 10 ? '0' + currentSector : currentSector);
    sectorBadge.style.color = '';
  }

  /* =========================================================
     SECTOR RESOLUTION: WIN / GAME OVER TELEMETRY
     ========================================================= */
  function checkSectorResolution() {
    // 1. Victory Check: All Firewall Corruption Cleansed!
    if (clearedCorruptedCount >= totalCorruptedCount) {
      triggerSectorWin();
      return;
    }

    // 2. Defeat Check: Moves Exhausted
    if (movesLeft <= 0) {
      triggerGameOver();
    }
  }

  function triggerSectorWin() {
    playSynth('win');
    const moveBonus = movesLeft * 120;
    score += moveBonus;
    updateHUD();

    document.getElementById('winBonusVal').innerText = `+${moveBonus} pts (${movesLeft} Moves Left)`;
    document.getElementById('winTotalScore').innerText = score + ' pts';
    winOverlay.style.display = 'flex';

    saveScoreRecords(score);
  }

  function advanceToNextLevel() {
    winOverlay.style.display = 'none';
    setupSector(currentSector + 1);
  }

  function triggerGameOver() {
    isGameOver = true;
    playSynth('gameover');

    document.getElementById('finalScoreVal').innerText = score + ' pts';
    document.getElementById('finalSectorVal').innerText = 'Sector ' + currentSector;
    gameOverOverlay.style.display = 'flex';

    saveScoreRecords(score);
  }

  function saveScoreRecords(finalScore) {
    // Local telemetry
    const prevBest = parseInt(localStorage.getItem('hub_glitch_high') || '0', 10);
    if (finalScore > prevBest) {
      localStorage.setItem('hub_glitch_high', finalScore);
    }
    const prevSec = localStorage.getItem('hub_glitch_sector') || 'Sector 1';
    const prevSecNum = parseInt(prevSec.replace(/\D/g, '') || '1', 10);
    if (currentSector > prevSecNum) {
      localStorage.setItem('hub_glitch_sector', 'Sector ' + currentSector);
    }

    // Database Cloud sync
    saveScoreToDatabase(finalScore);
  }

  async function saveScoreToDatabase(finalScore) {
    try {
      const params = new URLSearchParams();
      params.append('game', 'glitch_protocol');
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
          reasonEl.innerHTML = '<span style="color: var(--primary);">✓ High score synchronized to cloud leaderboard!</span>';
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
