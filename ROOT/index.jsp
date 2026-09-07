<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CYBER HUB // ARCADE 2026</title>
<style>
  :root {
    --bg-base: #05070e;
    --card-bg: rgba(13, 19, 36, 0.7);
    --border-glow: rgba(56, 189, 248, 0.25);
    --primary: #38bdf8;
    --accent: #22c55e;
    --neon-pink: #f43f5e;
    --neon-purple: #a855f7;
    --text-main: #f8fafc;
    --text-muted: #64748b;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', system-ui, sans-serif; }

  body {
    background-color: var(--bg-base);
    color: var(--text-main);
    min-height: 100vh;
    display: flex;
    overflow-x: hidden;
    position: relative;
  }

  /* Digital Ambiance Animated Background */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.12) 0%, transparent 40%),
      radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.12) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 40px 40px, 40px 40px;
    z-index: -1;
    pointer-events: none;
  }

  /* Sidebar */
  aside {
    width: 260px;
    background: rgba(10, 15, 29, 0.85);
    backdrop-filter: blur(16px);
    border-right: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    flex-direction: column;
    padding: 2rem 1.25rem;
    flex-shrink: 0;
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
    transition: all 0.25s ease;
    text-align: left;
  }
  .nav-btn:hover {
    color: var(--text-main);
    background: rgba(255, 255, 255, 0.04);
  }
  .nav-btn.active {
    background: linear-gradient(90deg, rgba(56, 189, 248, 0.15), transparent);
    color: var(--primary);
    border-left: 3px solid var(--primary);
  }

  /* Main Workspace */
  main {
    flex: 1;
    padding: 2.5rem 3rem;
    overflow-y: auto;
    position: relative;
  }

  .top-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .top-meta h2 { font-size: 1.8rem; font-weight: 800; letter-spacing: 0.5px; }
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

  /* Slidable Carousel Shelf */
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
    width: 38px;
    height: 38px;
    border-radius: 50%;
    cursor: pointer;
    transition: 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .scroll-btn:hover {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.4);
  }

  .game-carousel {
    display: flex;
    gap: 1.75rem;
    overflow-x: auto;
    padding-bottom: 2rem;
    scroll-behavior: smooth;
    scrollbar-width: thin;
    scrollbar-color: var(--border-glow) transparent;
  }
  .game-carousel::-webkit-scrollbar { height: 6px; }
  .game-carousel::-webkit-scrollbar-thumb { background: var(--border-glow); border-radius: 4px; }

  /* Neon Glow Game Cards */
  .game-card {
    min-width: 320px;
    max-width: 320px;
    background: var(--card-bg);
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    overflow: hidden;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
    backdrop-filter: blur(12px);
    position: relative;
  }

  .game-card::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: 16px;
    box-shadow: inset 0 0 20px transparent;
    transition: 0.35s ease;
    pointer-events: none;
  }

  .game-card:hover {
    transform: translateY(-8px);
    border-color: var(--primary);
    box-shadow: 0 12px 30px -5px rgba(56, 189, 248, 0.35), 0 0 20px rgba(56, 189, 248, 0.2);
  }

  .banner-guesser { background: linear-gradient(135deg, #4338ca, #6366f1); }
  .banner-snake { background: linear-gradient(135deg, #065f46, #10b981); }
  .banner-maze { background: linear-gradient(135deg, #0284c7, #38bdf8); }

  .card-banner {
    height: 150px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3rem;
    position: relative;
  }
  .card-banner::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 40px;
    background: linear-gradient(to top, var(--card-bg), transparent);
  }

  .card-body {
    padding: 1.25rem 1.4rem 1.5rem;
    display: flex;
    flex-direction: column;
    flex: 1;
  }
  .card-tag {
    font-size: 0.68rem;
    letter-spacing: 1.2px;
    font-weight: 700;
    text-transform: uppercase;
    color: var(--primary);
    margin-bottom: 0.4rem;
  }
  .card-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 0.4rem; }
  .card-desc { font-size: 0.85rem; color: var(--text-muted); line-height: 1.4; margin-bottom: 1.25rem; }

  .card-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .card-score-preview {
    font-size: 0.8rem;
    color: var(--text-muted);
  }
  .card-score-preview span { color: #facc15; font-weight: 700; }
  .launch-arrow {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary);
    transition: 0.2s ease;
  }
  .game-card:hover .launch-arrow {
    background: var(--primary);
    color: #000;
  }

  /* High Scores Table */
  .score-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1.5rem;
  }
  .score-card {
    background: var(--card-bg);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 1.5rem;
    backdrop-filter: blur(10px);
  }
  .score-card h3 {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 1.1rem;
    margin-bottom: 1rem;
    color: var(--primary);
  }
  .stat-row {
    display: flex;
    justify-content: space-between;
    padding: 0.6rem 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    font-size: 0.9rem;
  }
  .stat-row span:last-child { font-weight: 700; color: #facc15; }

  /* Settings Styles */
  .settings-box {
    max-width: 500px;
    background: var(--card-bg);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 1.5rem;
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
  }
  .settings-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  /* Modal */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(2, 6, 23, 0.75);
    backdrop-filter: blur(8px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 50;
  }
  .modal-box {
    background: #0f172a;
    border: 1px solid var(--border-glow);
    box-shadow: 0 0 35px rgba(56, 189, 248, 0.25);
    border-radius: 16px;
    padding: 2rem;
    width: 90%;
    max-width: 440px;
    text-align: center;
  }
  .modal-box h3 { font-size: 1.5rem; margin-bottom: 0.5rem; }
  .modal-box p { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; }
  .modal-actions { display: flex; gap: 1rem; justify-content: center; }
  .btn-modal {
    padding: 0.6rem 1.25rem;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    font-weight: 600;
  }
  .btn-launch { background: var(--primary); color: #000; }
  .btn-cancel { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
</style>
</head>
<body>

  <!-- Left Sidebar -->
  <aside>
    <div class="brand">
      GAME <span class="brand-badge">HUB</span>
    </div>
    <nav>
      <button class="nav-btn active" onclick="switchTab('library', this)">📚 Library</button>
      <button class="nav-btn" onclick="switchTab('scores', this)">🏆 High Scores</button>
      <button class="nav-btn" onclick="switchTab('settings', this)">⚙️ Settings</button>
    </nav>
  </aside>

  <!-- Main View Area -->
  <main>
    <div class="top-meta">
      <h2 id="viewTitle">Game Library</h2>
      <div class="sys-status">Tomcat Online</div>
    </div>

    <!-- VIEW 1: Slidable Game Carousel -->
    <section id="libraryView" class="view-panel active">
      <div class="carousel-controls">
        <button class="scroll-btn" onclick="scrollCarousel(-340)">‹</button>
        <button class="scroll-btn" onclick="scrollCarousel(340)">›</button>
      </div>

      <div class="game-carousel" id="carousel">
        <!-- Number Guesser -->
        <div class="game-card" onclick="openLaunchModal('Game1.jsp', 'Number Guesser', 'Guess the server secret number with algorithmic feedback.')">
          <div class="card-banner banner-guesser">🔢</div>
          <div class="card-body">
            <div class="card-tag">Session Math</div>
            <div class="card-title">Number Guesser</div>
            <div class="card-desc">Crack the secret integer generated by the server session in minimal attempts.</div>
            <div class="card-footer">
              <div class="card-score-preview">Best: <span id="preview-guess">--</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Snake -->
        <div class="game-card" onclick="openLaunchModal('Snake.jsp', 'Cyber Snake', 'Steer your cyber serpent, consume data nodes, and climb the local board.')">
          <div class="card-banner banner-snake">🐍</div>
          <div class="card-body">
            <div class="card-tag">Arcade Classic</div>
            <div class="card-title">Cyber Snake</div>
            <div class="card-desc">Steer your neon serpent through grid coordinates and maximize buffer size.</div>
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
              <div class="card-score-preview">Fastest: <span id="preview-maze">--</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- VIEW 2: High Scores -->
    <section id="scoresView" class="view-panel">
      <div class="score-grid">
        <div class="score-card">
          <h3>🐍 Cyber Snake</h3>
          <div class="stat-row"><span>High Score</span><span id="statSnakeBest">0 pts</span></div>
          <div class="stat-row"><span>Longest Streak</span><span id="statSnakeStreak">0</span></div>
        </div>
        <div class="score-card">
          <h3>⚡ Cyber Maze</h3>
          <div class="stat-row"><span>Hard Mazes Cleared</span><span id="statMazeClears">0</span></div>
          <div class="stat-row"><span>Record Extraction</span><span id="statMazeTime">--</span></div>
        </div>
        <div class="score-card">
          <h3>🔢 Number Guesser</h3>
          <div class="stat-row"><span>Fewest Tries</span><span id="statGuessBest">--</span></div>
          <div class="stat-row"><span>Games Solved</span><span id="statGuessTotal">0</span></div>
        </div>
      </div>
    </section>

    <!-- VIEW 3: Settings -->
    <section id="settingsView" class="view-panel">
      <div class="settings-box">
        <div class="settings-row">
          <span>Audio Effects</span>
          <input type="checkbox" id="settingSound" checked>
        </div>
        <div class="settings-row">
          <span>High Performance Glows</span>
          <input type="checkbox" id="settingGlow" checked>
        </div>
        <button class="btn-modal btn-cancel" onclick="resetScores()" style="margin-top: 1rem;">Reset Local Score Records</button>
      </div>
    </section>
  </main>

  <!-- Launch Modal -->
  <div class="modal-overlay" id="launchModal">
    <div class="modal-box">
      <h3 id="modalTitle">Launch Game</h3>
      <p id="modalDesc">Ready to start session?</p>
      <div class="modal-actions">
        <button class="btn-modal btn-cancel" onclick="closeLaunchModal()">Cancel</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">Launch Game</button>
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
      document.getElementById('viewTitle').innerText = 'High Scores Leaderboard';
      loadScores();
    } else if (tab === 'settings') {
      document.getElementById('settingsView').classList.add('active');
      document.getElementById('viewTitle').innerText = 'System Settings';
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

    // Cards preview
    document.getElementById('preview-snake').innerText = snakeScore + ' pts';
    document.getElementById('preview-maze').innerText = mazeClears + ' clears';
    document.getElementById('preview-guess').innerText = guessBest;

    // Leaderboard view
    document.getElementById('statSnakeBest').innerText = snakeScore + ' pts';
    document.getElementById('statSnakeStreak').innerText = (snakeScore > 0 ? Math.floor(snakeScore/5) : 0);
    document.getElementById('statMazeClears').innerText = mazeClears;
    document.getElementById('statGuessBest').innerText = guessBest;
  }

  function resetScores() {
    if(confirm("Erase all local scoreboard tracking?")) {
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