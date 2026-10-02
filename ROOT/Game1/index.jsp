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
            message = "New encryption key generated. Probe between 1 and 100.";
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
                message = "CIPHER CRACKED! Correct key verified in " + attempts + " probe" + (attempts == 1 ? "" : "s") + "!";
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
<title>Cipher Guesser // Tactical Decryption Matrix</title>

<!-- Framer Motion Browser Engine -->
<script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>

<!-- Dedicated Fullscreen Cryptographic Hex Matrix & Cipher Wheels Canvas -->
<canvas id="cipherBgCanvas" class="cipher-bg-canvas"></canvas>

<!-- Universal Cyber-Scanner Wipe Transition -->
<div id="cyberWipeOverlay" class="cyber-wipe-overlay">
  <div class="cyber-wipe-beam"></div>
</div>

<div class="game-card">
  <!-- Traveling Light Beam Perimeter Circuit -->
  <div class="card-beam-perimeter">
    <div class="beam-runner beam-top"></div>
    <div class="beam-runner beam-right"></div>
    <div class="beam-runner beam-bottom"></div>
    <div class="beam-runner beam-left"></div>
    <div class="beam-corner-dot dot-tl"></div>
    <div class="beam-corner-dot dot-tr"></div>
    <div class="beam-corner-dot dot-br"></div>
    <div class="beam-corner-dot dot-bl"></div>
  </div>

  <!-- Standardized Pre-Game Startup Screen (Obsidian Space Glass) -->
  <div id="guesserStartup" class="startup-overlay <%= (guessParam != null || restart != null) ? "dismissed" : "" %>">
    <div class="overlay-badge">
      <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
      <span>QUANTUM CRYPTOGRAPHY SIMULATOR</span>
    </div>

    <div class="overlay-icon">
      <svg class="cipher-vault-svg" viewBox="0 0 64 64" fill="none">
        <rect x="12" y="24" width="40" height="32" rx="8" fill="url(#vaultGrad)" stroke="rgba(255,255,255,0.3)" stroke-width="2"/>
        <path d="M22 24 V16 C22 10.5 26.5 6 32 6 C37.5 6 42 10.5 42 16 V24" stroke="url(#vaultGrad)" stroke-width="4" stroke-linecap="round"/>
        <circle cx="32" cy="38" r="5" fill="#ffffff" />
        <path d="M32 43 V49" stroke="#ffffff" stroke-width="3" stroke-linecap="round"/>
        <circle cx="32" cy="40" r="16" stroke="rgba(56,189,248,0.4)" stroke-width="1.5" stroke-dasharray="4 4" />
        <defs>
          <linearGradient id="vaultGrad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#ffffff"/>
            <stop offset="45%" stop-color="#38bdf8"/>
            <stop offset="100%" stop-color="#0284c7"/>
          </linearGradient>
        </defs>
      </svg>
    </div>

    <h2 class="overlay-title">
      CIPHER <span class="hollow-text">GUESSER</span>
    </h2>
    <p class="overlay-sub">Intercept and decrypt server-side randomized encryption keys between 1 and 100 using precision quantum mathematical feedback.</p>
    
    <div class="overlay-stats">
      <div class="stat-col">
        <span class="stat-label">RECORD PROBES</span>
        <span class="stat-val" id="splashGuessBest">--</span>
      </div>
      <div class="stat-col">
        <span class="stat-label">SECURITY LEVEL</span>
        <span class="stat-val" style="color:var(--primary)">1 - 100</span>
      </div>
    </div>

    <div class="menu-actions">
      <button class="btn-cyber btn-cyber-primary" onclick="dismissGuesserStartup()">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
        <span>INITIATE DECRYPTION</span>
      </button>
      <div class="menu-actions-row">
        <button class="btn-cyber btn-cyber-secondary" onclick="openRules()">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
          <span>PROTOCOLS</span>
        </button>
        <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
          <span>HUB</span>
        </a>
      </div>
    </div>
  </div>

  <!-- Game Card Header Bar -->
  <header class="card-header">
    <div class="header-left">
      <div class="key-icon-mini">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#38bdf8" stroke-width="2"><circle cx="7.5" cy="15.5" r="4.5"/><path d="m21 3-9.5 9.5M15.5 7.5l3 3M18 5l3 3"/></svg>
      </div>
      <h2>CIPHER <span class="hollow-text">GUESSER</span></h2>
      <span class="header-badge">CRYPTO v3.0</span>
    </div>
    <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-hub">
      <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
      <span>Hub</span>
    </a>
  </header>

  <!-- Central Holographic Decryption Reticle -->
  <div class="cipher-reticle-wrap">
    <svg class="reticle-svg" viewBox="0 0 100 100" fill="none">
      <circle cx="50" cy="50" r="44" stroke="rgba(56,189,248,0.2)" stroke-width="1.5" stroke-dasharray="6 4" class="reticle-rot-cw"/>
      <circle cx="50" cy="50" r="36" stroke="rgba(255,255,255,0.25)" stroke-width="1.2" stroke-dasharray="14 8" class="reticle-rot-ccw"/>
      <circle cx="50" cy="50" r="26" fill="rgba(8,12,24,0.9)" stroke="<%= gameWon ? "#22c55e" : "#38bdf8" %>" stroke-width="2"/>
      <% if (gameWon) { %>
        <!-- Decrypted Unlock Vector -->
        <path d="M42 50 L48 56 L58 44" stroke="#22c55e" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
      <% } else { %>
        <!-- Locked Security Vector -->
        <rect x="44" y="47" width="12" height="10" rx="2" fill="#38bdf8" />
        <path d="M46 47 V43 C46 40.8 47.8 39 50 39 C52.2 39 54 40.8 54 43 V47" stroke="#38bdf8" stroke-width="2" stroke-linecap="round"/>
      <% } %>
    </svg>
  </div>

  <!-- Telemetry Message Banner -->
  <div class="msg-banner <%= gameWon ? "won" : "" %>">
    <%= message %>
  </div>

  <!-- Telemetry Statistics Bar -->
  <div class="stats-bar">
    <div class="stat-item">
      <span class="stat-label">LIVE PROBES</span>
      <span class="stat-value" id="displayAttempts"><%= (sess.getAttribute("attempts") != null) ? sess.getAttribute("attempts") : 0 %></span>
    </div>
    <div class="stat-item">
      <span class="stat-label">RECORD EFFICIENCY</span>
      <span class="stat-value" id="bestAttemptsVal">--</span>
    </div>
  </div>

  <!-- Probe Submission Form -->
  <form method="POST" action="index.jsp" class="cipher-form">
    <% if (!gameWon) { %>
      <div class="input-wrap">
        <input type="number" id="guessInput" name="guess" min="1" max="100" placeholder="ENTER PROBE (1 - 100)" required autofocus autocomplete="off">
        <span class="input-focus-glow"></span>
      </div>
      <div class="btn-action-group">
        <button type="submit" class="btn-cyber btn-cyber-primary" style="flex:1;">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          <span>SUBMIT PROBE</span>
        </button>
        <button type="button" class="btn-cyber btn-cyber-secondary" onclick="openRules()">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
          <span>MANUAL</span>
        </button>
      </div>
    <% } else { %>
      <div class="btn-action-group">
        <a href="index.jsp?restart=true" class="btn-cyber btn-cyber-primary" style="flex:1;">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
          <span>REBOOT & PLAY AGAIN</span>
        </a>
        <a href="../index.jsp" onclick="cyberNavigate('../index.jsp'); return false;" class="btn-cyber btn-cyber-secondary">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
          <span>HUB</span>
        </a>
      </div>
    <% } %>
  </form>

  <!-- Decryption Rules Modal (Obsidian Space Glass) -->
  <div id="rulesModal" class="rules-modal">
    <div class="rules-box">
      <div class="rules-title">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="#38bdf8" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
        <span>CRYPTOGRAPHIC PROTOCOLS</span>
      </div>
      <div class="rules-content">
        <p><strong>1. Target Key:</strong> The central node encapsulates a randomized integer from 1 to 100.</p>
        <p><strong>2. Feedback Probes:</strong> Submit probe integers. The terminal telemetry reports whether the real key is strictly HIGHER or LOWER.</p>
        <p><strong>3. Record Precision:</strong> Crack the cipher in minimal attempts. Optimal binary search solves any key in 7 probes or fewer!</p>
      </div>
      <button class="btn-cyber btn-cyber-primary" style="width: 100%; margin-top: 1rem;" onclick="closeRules()">
        <span>RETURN TO CONSOLE</span>
      </button>
    </div>
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