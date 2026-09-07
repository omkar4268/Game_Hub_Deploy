<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session State Management
    Integer target = (Integer) session.getAttribute("targetNumber");
    Integer attempts = (Integer) session.getAttribute("guessAttempts");
    String feedback = "";
    String statusType = "neutral"; // neutral, high, low, win

    if (request.getParameter("reset") != null || target == null) {
        target = (int)(Math.random() * 100) + 1;
        attempts = 0;
        session.setAttribute("targetNumber", target);
        session.setAttribute("guessAttempts", attempts);
    }

    String userGuessStr = request.getParameter("guess");
    if (userGuessStr != null && !userGuessStr.trim().isEmpty()) {
        try {
            int guess = Integer.parseInt(userGuessStr.trim());
            attempts++;
            session.setAttribute("guessAttempts", attempts);

            if (guess < 1 || guess > 100) {
                feedback = "OUT OF BOUNDS (1 - 100 ONLY)";
                statusType = "neutral";
            } else if (guess < target) {
                feedback = "FREQUENCY TOO LOW ▲ GO HIGHER";
                statusType = "low";
            } else if (guess > target) {
                feedback = "FREQUENCY TOO HIGH ▼ GO LOWER";
                statusType = "high";
            } else {
                feedback = "CIPHER CRACKED! ACCESS GRANTED";
                statusType = "win";
            }
        } catch (NumberFormatException e) {
            feedback = "INVALID CIPHER SYNTAX";
            statusType = "neutral";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Cyber Cipher // Number Guesser</title>
<style>
  :root {
    --bg-base: #05070e;
    --card-bg: rgba(15, 23, 42, 0.85);
    --border-glow: rgba(56, 189, 248, 0.25);
    --primary: #38bdf8;
    --accent: #22c55e;
    --danger: #f43f5e;
    --warning: #facc15;
    --text-main: #f8fafc;
    --text-muted: #64748b;
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', system-ui, sans-serif;
    -webkit-tap-highlight-color: transparent;
  }

  body {
    background: radial-gradient(circle at top, #0f172a, var(--bg-base));
    color: var(--text-main);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1rem;
    overflow-x: hidden;
  }

  /* Top Navigation */
  .top-bar {
    width: 100%;
    max-width: 420px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }
  .brand-title {
    font-size: 1.2rem;
    font-weight: 800;
    letter-spacing: 1px;
    color: var(--primary);
  }
  .btn-exit {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    padding: 0.4rem 0.9rem;
    border-radius: 8px;
    font-size: 0.85rem;
    cursor: pointer;
    text-decoration: none;
    transition: 0.2s ease;
  }
  .btn-exit:hover { background: rgba(244, 63, 94, 0.2); border-color: var(--danger); }

  /* Main Card */
  .game-panel {
    width: 100%;
    max-width: 420px;
    background: var(--card-bg);
    border: 1px solid var(--border-glow);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5), 0 0 20px rgba(56, 189, 248, 0.15);
    backdrop-filter: blur(12px);
    border-radius: 18px;
    padding: 1.6rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.2rem;
  }

  .stats-row {
    display: flex;
    justify-content: space-between;
    width: 100%;
    font-size: 0.9rem;
    color: var(--text-muted);
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    padding-bottom: 0.8rem;
  }
  .stats-row span { color: var(--text-main); font-weight: 700; }
  .stats-row .highlight { color: var(--warning); }

  /* Feedback Badge */
  .feedback-box {
    width: 100%;
    min-height: 48px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.9rem;
    font-weight: 700;
    letter-spacing: 0.8px;
    padding: 0.5rem;
    text-align: center;
  }
  .status-neutral { background: rgba(255, 255, 255, 0.05); color: var(--text-muted); }
  .status-low     { background: rgba(56, 189, 248, 0.15); color: var(--primary); border: 1px solid var(--primary); }
  .status-high    { background: rgba(244, 63, 94, 0.15); color: var(--danger); border: 1px solid var(--danger); }
  .status-win     { background: rgba(34, 197, 94, 0.2); color: var(--accent); border: 1px solid var(--accent); box-shadow: 0 0 15px rgba(34, 197, 94, 0.3); }

  /* Input Form */
  .cipher-display {
    width: 100%;
    background: #020617;
    border: 2px solid rgba(56, 189, 248, 0.3);
    border-radius: 12px;
    padding: 0.8rem;
    font-size: 1.8rem;
    font-weight: 800;
    text-align: center;
    color: var(--primary);
    letter-spacing: 4px;
    outline: none;
  }

  .action-row {
    width: 100%;
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 0.8rem;
  }
  .btn-action {
    padding: 0.8rem;
    border-radius: 10px;
    border: none;
    font-size: 0.95rem;
    font-weight: 700;
    cursor: pointer;
    transition: 0.2s;
  }
  .btn-submit { background: var(--primary); color: #000; box-shadow: 0 0 15px rgba(56, 189, 248, 0.3); }
  .btn-reset { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
  .btn-submit:active, .btn-reset:active { transform: scale(0.97); }

  /* Mobile On-Screen Numpad */
  .numpad {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 8px;
    width: 100%;
    margin-top: 0.4rem;
  }
  .num-key {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.08);
    color: var(--text-main);
    border-radius: 10px;
    padding: 0.8rem 0;
    font-size: 1.2rem;
    font-weight: 700;
    cursor: pointer;
    user-select: none;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .num-key:active {
    background: var(--primary);
    color: #000;
    box-shadow: 0 0 10px rgba(56, 189, 248, 0.4);
  }
</style>
</head>
<body>

  <!-- Top Exit & Brand Header -->
  <div class="top-bar">
    <div class="brand-title">CYBER CIPHER</div>
    <a href="index.jsp" class="btn-exit">✕ Exit to Hub</a>
  </div>

  <div class="game-panel">
    <div class="stats-row">
      <div>Attempts: <span><%= attempts %></span></div>
      <div>Range: <span>1 - 100</span></div>
      <div>Record: <span id="recordDisplay" class="highlight">--</span></div>
    </div>

    <!-- Live Feedback Display -->
    <div class="feedback-box status-<%= statusType %>">
      <%= feedback.isEmpty() ? "ENTER 2-DIGIT FREQUENCY" : feedback %>
    </div>

    <!-- Guess Form -->
    <form id="guessForm" action="Game1.jsp" method="POST" style="width: 100%; display: flex; flex-direction: column; gap: 0.8rem;">
      <input type="number" id="guessInput" name="guess" class="cipher-display" placeholder="--" min="1" max="100" autocomplete="off" autofocus>

      <div class="action-row">
        <button type="submit" class="btn-action btn-submit">EXECUTE GUESS</button>
        <a href="Game1.jsp?reset=1" class="btn-action btn-reset" style="text-align: center; text-decoration: none;">RESET</a>
      </div>
    </form>

    <!-- Mobile Touch Keypad -->
    <div class="numpad">
      <div class="num-key" onclick="appendKey('1')">1</div>
      <div class="num-key" onclick="appendKey('2')">2</div>
      <div class="num-key" onclick="appendKey('3')">3</div>
      <div class="num-key" onclick="appendKey('4')">4</div>
      <div class="num-key" onclick="appendKey('5')">5</div>
      <div class="num-key" onclick="appendKey('6')">6</div>
      <div class="num-key" onclick="appendKey('7')">7</div>
      <div class="num-key" onclick="appendKey('8')">8</div>
      <div class="num-key" onclick="appendKey('9')">9</div>
      <div class="num-key" onclick="clearKey()">CLR</div>
      <div class="num-key" onclick="appendKey('0')">0</div>
      <div class="num-key" onclick="deleteKey()">⌫</div>
    </div>
  </div>

<script>
  const input = document.getElementById('guessInput');

  function appendKey(val) {
    if (input.value.length < 3) {
      input.value += val;
    }
  }

  function clearKey() {
    input.value = '';
  }

  function deleteKey() {
    input.value = input.value.slice(0, -1);
  }

  // Record Synchronization
  const currentAttempts = <%= attempts %>;
  const isWin = "<%= statusType %>" === "win";
  let bestScore = localStorage.getItem('hub_guess_best');

  if (bestScore) {
    document.getElementById('recordDisplay').innerText = bestScore + " tries";
  }

  if (isWin && currentAttempts > 0) {
    if (!bestScore || currentAttempts < parseInt(bestScore)) {
      localStorage.setItem('hub_guess_best', currentAttempts);
      document.getElementById('recordDisplay').innerText = currentAttempts + " tries";
    }
  }
</script>
</body>
</html>