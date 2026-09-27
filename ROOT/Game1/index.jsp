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

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="../css/ransom_horror.css">
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
        <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary">‹ RETURN TO HUB</a>
      </div>
    </div>
  </div>

  <div class="card-header">
    <div style="display:flex; align-items:center; gap:8px;">
      <h2>CIPHER GUESSER</h2>
      <span class="header-badge">v2.5</span>
    </div>
    <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-hub">‹ Hub</a>
  </div>

  <div class="cipher-icon">🔢</div>

  <div class="msg-banner <%= gameWon ? "won" : "" %>">
    <%= message %>
  </div>

  <div class="stats-bar">
    <div>Attempts<span id="displayAttempts"><%= (sess.getAttribute("attempts") != null) ? sess.getAttribute("attempts") : 0 %></span></div>
    <div>Fewest Record<span id="bestAttemptsVal">--</span></div>
  </div>

  <form method="POST" action="index.jsp">
    <% if (!gameWon) { %>
      <input type="number" id="guessInput" name="guess" min="1" max="100" placeholder="Input Integer (1 - 100)" required autofocus autocomplete="off">
      <div class="btn-action-group">
        <button type="submit" class="btn-cyber btn-cyber-primary" style="flex:1;">SUBMIT PROBE</button>
        <button type="button" class="btn-cyber btn-cyber-secondary" onclick="openRules()">RULES</button>
      </div>
    <% } else { %>
      <div class="btn-action-group">
        <a href="index.jsp?restart=true" class="btn-cyber btn-cyber-primary" style="flex:1;">PLAY AGAIN</a>
        <a href="../index.jsp" class="btn-cyber btn-cyber-secondary">RETURN TO HUB</a>
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
  window.cipherGameWon = <%= gameWon %>;
  window.cipherFinalAttempts = <%= finalAttempts %>;
</script>
<script src="js/engine.js"></script>
<script src="../js/ransom_horror.js"></script>
</body>
</html>