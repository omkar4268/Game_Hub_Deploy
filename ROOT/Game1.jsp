<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Random" %>
<%
    HttpSession sess = request.getSession();
    String message = "System encrypted a secret integer between 1 and 100.";
    String restart = request.getParameter("restart");
    boolean gameWon = false;
    int finalAttempts = 0;

    if (restart != null || sess.getAttribute("target") == null) {
        int target = new Random().nextInt(100) + 1;
        sess.setAttribute("target", target);
        sess.setAttribute("attempts", 0);
        if (restart != null) {
            message = "New encryption key generated. Guess between 1 and 100.";
        }
    }

    String guessParam = request.getParameter("guess");
    if (guessParam != null && !guessParam.trim().isEmpty()) {
        try {
            int guess = Integer.parseInt(guessParam.trim());
            Object targetObj = sess.getAttribute("target");
            Object attemptsObj = sess.getAttribute("attempts");
            int target = (targetObj != null) ? (Integer) targetObj : 50;
            int attempts = (attemptsObj != null) ? (Integer) attemptsObj + 1 : 1;
            sess.setAttribute("attempts", attempts);

            if (guess == target) {
                gameWon = true;
                finalAttempts = attempts;
                message = "CIPHER CRACKED! Correct key verified in " + attempts + " attempt" + (attempts == 1 ? "" : "s") + "!";
                sess.removeAttribute("target");
            } else if (guess < target) {
                message = "CIPHER MISMATCH: Key is HIGHER than " + guess + " (Probe #" + attempts + ")";
            } else {
                message = "CIPHER MISMATCH: Key is LOWER than " + guess + " (Probe #" + attempts + ")";
            }
        } catch (NumberFormatException e) {
            message = "ERROR: Input must be a valid integer between 1 and 100.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cipher Guesser // Tactical Decryption</title>
<style>
  :root {
    --bg-base: #030712;
    --card-bg: rgba(15, 23, 42, 0.88);
    --primary: #38bdf8;
    --primary-glow: rgba(56, 189, 248, 0.45);
    --accent: #22c55e;
    --accent-glow: rgba(34, 197, 94, 0.4);
    --danger: #f43f5e;
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
    background: radial-gradient(circle at top, #0f172a, var(--bg-base));
    color: var(--text-main);
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
    position: relative;
    overflow-x: hidden;
  }
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.09) 0%, transparent 40%),
      radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.09) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 32px 32px, 32px 32px;
    z-index: -1;
    pointer-events: none;
  }

  .game-card {
    background: var(--card-bg);
    border: 1px solid rgba(56, 189, 248, 0.35);
    border-radius: 24px;
    padding: 2.8rem 2.4rem;
    width: 100%;
    max-width: 520px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.85), 0 0 35px rgba(56, 189, 248, 0.25);
    backdrop-filter: blur(16px);
    text-align: center;
    position: relative;
    overflow: hidden;
    box-sizing: border-box;
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .card-header h2 {
    font-size: 1.45rem;
    color: var(--primary);
    letter-spacing: 1.5px;
    font-weight: 900;
    text-shadow: 0 0 15px var(--primary-glow);
  }
  .header-badge {
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.4);
    color: var(--primary);
    font-size: 0.72rem;
    padding: 3px 8px;
    border-radius: 6px;
    font-weight: 800;
    letter-spacing: 0.8px;
  }

  .btn-hub {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    padding: 0.45rem 1rem;
    border-radius: 10px;
    font-size: 0.85rem;
    font-weight: 700;
    text-decoration: none;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }
  .btn-hub:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(56, 189, 248, 0.4);
  }

  .cipher-icon {
    font-size: 3.6rem;
    margin-bottom: 0.8rem;
    filter: drop-shadow(0 0 18px var(--primary-glow));
    animation: bounce 2.2s infinite ease-in-out;
  }
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }

  .msg-banner {
    background: rgba(15, 23, 42, 0.7);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 12px;
    padding: 0.9rem 1.2rem;
    margin-bottom: 1.5rem;
    font-size: 0.92rem;
    line-height: 1.5;
    color: #e2e8f0;
    min-height: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .msg-banner.won {
    background: rgba(34, 197, 94, 0.15);
    border-color: rgba(34, 197, 94, 0.5);
    color: #86efac;
    font-weight: 700;
    box-shadow: 0 0 15px rgba(34, 197, 94, 0.25);
  }

  .stats-bar {
    display: flex;
    justify-content: space-around;
    background: rgba(0, 0, 0, 0.35);
    padding: 0.75rem 1rem;
    border-radius: 14px;
    margin-bottom: 1.5rem;
    font-size: 0.85rem;
    border: 1px solid rgba(255, 255, 255, 0.06);
  }
  .stats-bar div span {
    display: block;
    font-size: 1.15rem;
    font-weight: 800;
    color: var(--primary);
    margin-top: 2px;
  }

  input[type="number"] {
    width: 100%;
    height: 52px;
    padding: 0 1.2rem;
    margin-bottom: 1.2rem;
    border-radius: 12px;
    border: 1px solid rgba(56, 189, 248, 0.3);
    background: rgba(15, 23, 42, 0.9);
    color: #fff;
    font-size: 20px !important;
    text-align: center;
    outline: none;
    transition: all 0.2s;
    box-sizing: border-box;
  }
  input[type="number"]:focus {
    border-color: var(--primary);
    box-shadow: 0 0 18px rgba(56, 189, 248, 0.4);
  }

  .btn-action-group {
    display: flex;
    gap: 0.8rem;
  }
  .btn-cyber {
    min-height: 48px;
    padding: 0.75rem 1.4rem;
    border-radius: 12px;
    border: none;
    font-size: 0.92rem;
    font-weight: 800;
    cursor: pointer;
    transition: all 0.2s;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    flex: 1;
    letter-spacing: 1px;
  }
  .btn-cyber-primary {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 18px var(--primary-glow);
  }
  .btn-cyber-primary:hover {
    background: #7dd3fc;
    box-shadow: 0 0 28px rgba(56, 189, 248, 0.6);
    transform: translateY(-2px);
  }
  .btn-cyber-secondary {
    background: rgba(255, 255, 255, 0.08);
    color: var(--text-main);
    border: 1px solid rgba(255, 255, 255, 0.12);
  }
  .btn-cyber-secondary:hover {
    background: rgba(255, 255, 255, 0.16);
    transform: translateY(-1px);
  }

  /* Standardized Pre-Game Startup Overlay */
  .startup-overlay {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.96);
    backdrop-filter: blur(14px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 2.2rem 2rem;
    z-index: 25;
    text-align: center;
    box-sizing: border-box;
  }
  .startup-overlay.dismissed { display: none; }

  .overlay-icon {
    font-size: 3.4rem;
    margin-bottom: 0.4rem;
    filter: drop-shadow(0 0 18px var(--primary-glow));
    animation: bounce 2.2s infinite ease-in-out;
  }

  .overlay-title {
    font-size: 1.6rem;
    font-weight: 900;
    letter-spacing: 2px;
    color: var(--primary);
    text-shadow: 0 0 18px var(--primary-glow);
    margin-bottom: 0.4rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    flex-wrap: wrap;
  }

  .overlay-sub {
    font-size: 0.88rem;
    color: var(--text-muted);
    max-width: 380px;
    line-height: 1.6;
    margin-bottom: 1.4rem;
  }

  .overlay-stats {
    display: flex;
    gap: 2rem;
    background: rgba(15, 23, 42, 0.85);
    border: 1px solid rgba(255, 255, 255, 0.1);
    padding: 0.75rem 2rem;
    border-radius: 14px;
    margin-bottom: 1.6rem;
    font-size: 0.8rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.4);
  }
  .overlay-stats div span {
    display: block;
    font-weight: 800;
    font-size: 1.15rem;
    color: var(--accent);
    margin-top: 2px;
  }

  .menu-actions {
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
    width: 100%;
    max-width: 360px;
  }

  .menu-actions-row {
    display: flex;
    gap: 0.8rem;
    width: 100%;
  }

  /* Rules Modal */
  .rules-modal {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.97);
    backdrop-filter: blur(16px);
    display: none;
    flex-direction: column;
    padding: 2rem;
    z-index: 35;
    text-align: left;
    box-sizing: border-box;
    overflow-y: auto;
  }
  .rules-modal.active { display: flex; }

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

  @media (max-width: 600px) {
    .game-card { padding: 1.5rem 1.1rem; max-width: 95vw; }
    .overlay-screen, .startup-overlay { padding: 1.2rem 1rem; }
    .overlay-icon { font-size: 2.2rem; margin-bottom: 2px; }
    .overlay-title { font-size: 1.3rem; margin-bottom: 2px; }
    .overlay-sub { font-size: 0.8rem; line-height: 1.4; margin-bottom: 0.8rem; }
    .overlay-stats { gap: 1rem; padding: 0.4rem 1rem; margin-bottom: 0.8rem; }
    .menu-actions { gap: 0.55rem; width: 100%; max-width: 320px; }
    .menu-actions-row { display: flex; flex-direction: row; gap: 0.55rem; width: 100%; }
    .btn-cyber { min-height: 44px; padding: 0.55rem 0.75rem; font-size: 0.82rem; }
  }
</style>
</head>
<body>
<!-- Universal Cyber-Scanner Wipe Transition -->
<div id="cyberWipeOverlay" class="cyber-wipe-overlay">
  <div class="cyber-wipe-beam"></div>
</div>

<div class="game-card">
  <!-- Standardized Pre-Game Startup Screen -->
  <div id="guesserStartup" class="startup-overlay <%= (guessParam != null || restart != null) ? "dismissed" : "" %>">
    <div class="overlay-icon">🔢</div>
    <h2 class="overlay-title">
      CIPHER GUESSER
      <span class="header-badge">CRYPTO v2.5</span>
    </h2>
    <p class="overlay-sub">Intercept and decrypt server-side randomized encryption keys between 1 and 100 in minimal probe iterations.</p>
    
    <div class="overlay-stats">
      <div>Fewest Tries<span id="splashGuessBest">--</span></div>
      <div>Security Level<span style="color:var(--primary)">1 - 100</span></div>
    </div>

    <div class="menu-actions">
      <button class="btn-cyber btn-cyber-primary" onclick="dismissGuesserStartup()">▶ INITIATE RUN</button>
      <div class="menu-actions-row">
        <button class="btn-cyber btn-cyber-secondary" onclick="openRules()">⚙ PROTOCOL & CONTROLS</button>
        <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
      </div>
    </div>
  </div>

  <div class="card-header">
    <div style="display:flex; align-items:center; gap:8px;">
      <h2>CIPHER GUESSER</h2>
      <span class="header-badge">v2.5</span>
    </div>
    <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-hub">‹ Hub</a>
  </div>

  <div class="cipher-icon">🔢</div>

  <div class="msg-banner <%= gameWon ? "won" : "" %>">
    <%= message %>
  </div>

  <div class="stats-bar">
    <div>Attempts<span id="displayAttempts"><%= (sess.getAttribute("attempts") != null) ? sess.getAttribute("attempts") : 0 %></span></div>
    <div>Fewest Record<span id="bestAttemptsVal">--</span></div>
  </div>

  <form method="POST" action="Game1.jsp">
    <% if (!gameWon) { %>
      <input type="number" id="guessInput" name="guess" min="1" max="100" placeholder="Input Integer (1 - 100)" required autofocus autocomplete="off">
      <div class="btn-action-group">
        <button type="submit" class="btn-cyber btn-cyber-primary" style="flex:1;">SUBMIT PROBE</button>
        <button type="button" class="btn-cyber btn-cyber-secondary" onclick="openRules()">RULES</button>
      </div>
    <% } else { %>
      <div class="btn-action-group">
        <a href="Game1.jsp?restart=true" class="btn-cyber btn-cyber-primary" style="flex:1;">PLAY AGAIN</a>
        <a href="index.jsp" class="btn-cyber btn-cyber-secondary">RETURN TO HUB</a>
      </div>
    <% } %>
  </form>

  <!-- Rules Modal -->
  <div id="rulesModal" class="rules-modal">
    <h3 style="color: var(--primary); margin-bottom: 1rem; font-size:1.25rem;">DECRYPTION MANUAL</h3>
    <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.6; margin-bottom: 1.2rem;">
      1. The server generates a random encrypted key from 1 to 100.<br><br>
      2. Submit probe integers. The system will report whether the target cipher is higher or lower.<br><br>
      3. Crack the key in the fewest possible attempts. Your best record is preserved in the central Cyber Hub records!
    </p>
    <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeRules()">RETURN TO CIPHER</button>
  </div>
</div>

<script>
  function openRules() { document.getElementById('rulesModal').classList.add('active'); }
  function closeRules() { document.getElementById('rulesModal').classList.remove('active'); }

  function dismissGuesserStartup() {
    document.getElementById('guesserStartup').classList.add('dismissed');
    const input = document.getElementById('guessInput');
    if (input) input.focus();
  }

  // Telemetry Sync
  const bestAttemptsVal = document.getElementById('bestAttemptsVal');
  const splashGuessBest = document.getElementById('splashGuessBest');
  let savedBest = parseInt(localStorage.getItem('hub_guess_best') || '0', 10);
  if (savedBest > 0) {
    bestAttemptsVal.innerText = savedBest + ' tries';
    if (splashGuessBest) splashGuessBest.innerText = savedBest + ' tries';
  }

  <% if (gameWon) { %>
    const currentTries = <%= finalAttempts %>;
    if (savedBest === 0 || currentTries < savedBest) {
      localStorage.setItem('hub_guess_best', currentTries);
      bestAttemptsVal.innerText = currentTries + ' tries';
    }

    const calcScore = Math.max(50, (20 - currentTries) * 50);
    fetch('save_score.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ game: 'number_guess', score: calcScore })
    }).catch(() => console.log('Offline score preserved.'));
  <% } %>

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
</script>
</body>
</html>