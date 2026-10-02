<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
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

  /* Post-Auth Transition Overlay (loader.tsx implementation) */
  .auth-transition-overlay {
    position: fixed;
    inset: 0;
    z-index: 10000;
    display: flex;
    align-items: center;
    justify-content: center;
    background: radial-gradient(circle at 50% 50%, rgba(6, 13, 28, 0.96) 0%, rgba(2, 4, 10, 0.99) 100%);
    backdrop-filter: blur(28px) saturate(140%);
    -webkit-backdrop-filter: blur(28px) saturate(140%);
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.35s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .auth-transition-overlay.active {
    opacity: 1;
    pointer-events: auto;
  }
  .auth-transition-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 2rem;
    padding: 2rem;
  }

  /* Multi-Ring Conic Loader matching loader.tsx */
  .deliberate-loader-container {
    position: relative;
    width: 8rem; /* size-32 */
    height: 8rem;
    animation: loaderContainerBreathe 4s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  }
  @keyframes loaderContainerBreathe {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.03); }
  }

  /* Outer Ring with shimmer */
  .loader-ring-outer {
    position: absolute;
    inset: 0;
    border-radius: 9999px;
    background: conic-gradient(from 0deg, transparent 0deg, rgba(255, 255, 255, 0.95) 90deg, transparent 180deg);
    -webkit-mask: radial-gradient(circle at 50% 50%, transparent 66%, black 67%);
    mask: radial-gradient(circle at 50% 50%, transparent 66%, black 67%);
    animation: loaderSpinClockwise 3s linear infinite;
  }

  /* Counter-Rotating Middle Ring */
  .loader-ring-middle {
    position: absolute;
    inset: 8px; /* inset-2 */
    border-radius: 9999px;
    background: conic-gradient(from 180deg, transparent 0deg, rgba(255, 255, 255, 0.9) 180deg, transparent 270deg);
    -webkit-mask: radial-gradient(circle at 50% 50%, transparent 64%, black 65%);
    mask: radial-gradient(circle at 50% 50%, transparent 64%, black 65%);
    animation: loaderSpinCounter 2.5s linear infinite;
  }

  /* Inner Pulsing Ring */
  .loader-ring-inner {
    position: absolute;
    inset: 16px; /* inset-4 */
    border-radius: 9999px;
    background: conic-gradient(from 90deg, transparent 0deg, rgba(0, 240, 255, 0.95) 90deg, transparent 135deg);
    -webkit-mask: radial-gradient(circle at 50% 50%, transparent 60%, black 62%);
    mask: radial-gradient(circle at 50% 50%, transparent 60%, black 62%);
    animation: loaderSpinClockwise 2s linear infinite, loaderInnerScale 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  }

  @keyframes loaderSpinClockwise {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  @keyframes loaderSpinCounter {
    from { transform: rotate(360deg); }
    to { transform: rotate(0deg); }
  }
  @keyframes loaderInnerScale {
    0%, 100% { transform: scale(0.98); }
    50% { transform: scale(1.02); }
  }

  /* Center Precision Dot */
  .loader-center-dot {
    position: absolute;
    inset: 0;
    margin: auto;
    width: 6px;
    height: 6px;
    border-radius: 9999px;
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 0 10px rgba(0, 240, 255, 0.85);
  }

  /* Minimal Accent Particles Orbit */
  .loader-particles-orbit {
    position: absolute;
    inset: 0;
    animation: loaderSpinClockwise 8s linear infinite;
    pointer-events: none;
  }
  .loader-particle-dot {
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    border-radius: 9999px;
  }
  .loader-particle-dot.dot-top {
    top: 0;
    width: 4px;
    height: 4px;
    background: rgba(255, 255, 255, 0.8);
    box-shadow: 0 0 8px rgba(0, 240, 255, 0.9);
  }
  .loader-particle-dot.dot-bottom {
    bottom: 0;
    width: 2.5px;
    height: 2.5px;
    background: rgba(255, 255, 255, 0.45);
  }

  /* Modern Typography with Breathing Opacity */
  .loader-typography {
    text-align: center;
    max-width: 18rem; /* max-w-64 */
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    animation: loaderTextBreath 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  }
  @keyframes loaderTextBreath {
    0%, 100% { opacity: 0.68; }
    50% { opacity: 1; }
  }
  .loader-title {
    font-size: 1.05rem;
    font-weight: 600;
    letter-spacing: -0.015em;
    color: #f8fafc;
    margin: 0;
  }
  .loader-subtitle {
    font-size: 0.875rem;
    line-height: 1.45;
    color: #94a3b8;
    margin: 0;
  }

  /* Main Floating Space Terminal Auth Card with White-to-Blue Dual Gradient */
  .auth-portal-card {
    position: relative;
    z-index: 10;
    width: 92vw;
    max-width: 440px;
    max-height: 96dvh;
    overflow: hidden !important;
    scrollbar-width: none !important;
    -ms-overflow-style: none !important;
    background: radial-gradient(circle at 50% 0%, rgba(0, 240, 255, 0.14) 0%, rgba(4, 9, 22, 0.94) 75%);
    backdrop-filter: blur(28px);
    -webkit-backdrop-filter: blur(28px);
    border: 1px solid rgba(0, 240, 255, 0.35);
    border-radius: 24px;
    padding: 1.45rem 1.75rem;
    box-shadow: 0 0 50px rgba(0, 240, 255, 0.18), 0 30px 80px rgba(0, 0, 0, 0.95);
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    animation: cardSpringIn 0.55s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
    transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.35s ease, filter 0.35s ease;
    box-sizing: border-box;
  }
  .auth-portal-card::-webkit-scrollbar {
    display: none !important;
    width: 0 !important;
    height: 0 !important;
  }

  /* Top Glowing Cyber Beam with White-to-Blue Spectrum */
  .auth-portal-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 10%;
    right: 10%;
    height: 2px;
    background: linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.9) 25%, #00f0ff 75%, transparent 100%);
    box-shadow: 0 0 16px rgba(0, 240, 255, 0.8);
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
    border: 1px solid rgba(0, 240, 255, 0.32);
    padding: 4px 12px;
    border-radius: 9999px;
    font-size: 0.70rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: #00f0ff;
    text-transform: uppercase;
    margin-bottom: 0.55rem;
    box-shadow: 0 0 16px rgba(0, 240, 255, 0.2);
  }
  .portal-tag::before {
    content: '';
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #10e6a8;
    box-shadow: 0 0 8px #10e6a8;
    animation: pulseDot 1.8s infinite;
  }
  @keyframes pulseDot {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.3); opacity: 0.6; }
  }

  .portal-title {
    font-size: clamp(1.6rem, 4.5vw, 2.1rem);
    font-weight: 900;
    letter-spacing: 2.5px;
    color: #ffffff;
    text-shadow: 0 0 25px rgba(0, 240, 255, 0.45);
    margin: 0 0 0.25rem 0;
    line-height: 1.1;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
  }
  .portal-title span {
    color: var(--primary);
    text-shadow: 0 0 35px var(--primary);
  }

  /* Hollow HUB with Pure White Outline Lines */
  .hollow-hub {
    color: transparent !important;
    -webkit-text-fill-color: transparent !important;
    -webkit-text-stroke: 1.8px #ffffff !important;
    text-stroke: 1.8px #ffffff !important;
    letter-spacing: 3.5px;
    font-weight: 900;
    display: inline-block;
    filter: drop-shadow(0 0 12px rgba(255, 255, 255, 0.75));
    transition: filter 0.3s cubic-bezier(0.16, 1, 0.3, 1), -webkit-text-stroke 0.3s ease;
  }
  .hollow-hub:hover {
    filter: drop-shadow(0 0 20px rgba(255, 255, 255, 0.95)) drop-shadow(0 0 30px rgba(var(--panel-rgb, 0, 240, 255), 0.7));
    -webkit-text-stroke: 2.2px #ffffff !important;
  }

  .portal-subtitle {
    font-size: 0.78rem;
    line-height: 1.38;
    color: var(--text-muted);
    margin-bottom: 0.85rem;
    max-width: 360px;
  }

  /* Framer-Motion Tab Switcher */
  .auth-tabs {
    display: flex;
    width: 100%;
    background: rgba(2, 4, 10, 0.75);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 12px;
    padding: 3px;
    margin-bottom: 0.85rem;
    gap: 4px;
    box-sizing: border-box;
  }
  .auth-tab {
    flex: 1;
    padding: 7px 10px;
    background: transparent;
    border: none;
    border-radius: 9px;
    color: var(--text-muted);
    font-weight: 800;
    font-size: 0.76rem;
    letter-spacing: 1.5px;
    cursor: pointer;
    transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .auth-tab:hover {
    color: #ffffff;
  }
  .auth-tab.active {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.22) 0%, var(--primary) 100%);
    color: #02040a;
    box-shadow: 0 0 18px rgba(0, 240, 255, 0.45);
  }

  /* Forms & Inputs */
  .auth-form-wrap {
    width: 100%;
    display: none;
    flex-direction: column;
    gap: 9px;
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
    gap: 3px;
  }
  .auth-input-label {
    font-size: 0.65rem;
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
    left: 13px;
    font-size: 0.9rem;
    pointer-events: none;
    opacity: 0.8;
  }
  .auth-field {
    width: 100%;
    background: rgba(2, 4, 10, 0.85);
    border: 1px solid rgba(0, 240, 255, 0.25);
    border-radius: 11px;
    padding: 9px 12px 9px 38px;
    color: #ffffff;
    font-size: 14px !important;
    outline: none;
    transition: all 0.2s ease;
    box-sizing: border-box;
  }
  .auth-field:focus {
    border-color: var(--primary);
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.35);
    background: rgba(2, 6, 16, 0.95);
  }
  .auth-field::placeholder {
    color: rgba(255, 255, 255, 0.25);
    font-size: 0.80rem;
  }

  /* Action Buttons with Spring Micro-interactions */
  .btn-submit {
    width: 100%;
    padding: 11px 16px;
    border: none;
    border-radius: 12px;
    background: linear-gradient(135deg, #ffffff 0%, var(--primary) 40%, #0284c7 100%);
    color: #02040a;
    font-weight: 900;
    font-size: 0.82rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    cursor: pointer;
    box-shadow: 0 0 25px rgba(0, 240, 255, 0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 4px;
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
    margin-top: 0.75rem;
    padding-top: 0.75rem;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
  }
  .btn-guest {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: var(--text-muted);
    padding: 8px 14px;
    border-radius: 11px;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 1px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    width: 100%;
    justify-content: center;
    box-sizing: border-box;
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

  <!-- =========================================================
       POST-AUTH TRANSITION SCREEN (loader.tsx Implementation)
       ========================================================= -->
  <div id="authTransitionOverlay" class="auth-transition-overlay" aria-hidden="true">
    <div class="auth-transition-card">
      <!-- Enhanced Monochrome Multi-Ring Conic Loader -->
      <div class="deliberate-loader-container">
        <!-- Outer elegant ring with shimmer -->
        <div class="loader-ring loader-ring-outer"></div>
        <!-- Counter-rotating middle ring -->
        <div class="loader-ring loader-ring-middle"></div>
        <!-- Inner pulsing ring with subtle gradient -->
        <div class="loader-ring loader-ring-inner"></div>
        <!-- Center precision dot -->
        <div class="loader-center-dot"></div>
        <!-- Minimal accent particles orbit -->
        <div class="loader-particles-orbit">
          <div class="loader-particle-dot dot-top"></div>
          <div class="loader-particle-dot dot-bottom"></div>
        </div>
      </div>

      <!-- Modern typography with subtle breathing animation -->
      <div class="loader-typography">
        <h3 id="loaderTitle" class="loader-title">Configuring your account...</h3>
        <p id="loaderSubtitle" class="loader-subtitle">Please wait while we prepare everything for you</p>
      </div>
    </div>
  </div>

  <!-- Dedicated Space Terminal Auth Card -->
  <div class="auth-portal-card" id="authCard">
    <div class="portal-tag">🧠 BRAIN AGILITY & LOGIC PLATFORM</div>
    <h1 class="portal-title">GAME <span class="hollow-hub">HUB</span></h1>
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

  function showAuthTransition(title, subtitle, durationMs, onFinished) {
    const overlay = document.getElementById('authTransitionOverlay');
    const titleEl = document.getElementById('loaderTitle');
    const subEl = document.getElementById('loaderSubtitle');
    if (titleEl && title) titleEl.innerText = title;
    if (subEl && subtitle) subEl.innerText = subtitle;

    if (overlay) {
      overlay.classList.add('active');
    }

    const waitTime = durationMs || 2600;
    setTimeout(() => {
      if (overlay) overlay.classList.remove('active');
      if (onFinished) onFinished();
    }, waitTime);
  }

  // Framer Motion Kinetic Transition to Dashboard
  function triggerWarpToDashboard(callsign) {
    const card = document.getElementById('authCard');
    const Motion = (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;

    if (card) {
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(card, { opacity: [1, 0], scale: [1, 0.95], y: [0, -16], filter: ['blur(0px)', 'blur(8px)'] }, { duration: 0.25, ease: [0.16, 1, 0.3, 1] });
      } else {
        card.classList.add('warp-out');
      }
    }

    sessionStorage.setItem('hub_portal_passed', 'true');
    sessionStorage.setItem('hub_session_user', callsign || 'Operative');

    showAuthTransition(
      'Configuring your account...',
      'Please wait while we prepare everything for you',
      2600,
      () => {
        window.location.href = 'index.jsp';
      }
    );
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
  // KINETIC GRID ENGINE (White-to-Blue Spectrum 60 FPS Canvas)
  // =========================================================
  (function initKineticGrid() {
    const canvas = document.getElementById('techRaysCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let W = 0, H = 0;
    const CELL_SIZE = 52;
    const INFLUENCE_RADIUS = 260;
    const MAX_WARP = 24;
    const LERP_SPEED = 0.08;

    const mouse = { x: -9999, y: -9999 };
    const targetMouse = { x: -9999, y: -9999 };
    const ripples = [];

    let cols = 0, rows = 0;
    let grid = [];

    // Pre-computed canvas gradients
    let baseLineGrad = null;
    let activeLineGrad = null;

    function resize() {
      W = canvas.width = window.innerWidth;
      H = canvas.height = window.innerHeight;

      // Rebuild high-performance linear gradients across the screen (white on left -> electric blue on right)
      baseLineGrad = ctx.createLinearGradient(0, 0, W, 0);
      baseLineGrad.addColorStop(0, 'rgba(255, 255, 255, 0.38)');
      baseLineGrad.addColorStop(0.5, 'rgba(160, 240, 255, 0.34)');
      baseLineGrad.addColorStop(1, 'rgba(0, 240, 255, 0.38)');

      activeLineGrad = ctx.createLinearGradient(0, 0, W, 0);
      activeLineGrad.addColorStop(0, 'rgba(255, 255, 255, 0.95)');
      activeLineGrad.addColorStop(0.5, 'rgba(180, 245, 255, 0.95)');
      activeLineGrad.addColorStop(1, 'rgba(0, 240, 255, 0.95)');

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

      // Pass 1: Draw ALL idle grid lines in a single fast batched draw call with the White-to-Blue gradient
      ctx.beginPath();
      for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
          let p = pts[r][c];
          if (c < cols - 1) {
            let pr = pts[r][c + 1];
            if ((p.factor + pr.factor) * 0.5 <= 0.05) {
              ctx.moveTo(p.x, p.y);
              ctx.lineTo(pr.x, pr.y);
            }
          }
          if (r < rows - 1) {
            let pb = pts[r + 1][c];
            if ((p.factor + pb.factor) * 0.5 <= 0.05) {
              ctx.moveTo(p.x, p.y);
              ctx.lineTo(pb.x, pb.y);
            }
          }
        }
      }
      ctx.strokeStyle = baseLineGrad;
      ctx.lineWidth = 0.95;
      ctx.stroke();

      // Pass 2: Draw active warped lines near cursor / ripples with bright highlight gradient
      ctx.beginPath();
      for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
          let p = pts[r][c];
          if (c < cols - 1) {
            let pr = pts[r][c + 1];
            if ((p.factor + pr.factor) * 0.5 > 0.05) {
              ctx.moveTo(p.x, p.y);
              ctx.lineTo(pr.x, pr.y);
            }
          }
          if (r < rows - 1) {
            let pb = pts[r + 1][c];
            if ((p.factor + pb.factor) * 0.5 > 0.05) {
              ctx.moveTo(p.x, p.y);
              ctx.lineTo(pb.x, pb.y);
            }
          }
        }
      }
      ctx.strokeStyle = activeLineGrad;
      ctx.lineWidth = 2.0;
      ctx.stroke();

      // Pass 3: Draw Glowing Intersection Nodes (White on left, Cyan on right)
      for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
          let p = pts[r][c];
          if (p.factor > 0.035) {
            let ratio = Math.max(0, Math.min(1, p.x / W));
            let nr = Math.round(255 * (1 - ratio));
            let ng = Math.round(255 * (1 - ratio) + 240 * ratio);
            let rad = 1.8 + 2.4 * p.factor;

            ctx.beginPath();
            ctx.arc(p.x, p.y, rad, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(' + nr + ',' + ng + ',255,' + p.factor.toFixed(2) + ')';
            ctx.fill();

            if (p.factor > 0.25) {
              ctx.beginPath();
              ctx.arc(p.x, p.y, rad * 2.2, 0, Math.PI * 2);
              ctx.fillStyle = 'rgba(' + nr + ',' + ng + ',255,' + (p.factor * 0.35).toFixed(2) + ')';
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
