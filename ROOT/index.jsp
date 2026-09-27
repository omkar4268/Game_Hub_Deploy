<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentUser = null;
    if (session != null) {
        currentUser = (String) session.getAttribute("user_session");
        if (currentUser == null || currentUser.trim().isEmpty()) {
            currentUser = (String) session.getAttribute("user");
        }
    }
    boolean isLoggedIn = (currentUser != null && !currentUser.trim().isEmpty());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Game Hub | Brain & Mind Training Games</title>
<style>
  :root {
    --bg-base: #03050a;
    --card-bg: rgba(13, 19, 36, 0.75);
    --border-glow: rgba(56, 189, 248, 0.35);
    --primary: #38bdf8;
    --primary-rgb: 56, 189, 248;
    --accent: #22c55e;
    --accent-glow: rgba(34, 197, 94, 0.4);
    --neon-pink: #f43f5e;
    --neon-purple: #a855f7;
    --warning: #f59e0b;
    --danger: #ef4444;
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
  }

  * { 
    box-sizing: border-box; 
    margin: 0; 
    padding: 0; 
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
    -webkit-tap-highlight-color: transparent; 
  }

  body {
    background-color: var(--bg-base);
    color: var(--text-main);
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    overflow-x: hidden;
    position: relative;
  }

  @keyframes backgroundDrift {
    0% { background-position: 0% 0%; }
    100% { background-position: 100% 100%; }
  }
  
  body::before {
    content: '';
    position: fixed;
    inset: -50%;
    width: 200%;
    height: 200%;
    background: 
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.09) 0%, transparent 30%),
      radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.09) 0%, transparent 30%),
      radial-gradient(circle at 50% 50%, rgba(34, 197, 94, 0.04) 0%, transparent 35%),
      linear-gradient(rgba(255,255,255,0.015) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.015) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 100% 100%, 36px 36px, 36px 36px;
    z-index: -1;
    pointer-events: none;
    animation: backgroundDrift 100s linear infinite;
  }

  /* =========================================================
     FEATURE 1: HIGH-SPEED DIGITAL ZOOM-THROUGH & CYBER SHUTTER
     ========================================================= */
  .cyber-shutter {
    position: fixed;
    inset: 0;
    z-index: 5500;
    pointer-events: none;
    opacity: 0;
  }
  .cyber-shutter.active {
    pointer-events: all;
    opacity: 1;
    animation: cyberShutterAnim 0.28s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  @keyframes cyberShutterAnim {
    0% {
      background: rgba(56, 189, 248, 0.25);
      box-shadow: inset 0 0 100px rgba(56, 189, 248, 0.5);
      backdrop-filter: blur(2px);
    }
    50% {
      background: rgba(34, 197, 94, 0.2);
      backdrop-filter: blur(0px);
    }
    100% {
      background: transparent;
      opacity: 0;
    }
  }

  .cyber-shutter-beam {
    position: absolute;
    left: 0;
    right: 0;
    height: 4px;
    top: -10px;
    background: linear-gradient(90deg, transparent 0%, #38bdf8 30%, #22c55e 70%, transparent 100%);
    box-shadow: 0 0 25px #38bdf8, 0 0 40px #22c55e;
  }
  .cyber-shutter.active .cyber-shutter-beam {
    animation: shutterBeamSweep 0.26s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  @keyframes shutterBeamSweep {
    0% { top: 0%; opacity: 1; }
    100% { top: 100%; opacity: 0; }
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

  /* =========================================================
     LANDING PORTAL OVERLAY
     ========================================================= */
  #landingPortal {
    position: fixed;
    inset: 0;
    z-index: 5000;
    background: radial-gradient(circle at center, #091122 0%, #020408 100%);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
    text-align: center;
    transition: transform 0.28s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.25s ease, filter 0.25s ease, visibility 0.28s ease;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
  }
  #landingPortal.zoom-through {
    transform: scale(1.08);
    opacity: 0;
    filter: blur(5px);
    pointer-events: none;
  }
  #landingPortal.dismissed {
    opacity: 0;
    pointer-events: none;
    visibility: hidden;
  }

  .portal-content {
    max-width: 540px;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
    z-index: 2;
  }

  .portal-tag {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(56, 189, 248, 0.1);
    border: 1px solid rgba(56, 189, 248, 0.3);
    padding: 6px 16px;
    border-radius: 9999px;
    font-size: 0.75rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: var(--primary);
    text-transform: uppercase;
    margin-bottom: 1.2rem;
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.2);
  }
  .portal-tag::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent);
    box-shadow: 0 0 10px var(--accent);
    animation: pulseDot 1.8s infinite;
  }
  @keyframes pulseDot {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.3); opacity: 0.6; }
  }

  .portal-title {
    font-size: clamp(2.2rem, 6vw, 3.2rem);
    font-weight: 900;
    letter-spacing: 2.5px;
    line-height: 1.1;
    margin-bottom: 0.6rem;
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--neon-purple) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    text-shadow: 0 0 35px rgba(56, 189, 248, 0.4);
  }

  .portal-subtitle {
    font-size: clamp(0.85rem, 2.5vw, 0.95rem);
    color: var(--text-muted);
    line-height: 1.6;
    margin-bottom: 2rem;
    max-width: 460px;
  }

  .portal-actions {
    display: flex;
    flex-direction: column;
    gap: 0.85rem;
    width: 100%;
    max-width: 320px;
  }

  .btn-portal {
    min-height: 48px;
    padding: 0.8rem 1.4rem;
    border-radius: 12px;
    font-size: 0.92rem;
    font-weight: 800;
    letter-spacing: 1px;
    cursor: pointer;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    text-decoration: none;
    box-sizing: border-box;
  }

  .btn-portal-primary {
    background: linear-gradient(135deg, var(--primary), #0284c7);
    color: #000;
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.4);
  }
  .btn-portal-primary:hover {
    background: linear-gradient(135deg, #7dd3fc, var(--primary));
    box-shadow: 0 0 30px rgba(56, 189, 248, 0.6);
    transform: translateY(-2px);
  }

  .btn-portal-secondary {
    background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(34, 197, 94, 0.05));
    border: 1px solid rgba(34, 197, 94, 0.4);
    color: #86efac;
    box-shadow: 0 0 15px rgba(34, 197, 94, 0.2);
  }
  .btn-portal-secondary:hover {
    background: rgba(34, 197, 94, 0.25);
    border-color: var(--accent);
    color: #fff;
    transform: translateY(-2px);
  }

  .btn-portal-guest {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-muted);
  }
  .btn-portal-guest:hover {
    background: rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    border-color: rgba(255, 255, 255, 0.25);
  }

  .portal-footer-note {
    margin-top: 1.8rem;
    font-size: 0.72rem;
    color: #64748b;
    letter-spacing: 0.8px;
  }

  /* =========================================================
     MAIN APPLICATION LAYOUT & SIDEBAR
     ========================================================= */
  aside {
    width: 260px;
    background: rgba(8, 12, 23, 0.85);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border-right: 1px solid rgba(255, 255, 255, 0.06);
    display: flex;
    flex-direction: column;
    padding: 2rem 1.3rem;
    flex-shrink: 0;
    z-index: 100;
    box-shadow: 5px 0 35px rgba(0,0,0,0.6);
  }

  .brand {
    font-size: 1.45rem;
    font-weight: 900;
    letter-spacing: 2.5px;
    display: flex;
    align-items: center;
    gap: 0.6rem;
    margin-bottom: 2rem;
    text-shadow: 0 0 20px rgba(56, 189, 248, 0.5);
    cursor: pointer;
  }
  .brand-badge {
    background: linear-gradient(135deg, var(--primary), var(--neon-purple));
    font-size: 0.68rem;
    padding: 3px 8px;
    border-radius: 6px;
    color: #000;
    font-weight: 900;
    box-shadow: 0 0 15px rgba(168, 85, 247, 0.4);
  }

  /* User Auth Widget in Sidebar */
  .auth-widget {
    background: rgba(15, 23, 42, 0.7);
    border: 1px solid rgba(56, 189, 248, 0.25);
    border-radius: 14px;
    padding: 1.1rem;
    margin-bottom: 2rem;
    text-align: center;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.35);
  }
  .auth-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    margin: 0 auto 0.6rem auto;
    background: linear-gradient(135deg, var(--primary), var(--neon-purple));
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    color: #000;
    font-weight: 900;
    box-shadow: 0 0 18px rgba(56, 189, 248, 0.4);
  }
  .auth-name {
    font-size: 0.98rem;
    font-weight: 800;
    color: var(--primary);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .auth-role {
    font-size: 0.7rem;
    color: var(--accent);
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 0.9rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
  }
  .auth-role::before {
    content: '';
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
    box-shadow: 0 0 6px currentColor;
  }

  .btn-auth {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    width: 100%;
    padding: 0.6rem;
    border-radius: 8px;
    font-size: 0.85rem;
    font-weight: 700;
    cursor: pointer;
    border: none;
    transition: all 0.2s ease;
  }
  .btn-login {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 12px rgba(56, 189, 248, 0.3);
  }
  .btn-login:hover {
    background: #7dd3fc;
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.5);
  }
  .btn-logout {
    background: rgba(239, 68, 68, 0.15);
    color: #fca5a5;
    border: 1px solid rgba(239, 68, 68, 0.35);
  }
  .btn-logout:hover {
    background: rgba(239, 68, 68, 0.3);
    color: #fff;
  }

  nav { display: flex; flex-direction: column; gap: 0.8rem; }
  .nav-btn {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 0.9rem 1.1rem;
    border-radius: 12px;
    background: transparent;
    color: var(--text-muted);
    border: 1px solid transparent;
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 700;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    text-align: left;
    position: relative;
    overflow: hidden;
  }
  
  .nav-btn:hover { 
    color: var(--text-main); 
    background: rgba(255, 255, 255, 0.04); 
    transform: translateX(4px);
  }
  
  .nav-btn.active {
    background: linear-gradient(90deg, rgba(56, 189, 248, 0.12), transparent);
    color: var(--primary);
    border-color: rgba(56, 189, 248, 0.25);
    box-shadow: inset 4px 0 0 var(--primary);
  }

  .btn-portal-recall {
    margin-top: auto;
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.08);
    color: var(--text-muted);
    padding: 0.6rem;
    border-radius: 10px;
    font-size: 0.8rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    transition: 0.2s;
  }
  .btn-portal-recall:hover {
    background: rgba(255, 255, 255, 0.08);
    color: var(--text-main);
  }

  /* =========================================================
     FEATURE 2: BALANCED UI PROPORTIONS & GRID SCALING
     ========================================================= */
  main {
    flex: 1;
    padding: 2.2rem 2.5rem;
    overflow-y: auto;
    width: 100%;
    max-width: 1500px;
    margin: 0 auto;
    box-sizing: border-box;
  }

  .top-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    flex-wrap: wrap;
    gap: 1rem;
  }
  .top-meta h2 { 
    font-size: clamp(1.8rem, 4vw, 2.3rem); 
    font-weight: 900; 
    background: linear-gradient(to right, #fff, #94a3b8);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  .sys-status {
    font-size: 0.85rem;
    color: var(--accent);
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(34, 197, 94, 0.1);
    padding: 6px 14px;
    border-radius: 20px;
    border: 1px solid rgba(34, 197, 94, 0.25);
    box-shadow: 0 0 15px rgba(34, 197, 94, 0.15);
  }
  .sys-status::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent);
    animation: pulseDot 2s infinite;
  }

  .view-panel { display: none; opacity: 0; transition: opacity 0.35s ease; }
  .view-panel.active { display: block; opacity: 1; }

  .carousel-controls {
    display: flex;
    justify-content: flex-end;
    gap: 0.8rem;
    margin-bottom: 1.2rem;
  }
  .scroll-btn {
    background: rgba(15, 23, 42, 0.6);
    backdrop-filter: blur(4px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    width: 42px;
    height: 42px;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    transition: all 0.2s;
  }
  .scroll-btn:hover {
    background: var(--primary);
    color: #000;
    border-color: var(--primary);
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.5);
  }

  .game-carousel {
    display: flex;
    gap: 1.6rem;
    overflow-x: auto;
    padding: 0.8rem 0.5rem 2.5rem 0.5rem;
    scroll-behavior: smooth;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
  }
  .game-carousel::-webkit-scrollbar { height: 8px; }
  .game-carousel::-webkit-scrollbar-track { background: rgba(0,0,0,0.2); border-radius: 4px; }
  .game-carousel::-webkit-scrollbar-thumb { background: rgba(56, 189, 248, 0.3); border-radius: 4px; }
  .game-carousel::-webkit-scrollbar-thumb:hover { background: var(--primary); }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .game-card {
    min-width: 290px;
    max-width: 320px;
    width: 300px;
    background: var(--card-bg);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.06);
    overflow: hidden;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
    scroll-snap-align: center;
    flex-shrink: 0;
    opacity: 0;
    animation: fadeInUp 0.5s ease forwards;
    position: relative;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  }

  .game-card:hover {
    transform: translateY(-8px) scale(1.02);
    border-color: rgba(var(--primary-rgb), 0.5);
    box-shadow: 0 20px 45px rgba(0, 0, 0, 0.8), 0 0 25px rgba(var(--primary-rgb), 0.25);
  }

  .banner-bomb    { background: linear-gradient(135deg, #7f1d1d, #ea580c); }
  .banner-chess   { background: linear-gradient(135deg, #4c1d95, #ec4899); }
  .banner-snake   { background: linear-gradient(135deg, #064e3b, #10b981); }
  .banner-maze    { background: linear-gradient(135deg, #0c4a6e, #38bdf8); }
  .banner-guesser { background: linear-gradient(135deg, #312e81, #6366f1); }
  .banner-reactor { background: linear-gradient(135deg, #1e293b, #0284c7 50%, #f43f5e 100%); }

  .card-banner {
    height: 140px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3.6rem;
    position: relative;
    overflow: hidden;
  }

  .card-body {
    padding: 1.3rem;
    display: flex;
    flex-direction: column;
    flex: 1;
    background: linear-gradient(180deg, rgba(15,23,42,0) 0%, rgba(15,23,42,0.85) 100%);
  }
  .card-tag {
    font-size: 0.68rem;
    letter-spacing: 1.5px;
    font-weight: 800;
    text-transform: uppercase;
    color: var(--primary);
    margin-bottom: 0.35rem;
  }
  .card-title { font-size: 1.25rem; font-weight: 800; margin-bottom: 0.35rem; }
  .card-desc { font-size: 0.85rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 1.2rem; }

  .card-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 0.85rem;
    border-top: 1px solid rgba(255,255,255,0.06);
  }
  .card-score-preview { font-size: 0.82rem; color: var(--text-muted); }
  .card-score-preview span { color: var(--primary); font-weight: 800; }
  
  .launch-arrow {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary);
    font-size: 1.1rem;
    transition: all 0.3s;
  }
  .game-card:hover .launch-arrow {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 15px rgba(var(--primary-rgb), 0.6);
  }

  /* Cognitive Radar Chart (Spider Graph) */
  .radar-card {
    background: radial-gradient(circle at 80% 20%, rgba(56, 189, 248, 0.08) 0%, rgba(15, 23, 42, 0.8) 100%);
    backdrop-filter: blur(16px);
    border: 1px solid rgba(56, 189, 248, 0.3);
    border-radius: 20px;
    padding: 1.8rem;
    margin-bottom: 2rem;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5), inset 0 0 30px rgba(56, 189, 248, 0.05);
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
  }
  .radar-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    padding-bottom: 1rem;
    flex-wrap: wrap;
    gap: 1rem;
  }
  .radar-title {
    font-size: 1.35rem;
    font-weight: 900;
    letter-spacing: 1px;
    color: #fff;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .radar-subtitle {
    font-size: 0.82rem;
    color: var(--text-muted);
    margin-top: 4px;
  }
  .brain-index-badge {
    background: rgba(56, 189, 248, 0.12);
    border: 1px solid var(--primary);
    padding: 8px 16px;
    border-radius: 12px;
    text-align: right;
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.25);
  }
  .brain-index-label {
    display: block;
    font-size: 0.65rem;
    font-weight: 900;
    color: var(--primary);
    letter-spacing: 1.5px;
  }
  .brain-index-val {
    font-size: 1.4rem;
    font-weight: 900;
    color: #fff;
    font-variant-numeric: tabular-nums;
  }

  .radar-content {
    display: flex;
    align-items: center;
    justify-content: space-around;
    flex-wrap: wrap;
    gap: 1.5rem;
  }
  .radar-canvas-wrap {
    width: 290px;
    height: 270px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  #radarChartCanvas {
    width: 290px;
    height: 270px;
    display: block;
  }

  .radar-metrics-list {
    flex: 1;
    min-width: 260px;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }
  .radar-metric-item {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    padding: 10px 14px;
    display: flex;
    align-items: center;
    gap: 12px;
    transition: background 0.2s;
  }
  .radar-metric-item:hover {
    background: rgba(255, 255, 255, 0.06);
  }
  .metric-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    flex-shrink: 0;
  }
  .metric-name {
    font-weight: 800;
    font-size: 0.9rem;
    color: #fff;
    width: 75px;
  }
  .metric-desc {
    font-size: 0.75rem;
    color: var(--text-muted);
    flex: 1;
  }
  .metric-val {
    font-size: 0.95rem;
    font-weight: 900;
    font-family: monospace;
    color: var(--primary);
  }

  /* Score Grid */
  .score-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
    gap: 1.4rem;
  }
  .score-card, .settings-box {
    background: var(--card-bg);
    backdrop-filter: blur(14px);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 18px;
    padding: 1.6rem;
    transition: transform 0.3s ease, border-color 0.3s ease;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
    position: relative;
    overflow: hidden;
  }
  .score-card:hover { 
    transform: translateY(-4px); 
    border-color: rgba(56, 189, 248, 0.3); 
    box-shadow: 0 15px 35px rgba(0,0,0,0.6);
  }
  
  .score-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.1rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  }
  .score-card-title {
    font-size: 1.2rem;
    font-weight: 800;
    letter-spacing: 0.5px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .score-badge {
    font-size: 0.65rem;
    font-weight: 800;
    padding: 3px 8px;
    border-radius: 6px;
    text-transform: uppercase;
  }

  .stat-row, .settings-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.7rem 0;
    border-bottom: 1px dashed rgba(255, 255, 255, 0.08);
  }
  .stat-row:last-child, .settings-row:last-child { border-bottom: none; }
  .stat-label { color: var(--text-muted); font-size: 0.85rem; }
  .stat-val { font-weight: 800; font-size: 1rem; }

  .switch {
    position: relative; display: inline-block; width: 44px; height: 24px;
  }
  .switch input { opacity: 0; width: 0; height: 0; }
  .slider {
    position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
    background-color: rgba(255,255,255,0.1); transition: .4s; border-radius: 24px;
  }
  .slider:before {
    position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px;
    background-color: white; transition: .4s; border-radius: 50%;
  }
  input:checked + .slider { background-color: var(--primary); box-shadow: 0 0 10px var(--primary); }
  input:checked + .slider:before { transform: translateX(20px); }

  /* Modals */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(3, 5, 10, 0.92);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    padding: 1rem;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    opacity: 0;
    transition: opacity 0.25s ease;
  }
  .modal-overlay.active { display: flex; opacity: 1; }
  
  .modal-box {
    background: #0d1324;
    border: 1px solid rgba(56, 189, 248, 0.4);
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.95), 0 0 35px rgba(56, 189, 248, 0.25);
    border-radius: 18px;
    padding: 1.8rem 1.5rem;
    width: 90vw;
    max-width: 410px;
    max-height: 85vh;
    max-height: 85dvh;
    overflow-y: auto;
    margin: auto;
    text-align: center;
    transform: scale(0.94);
    transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    position: relative;
    box-sizing: border-box;
  }
  .modal-overlay.active .modal-box { transform: scale(1); }
  
  .modal-actions {
    display: flex;
    gap: 0.8rem;
    justify-content: center;
    margin-top: 1.4rem;
  }
  .btn-modal {
    min-height: 46px;
    padding: 0.75rem 1.2rem;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    font-weight: 800;
    font-size: 0.92rem;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.2s ease;
    flex: 1;
  }
  .btn-modal:disabled { opacity: 0.65; cursor: not-allowed; filter: grayscale(0.5); }
  .btn-launch { background: var(--primary); color: #000; box-shadow: 0 0 15px rgba(var(--primary-rgb), 0.4); }
  .btn-launch:hover:not(:disabled) { background: #0ea5e9; box-shadow: 0 0 25px rgba(var(--primary-rgb), 0.6); transform: translateY(-2px); }
  .btn-cancel { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
  .btn-cancel:hover:not(:disabled) { background: rgba(255, 255, 255, 0.15); }

  .auth-form-group { text-align: left; margin-top: 1rem; }
  .auth-label {
    display: block;
    font-size: 0.74rem;
    color: var(--text-muted);
    margin-bottom: 0.35rem;
    font-weight: 700;
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }
  .auth-input {
    width: 100%;
    height: 46px;
    min-height: 44px;
    padding: 0 1rem;
    background: rgba(15, 23, 42, 0.9);
    border: 1px solid rgba(56, 189, 248, 0.3);
    border-radius: 10px;
    color: var(--text-main);
    font-size: 16px !important; /* Critical: blocks iOS Safari auto-zoom */
    outline: none;
    transition: all 0.2s ease;
    box-sizing: border-box;
  }
  .auth-input:focus {
    border-color: var(--primary);
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.4);
    background: rgba(15, 23, 42, 1);
  }

  @keyframes bannerSlideIn {
    from { opacity: 0; transform: translateY(-8px) scale(0.96); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }
  .auth-msg {
    margin-top: 1rem;
    font-size: 0.85rem;
    line-height: 1.4;
    padding: 0.75rem 1rem;
    border-radius: 10px;
    display: none;
    text-align: left;
    animation: bannerSlideIn 0.3s ease forwards;
    word-break: break-word;
  }
  .auth-msg.error {
    background: rgba(239, 68, 68, 0.12);
    color: #fca5a5;
    border: 1px solid rgba(239, 68, 68, 0.6);
    box-shadow: 0 0 15px rgba(239, 68, 68, 0.25);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .auth-msg.success {
    background: rgba(34, 197, 94, 0.12);
    color: #86efac;
    border: 1px solid rgba(34, 197, 94, 0.6);
    box-shadow: 0 0 15px rgba(34, 197, 94, 0.25);
    display: flex;
    align-items: center;
    gap: 8px;
  }

  @keyframes spin { to { transform: rotate(360deg); } }
  .spinner {
    display: inline-block;
    width: 16px;
    height: 16px;
    border: 2px solid rgba(0, 0, 0, 0.25);
    border-top-color: #000;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }

  .switch-auth-link {
    display: inline-block;
    margin-top: 1.1rem;
    font-size: 0.85rem;
    color: var(--text-muted);
    cursor: pointer;
    text-decoration: underline;
    padding: 0.4rem;
  }
  .switch-auth-link:hover { color: var(--primary); }

  /* =========================================================
     DISCORD & GOOGLE PLAY GAMES ACCOUNT LEVELING SYSTEM
     ========================================================= */
  .profile-level-badge {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    background: linear-gradient(135deg, #f59e0b, #d97706);
    color: #000;
    font-size: 0.72rem;
    font-weight: 900;
    padding: 2px 7px;
    border-radius: 6px;
    letter-spacing: 0.5px;
    box-shadow: 0 0 10px rgba(245, 158, 11, 0.4);
    margin-left: 6px;
    vertical-align: middle;
  }
  .player-rank-title {
    font-size: 0.72rem;
    font-weight: 700;
    color: #38bdf8;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-top: 2px;
  }
  .profile-xp-box {
    width: 100%;
    margin-top: 8px;
    background: rgba(0, 0, 0, 0.45);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 8px;
    padding: 7px 9px;
    text-align: left;
  }
  .xp-header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.7rem;
    font-weight: 700;
    color: var(--text-muted);
    margin-bottom: 5px;
  }
  .xp-header-row .xp-val {
    color: var(--accent);
    font-weight: 800;
  }
  .xp-bar-track {
    width: 100%;
    height: 7px;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 999px;
    overflow: hidden;
    position: relative;
  }
  .xp-bar-fill {
    height: 100%;
    width: 0%;
    background: linear-gradient(90deg, #22c55e, #38bdf8);
    border-radius: 999px;
    box-shadow: 0 0 8px rgba(34, 197, 94, 0.6);
    transition: width 0.6s cubic-bezier(0.2, 0.8, 0.2, 1);
  }
  .xp-subtext {
    font-size: 0.64rem;
    color: var(--text-muted);
    margin-top: 4px;
    display: flex;
    justify-content: space-between;
  }

  /* Header Level Pill (Desktop & Mobile) */
  .meta-level-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: rgba(245, 158, 11, 0.12);
    border: 1px solid rgba(245, 158, 11, 0.35);
    color: #facc15;
    font-size: 0.75rem;
    font-weight: 800;
    padding: 4px 10px;
    border-radius: 999px;
    letter-spacing: 0.5px;
  }

  /* Navigation Lock Indicators */
  .nav-lock-badge {
    font-size: 0.75rem;
    margin-left: auto;
    background: rgba(244, 63, 94, 0.18);
    color: #f43f5e;
    border: 1px solid rgba(244, 63, 94, 0.3);
    padding: 1px 6px;
    border-radius: 4px;
    font-weight: 800;
    letter-spacing: 0.5px;
  }

  /* =========================================================
     LOCKED FEATURE CARDS FOR GUESTS
     ========================================================= */
  .locked-card {
    background: var(--card-bg);
    border: 1px solid rgba(244, 63, 94, 0.35);
    border-radius: 18px;
    padding: 2.4rem 1.8rem;
    text-align: center;
    max-width: 620px;
    margin: 2rem auto;
    position: relative;
    backdrop-filter: blur(16px);
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5), 0 0 25px rgba(244, 63, 94, 0.1);
  }
  .locked-icon-wrap {
    width: 64px;
    height: 64px;
    margin: 0 auto 1.2rem;
    background: rgba(244, 63, 94, 0.15);
    border: 1px solid rgba(244, 63, 94, 0.4);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.9rem;
    color: #f43f5e;
    box-shadow: 0 0 20px rgba(244, 63, 94, 0.3);
  }
  .locked-title {
    font-size: 1.45rem;
    font-weight: 900;
    color: var(--text-main);
    letter-spacing: 0.5px;
    margin-bottom: 0.6rem;
  }
  .locked-subtitle {
    color: var(--text-muted);
    font-size: 0.92rem;
    line-height: 1.55;
    max-width: 480px;
    margin: 0 auto 1.5rem;
  }
  .locked-perks-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 10px;
    margin-bottom: 1.8rem;
    text-align: left;
  }
  .locked-perk-item {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    padding: 10px 12px;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    font-size: 0.82rem;
  }
  .locked-perk-icon {
    font-size: 1.1rem;
    line-height: 1;
  }
  .locked-perk-title {
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 2px;
  }
  .locked-perk-desc {
    color: var(--text-muted);
    font-size: 0.75rem;
  }
  .locked-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
  }
  .btn-unlock-primary {
    background: linear-gradient(135deg, var(--primary), #0284c7);
    color: #000;
    font-weight: 900;
    border: none;
    padding: 10px 24px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.92rem;
    box-shadow: 0 0 16px rgba(56, 189, 248, 0.4);
    transition: all 0.2s;
  }
  .btn-unlock-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 0 24px rgba(56, 189, 248, 0.7);
  }
  .btn-unlock-secondary {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: var(--text-main);
    font-weight: 700;
    padding: 10px 22px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.92rem;
    transition: all 0.2s;
  }
  .btn-unlock-secondary:hover {
    background: rgba(255, 255, 255, 0.12);
  }

  /* Player Level Spotlight Card in Brain Stats */
  .player-spotlight-card {
    background: var(--card-bg);
    border: 1px solid rgba(245, 158, 11, 0.35);
    border-radius: 16px;
    padding: 1.4rem;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1.4rem;
    flex-wrap: wrap;
    backdrop-filter: blur(12px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
  }
  .spotlight-level-emblem {
    width: 68px;
    height: 68px;
    border-radius: 16px;
    background: linear-gradient(135deg, #f59e0b, #b45309);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #000;
    font-weight: 900;
    box-shadow: 0 0 20px rgba(245, 158, 11, 0.45);
    flex-shrink: 0;
  }
  .spotlight-level-emblem .emblem-lbl {
    font-size: 0.62rem;
    letter-spacing: 1px;
    line-height: 1;
  }
  .spotlight-level-emblem .emblem-num {
    font-size: 1.7rem;
    line-height: 1;
    margin-top: 2px;
  }
  .spotlight-info {
    flex: 1;
    min-width: 220px;
  }
  .spotlight-name-row {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 4px;
  }
  .spotlight-username {
    font-size: 1.25rem;
    font-weight: 900;
    color: var(--text-main);
  }
  .spotlight-tier-tag {
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.35);
    color: var(--primary);
    font-size: 0.72rem;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 999px;
  }

  /* Mobile Overrides */
  @media (max-width: 768px) {
    body { flex-direction: column; padding-bottom: 80px; }

    aside {
      width: 100%; height: 75px; position: fixed; bottom: 0; left: 0; right: 0;
      padding: 0.4rem; flex-direction: row; border-right: none;
      border-top: 1px solid rgba(255, 255, 255, 0.08); background: rgba(8, 12, 23, 0.96);
      align-items: center; justify-content: space-around; z-index: 999;
    }

    .brand, .auth-widget, .btn-portal-recall { display: none; }
    nav { flex-direction: row; width: 100%; justify-content: space-around; gap: 0; }
    .nav-btn {
      flex-direction: column; gap: 4px; padding: 0.35rem; font-size: 0.72rem;
      border-left: none !important; border-radius: 10px; text-align: center;
    }
    .nav-btn.active {
      background: rgba(56, 189, 248, 0.1); color: var(--primary);
      box-shadow: none; border-top: 2px solid var(--primary);
    }

    main { padding: 1.2rem 1rem; }
    .top-meta h2 { font-size: 1.5rem; }
    .carousel-controls { display: none; }
    
    .game-carousel { padding-bottom: 1.8rem; gap: 1.2rem; }
    .game-card { min-width: 82vw; width: 82vw; }

    .modal-box {
      padding: 1.4rem 1.1rem;
      width: 92vw;
      max-height: 82vh;
      max-height: 82dvh;
    }

    .portal-content {
      padding: 0.5rem;
    }
    .portal-title {
      font-size: 1.95rem;
    }
    .portal-subtitle {
      font-size: 0.82rem;
      margin-bottom: 1.2rem;
    }
    .portal-actions {
      max-width: 100%;
      width: 100%;
    }
    .btn-portal {
      min-height: 44px;
      padding: 0.7rem 1rem;
    }

    .nav-lock-badge { margin-left: 0; font-size: 0.65rem; padding: 0 4px; }
    .locked-card { padding: 1.6rem 1.1rem; width: 100%; margin: 1rem auto; }
    .locked-title { font-size: 1.25rem; }
    .locked-perks-grid { grid-template-columns: 1fr; }
    .player-spotlight-card { padding: 1rem; gap: 1rem; }
    .spotlight-level-emblem { width: 56px; height: 56px; }
    .spotlight-level-emblem .emblem-num { font-size: 1.4rem; }
  }
</style>
</head>
<body>

  <!-- Universal Cyber-Scanner Wipe Transition -->
  <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
    <div class="cyber-wipe-beam"></div>
  </div>

  <!-- High-Speed Cyber Shutter Flash -->
  <div id="cyberShutter" class="cyber-shutter">
    <div class="cyber-shutter-beam"></div>
  </div>

  <!-- =========================================================
       LANDING PORTAL OVERLAY
       ========================================================= -->
  <div id="landingPortal">
    <div class="portal-content">
      <div class="portal-tag">🧠 BRAIN TRAINING & LOGIC HUB</div>
      <h1 class="portal-title">GAME HUB</h1>
      <p class="portal-subtitle">
        Simple mind-training & logic puzzles. Boost your memory, focus, problem solving, and reflexes.
      </p>

      <div class="portal-actions">
        <% if (isLoggedIn) { %>
          <button class="btn-portal btn-portal-primary" onclick="triggerFastEnter('<%= currentUser %>', 'Welcome back!')">
            <span>▶ PLAY NOW (<%= currentUser %>)</span>
          </button>
          <button class="btn-portal btn-portal-secondary" onclick="performLogout()">
            <span>✕ LOG OUT</span>
          </button>
        <% } else { %>
          <button class="btn-portal btn-portal-primary" onclick="openLoginModal()">
            <span>LOG IN</span>
          </button>
          <button class="btn-portal btn-portal-secondary" onclick="openSignupModal()">
            <span>SIGN UP</span>
          </button>
          <button class="btn-portal btn-portal-guest" onclick="triggerFastEnter('Guest', 'Welcome! Enjoy the games.')">
            <span>🎮 PLAY AS GUEST</span>
          </button>
        <% } %>
      </div>

      <div class="portal-footer-note">
        Daily brain-training • Free to play • Fast & lightweight
      </div>
    </div>
  </div>

  <!-- =========================================================
       SIDEBAR & PROFILE STATE
       ========================================================= -->
  <aside>
    <div class="brand" onclick="showPortal()">
      GAME <span class="brand-badge">HUB</span>
    </div>

    <div class="auth-widget" id="authWidget">
      <% if (isLoggedIn) { %>
        <div class="auth-avatar"><%= currentUser.substring(0, 1).toUpperCase() %></div>
        <div class="auth-name">
          <%= currentUser %>
          <span class="profile-level-badge" id="profileLevelBadge">LVL 1</span>
        </div>
        <div class="player-rank-title" id="profileRankTitle">Novice Thinker</div>
        <div class="profile-xp-box" id="profileXpBox">
          <div class="xp-header-row">
            <span>XP PROGRESS</span>
            <span class="xp-val" id="profileXpText">0 / 200 XP</span>
          </div>
          <div class="xp-bar-track">
            <div class="xp-bar-fill" id="profileXpFill" style="width: 0%;"></div>
          </div>
          <div class="xp-subtext">
            <span id="profileXpPercent">0%</span>
            <span id="profileXpRemaining">200 XP to next lvl</span>
          </div>
        </div>
        <button class="btn-auth btn-logout" onclick="performLogout()" style="margin-top: 10px;">Log Out</button>
      <% } else { %>
        <div class="auth-avatar" style="background: rgba(255,255,255,0.05); color: var(--text-muted);">?</div>
        <div class="auth-name" style="color: var(--text-muted);">
          GUEST PLAYER
          <span class="profile-level-badge" style="background: rgba(255,255,255,0.1); color: var(--text-muted); box-shadow: none;">LVL 0</span>
        </div>
        <div class="auth-role" style="color: var(--warning); margin-top: 4px;">PLAYING AS GUEST</div>
        <div style="font-size: 0.72rem; color: var(--text-muted); margin: 6px 0;">Log in to earn XP & unlock levels</div>
        <div style="display: flex; gap: 6px; width: 100%; margin-top: 4px;">
          <button class="btn-auth btn-login" onclick="openLoginModal()" style="flex: 1;">Log In</button>
          <button class="btn-auth btn-signup" onclick="openSignupModal()" style="flex: 1; background: var(--accent); color: #000; font-weight: 800;">Sign Up</button>
        </div>
      <% } %>
    </div>

    <nav>
      <button class="nav-btn active" onclick="switchTab('library', this)">
        <span style="font-size: 1.2rem;">🎮</span>
        <span>Games</span>
      </button>
      <button class="nav-btn" onclick="switchTab('scores', this)" id="navBtnScores">
        <span style="font-size: 1.2rem;">🧠</span>
        <span>Brain Stats</span>
        <% if (!isLoggedIn) { %>
          <span class="nav-lock-badge" id="navLockScores">🔒</span>
        <% } %>
      </button>
      <button class="nav-btn" onclick="switchTab('settings', this)" id="navBtnSettings">
        <span style="font-size: 1.2rem;" id="navSettingsIcon"><%= isLoggedIn ? "⚙️" : "🔒" %></span>
        <span id="navSettingsText"><%= isLoggedIn ? "Settings" : "Settings (Locked)" %></span>
      </button>
    </nav>

    <button class="btn-portal-recall" onclick="showPortal()">
      <span>🏠 Welcome Screen</span>
    </button>
  </aside>

  <!-- =========================================================
       MAIN CONTENT DASHBOARD
       ========================================================= -->
  <main>
    <div class="top-meta">
      <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
        <h2 id="viewTitle">Games</h2>
        <div class="meta-level-pill" id="metaLevelPill" style="display: <%= isLoggedIn ? "inline-flex" : "none" %>;">
          <span>⭐</span>
          <span id="metaLevelText">LVL 1</span>
          <span style="color: var(--text-muted);">•</span>
          <span id="metaXpText">0 XP</span>
        </div>
      </div>
      <div class="sys-status">Online</div>
    </div>

    <!-- VIEW 1: GAME LIBRARY CAROUSEL -->
    <section id="libraryView" class="view-panel active">
      <div class="carousel-controls">
        <button class="scroll-btn" onclick="scrollCarousel(-340)">‹</button>
        <button class="scroll-btn" onclick="scrollCarousel(340)">›</button>
      </div>

      <div class="game-carousel" id="carousel">
        
        <!-- Game 1: Defusal Protocol -->
        <div class="game-card" style="animation-delay: 0.05s;" onclick="openLaunchModal('Bomb_Defuse/index.jsp', 'Defusal Protocol // Crisis Sim', 'Multi-module bomb defusal sim featuring Data Serpent, Reactor Matrix, Firewall Maze, Banana Wires, and Frequency Tuner with a 3-charge containment system.')">
          <div class="card-banner banner-bomb">☢️</div>
          <div class="card-body">
            <div class="card-tag">Tactical Sim v3.0</div>
            <div class="card-title">Defusal Protocol</div>
            <div class="card-desc">Disarm 5 tactical mini-games (Snake, Reactor, Maze, Banana Wires, Freq Tuner) under a 3-minute clock with 3 containment charges.</div>
            <div class="card-footer">
              <div class="card-score-preview">Top: <span id="preview-defuse">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 2: Cyber Chess -->
        <div class="game-card" style="animation-delay: 0.1s;" onclick="openLaunchModal('Chess.jsp', 'Cyber Chess', 'Experience grandmaster AI chess with Stockfish depth evaluation, move history analysis, and dynamic tactical rating.')">
          <div class="card-banner banner-chess">♟️</div>
          <div class="card-body">
            <div class="card-tag">AI Strategy</div>
            <div class="card-title">Cyber Chess</div>
            <div class="card-desc">Challenge deep neural chess engines with move evaluation, rating progression, and PGN game export.</div>
            <div class="card-footer">
              <div class="card-score-preview">Rating: <span id="preview-chess">1200</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 3: Cyber Snake -->
        <div class="game-card" style="animation-delay: 0.15s;" onclick="openLaunchModal('Snake.jsp', 'Cyber Snake', 'Steer your serpent through the cyber grid, devour rogue data packets, and breach node high scores.')">
          <div class="card-banner banner-snake">🐍</div>
          <div class="card-body">
            <div class="card-tag">Arcade Classic</div>
            <div class="card-title">Cyber Snake</div>
            <div class="card-desc">Balanced, fluid snake arcade experience with adjustable tick clocks, touch D-pads, and node tracking.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-snake">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 4: Cyber Maze -->
        <div class="game-card" style="animation-delay: 0.2s;" onclick="openLaunchModal('Maze.jsp', 'Cyber Maze Runner', 'Solve procedurally generated labyrinth nodes with recursive backtracking algorithms and locate extraction portals.')">
          <div class="card-banner banner-maze">⚡</div>
          <div class="card-body">
            <div class="card-tag">Procedural Puzzle</div>
            <div class="card-title">Cyber Maze</div>
            <div class="card-desc">Navigate randomized labyrinth architectures and locate extraction gates before system telemetry resets.</div>
            <div class="card-footer">
              <div class="card-score-preview">Cleared: <span id="preview-maze">0</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 5: Number Guesser -->
        <div class="game-card" style="animation-delay: 0.25s;" onclick="openLaunchModal('Game1.jsp', 'Cipher Guesser', 'Crack the secret integer generated by the server session in minimal probe attempts.')">
          <div class="card-banner banner-guesser">🔢</div>
          <div class="card-body">
            <div class="card-tag">Session Puzzle</div>
            <div class="card-title">Cipher Guesser</div>
            <div class="card-desc">Crack the server-side encrypted integer between 1 and 100 in minimal probe iterations.</div>
            <div class="card-footer">
              <div class="card-score-preview">Fewest: <span id="preview-guess">--</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 6: Reactor Meltdown -->
        <div class="game-card" style="animation-delay: 0.3s;" onclick="openLaunchModal('Reactor_Meltdown/index.jsp', 'Reactor Meltdown', 'Progressive core memory puzzle inspired by Among Us. Replicate randomized glowing tile sequences under a 20s tension timer (+3s per clear) before containment collapses.')">
          <div class="card-banner banner-reactor">☢️</div>
          <div class="card-body">
            <div class="card-tag">Core Memory</div>
            <div class="card-title">Reactor Meltdown</div>
            <div class="card-desc">Replicate glowing reactor sequences under a 20s timer. Clear stages to expand from 3x3 to 4x4 matrix.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-reactor">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

      </div>
    </section>

    <!-- VIEW 2: EXPANDED SCORING & LEADERBOARDS -->
    <section id="scoresView" class="view-panel">
      <!-- GUEST LOCKED NOTICE FOR BRAIN STATS & RADAR CHART -->
      <div class="locked-card" id="scoresLockedCard" style="display: <%= isLoggedIn ? "none" : "block" %>;">
        <div class="locked-icon-wrap">🔒</div>
        <div class="locked-title">Cognitive Radar Chart Locked</div>
        <div class="locked-subtitle">
          Log in or create a free account to unlock your personalized 5-axis cognitive radar chart, earn player XP across all games, and record your high scores on global leaderboards.
        </div>

        <div class="locked-perks-grid">
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🧠</span>
            <div>
              <div class="locked-perk-title">5-Axis Radar Chart</div>
              <div class="locked-perk-desc">Live spider graph analyzing Memory, Logic, Speed, Spatial & Strategy</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">⭐</span>
            <div>
              <div class="locked-perk-title">Account Level & XP</div>
              <div class="locked-perk-desc">Level up your profile and earn prestigious cognitive rank titles</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🏆</span>
            <div>
              <div class="locked-perk-title">Global Leaderboards</div>
              <div class="locked-perk-desc">Compete with players worldwide for top scores across 6 games</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">☁️</span>
            <div>
              <div class="locked-perk-title">Cloud Synchronized</div>
              <div class="locked-perk-desc">Your high scores and agility profile persist across any browser</div>
            </div>
          </div>
        </div>

        <div class="locked-actions">
          <button class="btn-unlock-primary" onclick="openLoginModal()">Log In to View Stats</button>
          <button class="btn-unlock-secondary" onclick="openSignupModal()">Create Free Account</button>
        </div>
      </div>

      <!-- MEMBER CONTENT (RADAR CHART & METRICS) -->
      <div id="scoresContentWrap" style="display: <%= isLoggedIn ? "block" : "none" %>;">
        <!-- DISCORD & GOOGLE PLAY GAMES PLAYER LEVEL CARD -->
        <div class="player-spotlight-card">
          <div class="spotlight-level-emblem">
            <span class="emblem-lbl">LEVEL</span>
            <span class="emblem-num" id="spotlightLevelNum">1</span>
          </div>
          <div class="spotlight-info">
            <div class="spotlight-name-row">
              <span class="spotlight-username"><%= isLoggedIn ? currentUser : "Player" %></span>
              <span class="spotlight-tier-tag" id="spotlightRankTitle">Novice Thinker</span>
            </div>
            <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 8px;">
              Total Brain Experience: <strong style="color: var(--accent);" id="spotlightTotalXp">0 XP</strong>
            </div>
            <div class="xp-bar-track" style="height: 9px;">
              <div class="xp-bar-fill" id="spotlightXpBar" style="width: 0%;"></div>
            </div>
            <div class="xp-subtext" style="font-size: 0.72rem; margin-top: 5px;">
              <span id="spotlightXpDetail">0 / 200 XP (0%)</span>
              <span id="spotlightXpRemaining">200 XP to next level</span>
            </div>
          </div>
        </div>

        <!-- COGNITIVE RADAR CHART (SPIDER GRAPH) -->
        <div class="radar-card">
        <div class="radar-card-header">
          <div>
            <div class="radar-title">🧠 Cognitive Agility Profile</div>
            <div class="radar-subtitle">Live brain-training metrics calculated from your game performance</div>
          </div>
          <div class="brain-index-badge">
            <span class="brain-index-label">BRAIN INDEX</span>
            <span class="brain-index-val" id="overallBrainScore">--</span>
          </div>
        </div>

        <div class="radar-content">
          <div class="radar-canvas-wrap">
            <canvas id="radarChartCanvas" width="290" height="270"></canvas>
          </div>
          <div class="radar-metrics-list">
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #38bdf8; box-shadow: 0 0 8px #38bdf8;"></span>
              <span class="metric-name">Memory</span>
              <span class="metric-desc">Reactor Meltdown (Sequence recall)</span>
              <span class="metric-val" id="valMetricMemory">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #facc15; box-shadow: 0 0 8px #facc15;"></span>
              <span class="metric-name">Logic</span>
              <span class="metric-desc">Defusal Protocol (Deduction under pressure)</span>
              <span class="metric-val" id="valMetricLogic">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #10b981; box-shadow: 0 0 8px #10b981;"></span>
              <span class="metric-name">Speed</span>
              <span class="metric-desc">Cyber Snake (Spatial reflexes & focus)</span>
              <span class="metric-val" id="valMetricSpeed">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #06b6d4; box-shadow: 0 0 8px #06b6d4;"></span>
              <span class="metric-name">Spatial</span>
              <span class="metric-desc">Cyber Maze (Pathfinding & navigation)</span>
              <span class="metric-val" id="valMetricSpatial">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #ec4899; box-shadow: 0 0 8px #ec4899;"></span>
              <span class="metric-name">Strategy</span>
              <span class="metric-desc">Cyber Chess (Tactical calculation)</span>
              <span class="metric-val" id="valMetricStrategy">0%</span>
            </div>
          </div>
        </div>
      </div>

      <div class="score-grid">
        
        <!-- 1. Defusal Protocol -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #ea580c;">☢️ Defusal Protocol</div>
            <div class="score-badge" style="background: rgba(234, 88, 12, 0.15); color: #ea580c; border: 1px solid rgba(234, 88, 12, 0.3);">Tier 1 Sim</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statDefuseBest" style="color: #ea580c;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Best Tier Cleared</span>
            <span class="stat-val" id="statDefuseLevel">Level 1</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Successful Disarms</span>
            <span class="stat-val" id="statDefuseDisarms">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Strikes Avoided</span>
            <span class="stat-val" id="statDefuseStrikes">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Agent</span>
            <span class="stat-val" id="statDefuseLeader" style="color: var(--primary);">--</span>
          </div>
        </div>

        <!-- 2. Cyber Chess -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #ec4899;">♟️ Cyber Chess</div>
            <div class="score-badge" style="background: rgba(236, 72, 153, 0.15); color: #ec4899; border: 1px solid rgba(236, 72, 153, 0.3);">Stockfish API</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">Rating</span>
            <span class="stat-val" id="statChessRating" style="color: #ec4899;">1200</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Matches Won</span>
            <span class="stat-val" id="statChessWins" style="color: var(--accent);">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Matches Lost</span>
            <span class="stat-val" id="statChessLosses" style="color: var(--danger);">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Win Ratio</span>
            <span class="stat-val" id="statChessRatio">0%</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Evaluation Engine</span>
            <span class="stat-val" style="color: var(--primary);">Depth 12</span>
          </div>
        </div>

        <!-- 3. Cyber Snake -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #10b981;">🐍 Cyber Snake</div>
            <div class="score-badge" style="background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3);">Balanced Tick</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statSnakeBest" style="color: #10b981;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Total Data Nodes</span>
            <span class="stat-val" id="statSnakeNodes">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Clock Rate</span>
            <span class="stat-val" style="color: var(--primary);">145ms Balanced</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Operator</span>
            <span class="stat-val" id="statSnakeLeader" style="color: var(--accent);">--</span>
          </div>
        </div>

        <!-- 4. Cyber Maze -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #38bdf8;">⚡ Cyber Maze</div>
            <div class="score-badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3);">Recursive Grid</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">Mazes Cleared</span>
            <span class="stat-val" id="statMazeClears" style="color: #38bdf8;">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Fastest Escape</span>
            <span class="stat-val" id="statMazeBestTime">--</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Labyrinth Synthesis</span>
            <span class="stat-val" style="color: var(--accent);">Adaptive</span>
          </div>
        </div>

        <!-- 5. Cipher Guesser -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #6366f1;">🔢 Cipher Guesser</div>
            <div class="score-badge" style="background: rgba(99, 102, 241, 0.15); color: #6366f1; border: 1px solid rgba(99, 102, 241, 0.3);">Session Crypto</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">Fewest Attempts</span>
            <span class="stat-val" id="statGuessBest" style="color: #6366f1;">--</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Decryption Range</span>
            <span class="stat-val">1 - 100</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Key Security</span>
            <span class="stat-val" style="color: var(--accent);">Server-Side</span>
          </div>
        </div>

        <!-- 6. Reactor Meltdown -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #38bdf8;">☢️ Reactor Meltdown</div>
            <div class="score-badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3);">Progressive Core</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statReactorBest" style="color: #38bdf8;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Deepest Sector</span>
            <span class="stat-val" id="statReactorStage">Sector 1</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Coolant System</span>
            <span class="stat-val" style="color: var(--accent);">20s (+3s/Clear)</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Operator</span>
            <span class="stat-val" id="statReactorLeader" style="color: var(--warning);">--</span>
          </div>
        </div>

      </div> <!-- end score-grid -->
      </div> <!-- end scoresContentWrap -->
    </section>

    <!-- VIEW 3: SYSTEM PREFERENCES -->
    <section id="settingsView" class="view-panel">
      <!-- GUEST LOCKED NOTICE FOR SETTINGS -->
      <div class="locked-card" id="settingsLockedCard" style="display: <%= isLoggedIn ? "none" : "block" %>;">
        <div class="locked-icon-wrap" style="color: var(--warning); border-color: rgba(245, 158, 11, 0.4); background: rgba(245, 158, 11, 0.15); box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);">🔒</div>
        <div class="locked-title">Settings Locked</div>
        <div class="locked-subtitle">
          Display preferences, audio customization, performance modes, and local cache controls require an active player account. Log in or create an account to unlock full settings access.
        </div>

        <div class="locked-perks-grid">
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🔊</span>
            <div>
              <div class="locked-perk-title">Audio Customization</div>
              <div class="locked-perk-desc">Toggle soundscape feedback and ambient effects</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">⚡</span>
            <div>
              <div class="locked-perk-title">Performance Turbo</div>
              <div class="locked-perk-desc">Optimize framerates and background animations</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🚪</span>
            <div>
              <div class="locked-perk-title">Gateway Bypass</div>
              <div class="locked-perk-desc">Customize direct entry into the arcade game hub</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🛡️</span>
            <div>
              <div class="locked-perk-title">Data & Cache Tools</div>
              <div class="locked-perk-desc">Manage local memory and sync with cloud records</div>
            </div>
          </div>
        </div>

        <div class="locked-actions">
          <button class="btn-unlock-primary" onclick="openLoginModal()">Log In to Unlock Settings</button>
          <button class="btn-unlock-secondary" onclick="openSignupModal()">Create Free Account</button>
        </div>
      </div>

      <!-- MEMBER CONTENT (SETTINGS CONTROLS) -->
      <div id="settingsContentWrap" style="display: <%= isLoggedIn ? "block" : "none" %>;">
        <div class="settings-box" style="max-width: 520px;">
          <h3 style="margin-bottom: 1.5rem; color: var(--primary);">System Preferences</h3>
          
          <div class="settings-row">
            <div>
              <div style="font-weight: 700;">Audio Effects</div>
              <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Enable interactive feedback soundscapes</div>
            </div>
            <label class="switch">
              <input type="checkbox" checked>
              <span class="slider"></span>
            </label>
          </div>
          
          <div class="settings-row">
            <div>
              <div style="font-weight: 700;">Performance Mode</div>
              <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Disable background grid animations</div>
            </div>
            <label class="switch">
              <input type="checkbox" onchange="togglePerformance(this)">
              <span class="slider"></span>
            </label>
          </div>

          <div class="settings-row">
            <div>
              <div style="font-weight: 700;">Entry Portal Bypass</div>
              <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Show landing gateway on initial visits</div>
            </div>
            <button class="btn-modal btn-cancel" style="flex: initial; padding: 6px 14px; font-size: 0.8rem;" onclick="showPortal()">
              Show Portal
            </button>
          </div>
          
          <button class="btn-modal btn-cancel" onclick="resetLocalCache()" style="margin-top: 2rem; width:100%; color: var(--danger); border: 1px solid rgba(239, 68, 68, 0.35);">
            ⚠ Purge Local Score Cache
          </button>
        </div>
      </div>
    </section>
  </main>

  <!-- =========================================================
       MODAL 1: PRE-GAME LAUNCH CONFIRMATION
       ========================================================= -->
  <div class="modal-overlay" id="launchModal">
    <div class="modal-box">
      <h2 id="modalTitle" style="color: var(--primary); font-weight: 900; letter-spacing: 1px;">Ready to Play?</h2>
      <p id="modalDesc" style="color:var(--text-muted); font-size:0.92rem; margin-top:0.8rem; line-height: 1.6;"></p>
      <div class="modal-actions">
        <button class="btn-modal btn-cancel" onclick="closeModal('launchModal')">Back</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">▶ Play Now</button>
      </div>
    </div>
  </div>

  <!-- =========================================================
       MODAL 2: LOGIN
       ========================================================= -->
  <div class="modal-overlay" id="loginModal">
    <div class="modal-box">
      <h2 style="color: var(--primary); font-weight: 900; letter-spacing: 1px;">Log In</h2>
      <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.4rem;">Welcome back! Log in to save your brain stats.</p>

      <div class="auth-msg" id="loginMsg"></div>

      <form id="loginForm" onsubmit="event.preventDefault(); submitLogin();">
        <div class="auth-form-group">
          <label class="auth-label" for="loginUsername">Username</label>
          <input type="text" class="auth-input" id="loginUsername" placeholder="Enter your username" autocomplete="username" required>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="loginPassword">Password</label>
          <input type="password" class="auth-input" id="loginPassword" placeholder="••••••••" autocomplete="current-password" required>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal btn-cancel" onclick="closeModal('loginModal')">Cancel</button>
          <button type="submit" class="btn-modal btn-launch" id="loginSubmitBtn">
            <span id="loginBtnText">Log In</span>
          </button>
        </div>
      </form>

      <span class="switch-auth-link" onclick="openSignupModal()">Don't have an account? Sign up here</span>
    </div>
  </div>

  <!-- =========================================================
       MODAL 3: SIGN UP
       ========================================================= -->
  <div class="modal-overlay" id="signupModal">
    <div class="modal-box">
      <h2 style="color: var(--accent); font-weight: 900; letter-spacing: 1px;">Sign Up</h2>
      <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.4rem;">Create a free account to track your progress</p>

      <div class="auth-msg" id="signupMsg"></div>

      <form id="signupForm" onsubmit="event.preventDefault(); submitSignup();">
        <div class="auth-form-group">
          <label class="auth-label" for="signupUsername">Choose Username [3-20 Letters/Numbers]</label>
          <input type="text" class="auth-input" id="signupUsername" placeholder="e.g. BrainMaster" autocomplete="username" required>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="signupPassword">Password [Min 6 Chars]</label>
          <input type="password" class="auth-input" id="signupPassword" placeholder="••••••••" autocomplete="new-password" required>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="signupPasswordConfirm">Confirm Password</label>
          <input type="password" class="auth-input" id="signupPasswordConfirm" placeholder="••••••••" autocomplete="new-password" required>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal btn-cancel" onclick="closeModal('signupModal')">Cancel</button>
          <button type="submit" class="btn-modal btn-launch" id="signupSubmitBtn" style="background:var(--accent); color: #000; box-shadow:0 0 15px rgba(34,197,94,0.4);">
            <span id="signupBtnText">Create Account</span>
          </button>
        </div>
      </form>

      <span class="switch-auth-link" onclick="openLoginModal()">Already have an account? Log in</span>
    </div>
  </div>

<script>
  let isUserLoggedIn = <%= isLoggedIn %>;
  let currentUsername = "<%= currentUser != null ? currentUser : "" %>";
  let targetUrl = '';

  // =========================================================
  // DISCORD & GOOGLE PLAY GAMES ACCOUNT LEVELING ENGINE
  // =========================================================
  function calculateTotalXP() {
    const defuseBest = parseFloat(localStorage.getItem('hub_defuse_high') || '0');
    const chessWins = parseFloat(localStorage.getItem('hub_chess_wins') || '0');
    const chessRating = parseFloat(localStorage.getItem('hub_chess_rating') || '1200');
    const snakeBest = parseFloat(localStorage.getItem('hub_snake_high') || '0');
    const mazeClears = parseFloat(localStorage.getItem('hub_maze_clears') || '0');
    const reactorBest = parseFloat(localStorage.getItem('hub_reactor_high') || '0');

    // Progressive XP breakdown
    const xpReactor = Math.round(reactorBest * 2);
    const xpDefuse = Math.round(defuseBest * 2);
    const xpSnake = Math.round(snakeBest * 5);
    const xpMaze = Math.round(mazeClears * 100);
    const xpChess = Math.round(chessWins * 150 + Math.max(0, chessRating - 1200) * 2);

    return xpReactor + xpDefuse + xpSnake + xpMaze + xpChess;
  }

  function getLevelData(totalXp) {
    const tierSteps = [200, 300, 450, 600, 800, 1000, 1250, 1500, 1800, 2100];
    let level = 1;
    let threshold = 0;
    let prevThreshold = 0;
    let step = 200;

    while (true) {
      step = (level <= tierSteps.length) ? tierSteps[level - 1] : (2100 + (level - 10) * 350);
      if (totalXp < threshold + step) {
        prevThreshold = threshold;
        break;
      }
      threshold += step;
      level++;
    }

    const xpInCurrentLevel = Math.max(0, totalXp - prevThreshold);
    const xpNeededForLevel = step;
    const percent = Math.min(100, Math.round((xpInCurrentLevel / xpNeededForLevel) * 100));

    const titles = [
      'Novice Thinker',
      'Curious Mind',
      'Apprentice Strategist',
      'Logic Specialist',
      'Pattern Analyst',
      'Puzzle Veteran',
      'Tactical Operative',
      'Cognitive Ace',
      'Mind Maestro',
      'Grandmaster Mind'
    ];
    const rankTitle = (level <= titles.length) ? titles[level - 1] : `Grandmaster Tier ${level - 9}`;

    return {
      level,
      totalXp,
      xpInCurrentLevel,
      xpNeededForLevel,
      remainingXp: Math.max(0, xpNeededForLevel - xpInCurrentLevel),
      percent,
      rankTitle
    };
  }

  function updateAccountLevelUI() {
    if (!isUserLoggedIn) return;

    const totalXp = calculateTotalXP();
    const data = getLevelData(totalXp);

    // 1. Sidebar Profile Updates
    const badge = document.getElementById('profileLevelBadge');
    const title = document.getElementById('profileRankTitle');
    const xpText = document.getElementById('profileXpText');
    const xpFill = document.getElementById('profileXpFill');
    const xpPct = document.getElementById('profileXpPercent');
    const xpRem = document.getElementById('profileXpRemaining');

    if (badge) badge.innerText = 'LVL ' + data.level;
    if (title) title.innerText = data.rankTitle;
    if (xpText) xpText.innerText = data.xpInCurrentLevel.toLocaleString() + ' / ' + data.xpNeededForLevel.toLocaleString() + ' XP';
    if (xpFill) xpFill.style.width = data.percent + '%';
    if (xpPct) xpPct.innerText = data.percent + '%';
    if (xpRem) xpRem.innerText = data.remainingXp.toLocaleString() + ' XP to next lvl';

    // 2. Header Meta Pill Updates
    const metaPill = document.getElementById('metaLevelPill');
    const metaLvl = document.getElementById('metaLevelText');
    const metaXp = document.getElementById('metaXpText');
    if (metaPill) metaPill.style.display = 'inline-flex';
    if (metaLvl) metaLvl.innerText = 'LVL ' + data.level;
    if (metaXp) metaXp.innerText = data.totalXp.toLocaleString() + ' XP';

    // 3. Brain Stats Spotlight Card Updates
    const spotLvl = document.getElementById('spotlightLevelNum');
    const spotRank = document.getElementById('spotlightRankTitle');
    const spotTotalXp = document.getElementById('spotlightTotalXp');
    const spotBar = document.getElementById('spotlightXpBar');
    const spotDetail = document.getElementById('spotlightXpDetail');
    const spotRem = document.getElementById('spotlightXpRemaining');

    if (spotLvl) spotLvl.innerText = data.level;
    if (spotRank) spotRank.innerText = data.rankTitle;
    if (spotTotalXp) spotTotalXp.innerText = data.totalXp.toLocaleString() + ' XP';
    if (spotBar) spotBar.style.width = data.percent + '%';
    if (spotDetail) spotDetail.innerText = data.xpInCurrentLevel.toLocaleString() + ' / ' + data.xpNeededForLevel.toLocaleString() + ' XP (' + data.percent + '%)';
    if (spotRem) spotRem.innerText = data.remainingXp.toLocaleString() + ' XP to next level';
  }

  // =========================================================
  // HIGH-SPEED DIGITAL ZOOM-THROUGH & CYBER SHUTTER ENGINE
  // =========================================================
  const portal = document.getElementById('landingPortal');
  const cyberShutter = document.getElementById('cyberShutter');

  function triggerFastEnter(targetIdentity, completionMsg, onCompleteCallback) {
    if (cyberShutter) {
      cyberShutter.classList.add('active');
    }
    if (portal) {
      portal.classList.add('zoom-through');
    }

    setTimeout(() => {
      if (portal) {
        portal.classList.add('dismissed');
        portal.classList.remove('zoom-through');
      }
      if (cyberShutter) {
        cyberShutter.classList.remove('active');
      }
      sessionStorage.setItem('hub_portal_passed', 'true');
      if (onCompleteCallback) onCompleteCallback();
    }, 260);
  }

  // Backward-compatible alias
  function triggerDoorTransition(targetIdentity, completionMsg, onCompleteCallback) {
    triggerFastEnter(targetIdentity, completionMsg, onCompleteCallback);
  }

  function showPortal() {
    if (portal) {
      portal.classList.remove('dismissed');
      portal.classList.remove('zoom-through');
    }
  }

  // Auto-dismiss portal if user already completed entrance in this browser tab
  if (sessionStorage.getItem('hub_portal_passed') === 'true') {
    if (portal) portal.classList.add('dismissed');
  }

  // Cyber-Scanner Navigation Wipe Handler
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

  // --- TAB NAVIGATION (GATED FOR GUESTS) ---
  function switchTab(tab, btn) {
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.view-panel').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    
    setTimeout(() => {
      if (tab === 'library') {
        document.getElementById('libraryView').classList.add('active');
        document.getElementById('viewTitle').innerText = 'Games';
      } else if (tab === 'scores') {
        document.getElementById('scoresView').classList.add('active');
        document.getElementById('viewTitle').innerText = isUserLoggedIn ? 'Brain Stats & Records' : 'Brain Stats (Locked)';
        const lockedCard = document.getElementById('scoresLockedCard');
        const contentWrap = document.getElementById('scoresContentWrap');
        if (isUserLoggedIn) {
          if (lockedCard) lockedCard.style.display = 'none';
          if (contentWrap) contentWrap.style.display = 'block';
          syncCloudScores();
          renderCognitiveRadarChart();
          updateAccountLevelUI();
        } else {
          if (lockedCard) lockedCard.style.display = 'block';
          if (contentWrap) contentWrap.style.display = 'none';
        }
      } else if (tab === 'settings') {
        document.getElementById('settingsView').classList.add('active');
        document.getElementById('viewTitle').innerText = isUserLoggedIn ? 'Settings' : 'Settings (Locked)';
        const lockedCard = document.getElementById('settingsLockedCard');
        const contentWrap = document.getElementById('settingsContentWrap');
        if (isUserLoggedIn) {
          if (lockedCard) lockedCard.style.display = 'none';
          if (contentWrap) contentWrap.style.display = 'block';
        } else {
          if (lockedCard) lockedCard.style.display = 'block';
          if (contentWrap) contentWrap.style.display = 'none';
        }
      }
    }, 40);
  }

  function scrollCarousel(dist) {
    document.getElementById('carousel').scrollBy({ left: dist, behavior: 'smooth' });
  }

  function openLaunchModal(url, title, desc) {
    targetUrl = url;
    document.getElementById('modalTitle').innerText = title;
    document.getElementById('modalDesc').innerText = desc;
    document.getElementById('confirmLaunchBtn').onclick = () => cyberNavigate(targetUrl);
    openModal('launchModal');
  }

  function openModal(id) {
    const modal = document.getElementById(id);
    if (!modal) return;
    modal.style.display = 'flex';
    void modal.offsetWidth;
    modal.classList.add('active');
    if (window.innerWidth > 768) {
      const input = modal.querySelector('input');
      if (input) input.focus();
    }
  }

  function closeModal(id) {
    const modal = document.getElementById(id);
    if (!modal) return;
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 250);
  }

  function openLoginModal() {
    closeModal('signupModal');
    const msg = document.getElementById('loginMsg');
    msg.className = 'auth-msg';
    msg.innerHTML = '';
    msg.style.display = 'none';
    openModal('loginModal');
  }

  function openSignupModal() {
    closeModal('loginModal');
    const msg = document.getElementById('signupMsg');
    msg.className = 'auth-msg';
    msg.innerHTML = '';
    msg.style.display = 'none';
    openModal('signupModal');
  }

  function setBanner(elemId, type, text) {
    const el = document.getElementById(elemId);
    if (!el) return;
    el.className = 'auth-msg ' + type;
    const icon = (type === 'success') ? '✓ ' : '⚠️ ';
    el.innerHTML = icon + text;
    el.style.display = 'flex';
  }

  // --- ASYNC AUTH HANDLERS ---
  async function submitLogin() {
    const u = document.getElementById('loginUsername').value.trim();
    const p = document.getElementById('loginPassword').value;
    const btn = document.getElementById('loginSubmitBtn');
    const btnText = document.getElementById('loginBtnText');

    if (!u || !p) {
      setBanner('loginMsg', 'error', 'Username and password required.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> Logging in...';

    try {
      const res = await fetch('login.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ username: u, password: p })
      });

      const rawText = await res.text();
      let data = null;

      try {
        data = JSON.parse(rawText);
      } catch (jsonErr) {
        setBanner('loginMsg', 'error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
        btn.disabled = false;
        btnText.innerText = 'Log In';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('loginMsg', 'success', 'Welcome back! Entering Game Hub...');
        setTimeout(() => {
          closeModal('loginModal');
          triggerDoorTransition(u.toUpperCase(), 'LOGGED IN // WELCOME BACK', () => {
            window.location.reload();
          });
        }, 400);
      } else {
        setBanner('loginMsg', 'error', data.message || 'Invalid username or password.');
        btn.disabled = false;
        btnText.innerText = 'Log In';
      }
    } catch (netErr) {
      setBanner('loginMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = 'Log In';
    }
  }

  async function submitSignup() {
    const u = document.getElementById('signupUsername').value.trim();
    const p = document.getElementById('signupPassword').value;
    const c = document.getElementById('signupPasswordConfirm').value;
    const btn = document.getElementById('signupSubmitBtn');
    const btnText = document.getElementById('signupBtnText');

    if (!u || !p || !c) {
      setBanner('signupMsg', 'error', 'Please fill in all fields.');
      return;
    }
    if (p !== c) {
      setBanner('signupMsg', 'error', 'Passwords do not match.');
      return;
    }
    if (p.length < 6) {
      setBanner('signupMsg', 'error', 'Password must be at least 6 characters.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> Creating Account...';

    try {
      const res = await fetch('register.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ username: u, password: p })
      });

      const rawText = await res.text();
      let data = null;

      try {
        data = JSON.parse(rawText);
      } catch (jsonErr) {
        setBanner('signupMsg', 'error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
        btn.disabled = false;
        btnText.innerText = 'Sign Up';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('signupMsg', 'success', 'Account created! Entering Game Hub...');
        setTimeout(() => {
          closeModal('signupModal');
          triggerDoorTransition(u.toUpperCase(), 'ACCOUNT READY // WELCOME', () => {
            window.location.reload();
          });
        }, 400);
      } else {
        setBanner('signupMsg', 'error', data.message || 'Registration failed.');
        btn.disabled = false;
        btnText.innerText = 'Sign Up';
      }
    } catch (netErr) {
      setBanner('signupMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = 'Sign Up';
    }
  }

  async function performLogout() {
    sessionStorage.removeItem('hub_portal_passed');
    try {
      await fetch('logout.jsp', { headers: { 'Accept': 'application/json' } });
      window.location.reload();
    } catch (e) {
      window.location.href = 'logout.jsp';
    }
  }

  // --- Dynamic Client Session Check ---
  async function checkLiveSession() {
    try {
      const res = await fetch('session_check.jsp');
      const text = await res.text();
      const data = JSON.parse(text);
      if (data.status === 'success' && data.loggedIn) {
        isUserLoggedIn = true;
        currentUsername = data.username || data.user_session;
        const u = currentUsername;

        const widget = document.getElementById('authWidget');
        if (widget) {
          widget.innerHTML = `
            <div class="auth-avatar">${u.substring(0, 1).toUpperCase()}</div>
            <div class="auth-name">
              ${u}
              <span class="profile-level-badge" id="profileLevelBadge">LVL 1</span>
            </div>
            <div class="player-rank-title" id="profileRankTitle">Novice Thinker</div>
            <div class="profile-xp-box" id="profileXpBox">
              <div class="xp-header-row">
                <span>XP PROGRESS</span>
                <span class="xp-val" id="profileXpText">0 / 200 XP</span>
              </div>
              <div class="xp-bar-track">
                <div class="xp-bar-fill" id="profileXpFill" style="width: 0%;"></div>
              </div>
              <div class="xp-subtext">
                <span id="profileXpPercent">0%</span>
                <span id="profileXpRemaining">200 XP to next lvl</span>
              </div>
            </div>
            <button class="btn-auth btn-logout" onclick="performLogout()" style="margin-top: 10px;">Log Out</button>
          `;
        }

        // Unlock Nav Buttons & Meta Pill
        const lockBadge = document.getElementById('navLockScores');
        if (lockBadge) lockBadge.remove();

        const navSetIcon = document.getElementById('navSettingsIcon');
        const navSetText = document.getElementById('navSettingsText');
        if (navSetIcon) navSetIcon.innerText = '⚙️';
        if (navSetText) navSetText.innerText = 'Settings';

        const metaPill = document.getElementById('metaLevelPill');
        if (metaPill) metaPill.style.display = 'inline-flex';

        const spotUser = document.querySelector('.spotlight-username');
        if (spotUser) spotUser.innerText = u;

        updateAccountLevelUI();
      } else {
        isUserLoggedIn = false;
      }
    } catch (e) {
      console.warn('Session polling offline:', e);
    }
  }

  // --- MULTI-GAME TELEMETRY SYNC ---
  async function syncCloudScores() {
    // 1. Defusal Protocol Metrics
    const localDefuse = localStorage.getItem('hub_defuse_high') || '0';
    const localDefuseLvl = localStorage.getItem('hub_defuse_level') || '1';
    const localDefuseDisarms = localStorage.getItem('hub_defuse_disarms') || '0';
    const localDefuseStrikes = localStorage.getItem('hub_defuse_strikes_avoided') || '0';

    const pDefuse = document.getElementById('preview-defuse');
    const sDefuseBest = document.getElementById('statDefuseBest');
    const sDefuseLevel = document.getElementById('statDefuseLevel');
    const sDefuseDisarms = document.getElementById('statDefuseDisarms');
    const sDefuseStrikes = document.getElementById('statDefuseStrikes');

    if (pDefuse) pDefuse.innerText = localDefuse + ' pts';
    if (sDefuseBest) sDefuseBest.innerText = localDefuse + ' pts';
    if (sDefuseLevel) sDefuseLevel.innerText = 'Level ' + localDefuseLvl;
    if (sDefuseDisarms) sDefuseDisarms.innerText = localDefuseDisarms;
    if (sDefuseStrikes) sDefuseStrikes.innerText = localDefuseStrikes;

    // 2. Cyber Chess Metrics
    const localChessRating = localStorage.getItem('hub_chess_rating') || '1200';
    const localChessWins = parseInt(localStorage.getItem('hub_chess_wins') || '0', 10);
    const localChessLosses = parseInt(localStorage.getItem('hub_chess_losses') || '0', 10);
    const totalMatches = localChessWins + localChessLosses;
    const winRatio = totalMatches > 0 ? Math.round((localChessWins / totalMatches) * 100) : 0;

    const pChess = document.getElementById('preview-chess');
    const sChessRating = document.getElementById('statChessRating');
    const sChessWins = document.getElementById('statChessWins');
    const sChessLosses = document.getElementById('statChessLosses');
    const sChessRatio = document.getElementById('statChessRatio');

    if (pChess) pChess.innerText = localChessRating;
    if (sChessRating) sChessRating.innerText = localChessRating;
    if (sChessWins) sChessWins.innerText = localChessWins;
    if (sChessLosses) sChessLosses.innerText = localChessLosses;
    if (sChessRatio) sChessRatio.innerText = winRatio + '%';

    // 3. Cyber Snake Metrics
    const localSnake = localStorage.getItem('hub_snake_high') || '0';
    const localSnakeNodes = localStorage.getItem('hub_snake_nodes') || '0';

    const pSnake = document.getElementById('preview-snake');
    const sSnakeBest = document.getElementById('statSnakeBest');
    const sSnakeNodes = document.getElementById('statSnakeNodes');

    if (pSnake) pSnake.innerText = localSnake + ' pts';
    if (sSnakeBest) sSnakeBest.innerText = localSnake + ' pts';
    if (sSnakeNodes) sSnakeNodes.innerText = localSnakeNodes;

    // 4. Cyber Maze Metrics
    const localMazeClears = localStorage.getItem('hub_maze_clears') || '0';
    const localMazeBestTime = localStorage.getItem('hub_maze_best_time') || '0';

    const pMaze = document.getElementById('preview-maze');
    const sMazeClears = document.getElementById('statMazeClears');
    const sMazeBestTime = document.getElementById('statMazeBestTime');

    if (pMaze) pMaze.innerText = localMazeClears;
    if (sMazeClears) sMazeClears.innerText = localMazeClears;
    if (sMazeBestTime) sMazeBestTime.innerText = localMazeBestTime > 0 ? localMazeBestTime + 's' : '--';

    // 5. Cipher Guesser Metrics
    const localGuess = localStorage.getItem('hub_guess_best') || '--';
    const pGuess = document.getElementById('preview-guess');
    const sGuessBest = document.getElementById('statGuessBest');

    if (pGuess) pGuess.innerText = (localGuess !== '--') ? localGuess + ' tries' : '--';
    if (sGuessBest) sGuessBest.innerText = (localGuess !== '--') ? localGuess + ' tries' : '--';

    // 6. Reactor Meltdown Metrics
    const localReactor = localStorage.getItem('hub_reactor_high') || '0';
    const localReactorStage = localStorage.getItem('hub_reactor_stage') || 'Sector 1';

    const pReactor = document.getElementById('preview-reactor');
    const sReactorBest = document.getElementById('statReactorBest');
    const sReactorStage = document.getElementById('statReactorStage');

    if (pReactor) pReactor.innerText = localReactor + ' pts';
    if (sReactorBest) sReactorBest.innerText = localReactor + ' pts';
    if (sReactorStage) sReactorStage.innerText = localReactorStage;

    // Query Database High Scores & Global Leaderboards
    try {
      const res = await fetch('get_scores.jsp');
      if (res.ok) {
        const data = await res.json();
        if (data.userScores) {
          if (data.userScores.snake !== undefined) {
            const dbSnake = data.userScores.snake;
            if (pSnake) pSnake.innerText = dbSnake + ' pts';
            if (sSnakeBest) sSnakeBest.innerText = dbSnake + ' pts';
            localStorage.setItem('hub_snake_high', dbSnake);
          }
          if (data.userScores.bomb_defuse !== undefined) {
            const dbDefuse = data.userScores.bomb_defuse;
            if (pDefuse) pDefuse.innerText = dbDefuse + ' pts';
            if (sDefuseBest) sDefuseBest.innerText = dbDefuse + ' pts';
            localStorage.setItem('hub_defuse_high', dbDefuse);
          }
          if (data.userScores.chess !== undefined) {
            const dbChess = data.userScores.chess;
            if (pChess) pChess.innerText = dbChess;
            if (sChessRating) sChessRating.innerText = dbChess;
            localStorage.setItem('hub_chess_rating', dbChess);
          }
          if (data.userScores.reactor_meltdown !== undefined) {
            const dbReactor = data.userScores.reactor_meltdown;
            if (pReactor) pReactor.innerText = dbReactor + ' pts';
            if (sReactorBest) sReactorBest.innerText = dbReactor + ' pts';
            localStorage.setItem('hub_reactor_high', dbReactor);
          }
        }

        if (data.leaders) {
          const lSnake = document.getElementById('statSnakeLeader');
          const lDefuse = document.getElementById('statDefuseLeader');
          const lReactor = document.getElementById('statReactorLeader');
          if (lSnake && data.leaders.snake) {
            lSnake.innerText = data.leaders.snake.username + ' (' + data.leaders.snake.score + ' pts)';
          }
          if (lDefuse && data.leaders.bomb_defuse) {
            lDefuse.innerText = data.leaders.bomb_defuse.username + ' (' + data.leaders.bomb_defuse.score + ' pts)';
          }
          if (lReactor && data.leaders.reactor_meltdown) {
            lReactor.innerText = data.leaders.reactor_meltdown.username + ' (' + data.leaders.reactor_meltdown.score + ' pts)';
          }
        }
      }
    } catch (e) {
      console.warn('Cloud score sync offline; relying on local telemetry.');
    }
    // Update Cognitive Radar Chart & Account Level
    renderCognitiveRadarChart();
    updateAccountLevelUI();
  }

  // --- COGNITIVE RADAR CHART (SPIDER GRAPH) ---
  function renderCognitiveRadarChart() {
    const canvas = document.getElementById('radarChartCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Fetch metric baseline values from localStorage
    const defuseBest = parseFloat(localStorage.getItem('hub_defuse_high') || '0');
    const chessRating = parseFloat(localStorage.getItem('hub_chess_rating') || '1200');
    const snakeBest = parseFloat(localStorage.getItem('hub_snake_high') || '0');
    const mazeClears = parseFloat(localStorage.getItem('hub_maze_clears') || '0');
    const reactorBest = parseFloat(localStorage.getItem('hub_reactor_high') || '0');

    // Normalized scores between 0.15 and 1.0 (with a baseline so initial display looks great)
    // 1. Memory: Reactor Meltdown (target ~300 pts)
    const scoreMemory = Math.min(1.0, Math.max(0.15, reactorBest > 0 ? (reactorBest / 300) : 0.2));
    // 2. Logic: Defusal Protocol (target ~500 pts)
    const scoreLogic = Math.min(1.0, Math.max(0.15, defuseBest > 0 ? (defuseBest / 500) : 0.2));
    // 3. Speed: Cyber Snake (target ~100 pts)
    const scoreSpeed = Math.min(1.0, Math.max(0.15, snakeBest > 0 ? (snakeBest / 100) : 0.2));
    // 4. Spatial: Cyber Maze (target ~5 clears)
    const scoreSpatial = Math.min(1.0, Math.max(0.15, mazeClears > 0 ? (mazeClears / 5) : 0.2));
    // 5. Strategy: Cyber Chess (1200 -> 0.33, 1600+ -> 1.0)
    const scoreStrategy = Math.min(1.0, Math.max(0.15, (chessRating - 1000) / 600));

    // Update percentage indicators in DOM
    const elMem = document.getElementById('valMetricMemory');
    const elLog = document.getElementById('valMetricLogic');
    const elSpd = document.getElementById('valMetricSpeed');
    const elSpa = document.getElementById('valMetricSpatial');
    const elStr = document.getElementById('valMetricStrategy');
    const elIndex = document.getElementById('overallBrainScore');

    if (elMem) elMem.innerText = Math.round(scoreMemory * 100) + '%';
    if (elLog) elLog.innerText = Math.round(scoreLogic * 100) + '%';
    if (elSpd) elSpd.innerText = Math.round(scoreSpeed * 100) + '%';
    if (elSpa) elSpa.innerText = Math.round(scoreSpatial * 100) + '%';
    if (elStr) elStr.innerText = Math.round(scoreStrategy * 100) + '%';

    const avgScore = Math.round(((scoreMemory + scoreLogic + scoreSpeed + scoreSpatial + scoreStrategy) / 5) * 100);
    if (elIndex) elIndex.innerText = avgScore;

    // Canvas geometry
    const w = canvas.width;
    const h = canvas.height;
    ctx.clearRect(0, 0, w, h);

    const cx = w / 2;
    const cy = h / 2 - 2;
    const r = Math.min(w, h) * 0.35; // ~95px radius
    const axes = [
      { name: 'Memory', score: scoreMemory, color: '#38bdf8' },
      { name: 'Logic', score: scoreLogic, color: '#facc15' },
      { name: 'Speed', score: scoreSpeed, color: '#10b981' },
      { name: 'Spatial', score: scoreSpatial, color: '#06b6d4' },
      { name: 'Strategy', score: scoreStrategy, color: '#ec4899' }
    ];
    const totalAxes = axes.length;

    function getCoord(axisIndex, distRatio) {
      const angle = -Math.PI / 2 + (2 * Math.PI * axisIndex / totalAxes);
      return {
        x: cx + Math.cos(angle) * (r * distRatio),
        y: cy + Math.sin(angle) * (r * distRatio)
      };
    }

    // Concentric Web Polygons
    const levels = [0.25, 0.5, 0.75, 1.0];
    levels.forEach(lvl => {
      ctx.beginPath();
      for (let i = 0; i < totalAxes; i++) {
        const pt = getCoord(i, lvl);
        if (i === 0) ctx.moveTo(pt.x, pt.y);
        else ctx.lineTo(pt.x, pt.y);
      }
      ctx.closePath();
      ctx.strokeStyle = lvl === 1.0 ? 'rgba(56, 189, 248, 0.4)' : 'rgba(148, 163, 184, 0.15)';
      ctx.lineWidth = 1;
      ctx.stroke();
    });

    // Radial Spokes
    for (let i = 0; i < totalAxes; i++) {
      const pt = getCoord(i, 1.0);
      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.lineTo(pt.x, pt.y);
      ctx.strokeStyle = 'rgba(148, 163, 184, 0.2)';
      ctx.lineWidth = 1;
      ctx.stroke();
    }

    // Player Polygon Fill & Outline
    ctx.beginPath();
    for (let i = 0; i < totalAxes; i++) {
      const pt = getCoord(i, axes[i].score);
      if (i === 0) ctx.moveTo(pt.x, pt.y);
      else ctx.lineTo(pt.x, pt.y);
    }
    ctx.closePath();

    const grad = ctx.createRadialGradient(cx, cy, 10, cx, cy, r);
    grad.addColorStop(0, 'rgba(56, 189, 248, 0.45)');
    grad.addColorStop(1, 'rgba(168, 85, 247, 0.2)');
    ctx.fillStyle = grad;
    ctx.fill();

    ctx.strokeStyle = '#38bdf8';
    ctx.lineWidth = 2.5;
    ctx.stroke();

    // Vertex Points
    for (let i = 0; i < totalAxes; i++) {
      const pt = getCoord(i, axes[i].score);
      ctx.beginPath();
      ctx.arc(pt.x, pt.y, 4.5, 0, Math.PI * 2);
      ctx.fillStyle = axes[i].color;
      ctx.fill();
      ctx.strokeStyle = '#ffffff';
      ctx.lineWidth = 1.5;
      ctx.stroke();
    }

    // Axis Labels
    ctx.font = '600 11px system-ui, -apple-system, sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    for (let i = 0; i < totalAxes; i++) {
      const labelPt = getCoord(i, 1.24);
      ctx.fillStyle = axes[i].color;
      ctx.fillText(axes[i].name, labelPt.x, labelPt.y);
    }
  }

  function resetLocalCache() {
    if (confirm('Purge local score and telemetry cache? Your cloud records remain safe in the database.')) {
      localStorage.clear();
      syncCloudScores();
      alert('Local telemetry purged successfully.');
    }
  }

  function togglePerformance(checkbox) {
    if (checkbox.checked) {
      document.body.style.setProperty('animation', 'none', 'important');
    } else {
      document.body.style.removeProperty('animation');
    }
  }

  document.querySelectorAll('.modal-overlay').forEach(modal => {
    modal.addEventListener('click', function(e) {
      if (e.target === this) closeModal(this.id);
    });
  });

  window.addEventListener('DOMContentLoaded', () => {
    checkLiveSession();
    syncCloudScores();
    if (isUserLoggedIn) updateAccountLevelUI();
  });
</script>
</body>
</html>