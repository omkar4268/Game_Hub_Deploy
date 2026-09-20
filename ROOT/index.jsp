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
<title>CYBER HUB // ARCADE</title>
<style>
  :root {
    --bg-base: #03050a;
    --card-bg: rgba(13, 19, 36, 0.65);
    --border-glow: rgba(56, 189, 248, 0.3);
    --primary: #38bdf8;
    --primary-rgb: 56, 189, 248;
    --accent: #22c55e;
    --neon-pink: #f43f5e;
    --neon-purple: #a855f7;
    --warning: #f59e0b;
    --danger: #ef4444;
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', system-ui, sans-serif; -webkit-tap-highlight-color: transparent; }

  body {
    background-color: var(--bg-base);
    color: var(--text-main);
    min-height: 100vh;
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
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.08) 0%, transparent 25%),
      radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.08) 0%, transparent 25%),
      linear-gradient(rgba(255,255,255,0.015) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.015) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 40px 40px, 40px 40px;
    z-index: -1;
    pointer-events: none;
    animation: backgroundDrift 90s linear infinite;
  }

  aside {
    width: 260px;
    background: rgba(8, 12, 23, 0.7);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-right: 1px solid rgba(255, 255, 255, 0.05);
    display: flex;
    flex-direction: column;
    padding: 2.5rem 1.5rem;
    flex-shrink: 0;
    z-index: 100;
    box-shadow: 5px 0 30px rgba(0,0,0,0.5);
  }

  .brand {
    font-size: 1.5rem;
    font-weight: 900;
    letter-spacing: 3px;
    display: flex;
    align-items: center;
    gap: 0.6rem;
    margin-bottom: 3rem;
    text-shadow: 0 0 20px rgba(56, 189, 248, 0.5);
  }
  .brand-badge {
    background: linear-gradient(135deg, var(--primary), var(--neon-purple));
    font-size: 0.7rem;
    padding: 3px 8px;
    border-radius: 6px;
    color: #000;
    font-weight: 900;
    box-shadow: 0 0 15px rgba(168, 85, 247, 0.4);
  }

  /* User Auth Widget in Sidebar */
  .auth-widget {
    background: rgba(15, 23, 42, 0.6);
    border: 1px solid rgba(56, 189, 248, 0.2);
    border-radius: 12px;
    padding: 1rem;
    margin-bottom: 2rem;
    text-align: center;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  }
  .auth-avatar {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    margin: 0 auto 0.5rem auto;
    background: linear-gradient(135deg, var(--primary), var(--neon-purple));
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    color: #000;
    font-weight: 900;
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.4);
  }
  .auth-name {
    font-size: 0.95rem;
    font-weight: 700;
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
    margin-bottom: 0.8rem;
  }
  .btn-auth {
    display: inline-block;
    width: 100%;
    padding: 0.55rem;
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
    color: var(--danger);
    border: 1px solid rgba(239, 68, 68, 0.3);
  }
  .btn-logout:hover {
    background: rgba(239, 68, 68, 0.3);
  }

  nav { display: flex; flex-direction: column; gap: 0.8rem; }
  .nav-btn {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem 1.2rem;
    border-radius: 12px;
    background: transparent;
    color: var(--text-muted);
    border: 1px solid transparent;
    cursor: pointer;
    font-size: 1rem;
    font-weight: 600;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    text-align: left;
    position: relative;
    overflow: hidden;
  }
  
  .nav-btn:hover { 
    color: var(--text-main); 
    background: rgba(255, 255, 255, 0.03); 
    transform: translateX(5px);
  }
  
  .nav-btn.active {
    background: linear-gradient(90deg, rgba(56, 189, 248, 0.1), transparent);
    color: var(--primary);
    border-color: rgba(56, 189, 248, 0.2);
    box-shadow: inset 4px 0 0 var(--primary);
  }

  main {
    flex: 1;
    padding: 2.5rem 3rem;
    overflow-y: auto;
    width: 100%;
  }

  .top-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2.5rem;
  }
  .top-meta h2 { 
    font-size: 2.2rem; 
    font-weight: 900; 
    background: linear-gradient(to right, #fff, #94a3b8);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  .sys-status {
    font-size: 0.85rem;
    color: var(--accent);
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(34, 197, 94, 0.1);
    padding: 6px 14px;
    border-radius: 20px;
    border: 1px solid rgba(34, 197, 94, 0.2);
  }
  
  @keyframes pulse {
    0% { box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.7); }
    70% { box-shadow: 0 0 0 6px rgba(34, 197, 94, 0); }
    100% { box-shadow: 0 0 0 0 rgba(34, 197, 94, 0); }
  }
  
  .sys-status::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent);
    animation: pulse 2s infinite;
  }

  .view-panel { display: none; opacity: 0; transition: opacity 0.4s ease; }
  .view-panel.active { display: block; opacity: 1; }

  .carousel-controls {
    display: flex;
    justify-content: flex-end;
    gap: 0.8rem;
    margin-bottom: 1.5rem;
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
    gap: 2rem;
    overflow-x: auto;
    padding: 1rem 1rem 3rem 1rem;
    margin: -1rem;
    scroll-behavior: smooth;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
  }
  .game-carousel::-webkit-scrollbar { height: 8px; }
  .game-carousel::-webkit-scrollbar-track { background: rgba(0,0,0,0.2); border-radius: 4px; }
  .game-carousel::-webkit-scrollbar-thumb { background: rgba(56, 189, 248, 0.3); border-radius: 4px; }
  .game-carousel::-webkit-scrollbar-thumb:hover { background: var(--primary); }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .game-card {
    min-width: 320px;
    width: 320px;
    background: var(--card-bg);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.05);
    overflow: hidden;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    scroll-snap-align: center;
    flex-shrink: 0;
    opacity: 0;
    animation: fadeInUp 0.6s ease forwards;
    position: relative;
  }

  .game-card::after {
    content: '';
    position: absolute;
    top: 0; left: -100%;
    width: 50%; height: 100%;
    background: linear-gradient(to right, transparent, rgba(255,255,255,0.1), transparent);
    transform: skewX(-20deg);
    transition: 0s;
  }

  .game-card:hover {
    transform: translateY(-12px) scale(1.02);
    border-color: rgba(var(--primary-rgb), 0.5);
    box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.8), 0 0 20px rgba(var(--primary-rgb), 0.2);
  }
  
  .game-card:hover::after {
    left: 200%;
    transition: left 0.8s ease-in-out;
  }

  .banner-bomb    { background: linear-gradient(135deg, #7f1d1d, #ea580c); }
  .banner-guesser { background: linear-gradient(135deg, #312e81, #6366f1); }
  .banner-snake   { background: linear-gradient(135deg, #064e3b, #10b981); }
  .banner-maze    { background: linear-gradient(135deg, #0c4a6e, #38bdf8); }
  .banner-chess   { background: linear-gradient(135deg, #4c1d95, #ec4899); }

  .card-banner {
    height: 160px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 4rem;
    position: relative;
    overflow: hidden;
  }

  .card-body {
    padding: 1.5rem;
    display: flex;
    flex-direction: column;
    flex: 1;
    background: linear-gradient(180deg, rgba(15,23,42,0) 0%, rgba(15,23,42,0.8) 100%);
  }
  .card-tag {
    font-size: 0.7rem;
    letter-spacing: 1.5px;
    font-weight: 800;
    text-transform: uppercase;
    color: var(--primary);
    margin-bottom: 0.5rem;
  }
  .card-title { font-size: 1.35rem; font-weight: 800; margin-bottom: 0.5rem; }
  .card-desc { font-size: 0.9rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 1.5rem; }

  .card-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 1rem;
    border-top: 1px solid rgba(255,255,255,0.05);
  }
  .card-score-preview { font-size: 0.85rem; color: var(--text-muted); }
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
    font-size: 1.2rem;
    transition: all 0.3s;
  }
  .game-card:hover .launch-arrow {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 15px rgba(var(--primary-rgb), 0.6);
  }

  .score-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1.5rem;
  }
  .score-card, .settings-box {
    background: var(--card-bg);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    padding: 1.8rem;
    transition: transform 0.3s;
  }
  .score-card:hover { transform: translateY(-5px); border-color: rgba(255,255,255,0.1); }
  
  .stat-row, .settings-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.8rem 0;
    border-bottom: 1px dashed rgba(255, 255, 255, 0.1);
  }
  .stat-row:last-child, .settings-row:last-child { border-bottom: none; }
  .stat-row span:last-child { font-weight: 800; color: var(--primary); font-size: 1.1rem; }

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

  /* =========================================================
     MOBILE-FIRST RESPONSIVE MODAL SYSTEM (PHASE 2 OVERHAUL)
     ========================================================= */
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
    padding: 2rem 1.6rem;
    width: 90vw;
    max-width: 400px;
    max-height: 85vh;
    max-height: 85dvh;
    overflow-y: auto;
    margin: auto;
    text-align: center;
    transform: scale(0.94);
    transition: transform 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    position: relative;
    box-sizing: border-box;
  }
  .modal-overlay.active .modal-box { transform: scale(1); }
  
  .modal-box::-webkit-scrollbar { width: 6px; }
  .modal-box::-webkit-scrollbar-track { background: rgba(0,0,0,0.3); border-radius: 4px; }
  .modal-box::-webkit-scrollbar-thumb { background: rgba(56, 189, 248, 0.3); border-radius: 4px; }

  .modal-actions {
    display: flex;
    gap: 0.8rem;
    justify-content: center;
    margin-top: 1.5rem;
  }
  .btn-modal {
    min-height: 44px; /* Mobile touch target */
    padding: 0.75rem 1.2rem;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    font-weight: 700;
    font-size: 0.95rem;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.2s ease;
    flex: 1;
  }
  .btn-modal:disabled {
    opacity: 0.65;
    cursor: not-allowed;
    filter: grayscale(0.5);
  }

  .btn-launch { 
    background: var(--primary); 
    color: #000; 
    box-shadow: 0 0 15px rgba(var(--primary-rgb), 0.4);
  }
  .btn-launch:hover:not(:disabled) { 
    background: #0ea5e9; 
    box-shadow: 0 0 25px rgba(var(--primary-rgb), 0.6); 
    transform: translateY(-2px); 
  }
  .btn-cancel { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
  .btn-cancel:hover:not(:disabled) { background: rgba(255, 255, 255, 0.15); }

  /* Input fields for Auth Modals */
  .auth-form-group {
    text-align: left;
    margin-top: 1rem;
  }
  .auth-label {
    display: block;
    font-size: 0.75rem;
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
    font-size: 16px !important; /* Critical: 16px prevents iOS Safari auto-zoom */
    outline: none;
    transition: all 0.2s ease;
    box-sizing: border-box;
  }
  .auth-input:focus {
    border-color: var(--primary);
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.4);
    background: rgba(15, 23, 42, 1);
  }

  /* Animated Status & Error Banners */
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

  /* Loading Spinner */
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
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
    margin-top: 1.2rem;
    font-size: 0.85rem;
    color: var(--text-muted);
    cursor: pointer;
    text-decoration: underline;
    padding: 0.4rem;
  }
  .switch-auth-link:hover { color: var(--primary); }

  @media (max-width: 768px) {
    body { flex-direction: column; padding-bottom: 80px; }

    aside {
      width: 100%; height: 75px; position: fixed; bottom: 0; left: 0; right: 0;
      padding: 0.5rem; flex-direction: row; border-right: none;
      border-top: 1px solid rgba(255, 255, 255, 0.08); background: rgba(8, 12, 23, 0.95);
      align-items: center; justify-content: space-around; z-index: 999;
    }

    .brand, .auth-widget { display: none; }
    nav { flex-direction: row; width: 100%; justify-content: space-around; gap: 0; }
    .nav-btn {
      flex-direction: column; gap: 6px; padding: 0.5rem; font-size: 0.75rem;
      border-left: none !important; border-radius: 10px; text-align: center;
    }
    .nav-btn.active {
      background: rgba(56, 189, 248, 0.1); color: var(--primary);
      box-shadow: none; border-top: 2px solid var(--primary);
    }

    main { padding: 1.5rem 1.2rem; }
    .top-meta h2 { font-size: 1.6rem; }
    .carousel-controls { display: none; }
    
    .game-carousel { padding-bottom: 2rem; gap: 1.2rem; }
    .game-card { min-width: 85vw; width: 85vw; }

    /* Mobile Overrides for Modals */
    .modal-box {
      padding: 1.5rem 1.2rem;
      width: 92vw;
      max-height: 82vh;
      max-height: 82dvh;
    }
  }
</style>
</head>
<body>

  <aside>
    <div class="brand">
      CYBER <span class="brand-badge">HUB</span>
    </div>

    <!-- User Profile & Authentication State -->
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
  </aside>

  <main>
    <div class="top-meta">
      <h2 id="viewTitle">Game Library</h2>
      <div class="sys-status">Live Server</div>
    </div>

    <!-- VIEW 1: Games -->
    <section id="libraryView" class="view-panel active">
      <div class="carousel-controls">
        <button class="scroll-btn" onclick="scrollCarousel(-340)">‹</button>
        <button class="scroll-btn" onclick="scrollCarousel(340)">›</button>
      </div>

      <div class="game-carousel" id="carousel">
        
        <!-- Bomb Defusal (Matches your Bomb_Defuse folder) -->
        <div class="game-card" style="animation-delay: 0.1s;" onclick="openLaunchModal('Bomb_Defuse/index.jsp', 'Defusal Protocol', 'High-stakes 3-minute bomb defusal simulation. Memorize the manual, disarm the modules, and do not trigger the failsafe.')">
          <div class="card-banner banner-bomb">☢️</div>
          <div class="card-body">
            <div class="card-tag">Crisis Sim</div>
            <div class="card-title">Defusal Protocol</div>
            <div class="card-desc">Execute override sequences on complex security modules under a strict 3-minute timer. Don't blow it.</div>
            <div class="card-footer">
              <div class="card-score-preview">Top: <span id="preview-defuse">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Cyber Chess -->
        <div class="game-card" style="animation-delay: 0.2s;" onclick="openLaunchModal('Chess.jsp', 'Cyber Chess', 'Experience enhanced chess with actual AI engine, move evaluation, PGN export, move history, and sound effects in a futuristic cyber theme.')">
          <div class="card-banner banner-chess">♟️</div>
          <div class="card-body">
            <div class="card-tag">AI Strategy</div>
            <div class="card-title">Cyber Chess</div>
            <div class="card-desc">Play against a real chess engine with move analysis, export games as PGN, and view detailed move history.</div>
            <div class="card-footer">
              <div class="card-score-preview">Engine: <span>Stockfish</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Snake -->
        <div class="game-card" style="animation-delay: 0.3s;" onclick="openLaunchModal('Snake.jsp', 'Cyber Snake', 'Steer your cyber serpent, consume data nodes, and break your record.')">
          <div class="card-banner banner-snake">🐍</div>
          <div class="card-body">
            <div class="card-tag">Arcade Classic</div>
            <div class="card-title">Cyber Snake</div>
            <div class="card-desc">Steer your cyber serpent through the grid, consume data nodes, and set the ultimate high score.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-snake">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Maze Runner -->
        <div class="game-card" style="animation-delay: 0.4s;" onclick="openLaunchModal('Maze.jsp', 'Cyber Maze Runner', 'Solve procedurally generated mazes under varying algorithm complexities.')">
          <div class="card-banner banner-maze">⚡</div>
          <div class="card-body">
            <div class="card-tag">Procedural Puzzle</div>
            <div class="card-title">Cyber Maze</div>
            <div class="card-desc">Navigate randomized labyrinth algorithms and locate extraction gates before the system resets.</div>
            <div class="card-footer">
              <div class="card-score-preview">Cleared: <span id="preview-maze">0</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Number Guesser -->
        <div class="game-card" style="animation-delay: 0.5s;" onclick="openLaunchModal('Game1.jsp', 'Number Guesser', 'Guess the secret integer generated by the server session.')">
          <div class="card-banner banner-guesser">🔢</div>
          <div class="card-body">
            <div class="card-tag">Session Puzzle</div>
            <div class="card-title">Number Guesser</div>
            <div class="card-desc">Crack the secret integer generated by the internal server session in minimal attempts.</div>
            <div class="card-footer">
              <div class="card-score-preview">Best: <span id="preview-guess">--</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

      </div>
    </section>

    <!-- VIEW 2: Scores & Leaderboard -->
    <section id="scoresView" class="view-panel">
      <div class="score-grid">
        <div class="score-card">
          <h3 style="color:#10b981; margin-bottom:1.2rem; font-size:1.4rem;">🐍 Cyber Snake</h3>
          <div class="stat-row"><span style="color:var(--text-muted)">Cloud Record</span><span id="statSnakeBest">0 pts</span></div>
          <div class="stat-row"><span style="color:var(--text-muted)">Top Player</span><span id="statSnakeLeader">--</span></div>
        </div>
        <div class="score-card">
          <h3 style="color:#ea580c; margin-bottom:1.2rem; font-size:1.4rem;">☢️ Defusal Protocol</h3>
          <div class="stat-row"><span style="color:var(--text-muted)">Cloud Record</span><span id="statDefuseBest">0 pts</span></div>
          <div class="stat-row"><span style="color:var(--text-muted)">Top Player</span><span id="statDefuseLeader">--</span></div>
        </div>
        <div class="score-card">
          <h3 style="color:#38bdf8; margin-bottom:1.2rem; font-size:1.4rem;">⚡ Cyber Maze</h3>
          <div class="stat-row"><span style="color:var(--text-muted)">Mazes Cleared</span><span id="statMazeClears">0</span></div>
        </div>
      </div>
    </section>

    <!-- VIEW 3: Settings -->
    <section id="settingsView" class="view-panel">
      <div class="settings-box" style="max-width: 500px;">
        <h3 style="margin-bottom: 1.5rem; color: var(--primary);">System Preferences</h3>
        
        <div class="settings-row">
          <div>
            <div style="font-weight: 600;">Audio Effects</div>
            <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Enable UI sounds and game audio</div>
          </div>
          <label class="switch">
            <input type="checkbox" checked>
            <span class="slider"></span>
          </label>
        </div>
        
        <div class="settings-row">
          <div>
            <div style="font-weight: 600;">Performance Mode</div>
            <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Disable background animations</div>
          </div>
          <label class="switch">
            <input type="checkbox" onchange="togglePerformance(this)">
            <span class="slider"></span>
          </label>
        </div>
        
        <button class="btn-modal btn-cancel" onclick="resetScores()" style="margin-top: 2rem; width:100%; color: var(--danger); border: 1px solid rgba(239, 68, 68, 0.3);">
          ⚠ Purge Local Data
        </button>
      </div>
    </section>
  </main>

  <!-- Launch Modal -->
  <div class="modal-overlay" id="launchModal">
    <div class="modal-box">
      <h2 id="modalTitle" style="color: var(--primary); font-weight: 900; letter-spacing: 1px;">Launch Game</h2>
      <p id="modalDesc" style="color:var(--text-muted); font-size:0.95rem; margin-top:0.8rem; line-height: 1.5;"></p>
      <div class="modal-actions">
        <button class="btn-modal btn-cancel" onclick="closeModal('launchModal')">Abort</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">Initialize</button>
      </div>
    </div>
  </div>

  <!-- Login Modal (Mobile Optimized) -->
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

  <!-- Sign Up Modal (Mobile Optimized) -->
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
    }, 50);
  }

  function scrollCarousel(dist) {
    document.getElementById('carousel').scrollBy({ left: dist, behavior: 'smooth' });
  }

  function openLaunchModal(url, title, desc) {
    targetUrl = url;
    document.getElementById('modalTitle').innerText = title;
    document.getElementById('modalDesc').innerText = desc;
    document.getElementById('confirmLaunchBtn').onclick = () => window.location.href = targetUrl;
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

  // --- BULLETPROOF ASYNC AUTH HANDLERS ---
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
        console.error("Non-JSON Server Response:", rawText);
        setBanner('loginMsg', 'error', 'Database offline. Verify MySQL is running or configure DB_URL on Render.');
        btn.disabled = false;
        btnText.innerText = 'Authenticate';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('loginMsg', 'success', data.message || 'Access Authorized! Initializing profile...');
        setTimeout(() => {
          checkLiveSession();
          closeModal('loginModal');
          window.location.reload();
        }, 600);
      } else {
        setBanner('loginMsg', 'error', data.message || 'Access Denied: Invalid credentials.');
        btn.disabled = false;
        btnText.innerText = 'Authenticate';
      }
    } catch (netErr) {
      console.error("Fetch Network Failure:", netErr);
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
        console.error("Non-JSON Server Response:", rawText);
        setBanner('signupMsg', 'error', 'Database offline. Verify MySQL is running or configure DB_URL on Render.');
        btn.disabled = false;
        btnText.innerText = 'Enlist';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('signupMsg', 'success', data.message || 'Identity Enlisted! Initializing cyber state...');
        setTimeout(() => {
          checkLiveSession();
          closeModal('signupModal');
          window.location.reload();
        }, 600);
      } else {
        setBanner('signupMsg', 'error', data.message || 'Registration failed.');
        btn.disabled = false;
        btnText.innerText = 'Enlist';
      }
    } catch (netErr) {
      console.error("Fetch Network Failure:", netErr);
      setBanner('signupMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = 'Enlist';
    }
  }

  async function performLogout() {
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

  // --- High Score Sync & Fallback ---
  async function syncCloudScores() {
    const localSnake = localStorage.getItem('hub_snake_high') || '0';
    const localDefuse = localStorage.getItem('hub_defuse_high') || '0';
    const localMaze = localStorage.getItem('hub_maze_clears') || '0';
    const localGuess = localStorage.getItem('hub_guess_best') || '--';

    const pSnake = document.getElementById('preview-snake');
    const pDefuse = document.getElementById('preview-defuse');
    const pMaze = document.getElementById('preview-maze');
    const pGuess = document.getElementById('preview-guess');

    if (pSnake) pSnake.innerText = localSnake + ' pts';
    if (pDefuse) pDefuse.innerText = localDefuse + ' pts';
    if (pMaze) pMaze.innerText = localMaze;
    if (pGuess) pGuess.innerText = localGuess;

    const sSnake = document.getElementById('statSnakeBest');
    const sDefuse = document.getElementById('statDefuseBest');
    const sMaze = document.getElementById('statMazeClears');

    if (sSnake) sSnake.innerText = localSnake + ' pts';
    if (sDefuse) sDefuse.innerText = localDefuse + ' pts';
    if (sMaze) sMaze.innerText = localMaze;

    try {
      const res = await fetch('get_scores.jsp');
      if (res.ok) {
        const data = await res.json();
        if (data.userScores) {
          if (data.userScores.snake !== undefined) {
            if (pSnake) pSnake.innerText = data.userScores.snake + ' pts';
            if (sSnake) sSnake.innerText = data.userScores.snake + ' pts';
            localStorage.setItem('hub_snake_high', data.userScores.snake);
          }
          if (data.userScores.bomb_defuse !== undefined) {
            if (pDefuse) pDefuse.innerText = data.userScores.bomb_defuse + ' pts';
            if (sDefuse) sDefuse.innerText = data.userScores.bomb_defuse + ' pts';
            localStorage.setItem('hub_defuse_high', data.userScores.bomb_defuse);
          }
        }
        if (data.leaders) {
          const lSnake = document.getElementById('statSnakeLeader');
          const lDefuse = document.getElementById('statDefuseLeader');
          if (lSnake && data.leaders.snake) {
            lSnake.innerText = data.leaders.snake.username + ' (' + data.leaders.snake.score + ' pts)';
          }
          if (lDefuse && data.leaders.bomb_defuse) {
            lDefuse.innerText = data.leaders.bomb_defuse.username + ' (' + data.leaders.bomb_defuse.score + ' pts)';
          }
        }
      }
    } catch (e) {
      console.warn('Cloud score sync offline; relying on local cache.');
    }
  }

  function resetLocalCache() {
    if(confirm('Purge local score cache? Your cloud scores remain safe.')) {
      localStorage.clear();
      syncCloudScores();
    }
  }

  function togglePerformance(checkbox) {
    if(checkbox.checked) {
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