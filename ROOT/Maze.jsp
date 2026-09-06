<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cyber Maze Runner</title>
<style>
  :root {
    --bg-dark: #0f172a;
    --card-bg: #1e293b;
    --primary: #38bdf8;
    --accent: #22c55e;
    --danger: #ef4444;
    --text: #f8fafc;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', system-ui, sans-serif; }
  body {
    background: radial-gradient(circle at top, #1e293b, var(--bg-dark));
    color: var(--text);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1rem;
    user-select: none;
    touch-action: none;
  }
  .header { text-align: center; margin-bottom: 0.8rem; }
  h1 { color: var(--primary); font-size: 2rem; margin-bottom: 0.3rem; letter-spacing: 1px; }
  .controls-bar {
    display: flex;
    gap: 0.8rem;
    align-items: center;
    margin-bottom: 1rem;
    background: var(--card-bg);
    padding: 0.5rem 1rem;
    border-radius: 9999px;
    border: 1px solid #334155;
  }
  select, button {
    background: #0f172a;
    color: var(--text);
    border: 1px solid #475569;
    padding: 0.4rem 0.8rem;
    border-radius: 8px;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  button:hover { background: #334155; border-color: var(--primary); }
  .btn-primary { background: var(--primary); color: #000; font-weight: 600; border: none; }
  .btn-primary:hover { background: #7dd3fc; }

  .game-container {
    position: relative;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    background: #020617;
    border: 2px solid #334155;
    overflow: hidden;
  }
  canvas { display: block; }

  /* Loading Overlay */
  #loadingOverlay {
    position: absolute;
    inset: 0;
    background: rgba(15, 23, 42, 0.9);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 10;
    gap: 1rem;
    transition: opacity 0.3s ease;
  }
  .spinner {
    width: 45px;
    height: 45px;
    border: 4px solid #334155;
    border-top: 4px solid var(--primary);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }
  @keyframes spin { 100% { transform: rotate(360deg); } }

  /* Win Modal Overlay */
  #winModal {
    position: absolute;
    inset: 0;
    background: rgba(15, 23, 42, 0.88);
    display: none;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 20;
    backdrop-filter: blur(4px);
    animation: fadeIn 0.3s ease-out;
  }
  @keyframes fadeIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
  #winModal h2 { font-size: 2.2rem; color: var(--accent); margin-bottom: 0.5rem; text-shadow: 0 0 12px rgba(34, 197, 94, 0.4); }
  #winModal p { color: #94a3b8; margin-bottom: 1.5rem; }
  .modal-actions { display: flex; gap: 1rem; }

  /* Mobile D-Pad */
  .dpad {
    display: grid;
    grid-template-columns: repeat(3, 50px);
    grid-gap: 8px;
    margin-top: 1rem;
  }
  .dpad button {
    height: 50px;
    font-size: 1.2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 12px;
  }
  .dpad-up { grid-column: 2; }
  .dpad-left { grid-column: 1; grid-row: 2; }
  .dpad-down { grid-column: 2; grid-row: 2; }
  .dpad-right { grid-column: 3; grid-row: 2; }

  @media (min-width: 768px) {
    .dpad { display: none; } /* Hide on PC screens */
  }
</style>
</head>
<body>

  <div class="header">
    <h1>Cyber Maze Runner</h1>
    <div class="controls-bar">
      <label for="difficulty">Difficulty:</label>
      <select id="difficulty">
        <option value="easy">Easy (11x11)</option>
        <option value="medium" selected>Medium (21x21)</option>
        <option value="hard">Hard (31x31)</option>
      </select>
      <button onclick="startNewGame()">New Maze</button>
      <button onclick="window.location.href='index.jsp'">Exit to Hub</button>
    </div>
  </div>

  <div class="game-container">
    <div id="loadingOverlay">
      <div class="spinner"></div>
      <div>Synthesizing Maze Architecture...</div>
    </div>

    <div id="winModal">
      <h2>MAZE CLEARED!</h2>
      <p>Target node reached successfully.</p>
      <div class="modal-actions">
        <button class="btn-primary" onclick="startNewGame()">Play Again</button>
        <button onclick="window.location.href='index.jsp'">Exit Hub</button>
      </div>
    </div>

    <canvas id="mazeCanvas"></canvas>
  </div>

  <!-- Mobile Touch Controls -->
  <div class="dpad">
    <button class="dpad-up" onclick="movePlayer(0, -1)">▲</button>
    <button class="dpad-left" onclick="movePlayer(-1, 0)">◀</button>
    <button class="dpad-down" onclick="movePlayer(0, 1)">▼</button>
    <button class="dpad-right" onclick="movePlayer(1, 0)">▶</button>
  </div>

<script>
  const canvas = document.getElementById('mazeCanvas');
  const ctx = canvas.getContext('2d');
  const loadingOverlay = document.getElementById('loadingOverlay');
  const winModal = document.getElementById('winModal');
  const difficultySelect = document.getElementById('difficulty');

  let grid = [];
  let rows, cols;
  let cellSize = 20;
  let player = { x: 1, y: 1 };
  let goal = { x: 1, y: 1 };
  let isGameOver = false;

  function initGame() {
    winModal.style.display = 'none';
    loadingOverlay.style.display = 'flex';
    loadingOverlay.style.opacity = '1';
    isGameOver = true;

    const diff = difficultySelect.value;
    if (diff === 'easy') { rows = cols = 13; cellSize = 24; }
    else if (diff === 'medium') { rows = cols = 21; cellSize = 18; }
    else { rows = cols = 31; cellSize = 13; }

    canvas.width = cols * cellSize;
    canvas.height = rows * cellSize;

    // Simulate async generation delay for smooth loading animation
    setTimeout(() => {
      generateMaze();
      placeEntities();
      loadingOverlay.style.opacity = '0';
      setTimeout(() => {
        loadingOverlay.style.display = 'none';
        isGameOver = false;
        draw();
      }, 300);
    }, 450);
  }

  // Recursive Backtracker algorithm for pure, solveable maze generation
  function generateMaze() {
    grid = Array.from({ length: rows }, () => Array(cols).fill(1)); // 1 = wall, 0 = path

    function carve(x, y) {
      grid[y][x] = 0;
      const dirs = [
        [0, -2], [2, 0], [0, 2], [-2, 0]
      ].sort(() => Math.random() - 0.5);

      for (let [dx, dy] of dirs) {
        const nx = x + dx;
        const ny = y + dy;
        if (nx > 0 && nx < cols - 1 && ny > 0 && ny < rows - 1 && grid[ny][nx] === 1) {
          grid[y + dy / 2][x + dx / 2] = 0; // Break wall between
          carve(nx, ny);
        }
      }
    }
    carve(1, 1);
  }

  function placeEntities() {
    const openPaths = [];
    for (let r = 1; r < rows - 1; r++) {
      for (let c = 1; c < cols - 1; c++) {
        if (grid[r][c] === 0) openPaths.push({ x: c, y: r });
      }
    }

    // Pick random start
    const startIdx = Math.floor(Math.random() * openPaths.length);
    player = { ...openPaths[startIdx] };

    // Goal: Pick a random spot far away (Manhattan distance threshold)
    let bestGoal = openPaths[0];
    let maxDist = -1;
    for (let p of openPaths) {
      const dist = Math.abs(p.x - player.x) + Math.abs(p.y - player.y);
      if (dist > maxDist) {
        maxDist = dist;
        bestGoal = p;
      }
    }
    goal = { ...bestGoal };
  }

  function movePlayer(dx, dy) {
    if (isGameOver) return;
    const nx = player.x + dx;
    const ny = player.y + dy;

    if (nx >= 0 && nx < cols && ny >= 0 && ny < rows && grid[ny][nx] === 0) {
      player.x = nx;
      player.y = ny;
      draw();
      checkWin();
    }
  }

  function checkWin() {
    if (player.x === goal.x && player.y === goal.y) {
      isGameOver = true;
      setTimeout(() => { winModal.style.display = 'flex'; }, 100);
    }
  }

  function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Draw Walls & Paths
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        if (grid[r][c] === 1) {
          ctx.fillStyle = '#1e293b';
          ctx.fillRect(c * cellSize, r * cellSize, cellSize, cellSize);
        } else {
          ctx.fillStyle = '#020617';
          ctx.fillRect(c * cellSize, r * cellSize, cellSize, cellSize);
        }
      }
    }

    // Draw Goal (Pulsing Emerald Portal)
    ctx.fillStyle = '#22c55e';
    ctx.beginPath();
    ctx.arc((goal.x + 0.5) * cellSize, (goal.y + 0.5) * cellSize, cellSize * 0.38, 0, Math.PI * 2);
    ctx.fill();

    // Draw Player (Cyan Runner Block)
    ctx.fillStyle = '#38bdf8';
    ctx.shadowColor = '#38bdf8';
    ctx.shadowBlur = 8;
    ctx.fillRect(player.x * cellSize + 2, player.y * cellSize + 2, cellSize - 4, cellSize - 4);
    ctx.shadowBlur = 0;
  }

  window.addEventListener('keydown', (e) => {
    switch(e.key) {
      case 'ArrowUp': case 'w': case 'W': movePlayer(0, -1); e.preventDefault(); break;
      case 'ArrowDown': case 's': case 'S': movePlayer(0, 1); e.preventDefault(); break;
      case 'ArrowLeft': case 'a': case 'A': movePlayer(-1, 0); e.preventDefault(); break;
      case 'ArrowRight': case 'd': case 'D': movePlayer(1, 0); e.preventDefault(); break;
    }
  });

  difficultySelect.addEventListener('change', initGame);
  function startNewGame() { initGame(); }

  initGame();
</script>
</body>
</html>