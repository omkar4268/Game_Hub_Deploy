const canvas = document.getElementById('gameCanvas');
  const ctx = canvas.getContext('2d');
  const startScreen = document.getElementById('startScreen');
  const gameOverScreen = document.getElementById('gameOverScreen');
  const manualModal = document.getElementById('manualModal');

  const scoreVal = document.getElementById('scoreVal');
  const highScoreVal = document.getElementById('highScoreVal');
  const nodesVal = document.getElementById('nodesVal');
  const splashBest = document.getElementById('splashBest');
  const splashNodes = document.getElementById('splashNodes');
  const finalScoreVal = document.getElementById('finalScoreVal');
  const finalNodesVal = document.getElementById('finalNodesVal');
  const dpad = document.getElementById('mobileDpad');

  const isMobile = ('ontouchstart' in window) || 
                   (navigator.maxTouchPoints > 0) || 
                   /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);
  // Keep D-pad hidden on initial startup screen
  dpad.style.display = 'none';

  // Crisp 20x20 grid on a 400x400 internal canvas
  const grid = 20; 
  const cols = 20; 
  const rows = 20;
  canvas.width = cols * grid;
  canvas.height = rows * grid;

  let snake = [];
  let dir = { x: 1, y: 0 };
  let nextDir = { x: 1, y: 0 };
  let food = { x: 0, y: 0 };
  let score = 0;
  let runNodes = 0;

  // Persistent stats
  let highScore = parseInt(localStorage.getItem('hub_snake_high') || '0', 10);
  let totalNodes = parseInt(localStorage.getItem('hub_snake_nodes') || '0', 10);
  
  highScoreVal.innerText = highScore;
  splashBest.innerText = highScore + ' pts';
  splashNodes.innerText = totalNodes;

  let isPlaying = false;
  let lastTick = 0;
  
  // Balanced 145ms tick rate
  let tickRate = 145; 

  function setSpeed(ms, btnId) {
    tickRate = ms;
    document.querySelectorAll('.speed-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(btnId).classList.add('active');
  }

  function openManual() { 
    manualModal.classList.add('active'); 
    dpad.style.display = 'none';
  }
  function closeManual() { 
    manualModal.classList.remove('active'); 
    if (isPlaying && isMobile) dpad.style.display = 'grid';
  }

  function showStartScreen() {
    gameOverScreen.style.display = 'none';
    manualModal.classList.remove('active');
    startScreen.style.display = 'flex';
    splashBest.innerText = highScore + ' pts';
    splashNodes.innerText = totalNodes;
    dpad.style.display = 'none';
  }

  function spawnFood() {
    let valid = false;
    while (!valid) {
      food = {
        x: Math.floor(Math.random() * cols),
        y: Math.floor(Math.random() * rows)
      };
      valid = !snake.some(seg => seg.x === food.x && seg.y === food.y);
    }
  }

  function startGame() {
    startScreen.style.display = 'none';
    gameOverScreen.style.display = 'none';
    manualModal.classList.remove('active');
    if (isMobile) dpad.style.display = 'grid';

    snake = [
      { x: 8, y: 10 },
      { x: 7, y: 10 },
      { x: 6, y: 10 }
    ];
    dir = { x: 1, y: 0 };
    nextDir = { x: 1, y: 0 };
    score = 0;
    runNodes = 0;
    scoreVal.innerText = score;
    nodesVal.innerText = runNodes;
    spawnFood();
    isPlaying = true;
    lastTick = performance.now();
    requestAnimationFrame(gameLoop);

    if (window.RansomHorror) {
      RansomHorror.init('snake', {
        onGameOver: () => triggerGameOver(),
        onPurgeBonus: (bonus) => {
          score += bonus;
          scoreVal.innerText = score;
        }
      });
    }
  }

  function setDirection(newX, newY) {
    if (newX !== -dir.x && newY !== -dir.y) {
      nextDir = { x: newX, y: newY };
    }
  }

  function update() {
    dir = { ...nextDir };
    const head = { x: snake[0].x + dir.x, y: snake[0].y + dir.y };

    // Wall collision checks
    if (head.x < 0 || head.x >= cols || head.y < 0 || head.y >= rows) {
      return triggerGameOver();
    }

    // Body collision checks
    for (let i = 0; i < snake.length; i++) {
      if (head.x === snake[i].x && head.y === snake[i].y) {
        return triggerGameOver();
      }
    }

    snake.unshift(head);

    // Food consumption
    if (head.x === food.x && head.y === food.y) {
      score += 10;
      runNodes++;
      totalNodes++;
      scoreVal.innerText = score;
      nodesVal.innerText = runNodes;

      localStorage.setItem('hub_snake_nodes', totalNodes);

      if (score > highScore) {
        highScore = score;
        highScoreVal.innerText = highScore;
        localStorage.setItem('hub_snake_high', highScore);
      }
      spawnFood();
    } else {
      snake.pop();
    }
  }

  function triggerGameOver() {
    isPlaying = false;
    if (window.RansomHorror) {
      if (RansomHorror.state === 'lurking') RansomHorror.evadeLurker();
      clearTimeout(RansomHorror.lurkTimer);
    }
    finalScoreVal.innerText = score + ' pts';
    finalNodesVal.innerText = runNodes;
    gameOverScreen.style.display = 'flex';
    dpad.style.display = 'none';

    if (score > 0) {
      syncScoreToCloud('snake', score);
    }
  }

  async function syncScoreToCloud(gameName, finalScore) {
    try {
      const res = await fetch('../save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ game: gameName, score: finalScore })
      });
      const data = await res.json();
      if (data.success) {
        console.log("☁ High score synced to database:", finalScore);
      }
    } catch (err) {
      console.log("Local score preserved; cloud unreachable.");
    }
  }

  function render() {
    ctx.fillStyle = '#020617';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = 'rgba(255, 255, 255, 0.04)';
    for (let x = 0; x < cols; x++) {
      for (let y = 0; y < rows; y++) {
        ctx.fillRect(x * grid + grid/2 - 0.5, y * grid + grid/2 - 0.5, 1, 1);
      }
    }

    // Draw Neon Food
    ctx.fillStyle = '#f43f5e';
    ctx.shadowColor = '#f43f5e';
    ctx.shadowBlur = 12;
    ctx.beginPath();
    ctx.arc((food.x + 0.5) * grid, (food.y + 0.5) * grid, grid * 0.38, 0, Math.PI * 2);
    ctx.fill();

    // Draw Snake Segments
    snake.forEach((seg, index) => {
      ctx.fillStyle = (index === 0) ? '#34d399' : '#10b981';
      ctx.shadowColor = '#10b981';
      ctx.shadowBlur = (index === 0) ? 12 : 5;
      ctx.fillRect(seg.x * grid + 2, seg.y * grid + 2, grid - 4, grid - 4);
    });

    ctx.shadowBlur = 0;
  }

  function gameLoop(timestamp) {
    if (!isPlaying) return;
    if (timestamp - lastTick >= tickRate) {
      update();
      lastTick = timestamp;
    }
    render();
    if (isPlaying) requestAnimationFrame(gameLoop);
  }

  window.addEventListener('keydown', (e) => {
    switch (e.key) {
      case 'ArrowUp': case 'w': case 'W': setDirection(0, -1); e.preventDefault(); break;
      case 'ArrowDown': case 's': case 'S': setDirection(0, 1); e.preventDefault(); break;
      case 'ArrowLeft': case 'a': case 'A': setDirection(-1, 0); e.preventDefault(); break;
      case 'ArrowRight': case 'd': case 'D': setDirection(1, 0); e.preventDefault(); break;
    }
  });

  // Touch D-Pad
  document.querySelectorAll('.d-btn').forEach(btn => {
    const handlePress = (e) => {
      e.preventDefault();
      const dirStr = btn.getAttribute('data-dir');
      if (dirStr === 'UP') setDirection(0, -1);
      if (dirStr === 'DOWN') setDirection(0, 1);
      if (dirStr === 'LEFT') setDirection(-1, 0);
      if (dirStr === 'RIGHT') setDirection(1, 0);
    };
    btn.addEventListener('touchstart', handlePress, { passive: false });
    btn.addEventListener('mousedown', handlePress);
  });

  // Swipe detection
  let touchStartX = 0;
  let touchStartY = 0;

  canvas.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });

  canvas.addEventListener('touchend', (e) => {
    const dx = e.changedTouches[0].screenX - touchStartX;
    const dy = e.changedTouches[0].screenY - touchStartY;
    const absX = Math.abs(dx);
    const absY = Math.abs(dy);

    if (Math.max(absX, absY) > 25) {
      if (absX > absY) {
        setDirection(dx > 0 ? 1 : -1, 0);
      } else {
        setDirection(0, dy > 0 ? 1 : -1);
      }
    }
  }, { passive: true });

  // Initial draw
  render();

  // Kinetic Camera Depth Navigation Transition Handler
  function cyberNavigate(url) {
    const overlay = document.getElementById('cyberWipeOverlay');
    document.body.style.transform = 'scale(0.975)';
    document.body.style.filter = 'blur(4px)';
    document.body.style.opacity = '0.6';
    document.body.style.transition = 'all 0.22s cubic-bezier(0.16, 1, 0.3, 1)';

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
    document.body.style.transform = '';
    document.body.style.filter = '';
    document.body.style.opacity = '';
  });