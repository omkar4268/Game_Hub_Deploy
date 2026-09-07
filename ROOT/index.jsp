<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>CYBER HUB // ARCADE</title>
<style>
  :root {
    --bg-base: #05070e;
    --card-bg: rgba(13, 19, 36, 0.85);
    --border-glow: rgba(56, 189, 248, 0.25);
    --primary: #38bdf8;
    --accent: #22c55e;
    --neon-pink: #f43f5e;
    --neon-purple: #a855f7;
    --text-main: #f8fafc;
    --text-muted: #64748b;
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

  /* Digital Ambiance Background */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.12) 0%, transparent 40%),
      radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.12) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 30px 30px, 30px 30px;
    z-index: -1;
    pointer-events: none;
  }

  /* Desktop Sidebar */
  aside {
    width: 250px;
    background: rgba(10, 15, 29, 0.9);
    backdrop-filter: blur(16px);
    border-right: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    flex-direction: column;
    padding: 2rem 1.25rem;
    flex-shrink: 0;
    z-index: 100;
  }

  .brand {
    font-size: 1.35rem;
    font-weight: 900;
    letter-spacing: 2px;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 2.5rem;
  }
  .brand-badge {
    background: linear-gradient(135deg, var(--primary), var(--neon-purple));
    font-size: 0.65rem;
    padding: 2px 7px;
    border-radius: 4px;
    color: #000;
    font-weight: 800;
  }

  nav { display: flex; flex-direction: column; gap: 0.5rem; }
  .nav-btn {
    display: flex;
    align-items: center;
    gap: 0.85rem;
    padding: 0.8rem 1rem;
    border-radius: 10px;
    background: transparent;
    color: var(--text-muted);
    border: none;
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 600;
    transition: all 0.2s ease;
    text-align: left;
  }
  .nav-btn:hover { color: var(--text-main); background: rgba(255, 255, 255, 0.04); }
  .nav-btn.active {
    background: linear-gradient(90deg, rgba(56, 189, 248, 0.15), transparent);
    color: var(--primary);
    border-left: 3px solid var(--primary);
  }

  /* Main Workspace */
  main {
    flex: 1;
    padding: 2rem;
    overflow-y: auto;
    width: 100%;
  }

  .top-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .top-meta h2 { font-size: 1.8rem; font-weight: 800; }
  .sys-status {
    font-size: 0.8rem;
    color: var(--text-muted);
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .sys-status::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent);
    box-shadow: 0 0 8px var(--accent);
  }

  /* Views */
  .view-panel { display: none; }
  .view-panel.active { display: block; }

  /* Carousel */
  .carousel-controls {
    display: flex;
    justify-content: flex-end;
    gap: 0.5rem;
    margin-bottom: 1rem;
  }
  .scroll-btn {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    width: 36px;
    height: 36px;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .game-carousel {
    display: flex;
    gap: 1.5rem;
    overflow-x: auto;
    padding: 0.5rem 0.5rem 2rem 0.5rem;
    scroll-behavior: smooth;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
  }
  .game-carousel::-webkit-scrollbar { height: 6px; }
  .game-carousel::-webkit-scrollbar-thumb { background: var(--border-glow); border-radius: 4px; }

  /* Game Cards */
  .game-card {
    min-width: 300px;
    width: 300px;
    background: var(--card-bg);
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    overflow: hidden;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    transition: transform 0.25s, border-color 0.25s, box-shadow 0.25s;
    scroll-snap-align: start;
    flex-shrink: 0;
  }

  .game-card:hover {
    transform: translateY(-6px);
    border-color: var(--primary);
    box-shadow: 0 10px 25px -5px rgba(56, 189, 248, 0.35);
  }

  .banner-guesser { background: linear-gradient(135deg, #4338ca, #6366f1); }
  .banner-snake { background: linear-gradient(135deg, #065f46, #10b981); }
  .banner-maze { background: linear-gradient(135deg, #0284c7, #38bdf8); }

  .card-banner {
    height: 140px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3rem;
  }

  .card-body {
    padding: 1.2rem;
    display: flex;
    flex-direction: column;
    flex: 1;
  }
  .card-tag {
    font-size: 0.65rem;
    letter-spacing: 1px;
    font-weight: 700;
    text-transform: uppercase;
    color: var(--primary);
    margin-bottom: 0.3rem;
  }
  .card-title { font-size: 1.2rem; font-weight: 700; margin-bottom: 0.3rem; }
  .card-desc { font-size: 0.85rem; color: var(--text-muted); line-height: 1.4; margin-bottom: 1.2rem; }

  .card-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .card-score-preview { font-size: 0.8rem; color: var(--text-muted); }
  .card-score-preview span { color: #facc15; font-weight: 700; }
  .launch-arrow {
    width: 30px;
    height: 30px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary);
  }

  /* Score & Settings */
  .score-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 1.2rem;
  }
  .score-card, .settings-box {
    background: var(--card-bg);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 1.25rem;
  }
  .stat-row, .settings-row {
    display: flex;
    justify-content: space-between;
    padding: 0.6rem 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  }
  .stat-row span:last-child { font-weight: 700; color: #facc15; }

  /* Modal */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(2, 6, 23, 0.8);
    backdrop-filter: blur(8px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 200;
    padding: 1rem;
  }
  .modal-box {
    background: #0f172a;
    border: 1px solid var(--border-glow);
    box-shadow: 0 0 35px rgba(56, 189, 248, 0.25);
    border-radius: 16px;
    padding: 1.5rem;
    width: 100%;
    max-width: 380px;
    text-align: center;
  }
  .modal-actions { display: flex; gap: 1rem; justify-content: center; margin-top: 1.2rem; }
  .btn-modal {
    padding: 0.6rem 1.25rem;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    font-weight: 600;
  }
  .btn-launch { background: var(--primary); color: #000; }
  .btn-cancel { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }

  /* ======================================================== */
  /* MOBILE OPTIMIZATIONS (Screen width 768px and down)      */
  /* ======================================================== */
  @media (max-width: 768px) {
    body {
      flex-direction: column;
      padding-bottom: 75px; /* Room for mobile bottom nav */
    }

    /* Transform vertical sidebar into fixed bottom navigation */
    aside {
      width: 100%;
      height: 65px;
      position: fixed;
      bottom: 0;
      left: 0;
      right: 0;
      padding: 0.4rem 1rem;
      flex-direction: row;
      border-right: none;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      background: rgba(10, 15, 29, 0.95);
      align-items: center;
      justify-content: space-around;
    }

    .brand { display: none; /* Hide brand on bottom nav to save space */ }

    nav {
      flex-direction: row;
      width: 100%;
      justify-content: space-around;
      gap: 0;
    }

    .nav-btn {
      flex-direction: column;
      gap: 4px;
      padding: 0.4rem 0.8rem;
      font-size: 0.75rem;
      border-left: none !important;
      border-radius: 8px;
      text-align: center;
    }
    .nav-btn.active {
      background: rgba(56, 189, 248, 0.15);
      color: var(--primary);
    }

    main {
      padding: 1.2rem 1rem;
    }

    .top-meta h2 { font-size: 1.4rem; }
    .carousel-controls { display: none; /* Mobile users swipe naturally */ }

    .game-carousel {
      gap: 1rem;
      padding-bottom: 1rem;
    }

    /* Cards adapt comfortably to phone screens */
    .game-card {
      min-width: 82vw;
      width: 82vw;
    }
  }
</style>
</head>
<body>

  <!-- Sidebar (Desktop) / Bottom Nav Bar (Mobile) -->
  <aside>
    <div class="brand">
      GAME <span class="brand-badge">HUB</span>
    </div>
    <nav>
      <button class="nav-btn active" onclick="switchTab('library', this)">
        <span>📚</span>
        <span>Library</span>
      </button>
      <button class="nav-btn" onclick="switchTab('scores', this)">
        <span>🏆</span>
        <span>Scores</span>
      </button>
      <button class="nav-btn" onclick="switchTab('settings', this)">
        <span>⚙️</span>
        <span>Settings</span>
      </button>
    </nav>
  </aside>

  <!-- Main Content Area -->
  <main>
    <div class="top-meta">
      <h2 id="viewTitle">Game Library</h2>
      <div class="sys-status">Server Online</div>
    </div>

    <!-- VIEW 1: Games -->
    <section id="libraryView" class="view-panel active">
      <div class="carousel-controls">
        <button class="scroll-btn" onclick="scrollCarousel(-320)">‹</button>
        <button class="scroll-btn" onclick="scrollCarousel(320)">›</button>
      </div>

      <div class="game-carousel" id="carousel">
        <!-- Number Guesser -->
        <div class="game-card" onclick="openLaunchModal('Game1.jsp', 'Number Guesser', 'Guess the secret integer generated by the server session.')">
          <div class="card-banner banner-guesser">🔢</div>
          <div class="card-body">
            <div class="card-tag">Session Puzzle</div>
            <div class="card-title">Number Guesser</div>
            <div class="card-desc">Crack the secret integer generated by the server session in minimal attempts.</div>
            <div class="card-footer">
              <div class="card-score-preview">Best: <span id="preview-guess">--</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Snake -->
        <div class="game-card" onclick="openLaunchModal('Snake.jsp', 'Cyber Snake', 'Steer your cyber serpent, consume data nodes, and break your record.')">
          <div class="card-banner banner-snake">🐍</div>
          <div class="card-body">
            <div class="card-tag">Arcade Classic</div>
            <div class="card-title">Cyber Snake</div>
            <div class="card-desc">Steer your cyber serpent, consume data nodes, and set the high score.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-snake">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Maze Runner -->
        <div class="game-card" onclick="openLaunchModal('Maze.jsp', 'Cyber Maze Runner', 'Solve procedurally generated mazes under varying algorithm complexities.')">
          <div class="card-banner banner-maze">⚡</div>
          <div class="card-body">
            <div class="card-tag">Procedural Puzzle</div>
            <div class="card-title">Cyber Maze</div>
            <div class="card-desc">Navigate randomized labyrinth algorithms and locate extraction gates.</div>
            <div class="card-footer">
              <div class="card-score-preview">Cleared: <span id="preview-maze">0</span></div>
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
          <h3 style="color:var(--primary); margin-bottom:0.8rem;">🐍 Cyber Snake</h3>
          <div class="stat-row"><span>High Score</span><span id="statSnakeBest">0 pts</span></div>
          <div class="stat-row"><span>Longest Streak</span><span id="statSnakeStreak">0</span></div>
        </div>
        <div class="score-card">
          <h3 style="color:var(--primary); margin-bottom:0.8rem;">⚡ Cyber Maze</h3>
          <div class="stat-row"><span>Mazes Cleared</span><span id="statMazeClears">0</span></div>
        </div>
        <div class="score-card">
          <h3 style="color:var(--primary); margin-bottom:0.8rem;">🔢 Number Guesser</h3>
          <div class="stat-row"><span>Fewest Tries</span><span id="statGuessBest">--</span></div>
        </div>
      </div>
    </section>

    <!-- VIEW 3: Settings -->
    <section id="settingsView" class="view-panel">
      <div class="settings-box">
        <div class="settings-row">
          <span>Audio Effects</span>
          <input type="checkbox" checked>
        </div>
        <div class="settings-row">
          <span>Performance Mode</span>
          <input type="checkbox">
        </div>
        <button class="btn-modal btn-cancel" onclick="resetScores()" style="margin-top: 1rem; width:100%;">Reset High Scores</button>
      </div>
    </section>
  </main>

  <!-- Launch Modal -->
  <div class="modal-overlay" id="launchModal">
    <div class="modal-box">
      <h3 id="modalTitle">Launch Game</h3>
      <p id="modalDesc" style="color:var(--text-muted); font-size:0.9rem; margin-top:0.5rem; margin-bottom:1.5rem;">Ready to begin?</p>
      <div class="modal-actions">
        <button class="btn-modal btn-cancel" onclick="closeLaunchModal()">Cancel</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">Play Now</button>
      </div>
    </div>
  </div>

<script>
  let targetUrl = '';

  function switchTab(tab, btn) {
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.view-panel').forEach(p => p.classList.remove('active'));
    
    btn.classList.add('active');
    
    if (tab === 'library') {
      document.getElementById('libraryView').classList.add('active');
      document.getElementById('viewTitle').innerText = 'Game Library';
    } else if (tab === 'scores') {
      document.getElementById('scoresView').classList.add('active');
      document.getElementById('viewTitle').innerText = 'Leaderboard';
      loadScores();
    } else if (tab === 'settings') {
      document.getElementById('settingsView').classList.add('active');
      document.getElementById('viewTitle').innerText = 'Settings';
    }
  }

  function scrollCarousel(dist) {
    document.getElementById('carousel').scrollBy({ left: dist, behavior: 'smooth' });
  }

  function openLaunchModal(url, title, desc) {
    targetUrl = url;
    document.getElementById('modalTitle').innerText = title;
    document.getElementById('modalDesc').innerText = desc;
    document.getElementById('confirmLaunchBtn').onclick = () => window.location.href = targetUrl;
    document.getElementById('launchModal').style.display = 'flex';
  }

  function closeLaunchModal() {
    document.getElementById('launchModal').style.display = 'none';
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
    if(confirm("Clear high scores?")) {
      localStorage.removeItem('hub_snake_high');
      localStorage.removeItem('hub_maze_clears');
      localStorage.removeItem('hub_guess_best');
      loadScores();
    }
  }

  window.addEventListener('DOMContentLoaded', loadScores);
</script>
</body>
</html>
</html>