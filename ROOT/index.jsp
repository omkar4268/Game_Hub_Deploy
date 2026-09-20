<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

  /* Animated Digital Ambiance Background */
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

  /* Desktop Sidebar */
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

  /* Main Workspace */
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

  /* Views */
  .view-panel { display: none; opacity: 0; transition: opacity 0.4s ease; }
  .view-panel.active { display: block; opacity: 1; }

  /* Carousel */
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

  /* Game Cards with Entrance Animation */
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

  /* Sweeping shine effect on hover */
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
  
  .card-banner::before {
    content: '';
    position: absolute;
    inset: 0;
    background: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0IiBoZWlnaHQ9IjQiPgo8cmVjdCB3aWR0aD0iNCIgaGVpZ2h0PSI0IiBmaWxsPSJub25lIiAvPgo8cmVjdCB3aWR0aD0iMSIgaGVpZ2h0PSIxIiBmaWxsPSJyZ2JhKDI1NSwyNTUsMjU1LDAuMSkiIC8+Cjwvc3ZnPg==');
    opacity: 0.5;
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

  /* Score & Settings Grid */
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

  /* Custom Toggle Switch for Settings */
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

  /* Modal Overhaul */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(3, 5, 10, 0.85);
    backdrop-filter: blur(12px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 200;
    padding: 1rem;
    opacity: 0;
    transition: opacity 0.3s ease;
  }
  .modal-overlay.active { opacity: 1; }
  
  .modal-box {
    background: #0f172a;
    border: 1px solid rgba(56, 189, 248, 0.4);
    box-shadow: 0 20px 50px rgba(0,0,0,0.8), 0 0 30px rgba(56, 189, 248, 0.15);
    border-radius: 20px;
    padding: 2.5rem;
    width: 100%;
    max-width: 420px;
    text-align: center;
    transform: scale(0.9);
    transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  }
  .modal-overlay.active .modal-box { transform: scale(1); }
  
  .modal-actions { display: flex; gap: 1rem; justify-content: center; margin-top: 2rem; }
  .btn-modal {
    padding: 0.8rem 1.5rem;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    font-weight: 700;
    font-size: 1rem;
    transition: all 0.2s;
    flex: 1;
  }
  .btn-launch { 
    background: var(--primary); 
    color: #000; 
    box-shadow: 0 0 15px rgba(var(--primary-rgb), 0.4);
  }
  .btn-launch:hover { background: #0ea5e9; box-shadow: 0 0 25px rgba(var(--primary-rgb), 0.6); transform: translateY(-2px); }
  .btn-cancel { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
  .btn-cancel:hover { background: rgba(255, 255, 255, 0.15); }

  /* Mobile Optimizations */
  @media (max-width: 768px) {
    body { flex-direction: column; padding-bottom: 80px; }

    aside {
      width: 100%; height: 75px; position: fixed; bottom: 0; left: 0; right: 0;
      padding: 0.5rem; flex-direction: row; border-right: none;
      border-top: 1px solid rgba(255, 255, 255, 0.08); background: rgba(8, 12, 23, 0.95);
      align-items: center; justify-content: space-around; z-index: 999;
    }

    .brand { display: none; }
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
  }
</style>
</head>
<body>

  <!-- Sidebar / Mobile Nav -->
  <aside>
    <div class="brand">
      CYBER <span class="brand-badge">HUB</span>
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

  <!-- Main Content -->
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
        
        <!-- Bomb Defusal [NEW] -->
        <div class="game-card" style="animation-delay: 0.1s;" onclick="openLaunchModal('Bomb_Defuse/index.jsp', 'Defusal Protocol', 'High-stakes 3-minute bomb defusal simulation. Memorize the manual, disarm the modules, and do not trigger the failsafe.')">
          <div class="card-banner banner-bomb">☢️</div>
          <div class="card-body">
            <div class="card-tag">Crisis Sim</div>
            <div class="card-title">Defusal Protocol</div>
            <div class="card-desc">Execute override sequences on complex security modules under a strict 3-minute timer. Don't blow it.</div>
            <div class="card-footer">
              <div class="card-score-preview">Status: <span style="color:var(--danger)">Lethal</span></div>
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
              <div class="card-score-preview">Engine: <span>Stockfish 16</span></div>
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

    <!-- VIEW 2: Scores -->
    <section id="scoresView" class="view-panel">
      <div class="score-grid">
        <div class="score-card">
          <h3 style="color:#10b981; margin-bottom:1.2rem; font-size:1.4rem;">🐍 Cyber Snake</h3>
          <div class="stat-row"><span style="color:var(--text-muted)">High Score</span><span id="statSnakeBest">0 pts</span></div>
          <div class="stat-row"><span style="color:var(--text-muted)">Longest Streak</span><span id="statSnakeStreak">0</span></div>
        </div>
        <div class="score-card">
          <h3 style="color:#38bdf8; margin-bottom:1.2rem; font-size:1.4rem;">⚡ Cyber Maze</h3>
          <div class="stat-row"><span style="color:var(--text-muted)">Mazes Cleared</span><span id="statMazeClears">0</span></div>
        </div>
        <div class="score-card">
          <h3 style="color:#6366f1; margin-bottom:1.2rem; font-size:1.4rem;">🔢 Number Guesser</h3>
          <div class="stat-row"><span style="color:var(--text-muted)">Fewest Tries</span><span id="statGuessBest">--</span></div>
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
        <button class="btn-modal btn-cancel" onclick="closeLaunchModal()">Abort</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">Initialize</button>
      </div>
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
        loadScores();
      } else if (tab === 'settings') {
        document.getElementById('settingsView').classList.add('active');
        document.getElementById('viewTitle').innerText = 'Terminal Config';
      }
    }, 50); // slight delay for animation smoothness
  }

  function scrollCarousel(dist) {
    document.getElementById('carousel').scrollBy({ left: dist, behavior: 'smooth' });
  }

  function openLaunchModal(url, title, desc) {
    targetUrl = url;[cite: 2]
    document.getElementById('modalTitle').innerText = title;
    document.getElementById('modalDesc').innerText = desc;
    document.getElementById('confirmLaunchBtn').onclick = () => window.location.href = targetUrl;
    
    const modal = document.getElementById('launchModal');
    modal.style.display = 'flex';
    // Trigger reflow for animation
    void modal.offsetWidth;
    modal.classList.add('active');
  }

  function closeLaunchModal() {
    const modal = document.getElementById('launchModal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
  }

  function togglePerformance(checkbox) {
    if(checkbox.checked) {
      document.body.style.setProperty('animation', 'none', 'important');
    } else {
      document.body.style.removeProperty('animation');
    }
  }

  function loadScores() {
    const snakeScore = localStorage.getItem('hub_snake_high') || '0';
    const mazeClears = localStorage.getItem('hub_maze_clears') || '0';
    const guessBest = localStorage.getItem('hub_guess_best') || '--';

    document.getElementById('preview-snake').innerText = snakeScore + ' pts';
    document.getElementById('preview-maze').innerText = mazeClears;
    document.getElementById('preview-guess').innerText = guessBest;

    document.getElementById('statSnakeBest').innerText = snakeScore + ' pts';
    document.getElementById('statSnakeStreak').innerText = (snakeScore > 0 ? Math.floor(snakeScore/10) : 0);
    document.getElementById('statMazeClears').innerText = mazeClears;
    document.getElementById('statGuessBest').innerText = guessBest;
  }

  function resetScores() {
    if(confirm("WARNING: This will permanently purge all local high scores. Proceed?")) {
      localStorage.removeItem('hub_snake_high');
      localStorage.removeItem('hub_maze_clears');
      localStorage.removeItem('hub_guess_best');
      loadScores();
    }
  }

  // Close modal when clicking outside
  document.getElementById('launchModal').addEventListener('click', function(e) {
    if (e.target === this) closeLaunchModal();
  });

  window.addEventListener('DOMContentLoaded', loadScores);
</script>
</body>
</html>