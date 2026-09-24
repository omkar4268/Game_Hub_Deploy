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
    --primary-glow: rgba(56, 189, 248, 0.4);
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
    padding: 1rem;
    position: relative;
    overflow: hidden;
  }
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: 
      radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.08) 0%, transparent 40%),
      radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.08) 0%, transparent 40%),
      linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 30px 30px, 30px 30px;
    z-index: -1;
    pointer-events: none;
  }

  .game-card {
    background: var(--card-bg);
    border: 1px solid rgba(56, 189, 248, 0.3);
    border-radius: 20px;
    padding: 2.2rem 1.8rem;
    width: 90vw;
    max-width: 400px;
    box-shadow: 0 20px 50px rgba(0,0,0,0.8), 0 0 30px rgba(56, 189, 248, 0.2);
    backdrop-filter: blur(12px);
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .card-header h2 {
    font-size: 1.35rem;
    color: var(--primary);
    letter-spacing: 1.5px;
    font-weight: 900;
    text-shadow: 0 0 12px var(--primary-glow);
  }
  .btn-hub {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-main);
    padding: 0.35rem 0.8rem;
    border-radius: 8px;
    font-size: 0.8rem;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s;
  }
  .btn-hub:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(56, 189, 248, 0.4);
  }

  .cipher-icon {
    font-size: 3.5rem;
    margin-bottom: 0.8rem;
    filter: drop-shadow(0 0 15px var(--primary-glow));
  }

  .msg-banner {
    background: rgba(15, 23, 42, 0.7);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 10px;
    padding: 0.8rem 1rem;
    margin-bottom: 1.5rem;
    font-size: 0.88rem;
    line-height: 1.4;
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
    background: rgba(0, 0, 0, 0.3);
    padding: 0.6rem;
    border-radius: 10px;
    margin-bottom: 1.5rem;
    font-size: 0.8rem;
  }
  .stats-bar div span {
    display: block;
    font-size: 1.05rem;
    font-weight: 800;
    color: var(--primary);
  }

  input[type="number"] {
    width: 100%;
    height: 48px;
    padding: 0 1rem;
    margin-bottom: 1rem;
    border-radius: 10px;
    border: 1px solid rgba(56, 189, 248, 0.3);
    background: rgba(15, 23, 42, 0.9);
    color: #fff;
    font-size: 18px !important;
    text-align: center;
    outline: none;
    transition: all 0.2s;
  }
  input[type="number"]:focus {
    border-color: var(--primary);
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.4);
  }

  .btn-action-group {
    display: flex;
    gap: 0.6rem;
  }
  .btn-cyber {
    flex: 1;
    padding: 0.75rem;
    border-radius: 10px;
    border: none;
    font-size: 0.9rem;
    font-weight: 800;
    cursor: pointer;
    transition: all 0.2s;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }
  .btn-cyber-primary {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 15px var(--primary-glow);
  }
  .btn-cyber-primary:hover {
    background: #7dd3fc;
    box-shadow: 0 0 25px rgba(56, 189, 248, 0.6);
  }
  .btn-cyber-secondary {
    background: rgba(255, 255, 255, 0.08);
    color: var(--text-main);
    border: 1px solid rgba(255, 255, 255, 0.12);
  }
  .btn-cyber-secondary:hover {
    background: rgba(255, 255, 255, 0.16);
  }

  /* Overlay Modal (Rules & Intel) */
  .rules-modal {
    position: absolute;
    inset: 0;
    background: rgba(3, 7, 18, 0.96);
    backdrop-filter: blur(12px);
    display: none;
    flex-direction: column;
    padding: 1.5rem;
    z-index: 30;
    text-align: left;
  }
  .rules-modal.active { display: flex; }
</style>
</head>
<body>

<div class="game-card">
  <div class="card-header">
    <h2>CIPHER GUESSER</h2>
    <a href="index.jsp" class="btn-hub">‹ Hub</a>
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
      <input type="number" name="guess" min="1" max="100" placeholder="Input Integer (1 - 100)" required autofocus autocomplete="off">
      <div class="btn-action-group">
        <button type="submit" class="btn-cyber btn-cyber-primary">SUBMIT PROBE</button>
        <button type="button" class="btn-cyber btn-cyber-secondary" onclick="openRules()">RULES</button>
      </div>
    <% } else { %>
      <div class="btn-action-group">
        <a href="Game1.jsp?restart=true" class="btn-cyber btn-cyber-primary">PLAY AGAIN</a>
        <a href="index.jsp" class="btn-cyber btn-cyber-secondary">RETURN TO HUB</a>
      </div>
    <% } %>
  </form>

  <!-- Rules Modal -->
  <div id="rulesModal" class="rules-modal">
    <h3 style="color: var(--primary); margin-bottom: 1rem;">DECRYPTION MANUAL</h3>
    <p style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 1rem;">
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

  // Telemetry Sync
  const bestAttemptsVal = document.getElementById('bestAttemptsVal');
  let savedBest = parseInt(localStorage.getItem('hub_guess_best') || '0', 10);
  if (savedBest > 0) {
    bestAttemptsVal.innerText = savedBest + ' tries';
  }

  <% if (gameWon) { %>
    const currentTries = <%= finalAttempts %>;
    if (savedBest === 0 || currentTries < savedBest) {
      localStorage.setItem('hub_guess_best', currentTries);
      bestAttemptsVal.innerText = currentTries + ' tries';
    }

    // Award score based on speed: (20 - tries) * 50
    const calcScore = Math.max(50, (20 - currentTries) * 50);
    fetch('save_score.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ game: 'number_guess', score: calcScore })
    }).catch(() => console.log('Offline score preserved.'));
  <% } %>
</script>
</body>
</html>