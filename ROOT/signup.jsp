<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.sendRedirect("auth.jsp?mode=signup");
    if (true) return;

    String currentUser = null;
    if (session != null) {
        currentUser = (String) session.getAttribute("user_session");
        if (currentUser == null || currentUser.trim().isEmpty()) {
            currentUser = (String) session.getAttribute("user");
        }
    }
    boolean isLoggedIn = (currentUser != null && !currentUser.trim().isEmpty());
    String defaultMode = request.getParameter("mode");
    if (defaultMode == null || (!defaultMode.equals("login") && !defaultMode.equals("signup"))) {
        defaultMode = "signup"; // Default to sign up as requested
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Game Hub | Cognitive Portal & Operative Enlistment</title>
<link rel="stylesheet" href="css/ransom_horror.css">
<!-- Framer Motion Browser Engine -->
<script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>
<style>
  :root {
    --bg-base: #02040a;
    --card-bg: rgba(6, 12, 24, 0.88);
    --border-glow: rgba(0, 240, 255, 0.35);
    --border-cyan: rgba(0, 240, 255, 0.25);
    --primary: #00f0ff;
    --primary-rgb: 0, 240, 255;
    --primary-glow: rgba(0, 240, 255, 0.45);
    --accent: #10e6a8;
    --accent-glow: rgba(16, 230, 168, 0.4);
    --text-main: #f8fafc;
    --text-muted: #94a3b8;
    --danger: #ef4444;
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
    overflow: hidden !important;
    background-color: var(--bg-base);
    color: var(--text-main);
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    inset: 0;
  }

  /* Fullscreen Interactive Kinetic Grid Canvas */
  #techRaysCanvas {
    position: fixed;
    inset: 0;
    width: 100vw;
    height: 100vh;
    pointer-events: none;
    z-index: 1;
  }

  /* Subtle CRT Scanline Mesh */
  body::after {
    content: '';
    position: fixed;
    inset: 0;
    background: repeating-linear-gradient(
      0deg,
      rgba(0, 0, 0, 0.12),
      rgba(0, 0, 0, 0.12) 1px,
      transparent 1px,
      transparent 2px
    );
    pointer-events: none;
    z-index: 99;
    opacity: 0.45;
  }

  /* Framer Motion Kinetic Camera Depth Curtain & Transitions */
  .motion-page-curtain, .cyber-shutter {
    position: fixed;
    inset: 0;
    z-index: 9000;
    pointer-events: none;
    opacity: 0;
    background: radial-gradient(circle at 50% 50%, rgba(6, 13, 28, 0.94) 0%, rgba(2, 4, 10, 0.98) 100%);
    backdrop-filter: blur(28px) saturate(140%);
    -webkit-backdrop-filter: blur(28px) saturate(140%);
    transform: scale(1.02);
    transition: opacity 0.24s cubic-bezier(0.16, 1, 0.3, 1), transform 0.24s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .motion-page-curtain.active, .cyber-shutter.active {
    pointer-events: all;
    opacity: 1;
    transform: scale(1);
  }
  .motion-page-curtain .curtain-velocity-bar, .cyber-shutter-beam {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 2px;
    background: linear-gradient(90deg, transparent 0%, rgba(0, 240, 255, 0.3) 15%, #00f0ff 50%, rgba(0, 240, 255, 0.3) 85%, transparent 100%);
    box-shadow: 0 0 16px rgba(0, 240, 255, 0.8), 0 0 32px rgba(0, 240, 255, 0.4);
    transform: scaleX(0);
    transform-origin: center;
    transition: transform 0.26s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .motion-page-curtain.active .curtain-velocity-bar, .cyber-shutter.active .cyber-shutter-beam {
    transform: scaleX(1);
    opacity: 1;
  }

  /* Main Floating Space Terminal Auth Card */
  .auth-portal-card {
    position: relative;
    z-index: 10;
    width: 92vw;
    max-width: 450px;
    max-height: 90dvh;
    overflow-y: auto;
    background: rgba(4, 9, 22, 0.90);
    backdrop-filter: blur(28px);
    -webkit-backdrop-filter: blur(28px);
    border: 1px solid rgba(0, 240, 255, 0.35);
    border-radius: 28px;
    padding: 2.2rem 2rem;
    box-shadow: 0 0 60px rgba(0, 240, 255, 0.18), 0 30px 80px rgba(0, 0, 0, 0.95);
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    animation: cardSpringIn 0.55s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
    transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.35s ease, filter 0.35s ease;
  }

  /* Top Glowing Cyber Beam */
  .auth-portal-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 15%;
    right: 15%;
    height: 2px;
    background: linear-gradient(90deg, transparent, var(--primary), transparent);
    box-shadow: 0 0 16px var(--primary);
  }

  @keyframes cardSpringIn {
    0% { transform: scale(0.92) translateY(24px); opacity: 0; }
    100% { transform: scale(1) translateY(0); opacity: 1; }
  }

  /* Exit Spring Compression Warp */
  .auth-portal-card.warp-out {
    transform: scale(1.12) translateY(-20px);
    opacity: 0;
    filter: blur(14px);
    pointer-events: none;
  }

  /* Badges & Titles */
  .portal-tag {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(0, 240, 255, 0.08);
    border: 1px solid rgba(0, 240, 255, 0.3);
    padding: 5px 14px;
    border-radius: 9999px;
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: var(--primary);
    text-transform: uppercase;
    margin-bottom: 0.9rem;
    box-shadow: 0 0 16px rgba(0, 240, 255, 0.2);
  }
  .portal-tag::before {
    content: '';
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--accent);
    box-shadow: 0 0 8px var(--accent);
    animation: pulseDot 1.8s infinite;
  }
  @keyframes pulseDot {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.3); opacity: 0.6; }
  }

  .portal-title {
    font-size: clamp(1.8rem, 5vw, 2.4rem);
    font-weight: 900;
    letter-spacing: 3px;
    color: #ffffff;
    text-shadow: 0 0 30px rgba(0, 240, 255, 0.5);
    margin: 0 0 0.4rem 0;
    line-height: 1.1;
  }
  .portal-title span {
    color: var(--primary);
    text-shadow: 0 0 35px var(--primary);
  }

  .portal-subtitle {
    font-size: 0.82rem;
    line-height: 1.45;
    color: var(--text-muted);
    margin-bottom: 1.4rem;
    max-width: 360px;
  }

  /* Framer-Motion Tab Switcher */
  .auth-tabs {
    display: flex;
    width: 100%;
    background: rgba(2, 4, 10, 0.75);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 4px;
    margin-bottom: 1.25rem;
    gap: 4px;
  }
  .auth-tab {
    flex: 1;
    padding: 9px 12px;
    background: transparent;
    border: none;
    border-radius: 10px;
    color: var(--text-muted);
    font-weight: 800;
    font-size: 0.78rem;
    letter-spacing: 1.5px;
    cursor: pointer;
    transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .auth-tab:hover {
    color: #ffffff;
  }
  .auth-tab.active {
    background: var(--primary);
    color: #02040a;
    box-shadow: 0 0 18px rgba(0, 240, 255, 0.45);
  }

  /* Forms & Inputs */
  .auth-form-wrap {
    width: 100%;
    display: none;
    flex-direction: column;
    gap: 12px;
  }
  .auth-form-wrap.active {
    display: flex;
    animation: formFadeIn 0.3s ease forwards;
  }
  @keyframes formFadeIn {
    0% { opacity: 0; transform: translateY(6px); }
    100% { opacity: 1; transform: translateY(0); }
  }

  .auth-input-group {
    display: flex;
    flex-direction: column;
    text-align: left;
    gap: 5px;
  }
  .auth-input-label {
    font-size: 0.68rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    font-weight: 700;
    color: var(--text-muted);
  }
  .auth-input-box {
    position: relative;
    display: flex;
    align-items: center;
  }
  .auth-input-icon {
    position: absolute;
    left: 14px;
    font-size: 0.95rem;
    pointer-events: none;
    opacity: 0.8;
  }
  .auth-field {
    width: 100%;
    background: rgba(2, 4, 10, 0.85);
    border: 1px solid rgba(0, 240, 255, 0.25);
    border-radius: 12px;
    padding: 11px 14px 11px 40px;
    color: #ffffff;
    font-size: 15px !important;
    outline: none;
    transition: all 0.2s ease;
  }
  .auth-field:focus {
    border-color: var(--primary);
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.35);
    background: rgba(2, 6, 16, 0.95);
  }
  .auth-field::placeholder {
    color: rgba(255, 255, 255, 0.25);
    font-size: 0.82rem;
  }

  /* Action Buttons with Spring Micro-interactions */
  .btn-submit {
    width: 100%;
    padding: 13px 18px;
    border: none;
    border-radius: 13px;
    background: linear-gradient(135deg, var(--primary), #0284c7);
    color: #02040a;
    font-weight: 900;
    font-size: 0.85rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    cursor: pointer;
    box-shadow: 0 0 25px rgba(0, 240, 255, 0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 6px;
    transition: transform 0.15s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.2s ease;
  }
  .btn-submit:hover {
    transform: scale(1.02);
    box-shadow: 0 0 35px rgba(0, 240, 255, 0.65);
  }
  .btn-submit:active {
    transform: scale(0.98);
  }
  .btn-submit:disabled {
    opacity: 0.55;
    cursor: not-allowed;
    transform: none;
  }

  .btn-signup-submit {
    background: linear-gradient(135deg, var(--accent), #059669);
    box-shadow: 0 0 25px rgba(16, 230, 168, 0.4);
  }
  .btn-signup-submit:hover {
    box-shadow: 0 0 35px rgba(16, 230, 168, 0.65);
  }

  /* Guest Bypass Button */
  .guest-bypass-box {
    margin-top: 1.1rem;
    padding-top: 1.1rem;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
  }
  .btn-guest {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: var(--text-muted);
    padding: 10px 16px;
    border-radius: 12px;
    font-size: 0.78rem;
    font-weight: 700;
    letter-spacing: 1px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    width: 100%;
    justify-content: center;
  }
  .btn-guest:hover {
    background: rgba(0, 240, 255, 0.1);
    border-color: rgba(0, 240, 255, 0.4);
    color: #ffffff;
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.25);
    transform: scale(1.01);
  }

  /* Feedback Alerts */
  .auth-alert {
    display: none;
    width: 100%;
    padding: 9px 12px;
    border-radius: 10px;
    font-size: 0.78rem;
    font-weight: 600;
    line-height: 1.35;
    text-align: left;
    margin-bottom: 8px;
  }
  .auth-alert.error {
    background: rgba(239, 68, 68, 0.14);
    border: 1px solid rgba(239, 68, 68, 0.35);
    color: #fca5a5;
  }
  .auth-alert.success {
    background: rgba(16, 230, 168, 0.14);
    border: 1px solid rgba(16, 230, 168, 0.4);
    color: #6ee7b7;
  }

  /* Spinner */
  .spinner {
    display: inline-block;
    width: 14px;
    height: 14px;
    border: 2px solid rgba(0, 0, 0, 0.3);
    border-top-color: #02040a;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }
  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  .portal-footer-hint {
    margin-top: 1.1rem;
    font-size: 0.65rem;
    letter-spacing: 1.5px;
    color: rgba(0, 240, 255, 0.65);
    text-transform: uppercase;
  }
</style>
</head>
<body>

  <!-- Fullscreen Interactive Kinetic Grid Canvas -->
  <canvas id="techRaysCanvas"></canvas>

  <!-- High-Speed Cyber Shutter Flash -->
  <div id="cyberShutter" class="cyber-shutter">
    <div class="cyber-shutter-beam"></div>
  </div>

  <!-- Dedicated Space Terminal Auth Card -->
  <div class="auth-portal-card" id="authCard">
    <div class="portal-tag">🧠 BRAIN AGILITY & LOGIC PLATFORM</div>
    <h1 class="portal-title">GAME <span>HUB</span></h1>
    <p class="portal-subtitle">
      Cognitive agility, pattern recognition, and split-second reflex training. Zero latency.
    </p>

    <!-- Tab Switcher -->
    <div class="auth-tabs">
      <button type="button" class="auth-tab <%= "signup".equals(defaultMode) ? "active" : "" %>" id="tabSignup" onclick="switchAuthMode('signup')">
        SIGN UP
      </button>
      <button type="button" class="auth-tab <%= "login".equals(defaultMode) ? "active" : "" %>" id="tabLogin" onclick="switchAuthMode('login')">
        LOG IN
      </button>
    </div>

    <!-- Alert Box -->
    <div class="auth-alert" id="authAlert"></div>

    <!-- ================= SIGN UP FORM ================= -->
    <form class="auth-form-wrap <%= "signup".equals(defaultMode) ? "active" : "" %>" id="signupForm" onsubmit="event.preventDefault(); handleSignup();">
      <div class="auth-input-group">
        <label class="auth-input-label" for="signupUser">Operative Handle [3-20 Chars]</label>
        <div class="auth-input-box">
          <span class="auth-input-icon">👤</span>
          <input type="text" class="auth-field" id="signupUser" placeholder="e.g. AstroOperative" autocomplete="username" required>
        </div>
      </div>

      <div class="auth-input-group">
        <label class="auth-input-label" for="signupPass">Security Cipher [Min 6 Chars]</label>
        <div class="auth-input-box">
          <span class="auth-input-icon">🔒</span>
          <input type="password" class="auth-field" id="signupPass" placeholder="••••••••••••" autocomplete="new-password" required>
        </div>
      </div>

      <div class="auth-input-group">
        <label class="auth-input-label" for="signupPassConfirm">Confirm Cipher</label>
        <div class="auth-input-box">
          <span class="auth-input-icon">🛡️</span>
          <input type="password" class="auth-field" id="signupPassConfirm" placeholder="••••••••••••" autocomplete="new-password" required>
        </div>
      </div>

      <button type="submit" class="btn-submit btn-signup-submit" id="signupBtn">
        <span id="signupBtnText">⚡ ENLIST PROFILE & ENTER</span>
      </button>
    </form>

    <!-- ================= LOG IN FORM ================= -->
    <form class="auth-form-wrap <%= "login".equals(defaultMode) ? "active" : "" %>" id="loginForm" onsubmit="event.preventDefault(); handleLogin();">
      <div class="auth-input-group">
        <label class="auth-input-label" for="loginUser">Operative Callsign</label>
        <div class="auth-input-box">
          <span class="auth-input-icon">👤</span>
          <input type="text" class="auth-field" id="loginUser" placeholder="e.g. CyberNinja" autocomplete="username" required>
        </div>
      </div>

      <div class="auth-input-group">
        <label class="auth-input-label" for="loginPass">Security Cipher</label>
        <div class="auth-input-box">
          <span class="auth-input-icon">🔒</span>
          <input type="password" class="auth-field" id="loginPass" placeholder="••••••••••••" autocomplete="current-password" required>
        </div>
      </div>

      <button type="submit" class="btn-submit" id="loginBtn">
        <span id="loginBtnText">⚡ AUTHENTICATE & ENTER</span>
      </button>
    </form>

    <!-- Guest Access Bypass -->
    <div class="guest-bypass-box">
      <button type="button" class="btn-guest" onclick="handleGuestBypass()">
        <span>🎮 Bypass Authentication (Play as Guest)</span>
      </button>
    </div>

    <div class="portal-footer-hint">
      ⚡ KINETIC GRID ACTIVE • MOVE CURSOR & CLICK ANYWHERE
    </div>
  </div>

<script>
  // Tab Switching
  function switchAuthMode(mode) {
    const tabSignup = document.getElementById('tabSignup');
    const tabLogin = document.getElementById('tabLogin');
    const formSignup = document.getElementById('signupForm');
    const formLogin = document.getElementById('loginForm');
    const alertBox = document.getElementById('authAlert');

    if (alertBox) alertBox.style.display = 'none';

    if (mode === 'signup') {
      tabSignup.classList.add('active');
      tabLogin.classList.remove('active');
      formSignup.classList.add('active');
      formLogin.classList.remove('active');
    } else {
      tabLogin.classList.add('active');
      tabSignup.classList.remove('active');
      formLogin.classList.add('active');
      formSignup.classList.remove('active');
    }
  }

  function showAlert(type, text) {
    const alertBox = document.getElementById('authAlert');
    if (!alertBox) return;
    alertBox.className = 'auth-alert ' + type;
    alertBox.innerHTML = (type === 'success' ? '✓ ' : '⚠️ ') + text;
    alertBox.style.display = 'block';
  }

  // Framer Motion Kinetic Transition to Dashboard
  function triggerWarpToDashboard(callsign) {
    const card = document.getElementById('authCard');
    const shutter = document.getElementById('cyberShutter');
    const Motion = (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;

    if (card) {
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(card, { opacity: [1, 0], scale: [1, 0.95], y: [0, -16], filter: ['blur(0px)', 'blur(8px)'] }, { duration: 0.25, ease: [0.16, 1, 0.3, 1] });
      } else {
        card.classList.add('warp-out');
      }
    }
    if (shutter) {
      shutter.classList.add('active');
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(shutter, { opacity: [0, 1], scale: [1.02, 1] }, { duration: 0.24, ease: [0.16, 1, 0.3, 1] });
      }
    }

    sessionStorage.setItem('hub_portal_passed', 'true');
    sessionStorage.setItem('hub_session_user', callsign || 'Operative');

    // Smooth transition into index.jsp
    setTimeout(() => {
      window.location.href = 'index.jsp';
    }, 240);
  }

  // Guest Bypass
  function handleGuestBypass() {
    showAlert('success', 'Guest protocol verified. Initializing neural simulation...');
    setTimeout(() => {
      triggerWarpToDashboard('Guest Operative');
    }, 200);
  }

  // Async Login Handler
  async function handleLogin() {
    const u = document.getElementById('loginUser').value.trim();
    const p = document.getElementById('loginPass').value;
    const btn = document.getElementById('loginBtn');
    const btnText = document.getElementById('loginBtnText');

    if (!u || !p) {
      showAlert('error', 'Callsign and Security Cipher are required.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> Authenticating...';

    try {
      const res = await fetch('login.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ username: u, password: p })
      });
      const data = await res.json();

      if (data.status === 'success' || data.success) {
        showAlert('success', 'Verified! Entering Game Hub...');
        setTimeout(() => triggerWarpToDashboard(u), 350);
      } else {
        showAlert('error', data.message || 'Invalid callsign or security cipher.');
        btn.disabled = false;
        btnText.innerText = '⚡ AUTHENTICATE & ENTER';
      }
    } catch (err) {
      showAlert('error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
      btn.disabled = false;
      btnText.innerText = '⚡ AUTHENTICATE & ENTER';
    }
  }

  // Async Signup Handler
  async function handleSignup() {
    const u = document.getElementById('signupUser').value.trim();
    const p = document.getElementById('signupPass').value;
    const c = document.getElementById('signupPassConfirm').value;
    const btn = document.getElementById('signupBtn');
    const btnText = document.getElementById('signupBtnText');

    if (!u || !p || !c) {
      showAlert('error', 'Please fill in all operative credentials.');
      return;
    }
    if (p !== c) {
      showAlert('error', 'Security ciphers do not match.');
      return;
    }
    if (p.length < 6) {
      showAlert('error', 'Security cipher must be at least 6 characters.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> Enlisting Profile...';

    try {
      const res = await fetch('register.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ username: u, password: p })
      });
      const data = await res.json();

      if (data.status === 'success' || data.success) {
        showAlert('success', 'Profile enlisted! Entering Game Hub...');
        setTimeout(() => triggerWarpToDashboard(u), 350);
      } else {
        showAlert('error', data.message || 'Unable to register callsign.');
        btn.disabled = false;
        btnText.innerText = '⚡ ENLIST PROFILE & ENTER';
      }
    } catch (err) {
      showAlert('error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
      btn.disabled = false;
      btnText.innerText = '⚡ ENLIST PROFILE & ENTER';
    }
  }

  // =========================================================
  // KINETIC GRID ENGINE (60 FPS Canvas with Cursor & Touch Warp)
  // =========================================================
  (function initKineticGrid() {
    const canvas = document.getElementById('techRaysCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let W = 0, H = 0, horizonY = 0;
    const CELL_SIZE = 55;
    const INFLUENCE_RADIUS = 260;
    const MAX_WARP = 24;
    const DOT_SPACING = 30;
    const LERP_SPEED = 0.08;

    const LINE_BASE = { r: 0, g: 240, b: 255, a: 0.18 };
    const LINE_ACTIVE = { r: 74, g: 158, b: 255, a: 0.95 };
    const NODE_ACTIVE = { r: 74, g: 158, b: 255, a: 1.0 };
    const NODE_BASE_RADIUS = 1.8;
    const NODE_ACTIVE_RADIUS = 3.5;

    const mouse = { x: -9999, y: -9999 };
    const targetMouse = { x: -9999, y: -9999 };
    const ripples = [];

    function resize() {
      W = canvas.width = window.innerWidth;
      H = canvas.height = window.innerHeight;
      horizonY = Math.round(H * 0.78);
    }
    window.addEventListener('resize', resize);
    resize();

    window.addEventListener('mousemove', (e) => {
      targetMouse.x = e.clientX;
      targetMouse.y = e.clientY;
    });
    window.addEventListener('mouseleave', () => {
      targetMouse.x = -9999;
      targetMouse.y = -9999;
    });

    // Touch support for mobile
    window.addEventListener('touchmove', (e) => {
      if (e.touches.length > 0) {
        targetMouse.x = e.touches[0].clientX;
        targetMouse.y = e.touches[0].clientY;
      }
    }, { passive: true });
    window.addEventListener('touchend', () => {
      targetMouse.x = -9999;
      targetMouse.y = -9999;
    });

    window.addEventListener('click', (e) => {
      ripples.push({
        x: e.clientX,
        y: e.clientY,
        radius: 0,
        maxRadius: Math.max(W, H) * 0.45,
        alpha: 0.85,
        speed: 12
      });
    });

    function getDisplacement(px, py) {
      let dx = px - mouse.x;
      let dy = py - mouse.y;
      let d = Math.hypot(dx, dy);
      let wx = 0, wy = 0;
      let factor = 0;

      if (d < INFLUENCE_RADIUS && d > 0.001) {
        let f = Math.sin((1 - d / INFLUENCE_RADIUS) * (Math.PI / 2));
        wx = (dx / d) * f * MAX_WARP;
        wy = (dy / d) * f * MAX_WARP;
        factor = f;
      }

      for (let i = 0; i < ripples.length; i++) {
        let rip = ripples[i];
        let rdx = px - rip.x;
        let rdy = py - rip.y;
        let rd = Math.hypot(rdx, rdy);
        let distFromRing = Math.abs(rd - rip.radius);
        if (distFromRing < 45 && rd > 0.001) {
          let rf = (1 - distFromRing / 45) * rip.alpha;
          wx += (rdx / rd) * rf * 16;
          wy += (rdy / rd) * rf * 16;
          factor = Math.max(factor, rf);
        }
      }

      return { x: px + wx, y: py + wy, factor: Math.min(factor, 1) };
    }

    function lerpColor(c1, c2, t) {
      return 'rgba(' +
        Math.round(c1.r + (c2.r - c1.r) * t) + ',' +
        Math.round(c1.g + (c2.g - c1.g) * t) + ',' +
        Math.round(c1.b + (c2.b - c1.b) * t) + ',' +
        (c1.a + (c2.a - c1.a) * t).toFixed(3) + ')';
    }

    let cols = 0, rows = 0;
    let grid = [];

    function rebuildGrid() {
      cols = Math.ceil(W / CELL_SIZE) + 2;
      rows = Math.ceil(H / CELL_SIZE) + 2;
      grid = [];
      for (let r = 0; r < rows; r++) {
        grid[r] = [];
        for (let c = 0; c < cols; c++) {
          grid[r][c] = { origX: c * CELL_SIZE, origY: r * CELL_SIZE };
        }
      }
    }
    rebuildGrid();
    window.addEventListener('resize', rebuildGrid);

    function frame() {
      mouse.x += (targetMouse.x - mouse.x) * LERP_SPEED;
      mouse.y += (targetMouse.y - mouse.y) * LERP_SPEED;

      for (let i = ripples.length - 1; i >= 0; i--) {
        let rip = ripples[i];
        rip.radius += rip.speed;
        rip.alpha -= 0.022;
        if (rip.alpha <= 0 || rip.radius > rip.maxRadius) {
          ripples.splice(i, 1);
        }
      }

      ctx.clearRect(0, 0, W, H);

      let pts = [];
      for (let r = 0; r < rows; r++) {
        pts[r] = [];
        for (let c = 0; c < cols; c++) {
          let node = grid[r][c];
          pts[r][c] = getDisplacement(node.origX, node.origY);
        }
      }

      // Draw Lines
      for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
          let p = pts[r][c];

          if (c < cols - 1) {
            let pr = pts[r][c + 1];
            let avgFactor = (p.factor + pr.factor) * 0.5;
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(pr.x, pr.y);
            ctx.strokeStyle = lerpColor(LINE_BASE, LINE_ACTIVE, avgFactor);
            ctx.lineWidth = avgFactor > 0.05 ? 1 + avgFactor * 1.5 : 0.8;
            ctx.stroke();
          }

          if (r < rows - 1) {
            let pb = pts[r + 1][c];
            let avgFactor = (p.factor + pb.factor) * 0.5;
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(pb.x, pb.y);
            ctx.strokeStyle = lerpColor(LINE_BASE, LINE_ACTIVE, avgFactor);
            ctx.lineWidth = avgFactor > 0.05 ? 1 + avgFactor * 1.5 : 0.8;
            ctx.stroke();
          }
        }
      }

      // Draw Glowing Intersections
      for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
          let p = pts[r][c];
          if (p.factor > 0.04) {
            let rad = NODE_BASE_RADIUS + (NODE_ACTIVE_RADIUS - NODE_BASE_RADIUS) * p.factor;
            ctx.beginPath();
            ctx.arc(p.x, p.y, rad, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(' + NODE_ACTIVE.r + ',' + NODE_ACTIVE.g + ',' + NODE_ACTIVE.b + ',' + p.factor.toFixed(2) + ')';
            ctx.fill();

            if (p.factor > 0.3) {
              ctx.beginPath();
              ctx.arc(p.x, p.y, rad * 2.2, 0, Math.PI * 2);
              ctx.fillStyle = 'rgba(' + NODE_ACTIVE.r + ',' + NODE_ACTIVE.g + ',' + NODE_ACTIVE.b + ',' + (p.factor * 0.25).toFixed(2) + ')';
              ctx.fill();
            }
          }
        }
      }

      requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  })();
</script>
</body>
</html>
