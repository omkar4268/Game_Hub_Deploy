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
    --bg-base: #030e24;
    --card-bg: rgba(7, 24, 56, 0.94);
    --border-glow: rgba(0, 240, 255, 0.55);
    --border-cyan: rgba(0, 240, 255, 0.42);
    --primary: #00f0ff;
    --primary-rgb: 0, 240, 255;
    --primary-glow: rgba(0, 240, 255, 0.65);
    --accent: #38bdf8;
    --accent-glow: rgba(56, 189, 248, 0.55);
    --text-main: #f0f9ff;
    --text-muted: #7dd3fc;
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
    background: #000000;
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
    position: relative;
    z-index: 5;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 2rem;
    padding: 2rem;
  }

  /* Digital Cyber Matrix Background for Loading Screen */
  .digital-bg-matrix {
    position: absolute;
    inset: 0;
    pointer-events: none;
    overflow: hidden;
    z-index: 1;
  }
  .digital-grid-floor {
    position: absolute;
    bottom: -10%;
    left: -25%;
    right: -25%;
    height: 60%;
    background:
      linear-gradient(180deg, transparent 0%, rgba(0, 240, 255, 0.08) 100%),
      linear-gradient(90deg, rgba(0, 240, 255, 0.12) 1px, transparent 1px),
      linear-gradient(0deg, rgba(0, 240, 255, 0.12) 1px, transparent 1px);
    background-size: 100% 100%, 46px 46px, 46px 46px;
    transform: perspective(420px) rotateX(62deg);
    transform-origin: bottom center;
    opacity: 0.75;
    mask-image: linear-gradient(180deg, transparent 0%, black 40%, black 100%);
    -webkit-mask-image: linear-gradient(180deg, transparent 0%, black 40%, black 100%);
  }
  .digital-radar-system {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 680px;
    height: 680px;
    border-radius: 50%;
    pointer-events: none;
  }
  .digital-radar-circle {
    position: absolute;
    inset: 0;
    margin: auto;
    border-radius: 50%;
  }
  .digital-radar-circle.c-1 {
    width: 250px;
    height: 250px;
    border: 1px solid rgba(255, 255, 255, 0.18);
    animation: radarPulse 4s ease-in-out infinite;
  }
  .digital-radar-circle.c-2 {
    width: 440px;
    height: 440px;
    border: 1px dashed rgba(0, 240, 255, 0.22);
    animation: loaderSpinClockwise 45s linear infinite;
  }
  .digital-radar-circle.c-3 {
    width: 640px;
    height: 640px;
    border: 1px dotted rgba(0, 240, 255, 0.16);
  }
  .digital-radar-crosshair-h {
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, rgba(0, 240, 255, 0.35) 20%, transparent 45%, transparent 55%, rgba(0, 240, 255, 0.35) 80%, transparent 100%);
  }
  .digital-radar-crosshair-v {
    position: absolute;
    left: 50%;
    top: 0;
    bottom: 0;
    width: 1px;
    background: linear-gradient(180deg, transparent 0%, rgba(0, 240, 255, 0.35) 20%, transparent 45%, transparent 55%, rgba(0, 240, 255, 0.35) 80%, transparent 100%);
  }
  .digital-radar-sweep {
    position: absolute;
    inset: 40px;
    border-radius: 50%;
    background: conic-gradient(from 0deg, transparent 0deg, rgba(0, 240, 255, 0.12) 65deg, transparent 70deg);
    animation: loaderSpinClockwise 4s linear infinite;
  }
  @keyframes radarPulse {
    0%, 100% { transform: scale(1); opacity: 0.55; }
    50% { transform: scale(1.05); opacity: 0.9; }
  }

  /* HUD Telemetry Diagnostics on Loading Screen */
  .digital-hud-corner {
    position: absolute;
    display: flex;
    flex-direction: column;
    gap: 4px;
    font-family: 'SF Mono', 'Consolas', 'Courier New', monospace;
    font-size: 0.70rem;
    letter-spacing: 1.5px;
    color: rgba(0, 240, 255, 0.65);
    pointer-events: none;
    z-index: 2;
  }
  .digital-hud-corner .hud-status {
    color: rgba(255, 255, 255, 0.85);
    font-weight: 700;
  }
  .hud-top-left { top: 30px; left: 32px; }
  .hud-top-right { top: 30px; right: 32px; text-align: right; }
  .hud-bottom-left { bottom: 30px; left: 32px; }
  .hud-bottom-right { bottom: 30px; right: 32px; text-align: right; }
  .digital-hex-stream {
    position: absolute;
    top: 40%;
    font-family: 'SF Mono', 'Consolas', monospace;
    font-size: 0.65rem;
    letter-spacing: 3px;
    color: rgba(0, 240, 255, 0.28);
    writing-mode: vertical-rl;
    animation: hexFlicker 3s infinite alternate;
  }
  .stream-left { left: 36px; }
  .stream-right { right: 36px; }
  @keyframes hexFlicker {
    0% { opacity: 0.2; }
    50% { opacity: 0.45; }
    100% { opacity: 0.25; }
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
    background: conic-gradient(from 0deg, transparent 0deg, rgba(0, 240, 255, 0.9) 70deg, #ffffff 90deg, transparent 180deg);
    -webkit-mask: radial-gradient(circle at 50% 50%, transparent 66%, black 67%);
    mask: radial-gradient(circle at 50% 50%, transparent 66%, black 67%);
    animation: loaderSpinClockwise 3s linear infinite;
    filter: drop-shadow(0 0 16px rgba(0, 240, 255, 0.7));
  }

  /* Counter-Rotating Middle Ring */
  .loader-ring-middle {
    position: absolute;
    inset: 8px; /* inset-2 */
    border-radius: 9999px;
    background: conic-gradient(from 180deg, transparent 0deg, rgba(56, 189, 248, 0.9) 160deg, #bae6fd 180deg, transparent 270deg);
    -webkit-mask: radial-gradient(circle at 50% 50%, transparent 64%, black 65%);
    mask: radial-gradient(circle at 50% 50%, transparent 64%, black 65%);
    animation: loaderSpinCounter 2.5s linear infinite;
    filter: drop-shadow(0 0 12px rgba(56, 189, 248, 0.6));
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
    filter: drop-shadow(0 0 10px rgba(0, 240, 255, 0.8));
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

  /* 3D Scene Perspective Wrapper (from sign-in-card-2) */
  .auth-3d-scene {
    perspective: 1500px;
    position: relative;
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    max-width: 440px;
  }

  /* Monochromatic Obsidian Space Glass Terminal with White-to-Blue Gradient Outline */
  .auth-portal-card {
    position: relative;
    z-index: 10;
    width: 92vw;
    max-width: 440px;
    max-height: 96dvh;
    overflow: hidden !important;
    scrollbar-width: none !important;
    -ms-overflow-style: none !important;
    box-sizing: border-box;
    border-radius: 24px;
    /* Clean uniform obsidian space glass interior, with gradient outline (White to Tech Blue) */
    background:
      linear-gradient(rgba(8, 9, 14, 0.92), rgba(8, 9, 14, 0.92)) padding-box,
      linear-gradient(135deg,
        rgba(255, 255, 255, 0.95) 0%,
        rgba(255, 255, 255, 0.70) 30%,
        rgba(56, 189, 248, 0.85) 70%,
        #00f0ff 100%
      ) border-box;
    border: 1.8px solid transparent;
    backdrop-filter: blur(28px) saturate(110%);
    -webkit-backdrop-filter: blur(28px) saturate(110%);
    padding: 1.6rem 1.9rem;
    box-shadow:
      0 25px 70px rgba(0, 0, 0, 0.95),
      -8px -8px 30px rgba(255, 255, 255, 0.10),
      8px 8px 35px rgba(0, 240, 255, 0.22),
      inset 0 1px 0 rgba(255, 255, 255, 0.3);
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    transform-style: preserve-3d;
    will-change: transform;
    animation: cardGlowPulse 4s ease-in-out infinite alternate;
    transition: opacity 0.35s ease, filter 0.35s ease;
  }
  .auth-portal-card::-webkit-scrollbar {
    display: none !important;
    width: 0 !important;
    height: 0 !important;
  }

  /* Traveling Light Beam Perimeter Circuit (Space White -> Tech Blue Gradient) */
  .card-beam-perimeter {
    position: absolute;
    inset: 0;
    border-radius: 24px;
    overflow: hidden;
    pointer-events: none;
    z-index: 3;
  }

  /* Top Light Beam: Space White on left -> Tech Cyan on right */
  .beam-runner.beam-top {
    position: absolute;
    top: 0;
    left: -50%;
    height: 2.5px;
    width: 50%;
    background: linear-gradient(90deg, transparent 0%, #ffffff 35%, #7dd3fc 60%, #00f0ff 85%, transparent 100%);
    filter: blur(1.2px);
    box-shadow: 0 0 14px rgba(255, 255, 255, 0.8), 0 0 14px rgba(0, 240, 255, 0.8);
    animation: beamMoveTop 3.5s cubic-bezier(0.4, 0, 0.2, 1) infinite;
  }

  /* Right Light Beam: Tech Blue to Cyan */
  .beam-runner.beam-right {
    position: absolute;
    top: -50%;
    right: 0;
    width: 2.5px;
    height: 50%;
    background: linear-gradient(180deg, transparent 0%, rgba(56, 189, 248, 0.95) 50%, #00f0ff 85%, transparent 100%);
    filter: blur(1.5px);
    box-shadow: 0 0 16px rgba(0, 240, 255, 0.95), 0 0 8px #00f0ff;
    animation: beamMoveRight 3.5s cubic-bezier(0.4, 0, 0.2, 1) 0.6s infinite;
  }

  /* Bottom Light Beam: Electric Cyan on right -> Space White on left */
  .beam-runner.beam-bottom {
    position: absolute;
    bottom: 0;
    right: -50%;
    height: 2.5px;
    width: 50%;
    background: linear-gradient(270deg, transparent 0%, #00f0ff 35%, #7dd3fc 60%, #ffffff 85%, transparent 100%);
    filter: blur(1.2px);
    box-shadow: 0 0 14px rgba(0, 240, 255, 0.8), 0 0 14px rgba(255, 255, 255, 0.8);
    animation: beamMoveBottom 3.5s cubic-bezier(0.4, 0, 0.2, 1) 1.2s infinite;
  }

  /* Left Light Beam: Space White */
  .beam-runner.beam-left {
    position: absolute;
    bottom: -50%;
    left: 0;
    width: 2.5px;
    height: 50%;
    background: linear-gradient(0deg, transparent 0%, rgba(255, 255, 255, 0.98) 50%, #ffffff 85%, transparent 100%);
    filter: blur(1px);
    box-shadow: 0 0 14px #ffffff, 0 0 6px #ffffff;
    animation: beamMoveLeft 3.5s cubic-bezier(0.4, 0, 0.2, 1) 1.8s infinite;
  }

  @keyframes beamMoveTop {
    0% { left: -50%; opacity: 0.3; filter: blur(1px); }
    35%, 65% { opacity: 0.95; filter: blur(2px); }
    100% { left: 100%; opacity: 0.3; filter: blur(1px); }
  }

  @keyframes beamMoveRight {
    0% { top: -50%; opacity: 0.3; filter: blur(1px); }
    35%, 65% { opacity: 0.95; filter: blur(2px); }
    100% { top: 100%; opacity: 0.3; filter: blur(1px); }
  }

  @keyframes beamMoveBottom {
    0% { right: -50%; opacity: 0.3; filter: blur(1px); }
    35%, 65% { opacity: 0.95; filter: blur(2px); }
    100% { right: 100%; opacity: 0.3; filter: blur(1px); }
  }

  @keyframes beamMoveLeft {
    0% { bottom: -50%; opacity: 0.3; filter: blur(1px); }
    35%, 65% { opacity: 0.95; filter: blur(2px); }
    100% { bottom: 100%; opacity: 0.3; filter: blur(1px); }
  }

  /* Corner Glow Dots: Pure Space White on top-left, Vivid Tech Cyan on bottom-right */
  .beam-corner-dot {
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
    z-index: 4;
  }
  .beam-corner-dot.dot-tl {
    top: 3px;
    left: 3px;
    width: 6px;
    height: 6px;
    background: #ffffff;
    box-shadow: 0 0 14px #ffffff, 0 0 24px rgba(255, 255, 255, 0.9);
    animation: cornerPulseDot 2s ease-in-out infinite alternate;
  }
  .beam-corner-dot.dot-tr {
    top: 3px;
    right: 3px;
    width: 7px;
    height: 7px;
    background: #bae6fd;
    box-shadow: 0 0 12px #38bdf8, 0 0 20px rgba(56, 189, 248, 0.85);
    animation: cornerPulseDot 2.4s ease-in-out 0.5s infinite alternate;
  }
  .beam-corner-dot.dot-br {
    bottom: 3px;
    right: 3px;
    width: 7px;
    height: 7px;
    background: #00f0ff;
    box-shadow: 0 0 14px #00f0ff, 0 0 26px rgba(0, 240, 255, 0.9);
    animation: cornerPulseDot 2.2s ease-in-out 1.0s infinite alternate;
  }
  .beam-corner-dot.dot-bl {
    bottom: 3px;
    left: 3px;
    width: 6px;
    height: 6px;
    background: #bae6fd;
    box-shadow: 0 0 12px #ffffff, 0 0 20px rgba(186, 230, 253, 0.8);
    animation: cornerPulseDot 2.3s ease-in-out 1.5s infinite alternate;
  }

  @keyframes cornerPulseDot {
    0% { opacity: 0.4; transform: scale(0.85); }
    100% { opacity: 1; transform: scale(1.25); }
  }

  /* Subtle Card Border Glow Sheen (Diagonal 135deg Space White -> Tech Blue Gradient) */
  /* Card Border Glow Sheen (White-to-Blue Outline Gradient Accent) */
  .card-border-glow-sheen {
    position: absolute;
    inset: -1.5px;
    border-radius: 24px;
    border: 1.8px solid transparent;
    background: linear-gradient(135deg,
      rgba(255, 255, 255, 0.9) 0%,
      rgba(255, 255, 255, 0.5) 30%,
      rgba(56, 189, 248, 0.6) 70%,
      rgba(0, 240, 255, 0.85) 100%
    ) border-box;
    -webkit-mask: linear-gradient(#fff 0 0) padding-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
    mask-composite: exclude;
    pointer-events: none;
    opacity: 0.75;
    z-index: 2;
    filter: drop-shadow(-4px -4px 10px rgba(255, 255, 255, 0.3)) drop-shadow(4px 4px 12px rgba(0, 240, 255, 0.45));
    animation: borderSheenPulse 3.5s ease-in-out infinite alternate;
  }
  .auth-portal-card:hover .card-border-glow-sheen {
    opacity: 1;
  }
  @keyframes borderSheenPulse {
    0% { opacity: 0.55; }
    100% { opacity: 0.95; }
  }

  @keyframes cardGlowPulse {
    0% {
      box-shadow:
        0 25px 70px rgba(0, 0, 0, 0.95),
        -6px -6px 25px rgba(255, 255, 255, 0.08),
        6px 6px 30px rgba(0, 240, 255, 0.18),
        inset 0 1px 0 rgba(255, 255, 255, 0.25);
    }
    100% {
      box-shadow:
        0 25px 80px rgba(0, 0, 0, 0.95),
        -10px -10px 38px rgba(255, 255, 255, 0.15),
        10px 10px 42px rgba(0, 240, 255, 0.28),
        inset 0 1px 0 rgba(255, 255, 255, 0.4);
    }
  }

  /* Exit Spring Compression Warp */
  .auth-portal-card.warp-out {
    transform: scale(1.12) translateY(-20px) !important;
    opacity: 0;
    filter: blur(14px);
    pointer-events: none;
  }

  /* Badges & Titles matching index.jsp monochromatic clean aesthetic */
  .portal-tag {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.22);
    padding: 5px 14px;
    border-radius: 9999px;
    font-size: 0.70rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: #f1f5f9;
    text-transform: uppercase;
    margin-bottom: 0.70rem;
    box-shadow: 0 0 14px rgba(255, 255, 255, 0.08);
  }
  .portal-tag::before {
    content: '';
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #ffffff;
    box-shadow: 0 0 10px #ffffff;
    animation: pulseDot 1.8s infinite;
  }
  @keyframes pulseDot {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.3); opacity: 0.6; }
  }

  .portal-title {
    font-size: clamp(1.7rem, 4.5vw, 2.2rem);
    font-weight: 900;
    letter-spacing: 2.5px;
    margin: 0 0 0.35rem 0;
    line-height: 1.1;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    color: #ffffff;
    background: linear-gradient(180deg, #ffffff 40%, #cbd5e1 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    text-shadow: 0 2px 20px rgba(255, 255, 255, 0.35);
  }
  .portal-title span {
    color: #ffffff;
  }

  /* Hollow HUB with Pure White Lines Outline matching index.jsp */
  .hollow-hub {
    background: none !important;
    -webkit-background-clip: border-box !important;
    background-clip: border-box !important;
    color: transparent !important;
    -webkit-text-fill-color: transparent !important;
    -webkit-text-stroke: 1.8px #ffffff !important;
    text-stroke: 1.8px #ffffff !important;
    letter-spacing: 3.5px;
    font-weight: 900;
    display: inline-block;
    filter: drop-shadow(0 0 12px rgba(255, 255, 255, 0.7));
    transition: filter 0.3s cubic-bezier(0.16, 1, 0.3, 1), -webkit-text-stroke 0.3s ease;
  }
  .hollow-hub:hover {
    filter: drop-shadow(0 0 20px rgba(255, 255, 255, 0.95)) drop-shadow(0 0 30px rgba(0, 240, 255, 0.6));
    -webkit-text-stroke: 2.2px #ffffff !important;
  }

  .portal-subtitle {
    font-size: 0.80rem;
    line-height: 1.45;
    color: #94a3b8;
    margin-bottom: 0.95rem;
    max-width: 360px;
  }

  /* Monochromatic Tab Switcher matching first page buttons */
  .auth-tabs {
    position: relative;
    display: flex;
    width: 100%;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.16);
    box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.5);
    border-radius: 12px;
    padding: 4px;
    margin-bottom: 0.95rem;
    box-sizing: border-box;
    overflow: hidden;
  }
  .auth-tab-pill {
    position: absolute;
    top: 4px;
    bottom: 4px;
    left: 4px;
    width: calc(50% - 4px);
    background: #ffffff;
    box-shadow: 0 0 20px rgba(255, 255, 255, 0.6), 0 2px 6px rgba(0, 0, 0, 0.4);
    border-radius: 9px;
    pointer-events: none;
    z-index: 1;
    transition: transform 0.32s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  }
  .auth-tabs.is-login .auth-tab-pill {
    transform: translateX(100%);
  }
  .auth-tab {
    position: relative;
    z-index: 2;
    flex: 1;
    padding: 8px 10px;
    background: transparent;
    border: none;
    border-radius: 9px;
    color: #94a3b8;
    font-weight: 700;
    font-size: 0.76rem;
    letter-spacing: 1.5px;
    cursor: pointer;
    transition: color 0.22s ease;
  }
  .auth-tab:hover {
    color: #ffffff;
  }
  .auth-tab.active {
    color: #000000;
    font-weight: 900;
  }

  /* Morphing Forms & Monochromatic Inputs */
  .auth-form-wrap {
    width: 100%;
    display: none;
    flex-direction: column;
    gap: 9px;
    opacity: 0;
    transform: scale(0.96) translateY(8px);
    transition: opacity 0.22s cubic-bezier(0.16, 1, 0.3, 1), transform 0.26s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .auth-form-wrap.active {
    display: flex;
    opacity: 1;
    transform: scale(1) translateY(0);
  }

  .auth-input-group {
    display: flex;
    flex-direction: column;
    text-align: left;
    gap: 4px;
  }
  .auth-input-label {
    font-size: 0.68rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    font-weight: 700;
    color: #94a3b8;
  }
  .auth-input-box {
    position: relative;
    display: flex;
    align-items: center;
    border-radius: 12px;
    background: rgba(14, 16, 24, 0.85);
    border: 1px solid rgba(255, 255, 255, 0.16);
    box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.45);
    transition: transform 0.22s cubic-bezier(0.16, 1, 0.3, 1), border-color 0.2s ease, box-shadow 0.2s ease;
  }
  .auth-input-box:hover {
    transform: scale(1.01);
    border-color: rgba(255, 255, 255, 0.35);
    box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.4), 0 0 14px rgba(255, 255, 255, 0.08);
  }
  .auth-input-box:focus-within {
    transform: scale(1.015);
    border-color: #ffffff;
    box-shadow: inset 0 0 8px rgba(0, 0, 0, 0.4), 0 0 20px rgba(255, 255, 255, 0.25);
  }
  .auth-field {
    width: 100%;
    background: transparent !important;
    border: none !important;
    border-radius: 12px;
    padding: 10px 14px 10px 42px;
    color: #ffffff;
    font-size: 14px !important;
    outline: none;
    box-sizing: border-box;
    font-weight: 600;
  }
  .auth-field::placeholder {
    color: rgba(255, 255, 255, 0.35);
    font-size: 0.82rem;
  }
  .auth-svg-icon {
    position: absolute;
    left: 14px;
    width: 17px;
    height: 17px;
    pointer-events: none;
    stroke: #ffffff;
    filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.6));
    transition: transform 0.22s ease, filter 0.22s ease;
    z-index: 2;
  }
  .auth-input-box:focus-within .auth-svg-icon {
    transform: scale(1.15);
    filter: drop-shadow(0 0 10px #ffffff);
  }

  /* Action Buttons matching index.jsp primary and guest styles */
  .btn-submit {
    position: relative;
    overflow: hidden;
    width: 100%;
    padding: 12px 18px;
    border: none;
    border-radius: 12px;
    background: #ffffff;
    color: #000000;
    font-weight: 900;
    font-size: 0.84rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    cursor: pointer;
    box-shadow: 0 0 24px rgba(255, 255, 255, 0.45), 0 4px 14px rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 6px;
    transition: all 0.22s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  }
  .btn-shimmer-sweep {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.6) 50%, transparent 100%);
    transform: translateX(-100%);
    animation: btnShimmerSweep 3s cubic-bezier(0.4, 0, 0.2, 1) infinite;
    pointer-events: none;
    z-index: 1;
  }
  .btn-submit:hover .btn-shimmer-sweep {
    animation-duration: 1.5s;
  }
  .btn-submit span:not(.btn-shimmer-sweep) {
    position: relative;
    z-index: 2;
  }
  @keyframes btnShimmerSweep {
    0% { transform: translateX(-100%); }
    45%, 100% { transform: translateX(100%); }
  }
  .btn-submit:hover {
    background: #f1f5f9;
    box-shadow: 0 0 36px rgba(255, 255, 255, 0.8), 0 6px 20px rgba(0, 0, 0, 0.6);
    transform: translateY(-2px) scale(1.02);
  }
  .btn-submit:active {
    transform: scale(0.97);
  }
  .btn-submit:disabled {
    opacity: 0.55;
    cursor: not-allowed;
    transform: none;
  }

  .btn-signup-submit {
    background: #ffffff;
    color: #000000;
  }

  /* Guest Bypass Button matching btn-portal-guest on index.jsp */
  .guest-bypass-box {
    margin-top: 0.85rem;
    padding-top: 0.85rem;
    border-top: 1px solid rgba(255, 255, 255, 0.12);
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
  }
  .btn-guest {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.14);
    color: #94a3b8;
    padding: 10px 14px;
    border-radius: 12px;
    font-size: 0.78rem;
    font-weight: 700;
    letter-spacing: 1px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
    width: 100%;
    justify-content: center;
    box-sizing: border-box;
  }
  .btn-guest:hover {
    background: rgba(255, 255, 255, 0.09);
    border-color: rgba(255, 255, 255, 0.35);
    color: #ffffff;
    box-shadow: 0 0 18px rgba(255, 255, 255, 0.15);
    transform: translateY(-1px);
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
    <!-- Cinematic Cyber Digital Background -->
    <div class="digital-bg-matrix" aria-hidden="true">
      <div class="digital-grid-floor"></div>
      <div class="digital-radar-system">
        <div class="digital-radar-circle c-1"></div>
        <div class="digital-radar-circle c-2"></div>
        <div class="digital-radar-circle c-3"></div>
        <div class="digital-radar-crosshair-h"></div>
        <div class="digital-radar-crosshair-v"></div>
        <div class="digital-radar-sweep"></div>
      </div>
      <!-- HUD Telemetry Diagnostics -->
      <div class="digital-hud-corner hud-top-left">
        <span class="hud-tag">// SYSTEM_ID: GH-CORE-v3.5</span>
        <span class="hud-status">STATUS: INITIALIZING ENCRYPTION</span>
      </div>
      <div class="digital-hud-corner hud-top-right">
        <span class="hud-tag">// TELEMETRY_STREAM</span>
        <span class="hud-status">LATENCY: 0.12ms • 120 FPS</span>
      </div>
      <div class="digital-hud-corner hud-bottom-left">
        <span class="hud-tag">// MEMORY_ALLOC: 0x7FFF82A4</span>
        <span class="hud-status">NEURAL_BUS: PROTOCOLS SYNCED</span>
      </div>
      <div class="digital-hud-corner hud-bottom-right">
        <span class="hud-tag">// QUANTUM_STATE</span>
        <span class="hud-status">AUTHENTICATED • OPERATIONAL</span>
      </div>
      <!-- Ambient Hex Streams -->
      <div class="digital-hex-stream stream-left">01 7F E4 B9 2A 9C 00 FF 10 E6</div>
      <div class="digital-hex-stream stream-right">FF 00 F0 11 8A DE 44 2B C7 90</div>
    </div>

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

  <!-- Dedicated Space Terminal Auth Card with 3D Perspective Scene (from sign-in-card-2) -->
  <div class="auth-3d-scene" id="auth3DScene">
    <div class="auth-portal-card" id="authCard">
      <!-- Animated Traveling Light Beam Perimeter Circuit (from sign-in-card-2) -->
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

      <!-- Subtle Card Border Glow Sheen (Space White -> Tech Blue Gradient) -->
      <div class="card-border-glow-sheen"></div>

      <div class="portal-tag">
        <svg class="tag-svg-icon" viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="filter: drop-shadow(0 0 4px #ffffff);"><circle cx="12" cy="12" r="3"/><path d="M12 2v3m0 14v3M2 12h3m14 0h3"/></svg>
        BRAIN AGILITY &amp; LOGIC PLATFORM
      </div>
      <h1 class="portal-title">GAME <span class="hollow-hub">HUB</span></h1>
      <p class="portal-subtitle">
        Cognitive agility, pattern recognition, and split-second reflex training. Zero latency.
      </p>

      <!-- Tab Switcher with Morphing Pill -->
      <div class="auth-tabs <%= "login".equals(defaultMode) ? "is-login" : "" %>" id="authTabs">
        <div class="auth-tab-pill" id="authTabPill"></div>
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
            <svg class="auth-svg-icon" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <input type="text" class="auth-field" id="signupUser" placeholder="e.g. AstroOperative" autocomplete="username" required>
          </div>
        </div>

        <div class="auth-input-group">
          <label class="auth-input-label" for="signupPass">Security Cipher [Min 6 Chars]</label>
          <div class="auth-input-box">
            <svg class="auth-svg-icon" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            <input type="password" class="auth-field" id="signupPass" placeholder="••••••••••••" autocomplete="new-password" required>
          </div>
        </div>

        <div class="auth-input-group">
          <label class="auth-input-label" for="signupPassConfirm">Confirm Cipher</label>
          <div class="auth-input-box">
            <svg class="auth-svg-icon" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            <input type="password" class="auth-field" id="signupPassConfirm" placeholder="••••••••••••" autocomplete="new-password" required>
          </div>
        </div>

        <button type="submit" class="btn-submit btn-signup-submit" id="signupBtn">
          <span class="btn-shimmer-sweep"></span>
          <span id="signupBtnText" style="display:inline-flex;align-items:center;gap:7px;">
            <svg viewBox="0 0 24 24" width="15" height="15" fill="#020817" stroke="#020817" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
            ENLIST PROFILE &amp; ENTER
          </span>
        </button>
      </form>

      <!-- ================= LOG IN FORM ================= -->
      <form class="auth-form-wrap <%= "login".equals(defaultMode) ? "active" : "" %>" id="loginForm" onsubmit="event.preventDefault(); handleLogin();">
        <div class="auth-input-group">
          <label class="auth-input-label" for="loginUser">Operative Callsign</label>
          <div class="auth-input-box">
            <svg class="auth-svg-icon" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <input type="text" class="auth-field" id="loginUser" placeholder="e.g. CyberNinja" autocomplete="username" required>
          </div>
        </div>

        <div class="auth-input-group">
          <label class="auth-input-label" for="loginPass">Security Cipher</label>
          <div class="auth-input-box">
            <svg class="auth-svg-icon" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            <input type="password" class="auth-field" id="loginPass" placeholder="••••••••••••" autocomplete="current-password" required>
          </div>
        </div>

        <button type="submit" class="btn-submit" id="loginBtn">
          <span class="btn-shimmer-sweep"></span>
          <span id="loginBtnText" style="display:inline-flex;align-items:center;gap:7px;">
            <svg viewBox="0 0 24 24" width="15" height="15" fill="#020817" stroke="#020817" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
            AUTHENTICATE &amp; ENTER
          </span>
        </button>
      </form>

      <!-- Guest Access Bypass -->
      <div class="guest-bypass-box">
        <button type="button" class="btn-guest" onclick="handleGuestBypass()">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="filter: drop-shadow(0 0 5px rgba(255,255,255,0.5));"><line x1="6" y1="12" x2="10" y2="12"/><line x1="8" y1="10" x2="8" y2="14"/><line x1="15" y1="13" x2="15.01" y2="13"/><line x1="18" y1="11" x2="18.01" y2="11"/><rect x="2" y="6" width="20" height="12" rx="3"/></svg>
          <span>Bypass Authentication (Play as Guest)</span>
        </button>
      </div>
    </div>
  </div>

<script>
  // Framer Motion Morphing Tab & Form Switcher
  function switchAuthMode(mode) {
    const tabSignup = document.getElementById('tabSignup');
    const tabLogin = document.getElementById('tabLogin');
    const formSignup = document.getElementById('signupForm');
    const formLogin = document.getElementById('loginForm');
    const alertBox = document.getElementById('authAlert');
    const tabsContainer = document.getElementById('authTabs');
    const Motion = (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;

    if (alertBox) alertBox.style.display = 'none';

    if (mode === 'signup') {
      if (tabsContainer) tabsContainer.classList.remove('is-login');
      tabSignup.classList.add('active');
      tabLogin.classList.remove('active');

      if (formLogin && formSignup && formLogin.classList.contains('active')) {
        if (Motion && typeof Motion.animate === 'function') {
          Motion.animate(formLogin, { opacity: [1, 0], scale: [1, 0.96], y: [0, -6] }, { duration: 0.16 }).then(() => {
            formLogin.classList.remove('active');
            formSignup.classList.add('active');
            Motion.animate(formSignup, { opacity: [0, 1], scale: [0.96, 1], y: [6, 0] }, { duration: 0.28, ease: [0.16, 1, 0.3, 1] });
            const fields = formSignup.querySelectorAll('.auth-input-group, .btn-submit');
            Motion.animate(fields, { opacity: [0, 1], y: [8, 0] }, { delay: Motion.stagger(0.04), duration: 0.24, ease: [0.16, 1, 0.3, 1] });
          });
        } else {
          formLogin.classList.remove('active');
          formSignup.classList.add('active');
        }
      }
    } else {
      if (tabsContainer) tabsContainer.classList.add('is-login');
      tabLogin.classList.add('active');
      tabSignup.classList.remove('active');

      if (formSignup && formLogin && formSignup.classList.contains('active')) {
        if (Motion && typeof Motion.animate === 'function') {
          Motion.animate(formSignup, { opacity: [1, 0], scale: [1, 0.96], y: [0, -6] }, { duration: 0.16 }).then(() => {
            formSignup.classList.remove('active');
            formLogin.classList.add('active');
            Motion.animate(formLogin, { opacity: [0, 1], scale: [0.96, 1], y: [6, 0] }, { duration: 0.28, ease: [0.16, 1, 0.3, 1] });
            const fields = formLogin.querySelectorAll('.auth-input-group, .btn-submit');
            Motion.animate(fields, { opacity: [0, 1], y: [8, 0] }, { delay: Motion.stagger(0.04), duration: 0.24, ease: [0.16, 1, 0.3, 1] });
          });
        } else {
          formSignup.classList.remove('active');
          formLogin.classList.add('active');
        }
      }
    }
  }

  // Entrance Spring Morph for Terminal Card & 3D Tilt Initialization
  window.addEventListener('DOMContentLoaded', () => {
    const card = document.getElementById('authCard');
    const Motion = (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;
    if (card && Motion && typeof Motion.animate === 'function') {
      Motion.animate(
        card,
        { opacity: [0, 1], scale: [0.93, 1], y: [22, 0] },
        { duration: 0.48, ease: [0.175, 0.885, 0.32, 1.275] }
      ).then(() => {
        if (typeof window.onAuthCardEntranceDone === 'function') {
          window.onAuthCardEntranceDone();
        }
      });
      const activeFields = card.querySelectorAll('.auth-form-wrap.active .auth-input-group, .auth-form-wrap.active .btn-submit');
      if (activeFields.length > 0) {
        Motion.animate(
          activeFields,
          { opacity: [0, 1], y: [10, 0] },
          { delay: Motion.stagger(0.045, { startDelay: 0.12 }), duration: 0.32, ease: [0.16, 1, 0.3, 1] }
        );
      }
    } else {
      if (typeof window.onAuthCardEntranceDone === 'function') {
        window.onAuthCardEntranceDone();
      }
    }
  });

  // Interactive 3D Card Tilt Effect from sign-in-card-2 (perspective: 1500px, -10 to 10 deg)
  (function init3DCardTilt() {
    const card = document.getElementById('authCard');
    const scene = document.getElementById('auth3DScene');
    if (!card || !scene) return;

    let currentRotX = 0, currentRotY = 0;
    let targetRotX = 0, targetRotY = 0;
    let isHovered = false;
    let isWarping = false;
    let isReady = false;
    let animId = null;

    window.onAuthCardEntranceDone = function() {
      isReady = true;
    };

    function updateCardTransform() {
      if (isWarping) return;
      currentRotX += (targetRotX - currentRotX) * 0.14;
      currentRotY += (targetRotY - currentRotY) * 0.14;

      const translateZ = isHovered ? 10 : 0;
      card.style.transform = 'perspective(1500px) rotateX(' + currentRotX.toFixed(2) + 'deg) rotateY(' + currentRotY.toFixed(2) + 'deg) translateZ(' + translateZ + 'px)';

      if (Math.abs(targetRotX - currentRotX) > 0.01 || Math.abs(targetRotY - currentRotY) > 0.01 || isHovered) {
        animId = requestAnimationFrame(updateCardTransform);
      } else {
        animId = null;
      }
    }

    function handleMouseMove(e) {
      if (isWarping || !isReady) return;
      const rect = card.getBoundingClientRect();
      const centerX = rect.left + rect.width / 2;
      const centerY = rect.top + rect.height / 2;
      const dx = e.clientX - centerX;
      const dy = e.clientY - centerY;

      // Rotation range: -10 to 10 deg (matches sign-in-card-2)
      targetRotX = Math.max(-10, Math.min(10, (-dy / (rect.height / 2)) * 10));
      targetRotY = Math.max(-10, Math.min(10, (dx / (rect.width / 2)) * 10));

      if (!animId) animId = requestAnimationFrame(updateCardTransform);
    }

    function handleMouseEnter() {
      if (isWarping || !isReady) return;
      isHovered = true;
      if (!animId) animId = requestAnimationFrame(updateCardTransform);
    }

    function handleMouseLeave() {
      if (isWarping) return;
      isHovered = false;
      targetRotX = 0;
      targetRotY = 0;
      if (!animId) animId = requestAnimationFrame(updateCardTransform);
    }

    scene.addEventListener('mousemove', handleMouseMove);
    scene.addEventListener('mouseenter', handleMouseEnter);
    scene.addEventListener('mouseleave', handleMouseLeave);

    // Stop tilt during warp out
    window.stop3DTiltForWarp = function() {
      isWarping = true;
      if (animId) cancelAnimationFrame(animId);
      card.style.transform = '';
    };
  })();

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
    if (typeof window.stop3DTiltForWarp === 'function') {
      window.stop3DTiltForWarp();
    }
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
        btnText.innerHTML = '<svg viewBox="0 0 24 24" width="15" height="15" fill="#020817" stroke="#020817" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg> AUTHENTICATE & ENTER';
      }
    } catch (err) {
      showAlert('error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
      btn.disabled = false;
      btnText.innerHTML = '<svg viewBox="0 0 24 24" width="15" height="15" fill="#020817" stroke="#020817" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg> AUTHENTICATE & ENTER';
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
        btnText.innerHTML = '<svg viewBox="0 0 24 24" width="15" height="15" fill="#020817" stroke="#020817" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg> ENLIST PROFILE & ENTER';
      }
    } catch (err) {
      showAlert('error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
      btn.disabled = false;
      btnText.innerHTML = '<svg viewBox="0 0 24 24" width="15" height="15" fill="#020817" stroke="#020817" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg> ENLIST PROFILE & ENTER';
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

      // Rebuild high-performance linear gradients across the screen (Space White on left -> Electric Tech Cyan on right)
      baseLineGrad = ctx.createLinearGradient(0, 0, W, 0);
      baseLineGrad.addColorStop(0, 'rgba(255, 255, 255, 0.40)');
      baseLineGrad.addColorStop(0.45, 'rgba(180, 230, 255, 0.38)');
      baseLineGrad.addColorStop(1, 'rgba(0, 240, 255, 0.45)');

      activeLineGrad = ctx.createLinearGradient(0, 0, W, 0);
      activeLineGrad.addColorStop(0, 'rgba(255, 255, 255, 0.98)');
      activeLineGrad.addColorStop(0.45, 'rgba(186, 230, 253, 0.96)');
      activeLineGrad.addColorStop(1, 'rgba(0, 240, 255, 1.0)');

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

      // Pass 3: Draw Glowing Intersection Nodes (Space White on left, Ice Blue in middle, Neon Cyan on right)
      for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
          let p = pts[r][c];
          if (p.factor > 0.035) {
            let ratio = Math.max(0, Math.min(1, p.x / W));
            let nr = Math.round(255 * (1 - ratio));
            let ng = Math.round(255 * (1 - ratio) + 242 * ratio);
            let nb = 255;
            let rad = 1.8 + 2.4 * p.factor;

            ctx.beginPath();
            ctx.arc(p.x, p.y, rad, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(' + nr + ',' + ng + ',' + nb + ',' + p.factor.toFixed(2) + ')';
            ctx.fill();

            if (p.factor > 0.25) {
              ctx.beginPath();
              ctx.arc(p.x, p.y, rad * 2.2, 0, Math.PI * 2);
              ctx.fillStyle = 'rgba(' + nr + ',' + ng + ',' + nb + ',' + (p.factor * 0.35).toFixed(2) + ')';
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
