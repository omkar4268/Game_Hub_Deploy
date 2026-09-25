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
<title>CYBER HUB // ARCADE MATRIX</title>
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
  .banner-breaker { background: linear-gradient(135deg, #1e1b4b, #a855f7 60%, #06b6d4 100%); }
  .banner-glitch  { background: linear-gradient(135deg, #0284c7, #38bdf8 50%, #22c55e 100%); }

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
      <div class="portal-tag">SYSTEM ONLINE // SECURE ACCESS v2.5</div>
      <h1 class="portal-title">CYBER HUB // ARCADE</h1>
      <p class="portal-subtitle">
        Tactical neural gaming matrix. Engage in timed crisis defusals, engine-analyzed cyber chess, procedural labyrinths, and grid breaches.
      </p>

      <div class="portal-actions">
        <% if (isLoggedIn) { %>
          <button class="btn-portal btn-portal-primary" onclick="triggerFastEnter('OPERATOR: <%= currentUser.toUpperCase() %>', 'ACCESS AUTHORIZED // SYSTEM READY')">
            <span>⚡ ENTER AS <%= currentUser.toUpperCase() %></span>
          </button>
          <button class="btn-portal btn-portal-secondary" onclick="performLogout()">
            <span>✕ SIGN OUT</span>
          </button>
        <% } else { %>
          <button class="btn-portal btn-portal-primary" onclick="openLoginModal()">
            <span>🔐 SIGN IN</span>
          </button>
          <button class="btn-portal btn-portal-secondary" onclick="openSignupModal()">
            <span>⚡ REGISTER CALLSIGN</span>
          </button>
          <button class="btn-portal btn-portal-guest" onclick="triggerFastEnter('GUEST RECRUIT', 'GUEST ACCESS GRANTED // OVERRIDE ENGAGED')">
            <span>🎮 CONTINUE AS GUEST</span>
          </button>
        <% } %>
      </div>

      <div class="portal-footer-note">
        CLUSTERS: TOKYO SECURE [TLS] // AP-NORTHEAST-1 // PERSISTENT ARCHIVE
      </div>
    </div>
  </div>

  <!-- =========================================================
       SIDEBAR & PROFILE STATE
       ========================================================= -->
  <aside>
    <div class="brand" onclick="showPortal()">
      CYBER <span class="brand-badge">HUB</span>
    </div>

    <div class="auth-widget" id="authWidget">
      <% if (isLoggedIn) { %>
        <div class="auth-avatar"><%= currentUser.substring(0, 1).toUpperCase() %></div>
        <div class="auth-name"><%= currentUser %></div>
        <div class="auth-role">PLAYER ONLINE</div>
        <button class="btn-auth btn-logout" onclick="performLogout()">TERMINATE [LOGOUT]</button>
      <% } else { %>
        <div class="auth-avatar" style="background: rgba(255,255,255,0.05); color: var(--text-muted);">?</div>
        <div class="auth-name" style="color: var(--text-muted);">GUEST RECRUIT</div>
        <div class="auth-role" style="color: var(--warning);">UNAUTHENTICATED</div>
        <button class="btn-auth btn-login" onclick="openLoginModal()">ACCESS TERMINAL</button>
      <% } %>
    </div>

    <nav>
      <button class="nav-btn active" onclick="switchTab('library', this)">
        <span style="font-size: 1.2rem;">📚</span>
        <span>Library</span>
      </button>
      <button class="nav-btn" onclick="switchTab('scores', this)">
        <span style="font-size: 1.2rem;">🏆</span>
        <span>Records</span>
      </button>
      <button class="nav-btn" onclick="switchTab('settings', this)">
        <span style="font-size: 1.2rem;">⚙️</span>
        <span>System</span>
      </button>
    </nav>

    <button class="btn-portal-recall" onclick="showPortal()">
      <span>🔒 Portal Screen</span>
    </button>
  </aside>

  <!-- =========================================================
       MAIN CONTENT DASHBOARD
       ========================================================= -->
  <main>
    <div class="top-meta">
      <h2 id="viewTitle">Game Library</h2>
      <div class="sys-status">Live Server</div>
    </div>

    <!-- VIEW 1: GAME LIBRARY CAROUSEL -->
    <section id="libraryView" class="view-panel active">
      <div class="carousel-controls">
        <button class="scroll-btn" onclick="scrollCarousel(-340)">‹</button>
        <button class="scroll-btn" onclick="scrollCarousel(340)">›</button>
      </div>

      <div class="game-carousel" id="carousel">
        
        <!-- Game 1: Defusal Protocol -->
        <div class="game-card" style="animation-delay: 0.05s;" onclick="openLaunchModal('Bomb_Defuse/index.jsp', 'Defusal Protocol', 'High-stakes 3-minute bomb defusal simulation. Complete bypass sequences across modules before the integrity failsafe triggers.')">
          <div class="card-banner banner-bomb">☢️</div>
          <div class="card-body">
            <div class="card-tag">Crisis Sim</div>
            <div class="card-title">Defusal Protocol</div>
            <div class="card-desc">Execute override sequences on complex security modules under strict countdown timers. Zero tolerance for errors.</div>
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

        <!-- Game 6: Cyber Grid: Node Breaker -->
        <div class="game-card" style="animation-delay: 0.3s;" onclick="openLaunchModal('Node_Breaker.jsp', 'Cyber Grid: Node Breaker', 'Defragment cluster circuits, trigger gravitational collapses, and breach dynamic target matrices scaling progressively up to 8x8.')">
          <div class="card-banner banner-breaker">💠</div>
          <div class="card-body">
            <div class="card-tag">Tactical Logic</div>
            <div class="card-title">Node Breaker</div>
            <div class="card-desc">Neutralize cluster circuits, trigger quantum chain-reactions, and defragment data matrices across auto-scaling grids.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-breaker">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 7: Cyber Grid: Glitch Protocol -->
        <div class="game-card" style="animation-delay: 0.35s;" onclick="openLaunchModal('Glitch_Protocol.jsp', 'Cyber Grid: Glitch Protocol', 'Physics-based Match-3 puzzle. Swap adjacent glowing nodes, trigger cascading data streams, and purge corrupted firewall tiles across auto-scaling matrices.')">
          <div class="card-banner banner-glitch">⚡</div>
          <div class="card-body">
            <div class="card-tag">Match-3 Puzzle</div>
            <div class="card-title">Glitch Protocol</div>
            <div class="card-desc">Swap adjacent data streams, trigger cascading chain reactions, and purge corrupted firewall sectors.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-glitch">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

      </div>
    </section>

    <!-- VIEW 2: EXPANDED SCORING & LEADERBOARDS -->
    <section id="scoresView" class="view-panel">
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

        <!-- 6. Cyber Grid: Node Breaker -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #a855f7;">💠 Node Breaker</div>
            <div class="score-badge" style="background: rgba(168, 85, 247, 0.15); color: #a855f7; border: 1px solid rgba(168, 85, 247, 0.3);">Progressive 8x8</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statBreakerBest" style="color: #a855f7;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Highest Stage Cleared</span>
            <span class="stat-val" id="statBreakerLevel">Stage 1</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Grid Matrix Density</span>
            <span class="stat-val" style="color: var(--primary);">Dynamic 5x5 - 8x8</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Operator</span>
            <span class="stat-val" id="statBreakerLeader" style="color: var(--accent);">--</span>
          </div>
        </div>

        <!-- 7. Glitch Protocol -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #38bdf8;">⚡ Glitch Protocol</div>
            <div class="score-badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3);">Match-3 Stream</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statGlitchBest" style="color: #38bdf8;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Deepest Sector</span>
            <span class="stat-val" id="statGlitchSector">Sector 1</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Engine Mechanics</span>
            <span class="stat-val" style="color: var(--accent);">Cascading Purge</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Operator</span>
            <span class="stat-val" id="statGlitchLeader" style="color: var(--warning);">--</span>
          </div>
        </div>

      </div>
    </section>

    <!-- VIEW 3: SYSTEM PREFERENCES -->
    <section id="settingsView" class="view-panel">
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
    </section>
  </main>

  <!-- =========================================================
       MODAL 1: PRE-GAME LAUNCH CONFIRMATION
       ========================================================= -->
  <div class="modal-overlay" id="launchModal">
    <div class="modal-box">
      <h2 id="modalTitle" style="color: var(--primary); font-weight: 900; letter-spacing: 1px;">Launch Mission</h2>
      <p id="modalDesc" style="color:var(--text-muted); font-size:0.92rem; margin-top:0.8rem; line-height: 1.6;"></p>
      <div class="modal-actions">
        <button class="btn-modal btn-cancel" onclick="closeModal('launchModal')">Abort</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">Initialize</button>
      </div>
    </div>
  </div>

  <!-- =========================================================
       MODAL 2: IDENT SYSTEM // LOGIN (MOBILE FIRST)
       ========================================================= -->
  <div class="modal-overlay" id="loginModal">
    <div class="modal-box">
      <h2 style="color: var(--primary); font-weight: 900; letter-spacing: 1px;">IDENT SYSTEM // LOGIN</h2>
      <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.4rem;">Authorize your terminal credentials</p>

      <div class="auth-msg" id="loginMsg"></div>

      <form id="loginForm" onsubmit="event.preventDefault(); submitLogin();">
        <div class="auth-form-group">
          <label class="auth-label" for="loginUsername">Callsign [Username]</label>
          <input type="text" class="auth-input" id="loginUsername" placeholder="e.g. NeoCipher" autocomplete="username" required>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="loginPassword">Cipher [Password]</label>
          <input type="password" class="auth-input" id="loginPassword" placeholder="••••••••" autocomplete="current-password" required>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal btn-cancel" onclick="closeModal('loginModal')">Cancel</button>
          <button type="submit" class="btn-modal btn-launch" id="loginSubmitBtn">
            <span id="loginBtnText">Authenticate</span>
          </button>
        </div>
      </form>

      <span class="switch-auth-link" onclick="openSignupModal()">New recruit? Register identity here</span>
    </div>
  </div>

  <!-- =========================================================
       MODAL 3: NEW RECRUIT // ENLIST (MOBILE FIRST)
       ========================================================= -->
  <div class="modal-overlay" id="signupModal">
    <div class="modal-box">
      <h2 style="color: var(--accent); font-weight: 900; letter-spacing: 1px;">NEW RECRUIT // ENLIST</h2>
      <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.4rem;">Create persistent cyber identity</p>

      <div class="auth-msg" id="signupMsg"></div>

      <form id="signupForm" onsubmit="event.preventDefault(); submitSignup();">
        <div class="auth-form-group">
          <label class="auth-label" for="signupUsername">Choose Callsign [3-20 Alphanumeric]</label>
          <input type="text" class="auth-input" id="signupUsername" placeholder="e.g. CyberSamurai" autocomplete="username" required>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="signupPassword">Create Cipher [Min 6 Chars]</label>
          <input type="password" class="auth-input" id="signupPassword" placeholder="••••••••" autocomplete="new-password" required>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="signupPasswordConfirm">Confirm Cipher</label>
          <input type="password" class="auth-input" id="signupPasswordConfirm" placeholder="••••••••" autocomplete="new-password" required>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal btn-cancel" onclick="closeModal('signupModal')">Cancel</button>
          <button type="submit" class="btn-modal btn-launch" id="signupSubmitBtn" style="background:var(--accent); box-shadow:0 0 15px rgba(34,197,94,0.4);">
            <span id="signupBtnText">Enlist</span>
          </button>
        </div>
      </form>

      <span class="switch-auth-link" onclick="openLoginModal()">Already enlisted? Sign in</span>
    </div>
  </div>

<script>
  let targetUrl = '';

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

  // --- TAB NAVIGATION ---
  function switchTab(tab, btn) {
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.view-panel').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    
    setTimeout(() => {
      if (tab === 'library') {
        document.getElementById('libraryView').classList.add('active');
        document.getElementById('viewTitle').innerText = 'Game Library';
      } else if (tab === 'scores') {
        document.getElementById('scoresView').classList.add('active');
        document.getElementById('viewTitle').innerText = 'System Records';
        syncCloudScores();
      } else if (tab === 'settings') {
        document.getElementById('settingsView').classList.add('active');
        document.getElementById('viewTitle').innerText = 'Terminal Config';
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

  // --- ASYNC AUTH HANDLERS WITH BLAST DOORS INTEGRATION ---
  async function submitLogin() {
    const u = document.getElementById('loginUsername').value.trim();
    const p = document.getElementById('loginPassword').value;
    const btn = document.getElementById('loginSubmitBtn');
    const btnText = document.getElementById('loginBtnText');

    if (!u || !p) {
      setBanner('loginMsg', 'error', 'Callsign and cipher required.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> AUTHENTICATING...';

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
        btnText.innerText = 'Authenticate';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('loginMsg', 'success', 'Access Authorized! Triggering airlock sequence...');
        setTimeout(() => {
          closeModal('loginModal');
          triggerDoorTransition('OPERATOR: ' + u.toUpperCase(), 'CIPHER VALIDATED // ACCESS GRANTED', () => {
            window.location.reload();
          });
        }, 400);
      } else {
        setBanner('loginMsg', 'error', data.message || 'Access Denied: Invalid credentials.');
        btn.disabled = false;
        btnText.innerText = 'Authenticate';
      }
    } catch (netErr) {
      setBanner('loginMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = 'Authenticate';
    }
  }

  async function submitSignup() {
    const u = document.getElementById('signupUsername').value.trim();
    const p = document.getElementById('signupPassword').value;
    const c = document.getElementById('signupPasswordConfirm').value;
    const btn = document.getElementById('signupSubmitBtn');
    const btnText = document.getElementById('signupBtnText');

    if (!u || !p || !c) {
      setBanner('signupMsg', 'error', 'All fields required.');
      return;
    }
    if (p !== c) {
      setBanner('signupMsg', 'error', 'Ciphers do not match.');
      return;
    }
    if (p.length < 6) {
      setBanner('signupMsg', 'error', 'Cipher must be at least 6 characters.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> ENLISTING...';

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
        btnText.innerText = 'Enlist';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('signupMsg', 'success', 'Identity Enlisted! Initializing cyber state...');
        setTimeout(() => {
          closeModal('signupModal');
          triggerDoorTransition('NEW RECRUIT: ' + u.toUpperCase(), 'SECURITY CLEARANCE ISSUED // ACCESS GRANTED', () => {
            window.location.reload();
          });
        }, 400);
      } else {
        setBanner('signupMsg', 'error', data.message || 'Registration failed.');
        btn.disabled = false;
        btnText.innerText = 'Enlist';
      }
    } catch (netErr) {
      setBanner('signupMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = 'Enlist';
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
        const u = data.username || data.user_session;
        const widget = document.getElementById('authWidget');
        if (widget) {
          widget.innerHTML = `
            <div class="auth-avatar">${u.substring(0, 1).toUpperCase()}</div>
            <div class="auth-name">${u}</div>
            <div class="auth-role">PLAYER ONLINE</div>
            <button class="btn-auth btn-logout" onclick="performLogout()">TERMINATE [LOGOUT]</button>
          `;
        }
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

    // 6. Cyber Grid: Node Breaker Metrics
    const localBreaker = localStorage.getItem('hub_nodebreaker_high') || '0';
    const localBreakerLevel = localStorage.getItem('hub_nodebreaker_level') || 'Stage 1';

    const pBreaker = document.getElementById('preview-breaker');
    const sBreakerBest = document.getElementById('statBreakerBest');
    const sBreakerLevel = document.getElementById('statBreakerLevel');

    if (pBreaker) pBreaker.innerText = localBreaker + ' pts';
    if (sBreakerBest) sBreakerBest.innerText = localBreaker + ' pts';
    if (sBreakerLevel) sBreakerLevel.innerText = localBreakerLevel;

    // 7. Cyber Grid: Glitch Protocol Metrics
    const localGlitch = localStorage.getItem('hub_glitch_high') || '0';
    const localGlitchSector = localStorage.getItem('hub_glitch_sector') || 'Sector 1';

    const pGlitch = document.getElementById('preview-glitch');
    const sGlitchBest = document.getElementById('statGlitchBest');
    const sGlitchSector = document.getElementById('statGlitchSector');

    if (pGlitch) pGlitch.innerText = localGlitch + ' pts';
    if (sGlitchBest) sGlitchBest.innerText = localGlitch + ' pts';
    if (sGlitchSector) sGlitchSector.innerText = localGlitchSector;

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
          if (data.userScores.node_breaker !== undefined) {
            const dbBreaker = data.userScores.node_breaker;
            if (pBreaker) pBreaker.innerText = dbBreaker + ' pts';
            if (sBreakerBest) sBreakerBest.innerText = dbBreaker + ' pts';
            localStorage.setItem('hub_nodebreaker_high', dbBreaker);
          }
          if (data.userScores.glitch_protocol !== undefined) {
            const dbGlitch = data.userScores.glitch_protocol;
            if (pGlitch) pGlitch.innerText = dbGlitch + ' pts';
            if (sGlitchBest) sGlitchBest.innerText = dbGlitch + ' pts';
            localStorage.setItem('hub_glitch_high', dbGlitch);
          }
        }

        if (data.leaders) {
          const lSnake = document.getElementById('statSnakeLeader');
          const lDefuse = document.getElementById('statDefuseLeader');
          const lBreaker = document.getElementById('statBreakerLeader');
          const lGlitch = document.getElementById('statGlitchLeader');
          if (lSnake && data.leaders.snake) {
            lSnake.innerText = data.leaders.snake.username + ' (' + data.leaders.snake.score + ' pts)';
          }
          if (lDefuse && data.leaders.bomb_defuse) {
            lDefuse.innerText = data.leaders.bomb_defuse.username + ' (' + data.leaders.bomb_defuse.score + ' pts)';
          }
          if (lBreaker && data.leaders.node_breaker) {
            lBreaker.innerText = data.leaders.node_breaker.username + ' (' + data.leaders.node_breaker.score + ' pts)';
          }
          if (lGlitch && data.leaders.glitch_protocol) {
            lGlitch.innerText = data.leaders.glitch_protocol.username + ' (' + data.leaders.glitch_protocol.score + ' pts)';
          }
        }
      }
    } catch (e) {
      console.warn('Cloud score sync offline; relying on local telemetry.');
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
  });
</script>
</body>
</html>