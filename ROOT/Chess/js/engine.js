/* =========================================================
   CYBER CHESS // TACTICAL STOCKFISH GRANDMASTER v3.0
   ========================================================= */

/* =========================================================
   FULLSCREEN ANIMATED 3D PERSPECTIVE TACTICAL GRID CANVAS
   ========================================================= */
class ChessTacticalGridEngine {
  constructor() {
    this.canvas = document.getElementById('chessBgCanvas');
    if (!this.canvas) return;
    this.ctx = this.canvas.getContext('2d');
    this.gridOffset = 0;
    this.particles = [];
    this.numParticles = 40;
    this.init();
  }

  init() {
    this.resize();
    window.addEventListener('resize', () => this.resize());

    this.particles = [];
    for (let i = 0; i < this.numParticles; i++) {
      this.particles.push({
        x: Math.random() * this.width,
        y: Math.random() * this.height,
        vx: (Math.random() - 0.5) * 0.3,
        vy: (Math.random() - 0.5) * 0.3,
        size: Math.random() * 2 + 0.8,
        alpha: Math.random() * 0.5 + 0.2
      });
    }

    this.animate = this.animate.bind(this);
    requestAnimationFrame(this.animate);
  }

  resize() {
    if (!this.canvas) return;
    this.dpr = Math.min(window.devicePixelRatio || 1, 2);
    this.width = window.innerWidth;
    this.height = window.innerHeight;
    this.canvas.width = this.width * this.dpr;
    this.canvas.height = this.height * this.dpr;
    this.ctx.scale(this.dpr, this.dpr);
  }

  animate() {
    if (!this.ctx) return;
    this.ctx.fillStyle = '#000000';
    this.ctx.fillRect(0, 0, this.width, this.height);

    const horizonY = this.height * 0.32;
    const vpX = this.width / 2;

    // 1. Cyber Horizon Glow
    const horizGrad = this.ctx.createLinearGradient(0, horizonY - 40, 0, horizonY + 80);
    horizGrad.addColorStop(0, 'transparent');
    horizGrad.addColorStop(0.5, 'rgba(56, 189, 248, 0.12)');
    horizGrad.addColorStop(1, 'transparent');
    this.ctx.fillStyle = horizGrad;
    this.ctx.fillRect(0, horizonY - 40, this.width, 120);

    // 2. Converging Perspective Longitudinal Grid Lines
    this.ctx.strokeStyle = 'rgba(56, 189, 248, 0.14)';
    this.ctx.lineWidth = 1;
    const linesCount = 28;
    for (let i = -linesCount; i <= linesCount; i++) {
      const bottomX = vpX + i * 55;
      this.ctx.beginPath();
      this.ctx.moveTo(vpX, horizonY);
      this.ctx.lineTo(bottomX, this.height);
      this.ctx.stroke();
    }

    // 3. Scrolling Transversal Horizontal Perspective Grid Lines
    this.gridOffset = (this.gridOffset + 0.006) % 1;
    const numHoriz = 16;
    for (let i = 0; i < numHoriz; i++) {
      const p = (i + this.gridOffset) / numHoriz;
      const y = horizonY + Math.pow(p, 2.4) * (this.height - horizonY);
      const alpha = p * 0.25;
      this.ctx.strokeStyle = `rgba(56, 189, 248, ${alpha})`;
      this.ctx.beginPath();
      this.ctx.moveTo(0, y);
      this.ctx.lineTo(this.width, y);
      this.ctx.stroke();
    }

    // 4. Floating Tactical Ambient Particles
    this.particles.forEach((pt) => {
      pt.x += pt.vx;
      pt.y += pt.vy;
      if (pt.x < 0) pt.x = this.width;
      if (pt.x > this.width) pt.x = 0;
      if (pt.y < 0) pt.y = this.height;
      if (pt.y > this.height) pt.y = 0;

      this.ctx.fillStyle = `rgba(255, 255, 255, ${pt.alpha})`;
      this.ctx.beginPath();
      this.ctx.arc(pt.x, pt.y, pt.size, 0, Math.PI * 2);
      this.ctx.fill();
    });

    requestAnimationFrame(this.animate);
  }
}

/* =========================================================
   CORE CHESS GAME ENGINE
   ========================================================= */
const $status = $('#status');
const $pgn = $('#pgn');
const $sidebar = $('#sidebar');

let board = null;
let game = new Chess();
let isAiThinking = false;

$('#menuToggle').on('click', function(e) {
  e.stopPropagation();
  $sidebar.toggleClass('open');
});
$('#boardArea').on('click', function() {
  if ($(window).width() <= 900) $sidebar.removeClass('open');
});

// Triple-Routed AI Engine (Stockfish Online -> Chess-API -> Instant Tactical Fallback)
async function makeAiMove() {
  if (game.game_over()) return;

  isAiThinking = true;
  updateStatus('<span style="color:var(--primary); font-weight:700;">AI IS CALCULATING TACTICAL RESPONSE...</span>');
  
  const rawDepth = parseInt($('#aiDepth').val(), 10) || 5;
  let moveObj = null;
  let usedFallback = false;

  // Route 1: Stockfish Online (GET)
  const apiDepth = Math.max(5, Math.min(15, rawDepth));
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 4500);
    const fenSafe = encodeURIComponent(game.fen());
    
    const res1 = await fetch(`https://stockfish.online/api/s/v2.php?fen=${fenSafe}&depth=${apiDepth}`, {
      signal: controller.signal
    });
    clearTimeout(timeout);
    
    if (res1.ok) {
      const data1 = await res1.json();
      if (data1 && data1.success && data1.bestmove) {
        const parts = data1.bestmove.split(' ');
        const mStr = parts[1];
        if (mStr && mStr.length >= 4) {
          moveObj = {
            from: mStr.substring(0, 2),
            to: mStr.substring(2, 4),
            promotion: mStr.length > 4 ? mStr.substring(4, 5) : 'q'
          };
        }
      }
    }
  } catch (e) {
    console.warn("Primary Stockfish API unreachable. Routing to secondary...");
  }

  // Route 2: Chess-API.com (POST)
  if (!moveObj) {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 3000);
      
      let fenClean = game.fen();
      const fenParts = fenClean.split(' ');
      if (fenParts.length >= 4 && fenParts[3] !== '-') {
        fenClean = fenParts.slice(0, 3).join(' ') + ' - ' + fenParts.slice(4).join(' ');
      }

      const res2 = await fetch('https://chess-api.com/v1', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fen: fenClean, depth: Math.min(rawDepth, 8) }),
        signal: controller.signal
      });
      clearTimeout(timeout);
      
      if (res2.ok) {
        const data2 = await res2.json();
        if (data2 && data2.from && data2.to) {
          moveObj = { from: data2.from, to: data2.to, promotion: data2.promotion || 'q' };
        }
      }
    } catch (e) {
      console.warn("Secondary API failed. Routing to local tactical fallback...");
    }
  }

  // Route 3: Embedded Tactical Heuristic Fallback
  if (!moveObj) {
    const moves = game.moves({ verbose: true });
    if (moves && moves.length > 0) {
      usedFallback = true;
      let bestMove = moves[0];
      let bestScore = -99999;
      const pieceVals = { 'p': 100, 'n': 320, 'b': 330, 'r': 500, 'q': 900, 'k': 20000 };
      const centerSquares = ['d4', 'd5', 'e4', 'e5', 'c4', 'c5', 'f4', 'f5'];

      for (let m of moves) {
        let score = 0;
        game.move(m);
        if (game.in_checkmate()) {
          score += 100000;
        } else if (game.in_check()) {
          score += 80;
        }
        game.undo();

        if (m.captured) {
          const victimVal = pieceVals[m.captured] || 100;
          const attackerVal = pieceVals[m.piece] || 100;
          score += (victimVal * 10) - (attackerVal);
        }

        if (m.promotion) score += 850;
        if (centerSquares.includes(m.to)) score += 35;
        score += Math.floor(Math.random() * 20);

        if (score > bestScore) {
          bestScore = score;
          bestMove = m;
        }
      }

      if (rawDepth === 2 && moves.length > 1 && Math.random() < 0.3) {
        bestMove = moves[Math.floor(Math.random() * moves.length)];
      }

      moveObj = { from: bestMove.from, to: bestMove.to, promotion: bestMove.promotion || 'q' };
    }
  }

  // Execute verified move
  if (moveObj) {
    game.move(moveObj);
    board.position(game.fen());
  }

  isAiThinking = false;
  
  if (usedFallback) {
    updateStatus('<span style="color:var(--primary)">AI played tactical local heuristic move.</span>');
    setTimeout(() => updateStatus(), 2500);
  } else {
    updateStatus();
  }
}

function onDragStart(source, piece, position, orientation) {
  if (game.game_over() || isAiThinking) return false;
  if ((orientation === 'white' && piece.search(/^b/) !== -1) ||
      (orientation === 'black' && piece.search(/^w/) !== -1)) {
    return false;
  }
}

function onDrop(source, target) {
  const move = game.move({
    from: source,
    to: target,
    promotion: 'q' 
  });

  if (move === null) return 'snapback';
  updateStatus();

  try {
    if (window.RansomHorror && typeof window.RansomHorror.notifyChessMove === 'function') {
      window.RansomHorror.notifyChessMove(move);
    }
  } catch (err) {
    console.warn('RansomHorror notification bypassed:', err);
  }

  if (!game.game_over()) {
    window.setTimeout(makeAiMove, 250);
  }
}

function onSnapEnd() {
  board.position(game.fen());
}

function updateStatus(customOverride = null) {
  if (customOverride) {
    $status.html(customOverride);
    return;
  }

  let statusHTML = '';
  let moveColor = (game.turn() === 'w') ? 'White' : 'Black';

  if (game.in_checkmate()) {
    statusHTML = `<span style="color:var(--danger)">Game Over: ${moveColor} is in checkmate.</span>`;
    
    if (!game._recorded) {
      game._recorded = true;
      let wins = parseInt(localStorage.getItem('hub_chess_wins') || '0', 10);
      let losses = parseInt(localStorage.getItem('hub_chess_losses') || '0', 10);
      let rating = parseInt(localStorage.getItem('hub_chess_rating') || '1200', 10);

      const playerWon = (moveColor === 'Black' && board.orientation() === 'white') ||
                        (moveColor === 'White' && board.orientation() === 'black');

      if (playerWon) {
        wins++;
        rating += 30;
        localStorage.setItem('hub_chess_wins', wins);
        localStorage.setItem('hub_chess_rating', rating);
        statusHTML += ` <br><span style="color:var(--accent); font-size: 0.95rem;">Victory! Rating: ${rating} (+30)</span>`;
      } else {
        losses++;
        rating = Math.max(800, rating - 15);
        localStorage.setItem('hub_chess_losses', losses);
        localStorage.setItem('hub_chess_rating', rating);
        statusHTML += ` <br><span style="color:var(--danger); font-size: 0.95rem;">Defeat. Rating: ${rating} (-15)</span>`;
      }

      fetch('../save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ game: 'chess', score: rating })
      }).catch(() => console.log('Offline chess score saved.'));
    }
  } else if (game.in_draw()) {
    statusHTML = `<span style="color:var(--text-muted)">Game Over: Drawn position.</span>`;
  } else {
    statusHTML = `${moveColor} to move`;
    if (game.in_check()) statusHTML += ` <span style="color:var(--danger)">(Check)</span>`;
  }

  if (!isAiThinking) $status.html(statusHTML);
  
  let history = game.pgn({ max_width: 5, newline_char: '<br>' });
  $pgn.html(history || "Game moves will stream here...");
  
  const pgnEl = document.getElementById("pgn");
  if (pgnEl) pgnEl.scrollTop = pgnEl.scrollHeight;
}

const config = {
  draggable: true,
  position: 'start',
  onDragStart: onDragStart,
  onDrop: onDrop,
  onSnapEnd: onSnapEnd,
  pieceTheme: 'https://chessboardjs.com/img/chesspieces/wikipedia/{piece}.png'
};

board = Chessboard('myBoard', config);

$(window).resize(() => {
  if (board) board.resize();
});

$('#startBtn').on('click', function() {
  game.reset();
  board.start();
  isAiThinking = false;
  if ($(window).width() <= 900) $sidebar.removeClass('open');
  updateStatus();
  setTimeout(() => { if (board) board.resize(); }, 60);
  
  if (board.orientation() === 'black') {
    window.setTimeout(makeAiMove, 300);
  }
});

$('#flipBtn').on('click', () => {
  board.flip();
  setTimeout(() => { if (board) board.resize(); }, 60);
});

$('#exitBtn').on('click', () => cyberNavigate('../index.jsp'));

/* =========================================================
   STARTUP & MODALS
   ========================================================= */
function loadChessTelemetry() {
  const rating = localStorage.getItem('hub_chess_rating') || '1200';
  const wins = parseInt(localStorage.getItem('hub_chess_wins') || '0', 10);
  const losses = parseInt(localStorage.getItem('hub_chess_losses') || '0', 10);
  const total = wins + losses;
  const ratio = total > 0 ? Math.round((wins / total) * 100) : 0;

  const rEl = document.getElementById('splashChessRating');
  const wEl = document.getElementById('splashChessRatio');
  if (rEl) rEl.innerText = rating;
  if (wEl) wEl.innerText = ratio + '% (' + wins + 'W/' + losses + 'L)';
}

function startChessMatch() {
  const modal = document.getElementById('chessStartupModal');
  if (modal) {
    if (window.Motion) {
      window.Motion.animate(modal, { opacity: [1, 0], scale: [1, 0.94] }, { duration: 0.25 }).then(() => {
        modal.style.display = 'none';
      });
    } else {
      modal.style.display = 'none';
    }
  }

  closeChessIntel();
  game.reset();
  board.start();
  isAiThinking = false;
  updateStatus();
  setTimeout(() => { if (board) board.resize(); }, 60);

  try {
    if (window.RansomHorror && typeof window.RansomHorror.init === 'function') {
      RansomHorror.init('chess', {
        onGameOver: () => triggerChessLoss()
      });
    }
  } catch (err) {
    console.warn('RansomHorror initialization bypassed:', err);
  }
}

function triggerChessLoss() {
  isAiThinking = false;
  updateStatus('<span style="color:var(--danger); font-weight:800;">DEFEAT: RANS0M CORRUPTED MATCH</span>');
}

function openChessIntel() {
  const modal = document.getElementById('chessIntelModal');
  if (!modal) return;
  modal.classList.add('active');
  const box = modal.querySelector('.intel-box');
  if (box && window.Motion) {
    window.Motion.animate(box, { opacity: [0, 1], scale: [0.92, 1], y: [20, 0] }, { duration: 0.3, ease: [0.16, 1, 0.3, 1] });
  }
}

function closeChessIntel() {
  const modal = document.getElementById('chessIntelModal');
  if (!modal) return;
  const box = modal.querySelector('.intel-box');
  if (box && window.Motion) {
    window.Motion.animate(box, { opacity: [1, 0], scale: [1, 0.94], y: [0, 15] }, { duration: 0.2 }).then(() => {
      modal.classList.remove('active');
    });
  } else {
    modal.classList.remove('active');
  }
}

window.addEventListener('DOMContentLoaded', () => {
  new ChessTacticalGridEngine();
  loadChessTelemetry();
  updateStatus();

  const startModal = document.getElementById('chessStartupModal');
  if (startModal && window.Motion) {
    window.Motion.animate(startModal, { opacity: [0, 1], scale: [0.96, 1] }, { duration: 0.35, ease: [0.16, 1, 0.3, 1] });
  }
});

/* =========================================================
   NAVIGATION & WIPE TRANSITION
   ========================================================= */
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