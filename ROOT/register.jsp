<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/db_connect.jspf" %>
<%
    // If POST request, process enlistment registration
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Callsign and Security Cipher are required.\"}");
            return;
        }

        username = username.trim();
        if (!username.matches("^[a-zA-Z0-9_]{3,20}$")) {
            out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Callsign must be 3-20 alphanumeric characters (letters, numbers, underscores).\"}");
            return;
        }

        if (password.length() < 6) {
            out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Security cipher must be at least 6 characters.\"}");
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            conn = getDbConnection();

            // 1. Check if username is already taken
            checkStmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            rs = checkStmt.executeQuery();
            if (rs.next()) {
                out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Callsign already taken. Choose an alternate handle.\"}");
                return;
            }

            // 2. Hash password with cryptographic salt
            String salt = generateSalt();
            String passwordHash = hashPassword(password, salt);

            // 3. Insert new user record
            insertStmt = conn.prepareStatement("INSERT INTO users (username, password_hash, salt) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
            insertStmt.setString(1, username);
            insertStmt.setString(2, passwordHash);
            insertStmt.setString(3, salt);
            insertStmt.executeUpdate();

            ResultSet genKeys = insertStmt.getGeneratedKeys();
            int newUserId = -1;
            if (genKeys.next()) {
                newUserId = genKeys.getInt(1);
            }

            // 4. Session Persistence
            HttpSession userSession = request.getSession(true);
            userSession.setAttribute("user_session", username);
            userSession.setAttribute("user", username);
            userSession.setAttribute("user_id", newUserId);

            out.print("{\"status\": \"success\", \"success\": true, \"message\": \"Operative enlistment complete! Welcome to Game Hub.\", \"username\": \"" + escapeJson(username) + "\"}");
            return;

        } catch (Throwable t) {
            String errMsg = (t.getMessage() != null) ? t.getMessage() : t.toString();
            out.print("{\"status\": \"error\", \"success\": false, \"message\": \"" + escapeJson(errMsg) + "\"}");
            return;
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception ignored) {}
            if (checkStmt != null) try { checkStmt.close(); } catch(Exception ignored) {}
            if (insertStmt != null) try { insertStmt.close(); } catch(Exception ignored) {}
            if (conn != null) try { conn.close(); } catch(Exception ignored) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>OPERATIVE ENLISTMENT // GAME HUB MAINFRAME</title>
<style>
  :root {
    --bg-base: #02040a;
    --card-bg: rgba(6, 12, 24, 0.85);
    --primary: #00f0ff;
    --primary-rgb: 0, 240, 255;
    --primary-glow: rgba(0, 240, 255, 0.45);
    --secondary: #0284c7;
    --accent: #10e6a8;
    --accent-glow: rgba(16, 230, 168, 0.4);
    --danger: #f43f5e;
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --border-cyan: rgba(0, 240, 255, 0.28);
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    -webkit-tap-highlight-color: transparent;
  }

  html, body {
    width: 100vw;
    height: 100vh;
    height: 100dvh;
    max-height: 100vh;
    margin: 0;
    padding: 0;
    background-color: var(--bg-base);
    color: var(--text-main);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: fixed;
    inset: 0;
    overflow: hidden !important;
  }

  /* Rising Cyber Laser Rays & Particle Floor Horizon Canvas */
  #techRaysCanvas {
    position: fixed;
    inset: 0;
    width: 100vw;
    height: 100vh;
    pointer-events: none;
    z-index: 0;
  }

  /* Animated High-Tech Cyan-to-Blue Transitioning Tech Grid */
  body::before {
    content: '';
    position: fixed;
    inset: -50%;
    width: 200%;
    height: 200%;
    background: 
      radial-gradient(circle at 50% 15%, rgba(0, 240, 255, 0.15) 0%, transparent 45%),
      radial-gradient(circle at 15% 75%, rgba(2, 132, 199, 0.18) 0%, transparent 40%),
      radial-gradient(circle at 85% 65%, rgba(16, 230, 168, 0.08) 0%, transparent 40%),
      linear-gradient(rgba(0, 240, 255, 0.035) 1px, transparent 1px),
      linear-gradient(90deg, rgba(0, 240, 255, 0.035) 1px, transparent 1px);
    background-size: 100% 100%, 100% 100%, 100% 100%, 36px 36px, 36px 36px;
    z-index: -1;
    pointer-events: none;
    animation: techBackgroundDrift 90s linear infinite;
  }

  @keyframes techBackgroundDrift {
    0% { transform: translateY(0); }
    100% { transform: translateY(36px); }
  }

  body::after {
    content: '';
    position: fixed;
    inset: 0;
    background: repeating-linear-gradient(
      0deg,
      rgba(0, 0, 0, 0.15),
      rgba(0, 0, 0, 0.15) 1px,
      transparent 1px,
      transparent 2px
    );
    pointer-events: none;
    z-index: 99;
    opacity: 0.6;
  }

  .auth-terminal {
    width: 100%;
    max-width: 480px;
    background: var(--card-bg);
    border: 1px solid var(--border-cyan);
    border-radius: 20px;
    padding: clamp(1.8rem, 4vh, 2.6rem);
    backdrop-filter: blur(20px);
    box-shadow: 
      0 20px 60px rgba(0, 0, 0, 0.85),
      0 0 35px rgba(0, 240, 255, 0.18),
      inset 0 0 30px rgba(0, 240, 255, 0.04);
    position: relative;
    overflow: hidden;
    animation: terminalFadeIn 0.45s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }

  @keyframes terminalFadeIn {
    from { opacity: 0; transform: translateY(18px) scale(0.98); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }

  .auth-terminal::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, transparent, var(--primary), var(--accent), transparent);
    box-shadow: 0 0 15px var(--primary);
  }

  .terminal-brand {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.5rem;
  }
  .brand-logo {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-size: 1.35rem;
    font-weight: 900;
    letter-spacing: 2px;
    color: #fff;
    text-shadow: 0 0 15px var(--primary-glow);
    text-decoration: none;
  }
  .brand-logo span { color: var(--primary); }
  .brand-chip {
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 1.5px;
    color: var(--accent);
    background: rgba(16, 230, 168, 0.1);
    border: 1px solid rgba(16, 230, 168, 0.35);
    padding: 3px 8px;
    border-radius: 6px;
    text-transform: uppercase;
  }

  .terminal-title {
    font-size: clamp(1.4rem, 3vh, 1.7rem);
    font-weight: 900;
    letter-spacing: 1px;
    background: linear-gradient(135deg, #ffffff 30%, var(--primary) 70%, var(--accent) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 0.4rem;
  }
  .terminal-desc {
    font-size: 0.85rem;
    color: var(--text-muted);
    line-height: 1.5;
    margin-bottom: 1.6rem;
  }

  .form-group {
    margin-bottom: 1.2rem;
    position: relative;
  }
  .form-label {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.72rem;
    font-weight: 800;
    color: var(--text-muted);
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 6px;
  }
  .form-label span.req { color: var(--primary); }

  .input-wrap {
    position: relative;
    display: flex;
    align-items: center;
  }
  .input-icon {
    position: absolute;
    left: 14px;
    color: var(--text-muted);
    font-size: 1rem;
    pointer-events: none;
    transition: color 0.2s;
  }

  .auth-input {
    width: 100%;
    height: 48px;
    background: rgba(3, 7, 18, 0.75);
    border: 1px solid rgba(0, 240, 255, 0.22);
    border-radius: 12px;
    padding: 0 14px 0 44px;
    color: #fff;
    font-size: 0.95rem;
    font-weight: 600;
    outline: none;
    transition: all 0.2s ease;
  }
  .auth-input:focus {
    border-color: var(--primary);
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.35);
    background: rgba(3, 7, 18, 0.95);
  }

  .status-banner {
    display: none;
    padding: 0.75rem 1rem;
    border-radius: 10px;
    font-size: 0.85rem;
    font-weight: 700;
    margin-bottom: 1.25rem;
    align-items: center;
    gap: 8px;
    line-height: 1.4;
  }
  .status-banner.error {
    display: flex;
    background: rgba(244, 63, 94, 0.15);
    border: 1px solid rgba(244, 63, 94, 0.5);
    color: #fda4af;
  }
  .status-banner.success {
    display: flex;
    background: rgba(16, 230, 168, 0.15);
    border: 1px solid rgba(16, 230, 168, 0.5);
    color: #6ee7b7;
  }

  .btn-submit {
    width: 100%;
    min-height: 50px;
    background: linear-gradient(135deg, #10e6a8 0%, #0284c7 100%);
    color: #030712;
    border: none;
    border-radius: 12px;
    font-size: 0.95rem;
    font-weight: 900;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    cursor: pointer;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    box-shadow: 0 0 25px rgba(16, 230, 168, 0.4);
    margin-top: 0.5rem;
  }
  .btn-submit:hover:not(:disabled) {
    transform: translateY(-2px);
    box-shadow: 0 0 35px rgba(16, 230, 168, 0.65);
    background: linear-gradient(135deg, #00f0ff 0%, #10e6a8 100%);
  }
  .btn-submit:disabled {
    opacity: 0.65;
    cursor: not-allowed;
  }

  .actions-row {
    display: flex;
    gap: 0.75rem;
    margin-top: 1rem;
  }
  .btn-sec {
    flex: 1;
    min-height: 44px;
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    border-radius: 10px;
    font-size: 0.82rem;
    font-weight: 700;
    letter-spacing: 0.8px;
    cursor: pointer;
    transition: all 0.2s;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
  }
  .btn-sec:hover {
    background: rgba(0, 240, 255, 0.1);
    border-color: rgba(0, 240, 255, 0.35);
    color: var(--primary);
  }

  .terminal-footer {
    margin-top: 1.8rem;
    padding-top: 1.2rem;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.8rem;
    color: var(--text-muted);
  }
  .terminal-footer a {
    color: var(--primary);
    text-decoration: none;
    font-weight: 700;
  }
  .terminal-footer a:hover { text-decoration: underline; }

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
    background: linear-gradient(90deg, transparent 0%, rgba(0, 240, 255, 0.2) 60%, rgba(0, 240, 255, 0.7) 92%, #00f0ff 98%, #ffffff 100%);
    box-shadow: 12px 0 35px rgba(0, 240, 255, 0.85);
  }
  .cyber-wipe-overlay.active .cyber-wipe-beam {
    animation: cyberBeamSweep 0.28s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  @keyframes cyberBeamSweep {
    0% { transform: translateX(0); }
    100% { transform: translateX(200vw); }
  }
</style>
</head>
<body>

<!-- Rising Cyber Laser Rays & Particle Floor Horizon Canvas -->
<canvas id="techRaysCanvas"></canvas>

<div id="cyberWipeOverlay" class="cyber-wipe-overlay">
  <div class="cyber-wipe-beam"></div>
</div>

<div class="auth-terminal">
  <div class="terminal-brand">
    <a href="index.jsp" class="brand-logo">
      ⬡ GAME <span>HUB</span>
    </a>
    <span class="brand-chip">NEW OPERATIVE</span>
  </div>

  <h1 class="terminal-title">CREATE PROFILE</h1>
  <p class="terminal-desc">Establish your operative callsign to track brain radar progression, unlock account levels, and compete on cloud leaderboards.</p>

  <div id="statusBanner" class="status-banner"></div>

  <form id="enlistForm" onsubmit="event.preventDefault(); submitEnlist();">
    <div class="form-group">
      <label class="form-label" for="username">
        <span>// CHOOSE CALLSIGN</span>
        <span class="req">3-20 ALPHANUMERIC</span>
      </label>
      <div class="input-wrap">
        <span class="input-icon">👤</span>
        <input type="text" class="auth-input" id="username" name="username" placeholder="e.g. CyberViper" autocomplete="username" required autofocus>
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="password">
        <span>// SECURITY CIPHER</span>
        <span class="req">MIN 6 CHARACTERS</span>
      </label>
      <div class="input-wrap">
        <span class="input-icon">🔒</span>
        <input type="password" class="auth-input" id="password" name="password" placeholder="••••••••••••" autocomplete="new-password" required>
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="confirmPassword">
        <span>// CONFIRM CIPHER</span>
        <span class="req">MATCH</span>
      </label>
      <div class="input-wrap">
        <span class="input-icon">🛡️</span>
        <input type="password" class="auth-input" id="confirmPassword" name="confirmPassword" placeholder="••••••••••••" autocomplete="new-password" required>
      </div>
    </div>

    <button type="submit" class="btn-submit" id="submitBtn">
      <span id="btnText">🚀 ENLIST OPERATIVE</span>
    </button>
  </form>

  <div class="actions-row">
    <a href="login.jsp" class="btn-sec">
      <span>🔑 ALREADY ENLISTED? LOGIN</span>
    </a>
    <a href="index.jsp" class="btn-sec" onclick="event.preventDefault(); guestAccess();">
      <span>🎮 PLAY AS GUEST</span>
    </a>
  </div>

  <div class="terminal-footer">
    <a href="index.jsp">‹ Return to Mainframe Hub</a>
    <span>ENCRYPTED VIA SHA-256</span>
  </div>
</div>

<script>
  // =========================================================
  // RISING TECH LASER RAYS & PARTICLE HORIZON ENGINE
  // =========================================================
  (function initTechRaysEngine() {
    const canvas = document.getElementById('techRaysCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let width = 0;
    let height = 0;
    let horizonY = 0;

    function resize() {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
      horizonY = Math.round(height * 0.78);
    }
    window.addEventListener('resize', resize);
    resize();

    // 1. Vertical Laser Beams Rising from Horizon
    const RAY_COUNT = 85;
    const rays = [];
    for (let i = 0; i < RAY_COUNT; i++) {
      const isBright = Math.random() < 0.22;
      rays.push({
        xPct: Math.random(),
        maxHeight: isBright ? (0.45 + Math.random() * 0.50) : (0.2 + Math.random() * 0.42),
        width: isBright ? (1.8 + Math.random() * 2.0) : (0.8 + Math.random() * 1.3),
        alphaBase: isBright ? (0.65 + Math.random() * 0.35) : (0.22 + Math.random() * 0.38),
        pulseSpeed: 0.015 + Math.random() * 0.03,
        pulseOffset: Math.random() * Math.PI * 2,
        colorType: Math.random() < 0.58 ? 'cyan' : (Math.random() < 0.85 ? 'blue' : 'white')
      });
    }

    // 2. Rising Glowing Particles / Floating Dust
    const PARTICLE_COUNT = 100;
    const particles = [];
    function createParticle(initialSpawn) {
      return {
        x: Math.random() * (width || window.innerWidth),
        y: initialSpawn ? (horizonY - Math.random() * (horizonY * 0.85)) : (horizonY + Math.random() * 20),
        vx: (Math.random() - 0.5) * 0.45,
        vy: -(0.5 + Math.random() * 1.4),
        size: 0.9 + Math.random() * 2.0,
        alpha: 0.12 + Math.random() * 0.75,
        maxLife: 130 + Math.random() * 170,
        life: initialSpawn ? Math.random() * 200 : 0,
        color: Math.random() < 0.62 ? '#00f0ff' : (Math.random() < 0.88 ? '#38bdf8' : '#ffffff')
      };
    }
    for (let i = 0; i < PARTICLE_COUNT; i++) {
      particles.push(createParticle(true));
    }

    const FLOOR_LINE_COUNT = 24;
    let time = 0;

    function renderRays() {
      time += 1;
      ctx.clearRect(0, 0, width, height);

      // Dark Cyber Base Gradient
      const bgGrad = ctx.createLinearGradient(0, 0, 0, height);
      bgGrad.addColorStop(0, '#010307');
      bgGrad.addColorStop(0.65, '#020713');
      bgGrad.addColorStop(horizonY / height, '#040d24');
      bgGrad.addColorStop(1, '#01040a');
      ctx.fillStyle = bgGrad;
      ctx.fillRect(0, 0, width, height);

      // A. Reflective Floor (Below Horizon)
      const floorHeight = height - horizonY;
      if (floorHeight > 0) {
        ctx.save();
        ctx.strokeStyle = 'rgba(0, 240, 255, 0.08)';
        ctx.lineWidth = 1;
        const vpX = width / 2;
        for (let i = -FLOOR_LINE_COUNT; i <= FLOOR_LINE_COUNT; i++) {
          const spreadX = vpX + (i * (width / FLOOR_LINE_COUNT) * 1.35);
          ctx.beginPath();
          ctx.moveTo(vpX + (i * 12), horizonY);
          ctx.lineTo(spreadX, height);
          ctx.stroke();
        }
        ctx.restore();

        for (let yStep = 0; yStep < 6; yStep++) {
          const p = Math.pow(yStep / 5, 2.2);
          const y = horizonY + p * floorHeight;
          ctx.fillStyle = `rgba(0, 240, 255, ${0.04 + p * 0.06})`;
          ctx.fillRect(0, y, width, 1);
        }
      }

      // B. Vertical Laser Rays (Shooting UP from Horizon)
      for (let i = 0; i < rays.length; i++) {
        const r = rays[i];
        const x = r.xPct * width;
        const pulse = Math.sin(time * r.pulseSpeed + r.pulseOffset);
        const currentAlpha = Math.max(0.1, Math.min(1.0, r.alphaBase + pulse * 0.25));
        const rayLen = r.maxHeight * horizonY * (0.88 + pulse * 0.12);
        const topY = horizonY - rayLen;

        let coreColor, outerColor;
        if (r.colorType === 'cyan') {
          coreColor = `rgba(180, 255, 255, ${currentAlpha})`;
          outerColor = `rgba(0, 240, 255, ${currentAlpha * 0.75})`;
        } else if (r.colorType === 'blue') {
          coreColor = `rgba(140, 220, 255, ${currentAlpha})`;
          outerColor = `rgba(2, 132, 199, ${currentAlpha * 0.7})`;
        } else {
          coreColor = `rgba(255, 255, 255, ${currentAlpha})`;
          outerColor = `rgba(0, 240, 255, ${currentAlpha * 0.85})`;
        }

        const rayGrad = ctx.createLinearGradient(x, horizonY, x, topY);
        rayGrad.addColorStop(0, coreColor);
        rayGrad.addColorStop(0.2, outerColor);
        rayGrad.addColorStop(0.7, outerColor.replace(/[\d\.]+\)$/, (currentAlpha * 0.3) + ')'));
        rayGrad.addColorStop(1, 'transparent');

        ctx.fillStyle = rayGrad;
        ctx.fillRect(x - r.width / 2, topY, r.width, rayLen);

        // Downward Floor Reflection
        if (floorHeight > 0) {
          const reflLen = Math.min(floorHeight * 0.75, rayLen * 0.4);
          const reflGrad = ctx.createLinearGradient(x, horizonY, x, horizonY + reflLen);
          reflGrad.addColorStop(0, coreColor.replace(/[\d\.]+\)$/, (currentAlpha * 0.45) + ')'));
          reflGrad.addColorStop(0.4, outerColor.replace(/[\d\.]+\)$/, (currentAlpha * 0.2) + ')'));
          reflGrad.addColorStop(1, 'transparent');

          ctx.fillStyle = reflGrad;
          ctx.fillRect(x - (r.width * 1.2) / 2, horizonY, r.width * 1.2, reflLen);
        }
      }

      // C. Horizon Glow & Laser Line
      const horizGrad = ctx.createRadialGradient(width / 2, horizonY, 20, width / 2, horizonY, width * 0.65);
      horizGrad.addColorStop(0, 'rgba(0, 240, 255, 0.45)');
      horizGrad.addColorStop(0.35, 'rgba(2, 132, 199, 0.25)');
      horizGrad.addColorStop(0.75, 'rgba(0, 100, 200, 0.08)');
      horizGrad.addColorStop(1, 'transparent');
      ctx.fillStyle = horizGrad;
      ctx.fillRect(0, horizonY - 45, width, 90);

      const lineGrad = ctx.createLinearGradient(0, horizonY, width, horizonY);
      lineGrad.addColorStop(0, 'rgba(0, 240, 255, 0.1)');
      lineGrad.addColorStop(0.15, 'rgba(0, 240, 255, 0.85)');
      lineGrad.addColorStop(0.5, 'rgba(255, 255, 255, 0.98)');
      lineGrad.addColorStop(0.85, 'rgba(0, 240, 255, 0.85)');
      lineGrad.addColorStop(1, 'rgba(0, 240, 255, 0.1)');

      ctx.fillStyle = lineGrad;
      ctx.fillRect(0, horizonY - 1, width, 2.5);

      // D. Rising Particles
      for (let i = 0; i < particles.length; i++) {
        const p = particles[i];
        p.x += p.vx + Math.sin((time + i * 20) * 0.02) * 0.35;
        p.y += p.vy;
        p.life++;

        const lifeRatio = p.life / p.maxLife;
        let alpha = p.alpha;
        if (lifeRatio > 0.7) {
          alpha *= (1 - (lifeRatio - 0.7) / 0.3);
        }

        if (p.life >= p.maxLife || p.y < 0) {
          particles[i] = createParticle(false);
          continue;
        }

        ctx.fillStyle = p.color;
        ctx.globalAlpha = Math.max(0, Math.min(1, alpha));
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fill();

        if (p.size > 1.8) {
          ctx.fillStyle = 'rgba(0, 240, 255, 0.25)';
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.size * 2.2, 0, Math.PI * 2);
          ctx.fill();
        }
      }
      ctx.globalAlpha = 1.0;

      requestAnimationFrame(renderRays);
    }

    renderRays();
  })();

  function showStatus(type, msg) {
    const banner = document.getElementById('statusBanner');
    banner.className = 'status-banner ' + type;
    banner.innerHTML = (type === 'error' ? '⚠️ ' : '✅ ') + msg;
  }

  function guestAccess() {
    sessionStorage.setItem('hub_portal_passed', 'true');
    triggerWipe('index.jsp');
  }

  function triggerWipe(url) {
    const wipe = document.getElementById('cyberWipeOverlay');
    wipe.classList.add('active');
    setTimeout(() => { window.location.href = url; }, 240);
  }

  async function submitEnlist() {
    const u = document.getElementById('username').value.trim();
    const p = document.getElementById('password').value;
    const c = document.getElementById('confirmPassword').value;
    const btn = document.getElementById('submitBtn');
    const btnText = document.getElementById('btnText');

    if (!u || !p || !c) {
      showStatus('error', 'Please fill in all security fields.');
      return;
    }
    if (p !== c) {
      showStatus('error', 'Security ciphers do not match.');
      return;
    }
    if (p.length < 6) {
      showStatus('error', 'Cipher must be at least 6 characters.');
      return;
    }

    btn.disabled = true;
    btnText.innerText = 'ENLISTING OPERATIVE...';

    try {
      const res = await fetch('register.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ username: u, password: p })
      });

      const data = await res.json();

      if (data.status === 'success' || data.success) {
        showStatus('success', 'Profile established! Initializing clean session...');
        sessionStorage.setItem('hub_portal_passed', 'true');
        
        // Ensure new account has 0 XP and completely clean cache
        localStorage.clear();
        localStorage.setItem('hub_active_user', u);
        localStorage.setItem('hub_active_account', u);

        setTimeout(() => {
          triggerWipe('index.jsp');
        }, 350);
      } else {
        showStatus('error', data.message || 'Enlistment rejected. Verify handle requirements.');
        btn.disabled = false;
        btnText.innerText = '🚀 ENLIST OPERATIVE';
      }
    } catch (err) {
      showStatus('error', 'Gateway unreachable. Verify database connection.');
      btn.disabled = false;
      btnText.innerText = '🚀 ENLIST OPERATIVE';
    }
  }
</script>
</body>
</html>
