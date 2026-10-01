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
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Game Hub | Brain & Mind Training Games</title>
<link rel="stylesheet" href="css/ransom_horror.css">
<!-- Framer Motion Browser Engine (Motion One / Framer Motion Runtime) -->
<script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>
<style>
  :root {
    --bg-base: #02040a;
    --card-bg: rgba(6, 12, 24, 0.85);
    --border-glow: rgba(0, 240, 255, 0.4);
    --border-cyan: rgba(0, 240, 255, 0.25);
    --primary: #00f0ff;
    --primary-rgb: 0, 240, 255;
    --primary-glow: rgba(0, 240, 255, 0.45);
    --secondary: #0284c7;
    --secondary-glow: rgba(2, 132, 199, 0.35);
    --accent: #10e6a8;
    --accent-glow: rgba(16, 230, 168, 0.4);
    --neon-pink: #f43f5e;
    --neon-purple: #a855f7;
    --warning: #facc15;
    --danger: #ef4444;
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

  html, body {
    width: 100vw;
    height: 100vh;
    height: 100dvh;
    max-height: 100vh;
    overflow: hidden !important;
    margin: 0;
    padding: 0;
    background-color: var(--bg-base);
    color: var(--text-main);
    display: flex;
    position: fixed;
    inset: 0;
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

  /* =========================================================
     FRAMER MOTION KINETIC CAMERA DEPTH CURTAIN & TRANSITIONS
     (UI/UX Pro Max: No strobe flashes, no laser wipes)
     ========================================================= */
  .motion-page-curtain {
    position: fixed;
    inset: 0;
    z-index: 99999;
    pointer-events: none;
    opacity: 0;
    background: radial-gradient(circle at 50% 50%, rgba(6, 13, 28, 0.92) 0%, rgba(2, 4, 10, 0.98) 100%);
    backdrop-filter: blur(28px) saturate(140%);
    -webkit-backdrop-filter: blur(28px) saturate(140%);
    transform: scale(1.02);
    transition: opacity 0.24s cubic-bezier(0.16, 1, 0.3, 1), transform 0.24s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .motion-page-curtain.active {
    pointer-events: all;
    opacity: 1;
    transform: scale(1);
  }

  /* Precision luminous velocity bar at the top edge */
  .motion-page-curtain .curtain-velocity-bar {
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
  .motion-page-curtain.active .curtain-velocity-bar {
    transform: scaleX(1);
  }

  /* Subtle tactical pulse ring */
  .motion-page-curtain .curtain-pulse-ring {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 48px;
    height: 48px;
    margin: -24px 0 0 -24px;
    border: 2px solid rgba(0, 240, 255, 0.12);
    border-top: 2px solid #00f0ff;
    border-radius: 50%;
    opacity: 0;
    transform: scale(0.85);
    transition: opacity 0.2s ease, transform 0.24s cubic-bezier(0.16, 1, 0.3, 1);
    animation: curtainSpin 0.9s cubic-bezier(0.5, 0.1, 0.4, 0.9) infinite;
  }
  .motion-page-curtain.active .curtain-pulse-ring {
    opacity: 0.85;
    transform: scale(1);
  }
  @keyframes curtainSpin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  /* Camera Depth Recession for main hub viewport during transitions */
  .camera-receding {
    transform: scale(0.972) translateY(6px) !important;
    filter: blur(6px) brightness(0.82) !important;
    opacity: 0.55 !important;
    transition: transform 0.24s cubic-bezier(0.16, 1, 0.3, 1),
                filter 0.24s ease,
                opacity 0.24s ease !important;
  }
  .camera-restoring {
    transform: scale(1) translateY(0) !important;
    filter: blur(0px) brightness(1) !important;
    opacity: 1 !important;
    transition: transform 0.36s cubic-bezier(0.16, 1, 0.3, 1),
                filter 0.32s ease,
                opacity 0.32s ease !important;
  }

  /* Backward compatibility shims for any remaining .cyber-shutter / .cyber-wipe-overlay */
  .cyber-shutter, .cyber-wipe-overlay {
    position: fixed;
    inset: 0;
    pointer-events: none;
    z-index: 99999;
    opacity: 0;
    background: radial-gradient(circle at 50% 50%, rgba(6, 13, 28, 0.92) 0%, rgba(2, 4, 10, 0.98) 100%);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    transition: opacity 0.22s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .cyber-shutter.active, .cyber-wipe-overlay.active {
    pointer-events: all;
    opacity: 1;
  }
  .cyber-shutter-beam, .cyber-wipe-beam {
    display: none !important;
  }

  /* =========================================================
     LANDING PORTAL OVERLAY
     ========================================================= */
  #landingPortal {
    position: fixed;
    inset: 0;
    z-index: 5000;
    background: transparent;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
    text-align: center;
    transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.35s ease, filter 0.35s ease, visibility 0.35s ease;
    overflow: hidden !important;
  }
  #landingPortal.zoom-through {
    transform: scale(1.15);
    opacity: 0;
    filter: blur(12px);
    pointer-events: none;
  }
  #landingPortal.dismissed {
    opacity: 0;
    pointer-events: none;
    visibility: hidden;
    display: none !important;
  }

  /* Completely hide gallery and sidebar behind portal until user enters! */
  #landingPortal:not(.dismissed) ~ aside,
  #landingPortal:not(.dismissed) ~ main {
    display: none !important;
  }

  /* Staggered Framer-Motion Spring Entrance when entering dashboard */
  body.portal-entered aside {
    animation: sidebarSpringIn 0.55s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  body.portal-entered main {
    animation: mainSpringIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  @keyframes sidebarSpringIn {
    0% { opacity: 0; transform: translateX(-35px); }
    100% { opacity: 1; transform: translateX(0); }
  }
  @keyframes mainSpringIn {
    0% { opacity: 0; transform: translateY(25px) scale(0.97); }
    100% { opacity: 1; transform: translateY(0) scale(1); }
  }

  .portal-content {
    max-width: 480px;
    width: 90vw;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
    z-index: 10;
    background: rgba(4, 9, 22, 0.88);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border: 1px solid rgba(0, 240, 255, 0.35);
    border-radius: 28px;
    padding: 2.5rem 2.2rem;
    box-shadow: 0 0 60px rgba(0, 240, 255, 0.20), 0 30px 80px rgba(0, 0, 0, 0.95);
    animation: portalSpringIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
    box-sizing: border-box;
  }
  .portal-content::before {
    content: '';
    position: absolute;
    top: 0;
    left: 15%;
    right: 15%;
    height: 2px;
    background: linear-gradient(90deg, transparent, var(--primary), transparent);
    box-shadow: 0 0 16px var(--primary);
  }
  @keyframes portalSpringIn {
    0% { transform: scale(0.92) translateY(24px); opacity: 0; }
    100% { transform: scale(1) translateY(0); opacity: 1; }
  }

  .portal-tag {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(0, 240, 255, 0.08);
    border: 1px solid rgba(0, 240, 255, 0.3);
    padding: 6px 16px;
    border-radius: 9999px;
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: var(--primary);
    text-transform: uppercase;
    margin-bottom: 1rem;
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.2);
  }
  .portal-tag::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent);
    box-shadow: 0 0 10px var(--accent);
    animation: pulseDot 1.8s infinite;
  }
  @keyframes pulseDot {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.3); opacity: 0.6; }
  }

  .portal-title {
    font-size: clamp(2.2rem, 5vw, 3rem);
    font-weight: 900;
    letter-spacing: 2px;
    line-height: 1.1;
    margin-bottom: 0.5rem;
    background: linear-gradient(135deg, #ffffff 40%, var(--primary) 80%, #38bdf8 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    text-shadow: 0 0 35px rgba(0, 240, 255, 0.35);
  }

  .portal-subtitle {
    font-size: clamp(0.82rem, 2vw, 0.9rem);
    color: var(--text-muted);
    line-height: 1.5;
    margin-bottom: 1.8rem;
    max-width: 400px;
  }

  .portal-actions {
    display: flex;
    flex-direction: column;
    gap: 0.85rem;
    width: 100%;
    max-width: 320px;
  }

  .btn-portal {
    min-height: 48px;
    padding: 0.85rem 1.4rem;
    border-radius: 14px;
    font-size: 0.92rem;
    font-weight: 800;
    letter-spacing: 1px;
    cursor: pointer;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    transition: all 0.22s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    text-decoration: none;
    box-sizing: border-box;
  }
  .btn-portal:hover {
    transform: translateY(-2px) scale(1.02);
  }
  .btn-portal:active {
    transform: scale(0.96) !important;
  }

  .portal-kinetic-hint {
    margin-top: 1.3rem;
    font-size: 0.72rem;
    font-family: monospace;
    letter-spacing: 1.2px;
    color: var(--primary);
    opacity: 0.85;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .btn-portal-primary {
    background: linear-gradient(135deg, var(--primary), #0284c7);
    color: #000;
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.4);
  }
  .btn-portal-primary:hover {
    background: linear-gradient(135deg, #7dd3fc, var(--primary));
    box-shadow: 0 0 30px rgba(56, 189, 248, 0.6);
    transform: translateY(-2px);
  }

  .btn-portal-secondary {
    background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(34, 197, 94, 0.05));
    border: 1px solid rgba(34, 197, 94, 0.4);
    color: #86efac;
    box-shadow: 0 0 15px rgba(34, 197, 94, 0.2);
  }
  .btn-portal-secondary:hover {
    background: rgba(34, 197, 94, 0.25);
    border-color: var(--accent);
    color: #fff;
    transform: translateY(-2px);
  }

  .btn-portal-guest {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--text-muted);
  }
  .btn-portal-guest:hover {
    background: rgba(255, 255, 255, 0.1);
    color: var(--text-main);
    border-color: rgba(255, 255, 255, 0.25);
  }

  .portal-footer-note {
    margin-top: 1.8rem;
    font-size: 0.72rem;
    color: #64748b;
    letter-spacing: 0.8px;
  }

  /* =========================================================
     MAIN APPLICATION LAYOUT & SIDEBAR
     ========================================================= */
  aside {
    width: 250px;
    height: 100vh;
    height: 100dvh;
    max-height: 100vh;
    background: rgba(3, 7, 18, 0.94);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border-right: 1px solid rgba(0, 240, 255, 0.2);
    display: flex;
    flex-direction: column;
    padding: 1.2rem 1.1rem;
    flex-shrink: 0;
    z-index: 100;
    overflow: hidden;
    box-shadow: 10px 0 40px rgba(0, 0, 0, 0.8);
    box-sizing: border-box;
  }

  .brand {
    font-size: 1.3rem;
    font-weight: 900;
    letter-spacing: 2px;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 1.2rem;
    color: #fff;
    text-shadow: 0 0 20px rgba(0, 240, 255, 0.6);
    cursor: pointer;
  }
  .brand-glyph {
    color: var(--primary);
    filter: drop-shadow(0 0 8px var(--primary));
  }
  .brand-badge {
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    font-size: 0.65rem;
    padding: 3px 8px;
    border-radius: 6px;
    color: #030712;
    font-weight: 900;
    box-shadow: 0 0 15px rgba(0, 240, 255, 0.5);
    letter-spacing: 1px;
  }

  /* User Auth Widget in Sidebar */
  .auth-widget {
    background: linear-gradient(170deg, rgba(8, 16, 32, 0.9) 0%, rgba(3, 7, 18, 0.95) 100%);
    border: 1px solid rgba(0, 240, 255, 0.25);
    border-radius: 16px;
    padding: 0.9rem;
    margin-bottom: 1.2rem;
    text-align: center;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7), inset 0 0 20px rgba(0, 240, 255, 0.04);
    position: relative;
    overflow: hidden;
  }
  .auth-widget::before {
    content: '';
    position: absolute;
    top: 0;
    left: 20%;
    right: 20%;
    height: 2px;
    background: linear-gradient(90deg, transparent, var(--primary), transparent);
    box-shadow: 0 0 10px var(--primary);
  }
  .auth-avatar-wrap {
    position: relative;
    width: 52px;
    height: 52px;
    margin: 0 auto 0.65rem auto;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .auth-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.35rem;
    color: #030712;
    font-weight: 900;
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.5);
    border: 2px solid #ffffff;
    z-index: 2;
  }
  .auth-avatar-pulse {
    position: absolute;
    inset: -3px;
    border-radius: 50%;
    border: 1px dashed rgba(0, 240, 255, 0.6);
    animation: rotatePulse 12s linear infinite;
  }
  @keyframes rotatePulse {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  .auth-name {
    font-size: 0.98rem;
    font-weight: 800;
    color: #fff;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
  }
  .auth-role {
    font-size: 0.68rem;
    color: var(--accent);
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 0.8rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    font-weight: 800;
  }
  .auth-role::before {
    content: '';
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
    box-shadow: 0 0 8px currentColor;
  }

  .btn-auth {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    width: 100%;
    padding: 0.65rem;
    border-radius: 10px;
    font-size: 0.85rem;
    font-weight: 800;
    cursor: pointer;
    border: none;
    transition: all 0.2s ease;
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }
  .btn-login {
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    color: #030712;
    box-shadow: 0 0 15px rgba(0, 240, 255, 0.35);
  }
  .btn-login:hover {
    background: linear-gradient(135deg, #7dd3fc, var(--primary));
    box-shadow: 0 0 25px rgba(0, 240, 255, 0.6);
    transform: translateY(-1px);
  }
  .btn-logout {
    background: rgba(244, 63, 94, 0.12);
    color: #fda4af;
    border: 1px solid rgba(244, 63, 94, 0.35);
  }
  .btn-logout:hover {
    background: rgba(244, 63, 94, 0.25);
    color: #fff;
    box-shadow: 0 0 15px rgba(244, 63, 94, 0.4);
    transform: translateY(-1px);
  }

  nav { display: flex; flex-direction: column; gap: 0.8rem; }
  .nav-btn {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 0.9rem 1.1rem;
    border-radius: 12px;
    background: transparent;
    color: var(--text-muted);
    border: 1px solid transparent;
    cursor: pointer;
    font-size: 0.92rem;
    font-weight: 800;
    letter-spacing: 0.8px;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    text-align: left;
    position: relative;
    overflow: hidden;
  }
  
  .nav-btn:hover { 
    color: #fff; 
    background: rgba(0, 240, 255, 0.05); 
    border-color: rgba(0, 240, 255, 0.2);
    transform: translateX(4px);
  }
  
  .nav-btn.active {
    background: linear-gradient(90deg, rgba(0, 240, 255, 0.15) 0%, rgba(2, 132, 199, 0.05) 100%);
    color: var(--primary);
    border-color: rgba(0, 240, 255, 0.35);
    box-shadow: inset 4px 0 0 var(--primary), 0 0 20px rgba(0, 240, 255, 0.12);
  }

  .btn-portal-recall {
    margin-top: auto;
    background: rgba(0, 240, 255, 0.04);
    border: 1px solid rgba(0, 240, 255, 0.15);
    color: var(--text-muted);
    padding: 0.65rem;
    border-radius: 10px;
    font-size: 0.8rem;
    font-weight: 700;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    transition: 0.2s;
  }
  .btn-portal-recall:hover {
    background: rgba(0, 240, 255, 0.12);
    border-color: rgba(0, 240, 255, 0.4);
    color: #fff;
  }

  /* =========================================================
     FEATURE 2: BALANCED UI PROPORTIONS - 100% SINGLE PAGE (NO OVERFLOW)
     ========================================================= */
  main {
    flex: 1;
    min-width: 0;
    width: calc(100vw - 250px);
    height: 100vh;
    height: 100dvh;
    max-height: 100vh;
    display: flex;
    flex-direction: column;
    padding: 0.9rem 1.8rem;
    overflow: hidden !important;
    box-sizing: border-box;
    position: relative;
    z-index: 10;
  }

  .top-meta {
    height: 44px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.6rem;
    flex-shrink: 0;
  }
  .top-meta h2 { 
    font-size: clamp(1.4rem, 2.5vw, 1.8rem); 
    font-weight: 900; 
    letter-spacing: 1.5px;
    background: linear-gradient(135deg, #ffffff 30%, #38bdf8 70%, var(--primary) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  .sys-status {
    font-size: 0.72rem;
    color: var(--accent);
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    gap: 6px;
    background: rgba(16, 230, 168, 0.1);
    padding: 4px 12px;
    border-radius: 999px;
    border: 1px solid rgba(16, 230, 168, 0.35);
    box-shadow: 0 0 15px rgba(16, 230, 168, 0.2);
  }
  .sys-status::before {
    content: '';
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--accent);
    box-shadow: 0 0 8px var(--accent);
    animation: pulseDot 2s infinite;
  }

  .view-panel { display: none; opacity: 0; flex: 1; min-height: 0; }
  .view-panel.active { 
    display: flex; 
    flex-direction: column; 
    opacity: 1; 
    animation: panelSpringGlide 0.42s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  @keyframes panelSpringGlide {
    0% { opacity: 0; transform: translateX(20px); filter: blur(4px); }
    100% { opacity: 1; transform: translateX(0); filter: blur(0); }
  }

  /* =========================================================
     FEATURE: LINEAR NEURAL INTEGRATION BUS (Zero Loops Architecture)
     ========================================================= */
  .library-header-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.6rem;
    flex-wrap: wrap;
    gap: 0.6rem;
    flex-shrink: 0;
  }
  .view-mode-tabs {
    display: inline-flex;
    background: rgba(4, 9, 22, 0.85);
    border: 1px solid rgba(0, 240, 255, 0.25);
    border-radius: 12px;
    padding: 3px;
    gap: 3px;
  }
  .view-mode-pill {
    background: transparent;
    border: none;
    color: var(--text-muted);
    font-size: 0.76rem;
    font-weight: 800;
    letter-spacing: 1px;
    padding: 6px 14px;
    border-radius: 9px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: all 0.22s ease;
  }
  .view-mode-pill.active {
    background: rgba(0, 240, 255, 0.16);
    color: var(--primary);
    box-shadow: 0 0 14px rgba(0, 240, 255, 0.35);
  }
  .view-mode-pill .pill-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--primary);
    box-shadow: 0 0 8px var(--primary);
    display: inline-block;
  }
  .node-sync-indicator {
    font-family: monospace;
    font-size: 0.72rem;
    letter-spacing: 1px;
    color: var(--accent);
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: rgba(16, 230, 168, 0.08);
    border: 1px solid rgba(16, 230, 168, 0.25);
    padding: 5px 12px;
    border-radius: 20px;
  }
  .node-sync-indicator .live-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: #10e6a8;
    box-shadow: 0 0 8px #10e6a8;
    animation: livePulse 1.8s ease-in-out infinite;
  }
  @keyframes livePulse {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.4); opacity: 0.5; }
  }

  /* Neural Bus Container */
  .neural-bus-container {
    position: relative;
    width: 100%;
    height: calc(100vh - 170px);
    min-height: 480px;
    max-height: 720px;
    border-radius: 22px;
    border: 1px solid rgba(0, 240, 255, 0.25);
    background-color: rgba(3, 7, 18, 0.85);
    background-image: radial-gradient(circle, rgba(0, 240, 255, 0.2) 1.2px, transparent 1.2px);
    background-size: 28px 28px;
    box-shadow: inset 0 0 60px rgba(0, 0, 0, 0.95), 0 15px 40px rgba(0, 0, 0, 0.85);
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: panelSpringGlide 0.45s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  .neural-bus-container.hidden-mode {
    display: none !important;
  }
  .carousel-controls.hidden-mode,
  .game-carousel.hidden-mode {
    display: none !important;
  }

  /* Dynamic cursor spotlight glow */
  .neural-spotlight {
    position: absolute;
    inset: 0;
    pointer-events: none;
    z-index: 1;
    background: radial-gradient(circle 320px at var(--bus-mx, 50%) var(--bus-my, 50%), rgba(0, 240, 255, 0.08), transparent 70%);
    transition: opacity 0.2s ease;
  }

  /* SVG Canvas for Linear Traces */
  .neural-svg {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 2;
  }
  .neural-trace-base {
    stroke: rgba(0, 240, 255, 0.16);
    stroke-width: 2px;
    fill: none;
    stroke-linecap: round;
    transition: stroke 0.25s, stroke-width 0.25s, filter 0.25s;
  }
  .neural-trace-base.highlighted {
    stroke: rgba(0, 240, 255, 0.95);
    stroke-width: 3px;
    filter: drop-shadow(0 0 10px #00f0ff);
  }

  /* Animated linear energy pulses (HUB ➔ GAME) */
  .neural-trace-pulse {
    stroke-width: 3.5px;
    fill: none;
    stroke-linecap: round;
    stroke-dasharray: 45 200;
    animation: tracePacketFlow 2.8s linear infinite;
    filter: drop-shadow(0 0 6px rgba(0, 240, 255, 0.85));
  }
  @keyframes tracePacketFlow {
    0% { stroke-dashoffset: 245; }
    100% { stroke-dashoffset: 0; }
  }
  .pulse-chess    { animation-delay: 0.1s; stroke: #38bdf8; }
  .pulse-bomb     { animation-delay: 0.4s; stroke: #f43f5e; }
  .pulse-snake    { animation-delay: 0.7s; stroke: #10e6a8; }
  .pulse-maze     { animation-delay: 1.0s; stroke: #a855f7; }
  .pulse-guess    { animation-delay: 1.3s; stroke: #facc15; }
  .pulse-reactor  { animation-delay: 1.6s; stroke: #00f0ff; }

  .neural-trace-pulse.highlighted {
    stroke-width: 5px;
    stroke: #00f0ff !important;
    animation-duration: 1.4s;
    filter: drop-shadow(0 0 16px #00f0ff);
  }

  /* Central Game Hub Squircle Nucleus (Click to View Master Library) */
  .neural-hub-core {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%) translateZ(0);
    z-index: 10;
    width: 112px;
    height: 112px;
    border-radius: 28px;
    background: linear-gradient(135deg, rgba(8, 18, 42, 0.96), rgba(2, 6, 18, 0.98));
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1.5px solid rgba(0, 240, 255, 0.55);
    box-shadow: 0 0 35px rgba(0, 240, 255, 0.3), inset 0 0 25px rgba(0, 240, 255, 0.15);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    user-select: none;
    transition: transform 0.28s cubic-bezier(0.16, 1, 0.3, 1),
                border-color 0.25s,
                box-shadow 0.28s;
    overflow: visible;
    will-change: transform;
  }
  .neural-hub-core:hover {
    transform: translate(-50%, -50%) scale(1.08) translateZ(0);
    border-color: #00f0ff;
    box-shadow: 0 0 50px rgba(0, 240, 255, 0.7), inset 0 0 30px rgba(0, 240, 255, 0.35);
  }
  .neural-hub-core:active {
    transform: translate(-50%, -50%) scale(0.97) translateZ(0);
  }
  .hub-shader-canvas {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    border-radius: 28px;
    pointer-events: none;
    z-index: 1;
    opacity: 0.85;
    transition: opacity 0.25s ease;
  }
  .neural-hub-core:hover .hub-shader-canvas {
    opacity: 1;
  }
  .hub-core-content {
    position: relative;
    z-index: 2;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    pointer-events: none;
  }
  .hub-nexus-svg {
    width: 32px;
    height: 32px;
    filter: drop-shadow(0 0 10px rgba(0, 240, 255, 0.85));
    animation: hubNexusSpin 12s linear infinite;
  }
  @keyframes hubNexusSpin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  .hub-core-ping {
    position: absolute;
    inset: -8px;
    border-radius: 34px;
    border: 1.5px solid rgba(0, 240, 255, 0.25);
    animation: hubCorePulse 3s cubic-bezier(0.16, 1, 0.3, 1) infinite;
    pointer-events: none;
  }
  @keyframes hubCorePulse {
    0% { transform: scale(0.96); opacity: 0.7; }
    50% { transform: scale(1.1); opacity: 0.15; }
    100% { transform: scale(0.96); opacity: 0.7; }
  }
  .hub-core-title {
    font-size: 0.72rem;
    font-weight: 900;
    letter-spacing: 2px;
    color: #fff;
    text-transform: uppercase;
    text-align: center;
    line-height: 1.1;
    margin-top: 2px;
  }
  .hub-core-title span {
    color: var(--primary);
  }
  .hub-core-status {
    position: absolute;
    bottom: -10px;
    background: rgba(2, 6, 18, 0.95);
    border: 1px solid rgba(0, 240, 255, 0.4);
    padding: 2px 9px;
    border-radius: 20px;
    font-size: 0.55rem;
    font-weight: 800;
    letter-spacing: 1.5px;
    color: var(--primary);
    box-shadow: 0 0 10px rgba(0, 240, 255, 0.3);
    white-space: nowrap;
    z-index: 12;
    transition: all 0.2s ease;
  }
  .pulse-lib-hint {
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 4px;
  }
  .neural-hub-core:hover .pulse-lib-hint {
    background: #00f0ff;
    color: #020612;
    box-shadow: 0 0 20px #00f0ff;
    transform: translateY(-2px);
  }

  /* Satellite Game Squircles */
  .neural-node {
    position: absolute;
    transform: translate(-50%, -50%);
    z-index: 8;
    width: 84px;
    height: 84px;
    border-radius: 22px;
    background: rgba(6, 14, 30, 0.92);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1.5px solid rgba(0, 240, 255, 0.28);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.85), 0 0 20px rgba(0, 240, 255, 0.12);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1),
                border-color 0.25s,
                box-shadow 0.3s;
    user-select: none;
  }
  .neural-node:hover, .neural-node.active-hover {
    transform: translate(-50%, -50%) scale(1.15);
    border-color: var(--primary);
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.95), 0 0 35px rgba(0, 240, 255, 0.6);
    z-index: 15;
  }
  .neural-node:active {
    transform: translate(-50%, -50%) scale(0.96);
  }
  .neural-node .node-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    line-height: 1;
    margin-bottom: 2px;
    transition: transform 0.25s ease;
  }
  .node-cyber-svg {
    width: 36px;
    height: 36px;
    display: block;
    transition: transform 0.28s cubic-bezier(0.16, 1, 0.3, 1), filter 0.25s ease;
    filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.6));
  }
  .neural-node:hover .node-cyber-svg {
    transform: scale(1.18);
  }
  .svg-reactor ellipse {
    transform-origin: 20px 20px;
    animation: reactorRingSpin 8s linear infinite;
  }
  .svg-reactor ellipse:nth-child(2) {
    animation-direction: reverse;
    animation-duration: 6s;
  }
  @keyframes reactorRingSpin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  .svg-bomb circle[stroke-dasharray] {
    transform-origin: 20px 22px;
    animation: bombBracketSpin 10s linear infinite;
  }
  @keyframes bombBracketSpin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  .neural-node .node-name {
    font-size: 0.62rem;
    font-weight: 800;
    letter-spacing: 1px;
    color: #e2e8f0;
    text-transform: uppercase;
    text-align: center;
    white-space: nowrap;
    max-width: 76px;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* Node-specific color accents */
  .node-chess:hover   { border-color: #38bdf8; box-shadow: 0 0 35px rgba(56, 189, 248, 0.6); }
  .node-bomb:hover    { border-color: #f43f5e; box-shadow: 0 0 35px rgba(244, 63, 94, 0.6); }
  .node-snake:hover   { border-color: #10e6a8; box-shadow: 0 0 35px rgba(16, 230, 168, 0.6); }
  .node-maze:hover    { border-color: #a855f7; box-shadow: 0 0 35px rgba(168, 85, 247, 0.6); }
  .node-guess:hover   { border-color: #facc15; box-shadow: 0 0 35px rgba(250, 204, 21, 0.6); }
  .node-reactor:hover { border-color: #00f0ff; box-shadow: 0 0 35px rgba(0, 240, 255, 0.6); }

  /* Tactical Mission Briefing Popover Card */
  .neural-briefing-popover {
    position: absolute;
    z-index: 25;
    width: 290px;
    background: rgba(4, 9, 24, 0.96);
    backdrop-filter: blur(28px);
    -webkit-backdrop-filter: blur(28px);
    border: 1px solid rgba(0, 240, 255, 0.45);
    border-radius: 20px;
    padding: 1.2rem 1.3rem;
    box-shadow: 0 25px 60px rgba(0, 0, 0, 0.95), 0 0 40px rgba(0, 240, 255, 0.25);
    pointer-events: all;
    opacity: 0;
    transform: scale(0.92) translateY(10px);
    transition: opacity 0.22s cubic-bezier(0.16, 1, 0.3, 1),
                transform 0.22s cubic-bezier(0.16, 1, 0.3, 1);
    display: none;
  }
  .neural-briefing-popover.active {
    display: block;
    opacity: 1;
    transform: scale(1) translateY(0);
  }
  .briefing-tag {
    font-size: 0.65rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: var(--primary);
    text-transform: uppercase;
    margin-bottom: 4px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .briefing-close-btn {
    background: transparent;
    border: none;
    color: var(--text-muted);
    font-size: 0.9rem;
    line-height: 1;
    cursor: pointer;
    padding: 2px 6px;
    border-radius: 6px;
    transition: all 0.2s;
  }
  .briefing-close-btn:hover {
    color: #fff;
    background: rgba(255, 255, 255, 0.12);
  }
  .briefing-title {
    font-size: 1.15rem;
    font-weight: 900;
    color: #fff;
    margin-bottom: 6px;
    letter-spacing: 0.5px;
  }
  .briefing-desc {
    font-size: 0.8rem;
    line-height: 1.5;
    color: var(--text-muted);
    margin-bottom: 1rem;
  }
  .briefing-stat-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: rgba(0, 240, 255, 0.06);
    border: 1px solid rgba(0, 240, 255, 0.2);
    padding: 6px 12px;
    border-radius: 10px;
    margin-bottom: 1rem;
    font-size: 0.78rem;
    color: #e2e8f0;
  }
  .briefing-stat-row .stat-val {
    color: var(--primary);
    font-weight: 800;
    font-family: monospace;
  }
  .btn-briefing-launch {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 12px;
    background: linear-gradient(135deg, var(--primary), #0284c7);
    color: #02040a;
    font-weight: 900;
    font-size: 0.85rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.45);
    transition: transform 0.2s, box-shadow 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
  }
  .btn-briefing-launch:hover {
    transform: translateY(-2px);
    box-shadow: 0 0 30px rgba(0, 240, 255, 0.7);
    background: linear-gradient(135deg, #7dd3fc, var(--primary));
  }
  .btn-briefing-launch:active {
    transform: scale(0.97);
  }

  /* Mobile responsiveness */
  @media (max-width: 768px) {
    .neural-bus-container {
      min-height: 520px;
      height: 60vh;
      max-height: 600px;
    }
    .neural-node {
      width: 66px;
      height: 66px;
      border-radius: 16px;
    }
    .neural-node .node-icon {
      font-size: 1.5rem;
      margin-bottom: 2px;
    }
    .neural-node .node-name {
      font-size: 0.55rem;
      max-width: 60px;
    }
    .neural-hub-core {
      width: 82px;
      height: 82px;
      border-radius: 20px;
    }
    .hub-core-emblem {
      font-size: 1.2rem;
      margin-bottom: 2px;
    }
    .hub-core-title {
      font-size: 0.62rem;
    }
    .neural-briefing-popover {
      position: absolute !important;
      bottom: 10px !important;
      left: 10px !important;
      right: 10px !important;
      top: auto !important;
      width: auto !important;
      padding: 1rem;
      border-radius: 16px;
    }
    .briefing-title {
      font-size: 1rem;
    }
    .briefing-desc {
      font-size: 0.75rem;
      margin-bottom: 0.7rem;
    }
    .briefing-stat-row {
      margin-bottom: 0.7rem;
      padding: 4px 10px;
    }
    .btn-briefing-launch {
      padding: 8px;
      font-size: 0.8rem;
    }
  }

  /* GPU Compositing Performance Enhancements */
  .neural-bus-container,
  .neural-node,
  .neural-hub-core,
  .neural-briefing-popover,
  .game-card,
  .modal-box {
    transform: translateZ(0);
    backface-visibility: hidden;
  }

  /* Master Games Library Modal */
  .master-library-box {
    max-width: 920px !important;
    width: 95% !important;
    max-height: 88vh;
    display: flex;
    flex-direction: column;
    padding: 1.6rem !important;
    text-align: left;
    border: 1px solid rgba(0, 240, 255, 0.45);
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.95), 0 0 45px rgba(0, 240, 255, 0.25);
  }
  .master-library-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 1.1rem;
    padding-bottom: 0.9rem;
    border-bottom: 1px solid rgba(0, 240, 255, 0.18);
    flex-shrink: 0;
  }
  .master-tag {
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 2px;
    color: var(--primary);
    text-transform: uppercase;
    margin-bottom: 4px;
  }
  .master-title {
    font-size: 1.55rem;
    font-weight: 900;
    letter-spacing: 1px;
    color: #fff;
    margin: 0;
  }
  .master-subtitle {
    font-size: 0.82rem;
    color: var(--text-muted);
    margin-top: 4px;
  }
  .btn-master-close {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: #fff;
    font-size: 1rem;
    width: 36px;
    height: 36px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
  }
  .btn-master-close:hover {
    background: rgba(244, 63, 94, 0.25);
    border-color: #f43f5e;
    color: #f43f5e;
    transform: scale(1.05);
  }
  .master-toolbar {
    display: flex;
    gap: 1rem;
    margin-bottom: 1.1rem;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
  }
  .master-search-wrap {
    position: relative;
    flex: 1;
    min-width: 220px;
  }
  .master-search-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 0.85rem;
    color: var(--text-muted);
    pointer-events: none;
  }
  .master-search-input {
    width: 100%;
    background: rgba(4, 10, 25, 0.8);
    border: 1px solid rgba(0, 240, 255, 0.3);
    border-radius: 10px;
    padding: 8px 12px 8px 36px;
    color: #fff;
    font-size: 0.85rem;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
    box-sizing: border-box;
  }
  .master-search-input:focus {
    border-color: var(--primary);
    box-shadow: 0 0 15px rgba(0, 240, 255, 0.35);
  }
  .master-filter-pills {
    display: flex;
    gap: 6px;
    flex-wrap: wrap;
  }
  .master-pill {
    background: rgba(8, 18, 42, 0.8);
    border: 1px solid rgba(0, 240, 255, 0.2);
    color: var(--text-muted);
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 1px;
    padding: 6px 12px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s;
  }
  .master-pill:hover, .master-pill.active {
    background: rgba(0, 240, 255, 0.18);
    border-color: var(--primary);
    color: #fff;
    box-shadow: 0 0 12px rgba(0, 240, 255, 0.3);
  }
  .master-games-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 1rem;
    overflow-y: auto;
    padding-right: 4px;
    max-height: 52vh;
  }
  .master-games-grid::-webkit-scrollbar {
    width: 6px;
  }
  .master-games-grid::-webkit-scrollbar-thumb {
    background: rgba(0, 240, 255, 0.3);
    border-radius: 3px;
  }
  .master-card {
    background: rgba(6, 14, 32, 0.85);
    border: 1px solid rgba(0, 240, 255, 0.22);
    border-radius: 16px;
    padding: 1.1rem;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1),
                border-color 0.25s,
                box-shadow 0.25s;
    position: relative;
    overflow: hidden;
  }
  .master-card:hover {
    transform: translateY(-4px);
    border-color: var(--primary);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.7), 0 0 25px rgba(0, 240, 255, 0.25);
  }
  .master-card-top {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 0.8rem;
  }
  .master-card-icon-wrap {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    background: rgba(4, 9, 24, 0.9);
    border: 1px solid rgba(0, 240, 255, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }
  .master-card-title {
    font-size: 1.05rem;
    font-weight: 900;
    color: #fff;
    line-height: 1.2;
  }
  .master-card-category {
    font-size: 0.65rem;
    font-weight: 800;
    letter-spacing: 1.5px;
    color: var(--primary);
    text-transform: uppercase;
  }
  .master-card-desc {
    font-size: 0.78rem;
    color: var(--text-muted);
    line-height: 1.45;
    margin-bottom: 0.9rem;
    flex-grow: 1;
  }
  .master-card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 8px;
    padding-top: 0.7rem;
    border-top: 1px solid rgba(0, 240, 255, 0.12);
  }
  .master-card-stat {
    font-size: 0.75rem;
    font-family: monospace;
    font-weight: 700;
    color: #e2e8f0;
  }
  .master-card-stat span {
    color: var(--primary);
  }
  .btn-master-play {
    background: linear-gradient(135deg, var(--primary), #0284c7);
    border: none;
    color: #030712;
    font-size: 0.76rem;
    font-weight: 900;
    letter-spacing: 1px;
    padding: 7px 14px;
    border-radius: 8px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    transition: all 0.2s;
    box-shadow: 0 0 12px rgba(0, 240, 255, 0.35);
  }
  .btn-master-play:hover {
    background: linear-gradient(135deg, #7dd3fc, var(--primary));
    transform: translateY(-2px);
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.6);
  }
  @media (max-width: 768px) {
    .master-library-box {
      padding: 1.1rem !important;
      max-height: 92vh;
    }
    .master-title {
      font-size: 1.25rem;
    }
    .master-games-grid {
      grid-template-columns: 1fr;
      max-height: 56vh;
    }
  }

  #libraryView {
    display: none;
    flex-direction: column;
    flex: 1;
    min-height: 0;
    width: 100%;
    min-width: 0;
    overflow: hidden !important;
  }
  #libraryView.active {
    display: flex;
  }

  #scoresView.active, #settingsView.active {
    display: block;
    overflow-y: auto !important;
    overflow-x: hidden;
    padding-right: 0.6rem;
    scrollbar-width: thin;
  }

  .carousel-controls {
    display: flex;
    justify-content: flex-end;
    gap: 0.6rem;
    margin-bottom: 0.4rem;
    flex-shrink: 0;
  }
  .scroll-btn {
    background: rgba(8, 16, 32, 0.85);
    border: 1px solid rgba(0, 240, 255, 0.3);
    color: var(--primary);
    width: 36px;
    height: 36px;
    border-radius: 8px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
    font-weight: 900;
    transition: all 0.2s;
    box-shadow: 0 0 15px rgba(0, 240, 255, 0.15);
  }
  .scroll-btn:hover {
    background: var(--primary);
    color: #030712;
    border-color: var(--primary);
    box-shadow: 0 0 25px rgba(0, 240, 255, 0.6);
    transform: translateY(-2px);
  }

  .game-carousel {
    flex: 1;
    min-height: 0;
    width: 100%;
    min-width: 0;
    display: flex;
    gap: 1.3rem;
    overflow-x: auto;
    overflow-y: hidden !important; /* STRICTLY PREVENT VERTICAL SCROLL */
    padding: 0.2rem 0.2rem 0.8rem 0.2rem;
    scroll-behavior: smooth;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
    align-items: stretch;
  }
  .game-carousel::-webkit-scrollbar { height: 6px; }
  .game-carousel::-webkit-scrollbar-track { background: rgba(0,0,0,0.2); border-radius: 3px; }
  .game-carousel::-webkit-scrollbar-thumb { background: rgba(0, 240, 255, 0.3); border-radius: 3px; }
  .game-carousel::-webkit-scrollbar-thumb:hover { background: var(--primary); }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(14px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .game-card {
    flex: 0 0 270px;
    width: 270px;
    height: 100%;
    max-height: calc(100vh - 165px);
    background: linear-gradient(170deg, rgba(8, 16, 32, 0.92) 0%, rgba(2, 6, 16, 0.98) 100%);
    backdrop-filter: blur(16px);
    border-radius: 16px;
    border: 1px solid rgba(0, 240, 255, 0.22);
    overflow: hidden;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: transform 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.3s ease, border-color 0.25s ease;
    scroll-snap-align: center;
    flex-shrink: 0;
    opacity: 0;
    animation: gameCardSpringIn 0.55s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
    position: relative;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
    box-sizing: border-box;
  }

  .game-card:nth-child(1) { animation-delay: 0.04s; }
  .game-card:nth-child(2) { animation-delay: 0.10s; }
  .game-card:nth-child(3) { animation-delay: 0.16s; }
  .game-card:nth-child(4) { animation-delay: 0.22s; }
  .game-card:nth-child(5) { animation-delay: 0.28s; }
  .game-card:nth-child(6) { animation-delay: 0.34s; }

  @keyframes gameCardSpringIn {
    0% { opacity: 0; transform: translateY(35px) scale(0.94); filter: blur(4px); }
    70% { opacity: 1; transform: translateY(-4px) scale(1.01); filter: blur(0); }
    100% { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); }
  }

  /* Shimmer Beam Sweep on Hover */
  .game-card::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(105deg, transparent 35%, rgba(0, 240, 255, 0.18) 50%, transparent 65%);
    transform: translateX(-100%);
    transition: transform 0.65s cubic-bezier(0.16, 1, 0.3, 1);
    pointer-events: none;
    border-radius: 16px;
    z-index: 5;
  }
  .game-card:hover::after {
    transform: translateX(100%);
  }

  .game-card:hover {
    transform: translateY(-10px) scale(1.028);
    border-color: var(--primary);
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.95), 0 0 35px rgba(0, 240, 255, 0.45);
  }

  .game-card:active {
    transform: translateY(-2px) scale(0.96);
    transition: transform 0.1s cubic-bezier(0.4, 0, 0.2, 1);
  }

  /* Interactive Shockwave Pulse On Click */
  .card-click-ripple {
    position: absolute;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(0, 240, 255, 0.8) 0%, rgba(0, 240, 255, 0) 70%);
    border: 2px solid #00f0ff;
    transform: translate(-50%, -50%) scale(1);
    pointer-events: none;
    z-index: 15;
    animation: cardRippleExpand 0.55s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  @keyframes cardRippleExpand {
    0% { transform: translate(-50%, -50%) scale(1); opacity: 1; }
    100% { transform: translate(-50%, -50%) scale(22); opacity: 0; }
  }

  .card-banner {
    height: clamp(85px, 16vh, 115px);
    min-height: 80px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
    border-bottom: 1px solid rgba(0, 240, 255, 0.15);
    flex-shrink: 0;
  }
  .card-banner::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: 
      linear-gradient(rgba(0, 240, 255, 0.04) 1px, transparent 1px),
      linear-gradient(90deg, rgba(0, 240, 255, 0.04) 1px, transparent 1px);
    background-size: 18px 18px;
    pointer-events: none;
  }
  .banner-icon {
    font-size: clamp(2.2rem, 4vh, 2.7rem);
    filter: drop-shadow(0 0 15px var(--banner-glow, rgba(0, 240, 255, 0.6)));
    transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    z-index: 2;
  }
  .game-card:hover .banner-icon {
    transform: scale(1.12) translateY(-2px);
  }

  .banner-bomb    { --banner-glow: rgba(245, 158, 11, 0.7); background: radial-gradient(circle at center, rgba(234, 88, 12, 0.22) 0%, rgba(8, 14, 28, 0.96) 100%); }
  .banner-chess   { --banner-glow: rgba(168, 85, 247, 0.7); background: radial-gradient(circle at center, rgba(168, 85, 247, 0.22) 0%, rgba(8, 14, 28, 0.96) 100%); }
  .banner-snake   { --banner-glow: rgba(16, 185, 129, 0.7); background: radial-gradient(circle at center, rgba(16, 185, 129, 0.22) 0%, rgba(8, 14, 28, 0.96) 100%); }
  .banner-maze    { --banner-glow: rgba(0, 240, 255, 0.7); background: radial-gradient(circle at center, rgba(56, 189, 248, 0.22) 0%, rgba(8, 14, 28, 0.96) 100%); }
  .banner-guesser { --banner-glow: rgba(99, 102, 241, 0.7); background: radial-gradient(circle at center, rgba(99, 102, 241, 0.22) 0%, rgba(8, 14, 28, 0.96) 100%); }
  .banner-reactor { --banner-glow: rgba(0, 240, 255, 0.7); background: radial-gradient(circle at center, rgba(2, 132, 199, 0.25) 0%, rgba(8, 14, 28, 0.96) 100%); }

  .card-body {
    padding: 0.9rem;
    display: flex;
    flex-direction: column;
    flex: 1;
    min-height: 0;
    justify-content: space-between;
    background: transparent;
  }
  .card-tag {
    display: inline-flex;
    align-items: center;
    font-size: 0.62rem;
    letter-spacing: 1.2px;
    font-weight: 800;
    text-transform: uppercase;
    color: var(--primary);
    background: rgba(0, 240, 255, 0.08);
    border: 1px solid rgba(0, 240, 255, 0.25);
    padding: 3px 8px;
    border-radius: 4px;
    align-self: flex-start;
  }
  .card-title {
    font-size: 1.12rem;
    font-weight: 800;
    color: #ffffff;
    margin: 4px 0;
    letter-spacing: 0.5px;
  }
  .card-desc {
    font-size: 0.76rem;
    color: var(--text-muted);
    line-height: 1.4;
    margin-bottom: 0.5rem;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .card-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 0.85rem;
    border-top: 1px solid rgba(0, 240, 255, 0.12);
  }
  .card-score-preview {
    font-size: 0.78rem;
    font-weight: 700;
    color: var(--text-muted);
    letter-spacing: 0.5px;
    font-family: 'Consolas', monospace;
  }
  .card-score-preview span {
    color: var(--primary);
    font-weight: 900;
  }
  
  .launch-arrow {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    background: rgba(0, 240, 255, 0.08);
    border: 1px solid rgba(0, 240, 255, 0.25);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary);
    font-size: 1.05rem;
    transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  }
  .game-card:hover .launch-arrow {
    background: var(--primary);
    color: #030712;
    box-shadow: 0 0 25px rgba(0, 240, 255, 0.85);
    border-color: var(--primary);
    transform: scale(1.12) translateX(3px);
  }
  .launch-arrow:active {
    transform: scale(0.92);
  }

  /* Cognitive Radar Chart (Spider Graph) */
  .radar-card {
    background: linear-gradient(170deg, rgba(8, 16, 32, 0.92) 0%, rgba(2, 6, 16, 0.96) 100%);
    backdrop-filter: blur(16px);
    border: 1px solid rgba(0, 240, 255, 0.28);
    border-radius: 20px;
    padding: 1.8rem;
    margin-bottom: 2rem;
    box-shadow: 0 15px 45px rgba(0, 0, 0, 0.8), inset 0 0 35px rgba(0, 240, 255, 0.04);
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
    position: relative;
    overflow: hidden;
  }
  .radar-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 15%;
    right: 15%;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--primary), transparent);
    box-shadow: 0 0 10px var(--primary);
  }
  .radar-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(0, 240, 255, 0.15);
    padding-bottom: 1rem;
    flex-wrap: wrap;
    gap: 1rem;
  }
  .radar-title {
    font-size: 1.35rem;
    font-weight: 900;
    letter-spacing: 1px;
    color: #fff;
    display: flex;
    align-items: center;
    gap: 8px;
    text-shadow: 0 0 15px rgba(0, 240, 255, 0.4);
  }
  .radar-subtitle {
    font-size: 0.82rem;
    color: var(--text-muted);
    margin-top: 4px;
  }
  .brain-index-badge {
    background: rgba(0, 240, 255, 0.08);
    border: 1px solid var(--primary);
    padding: 8px 16px;
    border-radius: 12px;
    text-align: right;
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.25);
  }
  .brain-index-label {
    display: block;
    font-size: 0.65rem;
    font-weight: 900;
    color: var(--primary);
    letter-spacing: 1.5px;
  }
  .brain-index-val {
    font-size: 1.4rem;
    font-weight: 900;
    color: #fff;
    font-variant-numeric: tabular-nums;
    text-shadow: 0 0 10px rgba(0, 240, 255, 0.6);
  }

  .radar-content {
    display: flex;
    align-items: center;
    justify-content: space-around;
    flex-wrap: wrap;
    gap: 1.5rem;
  }
  .radar-canvas-wrap {
    width: 290px;
    height: 270px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  #radarChartCanvas {
    width: 290px;
    height: 270px;
    display: block;
  }

  .radar-metrics-list {
    flex: 1;
    min-width: 260px;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }
  .radar-metric-item {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    padding: 10px 14px;
    display: flex;
    align-items: center;
    gap: 12px;
    transition: background 0.2s;
  }
  .radar-metric-item:hover {
    background: rgba(255, 255, 255, 0.06);
  }
  .metric-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    flex-shrink: 0;
  }
  .metric-name {
    font-weight: 800;
    font-size: 0.9rem;
    color: #fff;
    width: 75px;
  }
  .metric-desc {
    font-size: 0.75rem;
    color: var(--text-muted);
    flex: 1;
  }
  .metric-val {
    font-size: 0.95rem;
    font-weight: 900;
    font-family: monospace;
    color: var(--primary);
  }

  /* Score Grid */
  .score-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
    gap: 1.4rem;
  }
  .score-card, .settings-box {
    background: linear-gradient(170deg, rgba(8, 16, 32, 0.92) 0%, rgba(2, 6, 16, 0.96) 100%);
    backdrop-filter: blur(14px);
    border: 1px solid rgba(0, 240, 255, 0.22);
    border-radius: 18px;
    padding: 1.6rem;
    transition: transform 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
    position: relative;
    overflow: hidden;
  }
  .score-card::before, .settings-box::before {
    content: '';
    position: absolute;
    top: 0;
    left: 20%;
    right: 20%;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(0, 240, 255, 0.5), transparent);
  }
  .score-card:hover { 
    transform: translateY(-4px); 
    border-color: var(--primary); 
    box-shadow: 0 15px 40px rgba(0,0,0,0.85), 0 0 25px rgba(0, 240, 255, 0.25);
  }
  
  .score-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.1rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid rgba(0, 240, 255, 0.15);
  }
  .score-card-title {
    font-size: 1.2rem;
    font-weight: 800;
    letter-spacing: 0.5px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .score-badge {
    font-size: 0.65rem;
    font-weight: 800;
    padding: 3px 8px;
    border-radius: 6px;
    text-transform: uppercase;
  }

  .stat-row, .settings-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.7rem 0;
    border-bottom: 1px dashed rgba(255, 255, 255, 0.08);
  }
  .stat-row:last-child, .settings-row:last-child { border-bottom: none; }
  .stat-label { color: var(--text-muted); font-size: 0.85rem; }
  .stat-val { font-weight: 800; font-size: 1rem; }

  .switch {
    position: relative; display: inline-block; width: 44px; height: 24px;
  }
  .switch input { opacity: 0; width: 0; height: 0; }
  .slider {
    position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
    background-color: rgba(255,255,255,0.1); transition: .4s; border-radius: 24px;
  }
  .slider:before {
    position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px;
    background-color: white; transition: .4s; border-radius: 50%;
  }
  input:checked + .slider { background-color: var(--primary); box-shadow: 0 0 10px var(--primary); }
  input:checked + .slider:before { transform: translateX(20px); }
  #toggleRansomHorror:checked + .slider { background-color: var(--danger) !important; box-shadow: 0 0 14px rgba(239, 68, 68, 0.8) !important; }

  /* Modals with Framer Motion Spring Physics & UI/UX Pro Max Glass */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(2, 4, 10, 0.45);
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    padding: 1rem;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    opacity: 0;
    transition: opacity 0.28s ease;
  }
  .modal-overlay.active { display: flex; opacity: 1; }
  
  .modal-box {
    background: rgba(4, 9, 22, 0.90);
    backdrop-filter: blur(28px);
    -webkit-backdrop-filter: blur(28px);
    border: 1px solid rgba(0, 240, 255, 0.38);
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.95), 0 0 55px rgba(0, 240, 255, 0.22);
    border-radius: 26px;
    padding: 2.2rem 1.9rem;
    width: 92vw;
    max-width: 440px;
    max-height: 88vh;
    max-height: 88dvh;
    overflow-y: auto;
    margin: auto;
    text-align: center;
    transform: scale(0.92) translateY(20px);
    transition: transform 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.25s ease;
    position: relative;
    box-sizing: border-box;
  }
  .modal-box::before {
    content: '';
    position: absolute;
    top: 0;
    left: 12%;
    right: 12%;
    height: 2px;
    background: linear-gradient(90deg, transparent, var(--primary), transparent);
    box-shadow: 0 0 16px var(--primary);
  }
  .modal-overlay.active .modal-box { transform: scale(1) translateY(0); }

  /* Framer Motion Style Modal Tabs */
  .auth-modal-tabs {
    display: flex;
    background: rgba(1, 4, 12, 0.7);
    border: 1px solid rgba(0, 240, 255, 0.2);
    border-radius: 12px;
    padding: 3px;
    margin: 1.2rem 0 1rem 0;
    gap: 4px;
  }
  .auth-modal-tab {
    flex: 1;
    padding: 0.55rem;
    font-size: 0.75rem;
    font-weight: 800;
    letter-spacing: 1px;
    color: var(--text-muted);
    background: transparent;
    border: none;
    border-radius: 9px;
    cursor: pointer;
    transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  }
  .auth-modal-tab.active {
    background: var(--primary);
    color: #030712;
    font-weight: 900;
    box-shadow: 0 0 15px rgba(0, 240, 255, 0.5);
  }
  .auth-modal-tab:hover:not(.active) {
    color: #fff;
    background: rgba(255, 255, 255, 0.05);
  }
  
  .modal-actions {
    display: flex;
    gap: 0.8rem;
    justify-content: center;
    margin-top: 1.4rem;
  }
  .btn-modal {
    min-height: 48px;
    padding: 0.8rem 1.2rem;
    border-radius: 12px;
    border: none;
    cursor: pointer;
    font-weight: 800;
    font-size: 0.92rem;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.22s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    flex: 1;
    letter-spacing: 0.5px;
  }
  .btn-modal:hover:not(:disabled) {
    transform: translateY(-2px) scale(1.02);
  }
  .btn-modal:active:not(:disabled) {
    transform: scale(0.96) !important;
  }
  .btn-modal:disabled { opacity: 0.65; cursor: not-allowed; filter: grayscale(0.5); }
  .btn-launch { 
    background: linear-gradient(135deg, var(--primary), #0284c7); 
    color: #030712; 
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.45); 
    font-weight: 900;
  }
  .btn-launch:hover:not(:disabled) { 
    background: linear-gradient(135deg, #7dd3fc, var(--primary)); 
    box-shadow: 0 0 30px rgba(0, 240, 255, 0.7); 
  }
  .btn-cancel { 
    background: rgba(255, 255, 255, 0.05); 
    border: 1px solid rgba(255, 255, 255, 0.15); 
    color: var(--text-muted); 
  }
  .btn-cancel:hover:not(:disabled) { 
    background: rgba(255, 255, 255, 0.1); 
    color: #fff; 
    border-color: rgba(255, 255, 255, 0.3); 
  }

  .auth-form-group { text-align: left; margin-top: 1rem; }
  .auth-label {
    display: block;
    font-size: 0.74rem;
    color: var(--primary);
    margin-bottom: 0.35rem;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
  }
  .auth-input-wrap {
    position: relative;
    display: flex;
    align-items: center;
    width: 100%;
  }
  .auth-input-icon {
    position: absolute;
    left: 14px;
    font-size: 1rem;
    color: var(--text-muted);
    pointer-events: none;
    transition: color 0.2s;
  }
  .auth-input {
    width: 100%;
    height: 48px;
    min-height: 48px;
    padding: 0 1rem 0 2.6rem;
    background: rgba(6, 13, 28, 0.85);
    border: 1px solid rgba(0, 240, 255, 0.25);
    border-radius: 12px;
    color: var(--text-main);
    font-size: 15px !important;
    outline: none;
    transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    box-sizing: border-box;
  }
  .auth-input:focus {
    border-color: var(--primary);
    box-shadow: 0 0 20px rgba(0, 240, 255, 0.45);
    background: rgba(8, 18, 38, 0.95);
    transform: translateY(-1px);
  }
  .auth-input:focus + .auth-input-icon, .auth-input-wrap:focus-within .auth-input-icon {
    color: var(--primary);
  }

  @keyframes bannerSlideIn {
    from { opacity: 0; transform: translateY(-8px) scale(0.96); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }
  .auth-msg {
    margin-top: 1rem;
    font-size: 0.85rem;
    line-height: 1.4;
    padding: 0.75rem 1rem;
    border-radius: 10px;
    display: none;
    text-align: left;
    animation: bannerSlideIn 0.3s ease forwards;
    word-break: break-word;
  }
  .auth-msg.error {
    background: rgba(239, 68, 68, 0.12);
    color: #fca5a5;
    border: 1px solid rgba(239, 68, 68, 0.6);
    box-shadow: 0 0 15px rgba(239, 68, 68, 0.25);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .auth-msg.success {
    background: rgba(34, 197, 94, 0.12);
    color: #86efac;
    border: 1px solid rgba(34, 197, 94, 0.6);
    box-shadow: 0 0 15px rgba(34, 197, 94, 0.25);
    display: flex;
    align-items: center;
    gap: 8px;
  }

  @keyframes spin { to { transform: rotate(360deg); } }
  .spinner {
    display: inline-block;
    width: 16px;
    height: 16px;
    border: 2px solid rgba(0, 0, 0, 0.25);
    border-top-color: #000;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }

  .switch-auth-link {
    display: inline-block;
    margin-top: 1.1rem;
    font-size: 0.85rem;
    color: var(--text-muted);
    cursor: pointer;
    text-decoration: underline;
    padding: 0.4rem;
  }
  .switch-auth-link:hover { color: var(--primary); }

  /* =========================================================
     DISCORD & GOOGLE PLAY GAMES ACCOUNT LEVELING SYSTEM
     ========================================================= */
  .profile-level-badge {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    background: linear-gradient(135deg, #facc15 0%, #ca8a04 100%);
    color: #030712;
    font-size: 0.7rem;
    font-weight: 900;
    padding: 2px 7px;
    border-radius: 6px;
    letter-spacing: 0.5px;
    box-shadow: 0 0 12px rgba(250, 204, 21, 0.45);
    margin-left: 6px;
    vertical-align: middle;
  }
  .player-rank-title {
    font-size: 0.7rem;
    font-weight: 800;
    color: var(--primary);
    text-transform: uppercase;
    letter-spacing: 1.2px;
    margin-top: 3px;
    text-shadow: 0 0 8px rgba(0, 240, 255, 0.4);
  }
  .profile-xp-box {
    width: 100%;
    margin-top: 10px;
    background: rgba(3, 7, 18, 0.7);
    border: 1px solid rgba(0, 240, 255, 0.18);
    border-radius: 10px;
    padding: 8px 10px;
    text-align: left;
  }
  .xp-header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.68rem;
    font-weight: 800;
    color: var(--text-muted);
    letter-spacing: 0.8px;
    margin-bottom: 5px;
  }
  .xp-header-row .xp-val {
    color: var(--primary);
    font-weight: 900;
  }
  .xp-bar-track {
    width: 100%;
    height: 6px;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 999px;
    overflow: hidden;
    position: relative;
  }
  .xp-bar-fill {
    height: 100%;
    width: 0%;
    background: linear-gradient(90deg, #0284c7 0%, var(--primary) 100%);
    border-radius: 999px;
    box-shadow: 0 0 10px rgba(0, 240, 255, 0.8);
    transition: width 0.6s cubic-bezier(0.2, 0.8, 0.2, 1);
  }
  .xp-subtext {
    font-size: 0.65rem;
    color: var(--text-muted);
    margin-top: 4px;
    display: flex;
    justify-content: space-between;
    font-weight: 700;
  }

  /* Header Level Pill (Desktop & Mobile) */
  .meta-level-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: rgba(250, 204, 21, 0.12);
    border: 1px solid rgba(250, 204, 21, 0.4);
    color: #facc15;
    font-size: 0.75rem;
    font-weight: 900;
    padding: 4px 12px;
    border-radius: 999px;
    letter-spacing: 0.8px;
    box-shadow: 0 0 15px rgba(250, 204, 21, 0.25);
  }

  /* Navigation Lock Indicators */
  .nav-lock-badge {
    font-size: 0.75rem;
    margin-left: auto;
    background: rgba(244, 63, 94, 0.18);
    color: #f43f5e;
    border: 1px solid rgba(244, 63, 94, 0.3);
    padding: 1px 6px;
    border-radius: 4px;
    font-weight: 800;
    letter-spacing: 0.5px;
  }

  /* =========================================================
     LOCKED FEATURE CARDS FOR GUESTS
     ========================================================= */
  .locked-card {
    background: var(--card-bg);
    border: 1px solid rgba(244, 63, 94, 0.35);
    border-radius: 18px;
    padding: 2.4rem 1.8rem;
    text-align: center;
    max-width: 620px;
    margin: 2rem auto;
    position: relative;
    backdrop-filter: blur(16px);
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5), 0 0 25px rgba(244, 63, 94, 0.1);
  }
  .locked-icon-wrap {
    width: 64px;
    height: 64px;
    margin: 0 auto 1.2rem;
    background: rgba(244, 63, 94, 0.15);
    border: 1px solid rgba(244, 63, 94, 0.4);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.9rem;
    color: #f43f5e;
    box-shadow: 0 0 20px rgba(244, 63, 94, 0.3);
  }
  .locked-title {
    font-size: 1.45rem;
    font-weight: 900;
    color: var(--text-main);
    letter-spacing: 0.5px;
    margin-bottom: 0.6rem;
  }
  .locked-subtitle {
    color: var(--text-muted);
    font-size: 0.92rem;
    line-height: 1.55;
    max-width: 480px;
    margin: 0 auto 1.5rem;
  }
  .locked-perks-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 10px;
    margin-bottom: 1.8rem;
    text-align: left;
  }
  .locked-perk-item {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    padding: 10px 12px;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    font-size: 0.82rem;
  }
  .locked-perk-icon {
    font-size: 1.1rem;
    line-height: 1;
  }
  .locked-perk-title {
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 2px;
  }
  .locked-perk-desc {
    color: var(--text-muted);
    font-size: 0.75rem;
  }
  .locked-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
  }
  .btn-unlock-primary {
    background: linear-gradient(135deg, var(--primary), #0284c7);
    color: #000;
    font-weight: 900;
    border: none;
    padding: 10px 24px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.92rem;
    box-shadow: 0 0 16px rgba(56, 189, 248, 0.4);
    transition: all 0.2s;
  }
  .btn-unlock-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 0 24px rgba(56, 189, 248, 0.7);
  }
  .btn-unlock-secondary {
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: var(--text-main);
    font-weight: 700;
    padding: 10px 22px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.92rem;
    transition: all 0.2s;
  }
  .btn-unlock-secondary:hover {
    background: rgba(255, 255, 255, 0.12);
  }

  /* Player Level Spotlight Card in Brain Stats */
  .player-spotlight-card {
    background: linear-gradient(170deg, rgba(8, 16, 32, 0.92) 0%, rgba(2, 6, 16, 0.96) 100%);
    border: 1px solid rgba(0, 240, 255, 0.28);
    border-radius: 16px;
    padding: 1.4rem;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1.4rem;
    flex-wrap: wrap;
    backdrop-filter: blur(14px);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7), inset 0 0 20px rgba(0, 240, 255, 0.03);
    position: relative;
    overflow: hidden;
  }
  .player-spotlight-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 15%;
    right: 15%;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--primary), transparent);
    box-shadow: 0 0 8px var(--primary);
  }
  .spotlight-level-emblem {
    width: 68px;
    height: 68px;
    border-radius: 16px;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #030712;
    font-weight: 900;
    box-shadow: 0 0 25px rgba(0, 240, 255, 0.5);
    flex-shrink: 0;
    border: 1px solid rgba(255, 255, 255, 0.3);
  }
  .spotlight-level-emblem .emblem-lbl {
    font-size: 0.62rem;
    letter-spacing: 1px;
    line-height: 1;
  }
  .spotlight-level-emblem .emblem-num {
    font-size: 1.7rem;
    line-height: 1;
    margin-top: 2px;
  }
  .spotlight-info {
    flex: 1;
    min-width: 220px;
  }
  .spotlight-name-row {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 4px;
  }
  .spotlight-username {
    font-size: 1.25rem;
    font-weight: 900;
    color: var(--text-main);
  }
  .spotlight-tier-tag {
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.35);
    color: var(--primary);
    font-size: 0.72rem;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 999px;
  }

  /* Mobile Overrides */
  @media (max-width: 768px) {
    body { flex-direction: column; padding-bottom: 80px; }

    aside {
      width: 100%; height: 75px; position: fixed; bottom: 0; left: 0; right: 0;
      padding: 0.4rem; flex-direction: row; border-right: none;
      border-top: 1px solid rgba(255, 255, 255, 0.08); background: rgba(8, 12, 23, 0.96);
      align-items: center; justify-content: space-around; z-index: 999;
    }

    .brand, .auth-widget, .btn-portal-recall { display: none; }
    nav { flex-direction: row; width: 100%; justify-content: space-around; gap: 0; }
    .nav-btn {
      flex-direction: column; gap: 4px; padding: 0.35rem; font-size: 0.72rem;
      border-left: none !important; border-radius: 10px; text-align: center;
    }
    .nav-btn.active {
      background: rgba(56, 189, 248, 0.1); color: var(--primary);
      box-shadow: none; border-top: 2px solid var(--primary);
    }

    main { width: 100vw; height: calc(100vh - 75px); height: calc(100dvh - 75px); padding: 1.2rem 1rem; }
    .top-meta h2 { font-size: 1.5rem; }
    .carousel-controls { display: none; }
    
    .game-carousel { padding-bottom: 1.8rem; gap: 1.2rem; }
    .game-card { min-width: 82vw; width: 82vw; }

    .modal-box {
      padding: 1.4rem 1.1rem;
      width: 92vw;
      max-height: 82vh;
      max-height: 82dvh;
    }

    .portal-content {
      padding: 0.5rem;
    }
    .portal-title {
      font-size: 1.95rem;
    }
    .portal-subtitle {
      font-size: 0.82rem;
      margin-bottom: 1.2rem;
    }
    .portal-actions {
      max-width: 100%;
      width: 100%;
    }
    .btn-portal {
      min-height: 44px;
      padding: 0.7rem 1rem;
    }

    .nav-lock-badge { margin-left: 0; font-size: 0.65rem; padding: 0 4px; }
    .locked-card { padding: 1.6rem 1.1rem; width: 100%; margin: 1rem auto; }
    .locked-title { font-size: 1.25rem; }
    .locked-perks-grid { grid-template-columns: 1fr; }
    .player-spotlight-card { padding: 1rem; gap: 1rem; }
    .spotlight-level-emblem { width: 56px; height: 56px; }
    .spotlight-level-emblem .emblem-num { font-size: 1.4rem; }
  }
</style>
</head>
<body>

  <!-- Rising Cyber Laser Rays & Particle Floor Horizon Canvas -->
  <canvas id="techRaysCanvas"></canvas>

  <!-- Framer Motion Kinetic Camera Depth Curtain -->
  <div id="motionCurtain" class="motion-page-curtain" aria-hidden="true">
    <div class="curtain-velocity-bar"></div>
    <div class="curtain-pulse-ring"></div>
  </div>
  <!-- Legacy DOM hooks for seamless backward compatibility -->
  <div id="cyberWipeOverlay" class="legacy-curtain-alias" style="display:none;" aria-hidden="true"></div>
  <div id="cyberShutter" class="legacy-curtain-alias" style="display:none;" aria-hidden="true"></div>

  <!-- =========================================================
       LANDING PORTAL OVERLAY
       ========================================================= -->
  <div id="landingPortal">
    <div class="portal-content">
      <div class="portal-tag">🧠 BRAIN TRAINING & LOGIC HUB</div>
      <h1 class="portal-title">GAME HUB</h1>
      <p class="portal-subtitle">
        Simple mind-training & logic puzzles. Boost your memory, focus, problem solving, and reflexes.
      </p>

      <div class="portal-actions">
        <% if (isLoggedIn) { %>
          <button class="btn-portal btn-portal-primary" onclick="triggerFastEnter('<%= currentUser %>', 'Welcome back!')">
            <span>▶ PLAY NOW (<%= currentUser %>)</span>
          </button>
          <button class="btn-portal btn-portal-secondary" onclick="performLogout()">
            <span>✕ LOG OUT</span>
          </button>
        <% } else { %>
          <button class="btn-portal btn-portal-primary" onclick="window.location.href='auth.jsp?mode=login'">
            <span>LOG IN</span>
          </button>
          <button class="btn-portal btn-portal-secondary" onclick="window.location.href='auth.jsp?mode=signup'">
            <span>SIGN UP</span>
          </button>
          <button class="btn-portal btn-portal-guest" onclick="triggerFastEnter('Guest', 'Welcome! Enjoy the games.')">
            <span>🎮 PLAY AS GUEST</span>
          </button>
        <% } %>
      </div>

      <div class="portal-kinetic-hint">
        <span>⚡ KINETIC GRID ACTIVE • MOVE CURSOR & CLICK ANYWHERE</span>
      </div>

      <div class="portal-footer-note">
        Daily brain-training • Free to play • Fast & lightweight
      </div>
    </div>
  </div>

  <!-- =========================================================
       SIDEBAR & PROFILE STATE
       ========================================================= -->
  <aside>
    <div class="brand" onclick="showPortal()">
      <span class="brand-glyph">⬡</span> GAME <span class="brand-badge">CORE v3.5</span>
    </div>

    <div class="auth-widget" id="authWidget">
      <% if (isLoggedIn) { %>
        <div class="auth-avatar-wrap">
          <div class="auth-avatar"><%= currentUser.substring(0, 1).toUpperCase() %></div>
          <div class="auth-avatar-pulse"></div>
        </div>
        <div class="auth-name">
          <%= currentUser %>
          <span class="profile-level-badge" id="profileLevelBadge">LVL 1</span>
        </div>
        <div class="player-rank-title" id="profileRankTitle">Novice Thinker</div>
        <div class="profile-xp-box" id="profileXpBox">
          <div class="xp-header-row">
            <span>// XP PROGRESS</span>
            <span class="xp-val" id="profileXpText">0 / 200 XP</span>
          </div>
          <div class="xp-bar-track">
            <div class="xp-bar-fill" id="profileXpFill" style="width: 0%;"></div>
          </div>
          <div class="xp-subtext">
            <span id="profileXpPercent">0%</span>
            <span id="profileXpRemaining">200 XP to next lvl</span>
          </div>
        </div>
        <button class="btn-auth btn-logout" onclick="performLogout()" style="margin-top: 12px;">
          <span>⏻ DISCONNECT</span>
        </button>
      <% } else { %>
        <div class="auth-avatar-wrap">
          <div class="auth-avatar" style="background: rgba(255,255,255,0.08); color: var(--text-muted); box-shadow: none; border-color: rgba(255,255,255,0.2);">?</div>
        </div>
        <div class="auth-name" style="color: var(--text-muted);">
          GUEST OPERATIVE
          <span class="profile-level-badge" style="background: rgba(255,255,255,0.1); color: var(--text-muted); box-shadow: none;">LVL 0</span>
        </div>
        <div class="auth-role" style="color: var(--warning); margin-top: 4px;">UNREGISTERED GUEST</div>
        <div style="font-size: 0.72rem; color: var(--text-muted); margin: 6px 0;">Sign in to earn XP & save stats</div>
        <div style="display: flex; gap: 6px; width: 100%; margin-top: 6px;">
          <button class="btn-auth btn-login" onclick="openLoginModal()" style="flex: 1; padding: 0.5rem;">Log In</button>
          <button class="btn-auth btn-signup" onclick="openSignupModal()" style="flex: 1; padding: 0.5rem; background: var(--accent); color: #030712; font-weight: 800;">Sign Up</button>
        </div>
      <% } %>
    </div>

    <nav>
      <button class="nav-btn active" onclick="switchTab('library', this)">
        <span style="font-size: 1.15rem; color: var(--primary);">⬡</span>
        <span>Games</span>
      </button>
      <button class="nav-btn" onclick="switchTab('scores', this)" id="navBtnScores">
        <span style="font-size: 1.15rem; color: #a855f7;">◈</span>
        <span>Brain Stats</span>
        <% if (!isLoggedIn) { %>
          <span class="nav-lock-badge" id="navLockScores">🔒</span>
        <% } %>
      </button>
      <button class="nav-btn" onclick="switchTab('settings', this)" id="navBtnSettings">
        <span style="font-size: 1.15rem;" id="navSettingsIcon"><%= isLoggedIn ? "⚙️" : "🔒" %></span>
        <span id="navSettingsText"><%= isLoggedIn ? "Settings" : "Settings (Locked)" %></span>
      </button>
    </nav>

    <button class="btn-portal-recall" onclick="showPortal()">
      <span>🏠 Welcome Screen</span>
    </button>
  </aside>

  <!-- =========================================================
       MAIN CONTENT DASHBOARD
       ========================================================= -->
  <main>
    <div class="top-meta">
      <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
        <h2 id="viewTitle">GAMES GALLERY</h2>
        <div class="meta-level-pill" id="metaLevelPill" style="display: <%= isLoggedIn ? "inline-flex" : "none" %>;">
          <span>⭐</span>
          <span id="metaLevelText">LVL 1</span>
          <span style="color: rgba(250, 204, 21, 0.4);">•</span>
          <span id="metaXpText">0 XP</span>
        </div>
      </div>
      <div class="sys-status">System Online</div>
    </div>

    <!-- VIEW 1: GAME LIBRARY (NEURAL BUS & CAROUSEL DUAL MODE) -->
    <section id="libraryView" class="view-panel active">
      <!-- Top Layout Switcher & Status Bar -->
      <div class="library-header-bar">
        <div class="view-mode-tabs" role="tablist" aria-label="Library View Mode">
          <button class="view-mode-pill active" id="modeBtnNeural" onclick="setLibraryMode('neural')" role="tab" aria-selected="true">
            <span class="pill-dot"></span>
            <span>⚡ NEURAL BUS</span>
          </button>
          <button class="view-mode-pill" id="modeBtnCarousel" onclick="setLibraryMode('carousel')" role="tab" aria-selected="false">
            <span>🗂️ CAROUSEL</span>
          </button>
        </div>
        <div class="node-sync-indicator">
          <span class="live-dot"></span>
          <span>BUS INTEGRATION // 6 NODES ONLINE</span>
        </div>
      </div>

      <!-- LINEAR NEURAL INTEGRATION BUS (Zero Loops Architecture) -->
      <div class="neural-bus-container" id="neuralBusContainer">
        <!-- Interactive Cursor Spotlight Glow -->
        <div class="neural-spotlight" id="neuralSpotlight"></div>

        <!-- Linear SVG Traces (Zero Loops, Hub ➔ Games) -->
        <svg class="neural-svg" viewBox="0 0 1000 620" preserveAspectRatio="none" aria-hidden="true">
          <!-- Hub ➔ Chess (Top-Left) -->
          <path id="trace-base-chess" class="neural-trace-base" d="M 470 310 V 145 Q 470 120 445 120 H 200" />
          <path id="trace-pulse-chess" class="neural-trace-pulse pulse-chess" d="M 470 310 V 145 Q 470 120 445 120 H 200" />

          <!-- Hub ➔ Bomb Defusal (Top-Right) -->
          <path id="trace-base-bomb" class="neural-trace-base" d="M 530 310 V 145 Q 530 120 555 120 H 800" />
          <path id="trace-pulse-bomb" class="neural-trace-pulse pulse-bomb" d="M 530 310 V 145 Q 530 120 555 120 H 800" />

          <!-- Hub ➔ Snake (Mid-Left) -->
          <path id="trace-base-snake" class="neural-trace-base" d="M 500 310 H 140" />
          <path id="trace-pulse-snake" class="neural-trace-pulse pulse-snake" d="M 500 310 H 140" />

          <!-- Hub ➔ Maze (Mid-Right) -->
          <path id="trace-base-maze" class="neural-trace-base" d="M 500 310 H 860" />
          <path id="trace-pulse-maze" class="neural-trace-pulse pulse-maze" d="M 500 310 H 860" />

          <!-- Hub ➔ Cipher Guesser (Bottom-Left) -->
          <path id="trace-base-guess" class="neural-trace-base" d="M 470 310 V 475 Q 470 500 445 500 H 200" />
          <path id="trace-pulse-guess" class="neural-trace-pulse pulse-guess" d="M 470 310 V 475 Q 470 500 445 500 H 200" />

          <!-- Hub ➔ Reactor Meltdown (Bottom-Right) -->
          <path id="trace-base-reactor" class="neural-trace-base" d="M 530 310 V 475 Q 530 500 555 500 H 800" />
          <path id="trace-pulse-reactor" class="neural-trace-pulse pulse-reactor" d="M 530 310 V 475 Q 530 500 555 500 H 800" />
        </svg>

        <!-- Central Game Hub Squircle Nucleus (Click to View Master Library) -->
        <div class="neural-hub-core" id="neuralHubCore" onclick="openMasterLibraryModal()" tabindex="0" role="button" aria-label="Game Hub Core - Click to view all games" title="Click to browse all games">
          <div class="hub-core-ping"></div>
          <!-- Hypnotic WebGL Dithered Plasma Shader Canvas -->
          <canvas class="hub-shader-canvas" id="hubShaderCanvas" width="96" height="96" aria-hidden="true"></canvas>
          <div class="hub-core-content">
            <div class="hub-core-emblem">
              <svg class="hub-nexus-svg" viewBox="0 0 32 32" fill="none">
                <polygon points="16,3 28,10 28,22 16,29 4,22 4,10" stroke="#00f0ff" stroke-width="1.8" fill="rgba(0, 240, 255, 0.2)"/>
                <polygon points="16,8 23,12 23,20 16,24 9,20 9,12" stroke="#38bdf8" stroke-width="1.2" stroke-dasharray="3 1.5"/>
                <circle cx="16" cy="16" r="3.2" fill="#ffffff"/>
              </svg>
            </div>
            <div class="hub-core-title">GAME<span>HUB</span></div>
          </div>
          <div class="hub-core-status pulse-lib-hint">
            <span class="lib-icon">📂</span> ALL GAMES
          </div>
        </div>

        <!-- Satellite 1: Cyber Chess (Top-Left) -->
        <div class="neural-node node-chess" id="node-chess" style="left: 20%; top: 19.35%;"
             onmouseenter="showNeuralBriefing('chess', this)"
             onmouseleave="hideNeuralBriefing('chess')"
             onclick="handleNeuralNodeClick('chess', this)"
             tabindex="0" role="button" aria-label="Cyber Chess Node">
          <div class="node-icon">
            <svg class="node-cyber-svg svg-chess" viewBox="0 0 40 40" fill="none">
              <defs>
                <linearGradient id="gradChess" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#38bdf8" />
                  <stop offset="100%" stop-color="#818cf8" />
                </linearGradient>
              </defs>
              <path d="M12 34 h16 v-3 h-16 v3 z" fill="url(#gradChess)" opacity="0.8" />
              <path d="M14 31 h12 c0 -3 -2 -5 -3 -7 h1 c1.5 0 2.5 -1.5 2 -3 l-1 -3 c2 -1 3 -3 3 -5 c0 -3 -2.5 -5 -6 -5 c-1.5 0 -3 0.5 -4 1.5 c-3 0 -5 2 -6 5 c-1 3 0 5 2 6.5 c-1 2 -2 4.5 -2 7 c0 2 1 3 3 3 z" fill="url(#gradChess)" />
              <line x1="20" y1="13" x2="25" y2="14" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" />
              <circle cx="21" cy="14" r="1.2" fill="#00f0ff" />
            </svg>
          </div>
          <div class="node-name">Chess</div>
        </div>

        <!-- Satellite 2: Defusal Protocol (Top-Right) -->
        <div class="neural-node node-bomb" id="node-bomb" style="left: 80%; top: 19.35%;"
             onmouseenter="showNeuralBriefing('bomb', this)"
             onmouseleave="hideNeuralBriefing('bomb')"
             onclick="handleNeuralNodeClick('bomb', this)"
             tabindex="0" role="button" aria-label="Defusal Protocol Node">
          <div class="node-icon">
            <svg class="node-cyber-svg svg-bomb" viewBox="0 0 40 40" fill="none">
              <defs>
                <linearGradient id="gradBomb" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#f43f5e" />
                  <stop offset="100%" stop-color="#fb7185" />
                </linearGradient>
              </defs>
              <circle cx="20" cy="22" r="13" stroke="url(#gradBomb)" stroke-width="1.8" stroke-dasharray="8 3" />
              <circle cx="20" cy="22" r="9" fill="rgba(244, 63, 94, 0.25)" stroke="#f43f5e" stroke-width="1.5" />
              <rect x="17.5" y="6" width="5" height="4" rx="1" fill="#fb7185" />
              <path d="M20 6 C20 3 24 3 24 1" stroke="#facc15" stroke-width="1.8" stroke-linecap="round" />
              <circle cx="24" cy="1" r="1.5" fill="#facc15" />
              <text x="20" y="23" font-size="5.5" font-weight="900" font-family="monospace" fill="#ffffff" text-anchor="middle" dominant-baseline="central">00:07</text>
            </svg>
          </div>
          <div class="node-name">Defusal</div>
        </div>

        <!-- Satellite 3: Cyber Snake (Mid-Left) -->
        <div class="neural-node node-snake" id="node-snake" style="left: 14%; top: 50%;"
             onmouseenter="showNeuralBriefing('snake', this)"
             onmouseleave="hideNeuralBriefing('snake')"
             onclick="handleNeuralNodeClick('snake', this)"
             tabindex="0" role="button" aria-label="Cyber Snake Node">
          <div class="node-icon">
            <svg class="node-cyber-svg svg-snake" viewBox="0 0 40 40" fill="none">
              <defs>
                <linearGradient id="gradSnake" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#10e6a8" />
                  <stop offset="100%" stop-color="#34d399" />
                </linearGradient>
              </defs>
              <path d="M28 10 C28 6 22 6 20 9 C18 12 11 12 11 17 C11 22 17 23 20 25 C24 27 27 29 27 33 C27 36 23 37 20 37 C15 37 12 34 12 30" stroke="url(#gradSnake)" stroke-width="3" stroke-linecap="round" fill="none" />
              <circle cx="28" cy="10" r="3.5" fill="url(#gradSnake)" />
              <circle cx="29.2" cy="9.2" r="1" fill="#040918" />
              <circle cx="16" cy="19" r="1.4" fill="#ffffff" />
              <circle cx="24" cy="29" r="1.4" fill="#ffffff" />
            </svg>
          </div>
          <div class="node-name">Snake</div>
        </div>

        <!-- Satellite 4: Cyber Maze (Mid-Right) -->
        <div class="neural-node node-maze" id="node-maze" style="left: 86%; top: 50%;"
             onmouseenter="showNeuralBriefing('maze', this)"
             onmouseleave="hideNeuralBriefing('maze')"
             onclick="handleNeuralNodeClick('maze', this)"
             tabindex="0" role="button" aria-label="Cyber Maze Node">
          <div class="node-icon">
            <svg class="node-cyber-svg svg-maze" viewBox="0 0 40 40" fill="none">
              <defs>
                <linearGradient id="gradMaze" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#c084fc" />
                  <stop offset="100%" stop-color="#a855f7" />
                </linearGradient>
              </defs>
              <rect x="7" y="7" width="26" height="26" rx="5" stroke="url(#gradMaze)" stroke-width="2" fill="rgba(168, 85, 247, 0.12)" />
              <path d="M7 16 H20 V24 H13 V33" stroke="url(#gradMaze)" stroke-width="1.8" stroke-linecap="round" fill="none" />
              <path d="M26 7 V18 H33" stroke="url(#gradMaze)" stroke-width="1.8" stroke-linecap="round" fill="none" />
              <path d="M20 28 H27 V33" stroke="url(#gradMaze)" stroke-width="1.8" stroke-linecap="round" fill="none" />
              <circle cx="20" cy="20" r="2.2" fill="#ffffff" />
            </svg>
          </div>
          <div class="node-name">Maze</div>
        </div>

        <!-- Satellite 5: Cipher Guesser (Bottom-Left) -->
        <div class="neural-node node-guess" id="node-guess" style="left: 20%; top: 80.65%;"
             onmouseenter="showNeuralBriefing('guess', this)"
             onmouseleave="hideNeuralBriefing('guess')"
             onclick="handleNeuralNodeClick('guess', this)"
             tabindex="0" role="button" aria-label="Cipher Guesser Node">
          <div class="node-icon">
            <svg class="node-cyber-svg svg-guess" viewBox="0 0 40 40" fill="none">
              <defs>
                <linearGradient id="gradGuess" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#facc15" />
                  <stop offset="100%" stop-color="#fde047" />
                </linearGradient>
              </defs>
              <rect x="7" y="7" width="26" height="26" rx="5" stroke="url(#gradGuess)" stroke-width="2" fill="rgba(250, 204, 21, 0.12)" />
              <text x="14" y="16" font-size="7.5" font-weight="900" font-family="monospace" fill="#facc15" text-anchor="middle" dominant-baseline="central">1</text>
              <text x="26" y="16" font-size="7.5" font-weight="900" font-family="monospace" fill="#ffffff" text-anchor="middle" dominant-baseline="central">0</text>
              <text x="14" y="27" font-size="7.5" font-weight="900" font-family="monospace" fill="#ffffff" text-anchor="middle" dominant-baseline="central">? </text>
              <text x="26" y="27" font-size="7.5" font-weight="900" font-family="monospace" fill="#facc15" text-anchor="middle" dominant-baseline="central">7</text>
              <circle cx="20" cy="20" r="1.5" fill="#fde047" />
            </svg>
          </div>
          <div class="node-name">Cipher</div>
        </div>

        <!-- Satellite 6: Reactor Meltdown (Bottom-Right) -->
        <div class="neural-node node-reactor" id="node-reactor" style="left: 80%; top: 80.65%;"
             onmouseenter="showNeuralBriefing('reactor', this)"
             onmouseleave="hideNeuralBriefing('reactor')"
             onclick="handleNeuralNodeClick('reactor', this)"
             tabindex="0" role="button" aria-label="Reactor Meltdown Node">
          <div class="node-icon">
            <svg class="node-cyber-svg svg-reactor" viewBox="0 0 40 40" fill="none">
              <defs>
                <linearGradient id="gradReactor" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#00f0ff" />
                  <stop offset="100%" stop-color="#38bdf8" />
                </linearGradient>
              </defs>
              <ellipse cx="20" cy="20" rx="14" ry="5.5" stroke="url(#gradReactor)" stroke-width="1.8" transform="rotate(-30 20 20)" stroke-dasharray="14 4" />
              <ellipse cx="20" cy="20" rx="14" ry="5.5" stroke="url(#gradReactor)" stroke-width="1.8" transform="rotate(30 20 20)" stroke-dasharray="14 4" />
              <ellipse cx="20" cy="20" rx="14" ry="5.5" stroke="#ffffff" stroke-width="1.2" transform="rotate(90 20 20)" stroke-dasharray="10 6" />
              <circle cx="20" cy="20" r="4.5" fill="#00f0ff" />
              <circle cx="20" cy="20" r="2.2" fill="#ffffff" />
            </svg>
          </div>
          <div class="node-name">Reactor</div>
        </div>

        <!-- Tactical Mission Briefing Popover Card -->
        <div class="neural-briefing-popover" id="neuralBriefingCard" role="dialog" aria-modal="false" aria-labelledby="briefingTitle">
          <div class="briefing-tag">
            <span id="briefingTag">// TACTICAL SIM v3.0</span>
            <button class="briefing-close-btn" onclick="hideNeuralBriefing(null, true)" aria-label="Close briefing">✕</button>
          </div>
          <div class="briefing-title" id="briefingTitle">Cyber Chess</div>
          <div class="briefing-desc" id="briefingDesc">Description of game goes here.</div>
          <div class="briefing-stat-row">
            <span id="briefingStatLabel">AI Rating:</span>
            <span class="stat-val" id="briefingStatVal">1200</span>
          </div>
          <button class="btn-briefing-launch" id="briefingLaunchBtn" onclick="launchActiveNeuralGame()">
            <span>▶</span> PLAY NOW
          </button>
        </div>
      </div>

      <!-- CAROUSEL CONTROLS (Active in Carousel Mode) -->
      <div class="carousel-controls hidden-mode">
        <button class="scroll-btn" onclick="scrollCarousel(-340)">‹</button>
        <button class="scroll-btn" onclick="scrollCarousel(340)">›</button>
      </div>

      <!-- CAROUSEL WRAPPER (Active in Carousel Mode) -->
      <div class="game-carousel hidden-mode" id="carousel">
        
        <!-- Game 1: Defusal Protocol -->
        <div class="game-card" style="animation-delay: 0.05s;" onclick="openLaunchModal('Bomb_Defuse/index.jsp', 'Defusal Protocol // Crisis Sim', 'Multi-module bomb defusal sim featuring Data Serpent, Reactor Matrix, Firewall Maze, Banana Wires, and Frequency Tuner with a 3-charge containment system.')">
          <div class="card-banner banner-bomb"><span class="banner-icon">☢️</span></div>
          <div class="card-body">
            <div class="card-tag">// Tactical Sim v3.0</div>
            <div class="card-title">Defusal Protocol</div>
            <div class="card-desc">Disarm 5 tactical mini-games (Snake, Reactor, Maze, Banana Wires, Freq Tuner) under a 3-minute clock with 3 containment charges.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-defuse">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 2: Cyber Chess -->
        <div class="game-card" style="animation-delay: 0.1s;" onclick="openLaunchModal('Chess/index.jsp', 'Cyber Chess', 'Experience grandmaster AI chess with Stockfish depth evaluation, move history analysis, and dynamic tactical rating.')">
          <div class="card-banner banner-chess"><span class="banner-icon">♟️</span></div>
          <div class="card-body">
            <div class="card-tag">// AI Strategy</div>
            <div class="card-title">Cyber Chess</div>
            <div class="card-desc">Challenge deep neural chess engines with move evaluation, rating progression, and PGN game export.</div>
            <div class="card-footer">
              <div class="card-score-preview">Rating: <span id="preview-chess">1200</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 3: Cyber Snake -->
        <div class="game-card" style="animation-delay: 0.15s;" onclick="openLaunchModal('Snake/index.jsp', 'Cyber Snake', 'Steer your serpent through the cyber grid, devour rogue data packets, and breach node high scores.')">
          <div class="card-banner banner-snake"><span class="banner-icon">🐍</span></div>
          <div class="card-body">
            <div class="card-tag">// Arcade Classic</div>
            <div class="card-title">Cyber Snake</div>
            <div class="card-desc">Balanced, fluid snake arcade experience with adjustable tick clocks, touch D-pads, and node tracking.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-snake">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 4: Cyber Maze -->
        <div class="game-card" style="animation-delay: 0.2s;" onclick="openLaunchModal('Maze/index.jsp', 'Cyber Maze Runner', 'Solve procedurally generated labyrinth nodes with recursive backtracking algorithms and locate extraction portals.')">
          <div class="card-banner banner-maze"><span class="banner-icon">⚡</span></div>
          <div class="card-body">
            <div class="card-tag">// Procedural Labyrinth</div>
            <div class="card-title">Cyber Maze</div>
            <div class="card-desc">Navigate randomized labyrinth architectures and locate extraction gates before system telemetry resets.</div>
            <div class="card-footer">
              <div class="card-score-preview">Cleared: <span id="preview-maze">0</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 5: Number Guesser -->
        <div class="game-card" style="animation-delay: 0.25s;" onclick="openLaunchModal('Game1/index.jsp', 'Cipher Guesser', 'Crack the secret integer generated by the server session in minimal probe attempts.')">
          <div class="card-banner banner-guesser"><span class="banner-icon">🔢</span></div>
          <div class="card-body">
            <div class="card-tag">// Quantum Decryption</div>
            <div class="card-title">Cipher Guesser</div>
            <div class="card-desc">Crack the server-side encrypted integer between 1 and 100 in minimal probe iterations.</div>
            <div class="card-footer">
              <div class="card-score-preview">Fewest: <span id="preview-guess">--</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

        <!-- Game 6: Reactor Meltdown -->
        <div class="game-card" style="animation-delay: 0.3s;" onclick="openLaunchModal('Reactor_Meltdown/index.jsp', 'Reactor Meltdown', 'Progressive core memory puzzle inspired by Among Us. Replicate randomized glowing tile sequences under a 20s tension timer (+3s per clear) before containment collapses.')">
          <div class="card-banner banner-reactor"><span class="banner-icon">☢️</span></div>
          <div class="card-body">
            <div class="card-tag">// Core Memory</div>
            <div class="card-title">Reactor Meltdown</div>
            <div class="card-desc">Replicate glowing reactor sequences under a 20s timer. Clear stages to expand from 3x3 to 4x4 matrix.</div>
            <div class="card-footer">
              <div class="card-score-preview">Record: <span id="preview-reactor">0 pts</span></div>
              <div class="launch-arrow">➔</div>
            </div>
          </div>
        </div>

      </div>
    </section>

    <!-- VIEW 2: EXPANDED SCORING & LEADERBOARDS -->
    <section id="scoresView" class="view-panel">
      <!-- GUEST LOCKED NOTICE FOR BRAIN STATS & RADAR CHART -->
      <div class="locked-card" id="scoresLockedCard" style="display: <%= isLoggedIn ? "none" : "block" %>;">
        <div class="locked-icon-wrap">🔒</div>
        <div class="locked-title">Cognitive Radar Chart Locked</div>
        <div class="locked-subtitle">
          Log in or create a free account to unlock your personalized 5-axis cognitive radar chart, earn player XP across all games, and record your high scores on global leaderboards.
        </div>

        <div class="locked-perks-grid">
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🧠</span>
            <div>
              <div class="locked-perk-title">5-Axis Radar Chart</div>
              <div class="locked-perk-desc">Live spider graph analyzing Memory, Logic, Speed, Spatial & Strategy</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">⭐</span>
            <div>
              <div class="locked-perk-title">Account Level & XP</div>
              <div class="locked-perk-desc">Level up your profile and earn prestigious cognitive rank titles</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🏆</span>
            <div>
              <div class="locked-perk-title">Global Leaderboards</div>
              <div class="locked-perk-desc">Compete with players worldwide for top scores across 6 games</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">☁️</span>
            <div>
              <div class="locked-perk-title">Cloud Synchronized</div>
              <div class="locked-perk-desc">Your high scores and agility profile persist across any browser</div>
            </div>
          </div>
        </div>

        <div class="locked-actions">
          <button class="btn-unlock-primary" onclick="openLoginModal()">Log In to View Stats</button>
          <button class="btn-unlock-secondary" onclick="openSignupModal()">Create Free Account</button>
        </div>
      </div>

      <!-- MEMBER CONTENT (RADAR CHART & METRICS) -->
      <div id="scoresContentWrap" style="display: <%= isLoggedIn ? "block" : "none" %>;">
        <!-- DISCORD & GOOGLE PLAY GAMES PLAYER LEVEL CARD -->
        <div class="player-spotlight-card">
          <div class="spotlight-level-emblem">
            <span class="emblem-lbl">LEVEL</span>
            <span class="emblem-num" id="spotlightLevelNum">1</span>
          </div>
          <div class="spotlight-info">
            <div class="spotlight-name-row">
              <span class="spotlight-username"><%= isLoggedIn ? currentUser : "Player" %></span>
              <span class="spotlight-tier-tag" id="spotlightRankTitle">Novice Thinker</span>
            </div>
            <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 8px;">
              Total Brain Experience: <strong style="color: var(--accent);" id="spotlightTotalXp">0 XP</strong>
            </div>
            <div class="xp-bar-track" style="height: 9px;">
              <div class="xp-bar-fill" id="spotlightXpBar" style="width: 0%;"></div>
            </div>
            <div class="xp-subtext" style="font-size: 0.72rem; margin-top: 5px;">
              <span id="spotlightXpDetail">0 / 200 XP (0%)</span>
              <span id="spotlightXpRemaining">200 XP to next level</span>
            </div>
          </div>
        </div>

        <!-- COGNITIVE RADAR CHART (SPIDER GRAPH) -->
        <div class="radar-card">
        <div class="radar-card-header">
          <div>
            <div class="radar-title">🧠 Cognitive Agility Profile</div>
            <div class="radar-subtitle">Live brain-training metrics calculated from your game performance</div>
          </div>
          <div class="brain-index-badge">
            <span class="brain-index-label">BRAIN INDEX</span>
            <span class="brain-index-val" id="overallBrainScore">--</span>
          </div>
        </div>

        <div class="radar-content">
          <div class="radar-canvas-wrap">
            <canvas id="radarChartCanvas" width="290" height="270"></canvas>
          </div>
          <div class="radar-metrics-list">
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #38bdf8; box-shadow: 0 0 8px #38bdf8;"></span>
              <span class="metric-name">Memory</span>
              <span class="metric-desc">Reactor Meltdown (Sequence recall)</span>
              <span class="metric-val" id="valMetricMemory">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #facc15; box-shadow: 0 0 8px #facc15;"></span>
              <span class="metric-name">Logic</span>
              <span class="metric-desc">Defusal Protocol (Deduction under pressure)</span>
              <span class="metric-val" id="valMetricLogic">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #10b981; box-shadow: 0 0 8px #10b981;"></span>
              <span class="metric-name">Speed</span>
              <span class="metric-desc">Cyber Snake (Spatial reflexes & focus)</span>
              <span class="metric-val" id="valMetricSpeed">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #06b6d4; box-shadow: 0 0 8px #06b6d4;"></span>
              <span class="metric-name">Spatial</span>
              <span class="metric-desc">Cyber Maze (Pathfinding & navigation)</span>
              <span class="metric-val" id="valMetricSpatial">0%</span>
            </div>
            <div class="radar-metric-item">
              <span class="metric-dot" style="background: #ec4899; box-shadow: 0 0 8px #ec4899;"></span>
              <span class="metric-name">Strategy</span>
              <span class="metric-desc">Cyber Chess (Tactical calculation)</span>
              <span class="metric-val" id="valMetricStrategy">0%</span>
            </div>
          </div>
        </div>
      </div>

      <div class="score-grid">
        
        <!-- 1. Defusal Protocol -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #ea580c;">☢️ Defusal Protocol</div>
            <div class="score-badge" style="background: rgba(234, 88, 12, 0.15); color: #ea580c; border: 1px solid rgba(234, 88, 12, 0.3);">Tier 1 Sim</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statDefuseBest" style="color: #ea580c;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Best Tier Cleared</span>
            <span class="stat-val" id="statDefuseLevel">Level 1</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Successful Disarms</span>
            <span class="stat-val" id="statDefuseDisarms">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Strikes Avoided</span>
            <span class="stat-val" id="statDefuseStrikes">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Agent</span>
            <span class="stat-val" id="statDefuseLeader" style="color: var(--primary);">--</span>
          </div>
        </div>

        <!-- 2. Cyber Chess -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #ec4899;">♟️ Cyber Chess</div>
            <div class="score-badge" style="background: rgba(236, 72, 153, 0.15); color: #ec4899; border: 1px solid rgba(236, 72, 153, 0.3);">Stockfish API</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">Rating</span>
            <span class="stat-val" id="statChessRating" style="color: #ec4899;">1200</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Matches Won</span>
            <span class="stat-val" id="statChessWins" style="color: var(--accent);">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Matches Lost</span>
            <span class="stat-val" id="statChessLosses" style="color: var(--danger);">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Win Ratio</span>
            <span class="stat-val" id="statChessRatio">0%</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Evaluation Engine</span>
            <span class="stat-val" style="color: var(--primary);">Depth 12</span>
          </div>
        </div>

        <!-- 3. Cyber Snake -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #10b981;">🐍 Cyber Snake</div>
            <div class="score-badge" style="background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3);">Balanced Tick</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statSnakeBest" style="color: #10b981;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Total Data Nodes</span>
            <span class="stat-val" id="statSnakeNodes">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Clock Rate</span>
            <span class="stat-val" style="color: var(--primary);">145ms Balanced</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Operator</span>
            <span class="stat-val" id="statSnakeLeader" style="color: var(--accent);">--</span>
          </div>
        </div>

        <!-- 4. Cyber Maze -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #38bdf8;">⚡ Cyber Maze</div>
            <div class="score-badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3);">Recursive Grid</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">Mazes Cleared</span>
            <span class="stat-val" id="statMazeClears" style="color: #38bdf8;">0</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Fastest Escape</span>
            <span class="stat-val" id="statMazeBestTime">--</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Labyrinth Synthesis</span>
            <span class="stat-val" style="color: var(--accent);">Adaptive</span>
          </div>
        </div>

        <!-- 5. Cipher Guesser -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #6366f1;">🔢 Cipher Guesser</div>
            <div class="score-badge" style="background: rgba(99, 102, 241, 0.15); color: #6366f1; border: 1px solid rgba(99, 102, 241, 0.3);">Session Crypto</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">Fewest Attempts</span>
            <span class="stat-val" id="statGuessBest" style="color: #6366f1;">--</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Decryption Range</span>
            <span class="stat-val">1 - 100</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Key Security</span>
            <span class="stat-val" style="color: var(--accent);">Server-Side</span>
          </div>
        </div>

        <!-- 6. Reactor Meltdown -->
        <div class="score-card">
          <div class="score-card-header">
            <div class="score-card-title" style="color: #38bdf8;">☢️ Reactor Meltdown</div>
            <div class="score-badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3);">Progressive Core</div>
          </div>
          <div class="stat-row">
            <span class="stat-label">High Score</span>
            <span class="stat-val" id="statReactorBest" style="color: #38bdf8;">0 pts</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Deepest Sector</span>
            <span class="stat-val" id="statReactorStage">Sector 1</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Coolant System</span>
            <span class="stat-val" style="color: var(--accent);">20s (+3s/Clear)</span>
          </div>
          <div class="stat-row">
            <span class="stat-label">Top Global Operator</span>
            <span class="stat-val" id="statReactorLeader" style="color: var(--warning);">--</span>
          </div>
        </div>

      </div> <!-- end score-grid -->
      </div> <!-- end scoresContentWrap -->
    </section>

    <!-- VIEW 3: SYSTEM PREFERENCES -->
    <section id="settingsView" class="view-panel">
      <!-- GUEST LOCKED NOTICE FOR SETTINGS -->
      <div class="locked-card" id="settingsLockedCard" style="display: <%= isLoggedIn ? "none" : "block" %>;">
        <div class="locked-icon-wrap" style="color: var(--warning); border-color: rgba(245, 158, 11, 0.4); background: rgba(245, 158, 11, 0.15); box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);">🔒</div>
        <div class="locked-title">Settings Locked</div>
        <div class="locked-subtitle">
          Display preferences, audio customization, performance modes, and local cache controls require an active player account. Log in or create an account to unlock full settings access.
        </div>

        <div class="locked-perks-grid">
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🔊</span>
            <div>
              <div class="locked-perk-title">Audio Customization</div>
              <div class="locked-perk-desc">Toggle soundscape feedback and ambient effects</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">⚡</span>
            <div>
              <div class="locked-perk-title">Performance Turbo</div>
              <div class="locked-perk-desc">Optimize framerates and background animations</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🚪</span>
            <div>
              <div class="locked-perk-title">Gateway Bypass</div>
              <div class="locked-perk-desc">Customize direct entry into the arcade game hub</div>
            </div>
          </div>
          <div class="locked-perk-item">
            <span class="locked-perk-icon">🛡️</span>
            <div>
              <div class="locked-perk-title">Data & Cache Tools</div>
              <div class="locked-perk-desc">Manage local memory and sync with cloud records</div>
            </div>
          </div>
        </div>

        <div class="locked-actions">
          <button class="btn-unlock-primary" onclick="openLoginModal()">Log In to Unlock Settings</button>
          <button class="btn-unlock-secondary" onclick="openSignupModal()">Create Free Account</button>
        </div>
      </div>

      <!-- MEMBER CONTENT (SETTINGS CONTROLS) -->
      <div id="settingsContentWrap" style="display: <%= isLoggedIn ? "block" : "none" %>;">
        <div class="settings-box" style="max-width: 520px;">
          <h3 style="margin-bottom: 1.5rem; color: var(--primary);">System Preferences</h3>
          
          <div class="settings-row">
            <div>
              <div style="font-weight: 700;">Audio Effects</div>
              <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Enable interactive feedback soundscapes</div>
            </div>
            <label class="switch">
              <input type="checkbox" checked>
              <span class="slider"></span>
            </label>
          </div>
          
          <div class="settings-row">
            <div>
              <div style="font-weight: 700;">Performance Mode</div>
              <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Disable background grid animations</div>
            </div>
            <label class="switch">
              <input type="checkbox" onchange="togglePerformance(this)">
              <span class="slider"></span>
            </label>
          </div>

          <div class="settings-row">
            <div>
              <div style="font-weight: 700;">Entry Portal Bypass</div>
              <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Show landing gateway on initial visits</div>
            </div>
            <button class="btn-modal btn-cancel" style="flex: initial; padding: 6px 14px; font-size: 0.8rem;" onclick="showPortal()">
              Show Portal
            </button>
          </div>

          <!-- RANS0M ENTITY CHALLENGE & SIMULATOR (GAME INSIDE SETTINGS) -->
          <div class="settings-row" style="background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(15, 23, 42, 0.95) 100%); border: 1px solid rgba(239, 68, 68, 0.4); border-left: 4px solid var(--danger); padding: 16px; border-radius: 12px; margin-top: 14px; flex-direction: column; align-items: stretch; gap: 12px; box-shadow: 0 4px 20px rgba(239, 68, 68, 0.15);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px;">
              <div style="font-weight: 800; color: #f87171; display: flex; align-items: center; gap: 8px; font-size: 0.95rem;">
                <span>☣</span> RANS0M // Cyber Threat Simulator
                <span style="font-size: 0.65rem; background: #b91c1c; color: #fff; padding: 2px 7px; border-radius: 4px; font-weight: 900; letter-spacing: 0.5px;">HORROR MINIGAME</span>
              </div>
              <div style="display: flex; align-items: center; gap: 8px;">
                <span style="font-size: 0.72rem; color: #fca5a5; font-weight: 700;">Horror Intrusion:</span>
                <label class="switch">
                  <input type="checkbox" id="toggleRansomHorror" onchange="toggleRansomHorrorMode(this)">
                  <span class="slider"></span>
                </label>
              </div>
            </div>

            <div style="font-size: 0.8rem; color: #cbd5e1; line-height: 1.5;">
              Simulated ransomware crisis minigame. When armed, a flashing <strong style="color: #fff;">STOP SIGN</strong> appears randomly during gameplay (10-30s). <strong style="color: #ef4444;">FREEZE! ANY INPUT TRIGGERS AN ATTACK!</strong> Or launch the standalone Crisis Simulation to decrypt popups and recover encrypted files before the purge timer reaches zero.
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 8px; border-top: 1px dashed rgba(239, 68, 68, 0.25); flex-wrap: wrap; gap: 10px;">
              <div style="font-size: 0.78rem; color: var(--text-muted);">
                Containment Record: <strong id="statRansomBestSettings" style="color: #f87171; font-size: 0.92rem; margin-left: 4px;">0 pts</strong>
              </div>
              <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                <button type="button" class="btn-modal btn-cancel" style="flex: initial; padding: 6px 12px; font-size: 0.75rem; border-color: rgba(239, 68, 68, 0.4); color: #fca5a5;" onclick="openRansomInstructionModal()">
                  📜 Threat Dossier
                </button>
                <button type="button" class="btn-modal btn-launch" style="flex: initial; padding: 6px 14px; font-size: 0.75rem; background: linear-gradient(135deg, #ef4444, #991b1b); color: #fff; box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);" onclick="openLaunchModal('Ransom/index.jsp', 'RANS0M // Cyber Threat Simulator', 'Simulated desktop ransomware infection. Purge virus popup swarms, decipher the override key, and halt the system purge.')">
                  ▶ Play Crisis Sim
                </button>
              </div>
            </div>
          </div>
          
          <button class="btn-modal btn-cancel" onclick="resetLocalCache()" style="margin-top: 2rem; width:100%; color: var(--danger); border: 1px solid rgba(239, 68, 68, 0.35);">
            ⚠ Purge Local Score Cache
          </button>
        </div>
      </div>
    </section>
  </main>

  <!-- =========================================================
       MODAL: RANS0M THREAT INTEL DOSSIER (DISTORTED BACKGROUND)
       ========================================================= -->
  <div class="rh-intel-modal" id="ransomInstructionModal">
    <div class="rh-intel-backdrop" onclick="confirmRansomHorror(false)"></div>
    <div class="rh-intel-box">
      <div class="rh-intel-header">
        <div class="rh-intel-title-group">
          <span class="rh-intel-icon">☣</span>
          <div>
            <div class="rh-intel-title">THREAT INTEL: RANS0M.EXE</div>
            <div style="font-size: 0.7rem; color: #fca5a5; margin-top: 2px;">ANOMALY PROTOCOL // EYES ONLY</div>
          </div>
        </div>
        <div class="rh-intel-classification">LVL 5 THREAT</div>
      </div>

      <!-- Entity Profile Box -->
      <div style="display: flex; gap: 14px; background: rgba(0,0,0,0.5); border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 8px; padding: 12px; margin-bottom: 14px; align-items: center;">
        <img src="Ransom/assets/sprites/spr_ransom_attack_face.png" style="width: 58px; height: 58px; image-rendering: pixelated; filter: drop-shadow(0 0 10px rgba(239, 68, 68, 0.7)); animation: rhJitter 0.2s infinite;" alt="Entity Avatar">
        <div style="font-size: 0.78rem; line-height: 1.45; color: #e2e8f0;">
          <strong style="color: #f87171;">IDENTIFIER:</strong> Hostile Sub-Routine Entity (RANS0M.EXE)<br>
          <strong style="color: #f87171;">BEHAVIOR:</strong> Flashes STOP sign (10-30s). Attacks on ANY input.<br>
          <strong style="color: #f87171;">DIRECTIVE:</strong> Encrypt player items and force system crash
        </div>
      </div>

      <!-- Lore Item 1 -->
      <div class="rh-lore-item">
        <div class="rh-lore-heading"><span>🛑</span> THE CARDINAL RULE: FREEZE ON STOP SIGN!</div>
        <div class="rh-lore-body">
          A giant flashing <strong>STOP SIGN</strong> will manifest at random intervals (every 10 to 30 seconds). <strong>DO NOT PRESS ANY KEY, DO NOT CLICK, AND DO NOT TOUCH THE SCREEN!</strong> If you remain completely still for <strong>3.5 seconds</strong>, the entity vanishes harmlessly.
        </div>
      </div>

      <!-- Lore Item 2 -->
      <div class="rh-lore-item">
        <div class="rh-lore-heading"><span>⚡</span> CRISIS ACTIVATION: JUMPSCARE & 10s COUNTDOWN</div>
        <div class="rh-lore-body">
          If you make <strong>ANY input</strong> (keyboard, touch, mouse, moving chess piece, snake turn, etc.), RANS0M triggers an <strong>instant jumpscare</strong>, deploys the <strong>retro ransomware encryption box</strong>, and starts a <strong>10-second countdown</strong>:
          <ul style="margin: 6px 0 0 18px; padding: 0; font-size: 0.78rem; line-height: 1.5; color: #cbd5e1;">
            <li><strong style="color: #fde047;">3 to 7 Gold Tokens:</strong> Randomly spawn across your screen. You must click/tap all of them to pay the ransom in time!</li>
            <li><strong style="color: #f87171;">Moving Error Box:</strong> The ransomware dialog jumps to a new randomized position <strong>every second</strong>!</li>
            <li><strong style="color: #fde047;">Relocating Tokens:</strong> All uncollected tokens teleport to new randomized coordinates <strong>every 3 seconds</strong>!</li>
          </ul>
        </div>
      </div>

      <!-- Lore Item 3 -->
      <div class="rh-lore-item" style="border-left-color: #dc2626; background: rgba(220, 38, 38, 0.08);">
        <div class="rh-lore-heading" style="color: #ef4444;"><span>💀</span> THE PENALTY: FATAL SCREECH & GAME OVER</div>
        <div class="rh-lore-body">
          If the 10-second countdown hits <strong>00:00</strong> before you collect all tokens, RANS0M unleashes a <strong>violent screeching jumpscare attack</strong> with the screaming face and instantly terminates your active game with <strong>GAME OVER</strong>.
        </div>
      </div>

      <!-- Modal Action Buttons -->
      <div class="rh-intel-actions">
        <button type="button" class="rh-btn-activate" onclick="confirmRansomHorror(true)">
          ☣ ARM CHALLENGE & ACTIVATE
        </button>
        <button type="button" class="rh-btn-abort" onclick="confirmRansomHorror(false)">
          ABORT / SAFE MODE
        </button>
      </div>
    </div>
  </div>

  <!-- =========================================================
       MODAL 0: MASTER GAMES LIBRARY (CENTRAL PROTOCOLS ARCHIVE)
       ========================================================= -->
  <div class="modal-overlay" id="masterLibraryModal">
    <div class="modal-box master-library-box">
      <div class="master-library-header">
        <div>
          <div class="master-tag">// MASTER PROTOCOLS ARCHIVE</div>
          <h2 class="master-title">GAME HUB LIBRARY</h2>
          <div class="master-subtitle">6 operational cyber-simulation modules online. Select a game to view intel or launch.</div>
        </div>
        <button type="button" class="btn-master-close" onclick="closeModal('masterLibraryModal')" aria-label="Close Library">✕</button>
      </div>

      <!-- Search & Category Filters -->
      <div class="master-toolbar">
        <div class="master-search-wrap">
          <span class="master-search-icon">🔍</span>
          <input type="text" id="masterGameSearch" class="master-search-input" placeholder="Search protocol by name or genre..." oninput="filterMasterGames(this.value)">
        </div>
        <div class="master-filter-pills">
          <button class="master-pill active" onclick="filterMasterCategory('all', this)">ALL</button>
          <button class="master-pill" onclick="filterMasterCategory('strategy', this)">STRATEGY</button>
          <button class="master-pill" onclick="filterMasterCategory('tactical', this)">TACTICAL</button>
          <button class="master-pill" onclick="filterMasterCategory('arcade', this)">ARCADE</button>
          <button class="master-pill" onclick="filterMasterCategory('puzzle', this)">PUZZLE</button>
        </div>
      </div>

      <!-- Master Grid of 6 Games -->
      <div class="master-games-grid" id="masterGamesGrid"></div>
    </div>
  </div>

  <!-- =========================================================
       MODAL 1: PRE-GAME LAUNCH CONFIRMATION
       ========================================================= -->
  <div class="modal-overlay" id="launchModal">
    <div class="modal-box">
      <div style="font-size: 0.7rem; letter-spacing: 2px; color: var(--primary); font-weight: 800; text-transform: uppercase; margin-bottom: 6px;">[ MISSION BRIEFING // INITIALIZE PROTOCOL ]</div>
      <h2 id="modalTitle" style="color: #fff; font-weight: 900; letter-spacing: 1px; font-size: 1.45rem;">Ready to Play?</h2>
      <p id="modalDesc" style="color:var(--text-muted); font-size:0.88rem; margin-top:0.8rem; line-height: 1.6;"></p>
      <div class="modal-actions">
        <button class="btn-modal btn-cancel" onclick="closeModal('launchModal')">✕ ABORT</button>
        <button class="btn-modal btn-launch" id="confirmLaunchBtn">▶ ENGAGE SIM</button>
      </div>
    </div>
  </div>

  <!-- =========================================================
       MODAL 2: LOGIN
       ========================================================= -->
  <div class="modal-overlay" id="loginModal">
    <div class="modal-box">
      <div style="font-size: 0.7rem; letter-spacing: 2px; color: var(--primary); font-weight: 800; text-transform: uppercase; margin-bottom: 6px;">[ OPERATIVE AUTHENTICATION ]</div>
      <h2 style="color: #fff; font-weight: 900; letter-spacing: 1.5px; font-size: 1.5rem; margin: 0;">ACCESS TERMINAL</h2>
      <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.35rem; margin-bottom: 0;">Enter callsign and security cipher to synchronize telemetry.</p>

      <!-- Framer-Motion style tab switcher -->
      <div class="auth-modal-tabs">
        <button type="button" class="auth-modal-tab active">LOG IN</button>
        <button type="button" class="auth-modal-tab" onclick="closeModal('loginModal'); openSignupModal();">SIGN UP</button>
      </div>

      <div class="auth-msg" id="loginMsg"></div>

      <form id="loginForm" onsubmit="event.preventDefault(); submitLogin();">
        <div class="auth-form-group">
          <label class="auth-label" for="loginUsername">Operative Callsign</label>
          <div class="auth-input-wrap">
            <span class="auth-input-icon">👤</span>
            <input type="text" class="auth-input" id="loginUsername" placeholder="e.g. CyberNinja" autocomplete="username" required>
          </div>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="loginPassword">Security Cipher</label>
          <div class="auth-input-wrap">
            <span class="auth-input-icon">🔒</span>
            <input type="password" class="auth-input" id="loginPassword" placeholder="••••••••••••" autocomplete="current-password" required>
          </div>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal btn-cancel" onclick="closeModal('loginModal')">✕ ABORT</button>
          <button type="submit" class="btn-modal btn-launch" id="loginSubmitBtn">
            <span id="loginBtnText">⚡ AUTHENTICATE</span>
          </button>
        </div>
      </form>

      <span class="switch-auth-link" onclick="closeModal('loginModal'); openSignupModal();">New Operative? Enlist profile credentials</span>
    </div>
  </div>

  <!-- =========================================================
       MODAL 3: SIGN UP
       ========================================================= -->
  <div class="modal-overlay" id="signupModal">
    <div class="modal-box">
      <div style="font-size: 0.7rem; letter-spacing: 2px; color: var(--accent); font-weight: 800; text-transform: uppercase; margin-bottom: 6px;">[ OPERATIVE ENLISTMENT ]</div>
      <h2 style="color: #fff; font-weight: 900; letter-spacing: 1.5px; font-size: 1.5rem; margin: 0;">NEW PROFILE</h2>
      <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.35rem; margin-bottom: 0;">Register a permanent operative callsign to track XP and rank.</p>

      <!-- Framer-Motion style tab switcher -->
      <div class="auth-modal-tabs">
        <button type="button" class="auth-modal-tab" onclick="closeModal('signupModal'); openLoginModal();">LOG IN</button>
        <button type="button" class="auth-modal-tab active">SIGN UP</button>
      </div>

      <div class="auth-msg" id="signupMsg"></div>

      <form id="signupForm" onsubmit="event.preventDefault(); submitSignup();">
        <div class="auth-form-group">
          <label class="auth-label" for="signupUsername">Operative Callsign [3-20 Letters/Numbers]</label>
          <div class="auth-input-wrap">
            <span class="auth-input-icon">👤</span>
            <input type="text" class="auth-input" id="signupUsername" placeholder="e.g. BrainMaster" autocomplete="username" required>
          </div>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="signupPassword">Security Cipher [Min 6 Chars]</label>
          <div class="auth-input-wrap">
            <span class="auth-input-icon">🔒</span>
            <input type="password" class="auth-input" id="signupPassword" placeholder="••••••••••••" autocomplete="new-password" required>
          </div>
        </div>
        <div class="auth-form-group">
          <label class="auth-label" for="signupPasswordConfirm">Confirm Security Cipher</label>
          <div class="auth-input-wrap">
            <span class="auth-input-icon">🛡️</span>
            <input type="password" class="auth-input" id="signupPasswordConfirm" placeholder="••••••••••••" autocomplete="new-password" required>
          </div>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal btn-cancel" onclick="closeModal('signupModal')">✕ ABORT</button>
          <button type="submit" class="btn-modal btn-launch" id="signupSubmitBtn" style="background: linear-gradient(135deg, var(--accent), #059669); color: #030712; box-shadow: 0 0 20px rgba(16, 230, 168, 0.4);">
            <span id="signupBtnText">⚡ ENLIST PROFILE</span>
          </button>
        </div>
      </form>

      <span class="switch-auth-link" onclick="closeModal('signupModal'); openLoginModal();">Existing Operative? Access terminal</span>
    </div>
  </div>

<script>
  let isUserLoggedIn = <%= isLoggedIn %>;
  let currentUsername = "<%= currentUser != null ? currentUser : "" %>";
  let targetUrl = '';

  // =========================================================
  // ACCOUNT BOUNDARY & TELEMETRY ISOLATION ENGINE
  // Authoritative verified scores cache populated strictly from the cloud database
  let verifiedCloudScores = {
    snake: 0,
    defuse: 0,
    chessRating: 1200,
    chessWins: 0,
    chessPlayed: false,
    reactor: 0,
    maze: 0,
    guess: 0,
    ransom: 0
  };
  let scoresFetchedFromCloud = false;

  // =========================================================
  function enforceAccountBoundary(user) {
    const current = (user !== undefined && user !== null) ? user.trim() : '';
    const stored = localStorage.getItem('hub_active_user') || '';
    
    if (stored !== current || !current) {
      // Identity switch or guest detected: purge cached telemetry
      localStorage.clear();
      if (current) {
        localStorage.setItem('hub_active_user', current);
      }
      verifiedCloudScores = {
        snake: 0,
        defuse: 0,
        chessRating: 1200,
        chessWins: 0,
        chessPlayed: false,
        reactor: 0,
        maze: 0,
        guess: 0,
        ransom: 0
      };
      scoresFetchedFromCloud = false;
    }
  }

  // =========================================================
  // DISCORD & GOOGLE PLAY GAMES ACCOUNT LEVELING ENGINE
  // =========================================================
  function calculateTotalXP() {
    if (!isUserLoggedIn) return 0;
    if (!scoresFetchedFromCloud) return 0;

    const defuseBest = verifiedCloudScores.defuse || 0;
    const snakeBest = verifiedCloudScores.snake || 0;
    const mazeClears = verifiedCloudScores.maze || 0;
    const reactorBest = verifiedCloudScores.reactor || 0;
    const ransomBest = verifiedCloudScores.ransom || 0;
    const chessWins = verifiedCloudScores.chessPlayed ? (verifiedCloudScores.chessWins || 0) : 0;
    const chessRating = verifiedCloudScores.chessPlayed ? (verifiedCloudScores.chessRating || 1200) : 1200;

    // Progressive XP breakdown (strictly 0 if games never played)
    const xpReactor = Math.round(reactorBest * 2);
    const xpDefuse = Math.round(defuseBest * 2);
    const xpSnake = Math.round(snakeBest * 5);
    const xpMaze = Math.round(mazeClears * 100);
    const xpChess = verifiedCloudScores.chessPlayed ? Math.round(chessWins * 150 + Math.max(0, chessRating - 1200) * 2) : 0;
    const xpRansom = Math.round(ransomBest * 3);

    return xpReactor + xpDefuse + xpSnake + xpMaze + xpChess + xpRansom;
  }

  function getLevelData(totalXp) {
    const tierSteps = [200, 300, 450, 600, 800, 1000, 1250, 1500, 1800, 2100];
    let level = 1;
    let threshold = 0;
    let prevThreshold = 0;
    let step = 200;

    while (true) {
      step = (level <= tierSteps.length) ? tierSteps[level - 1] : (2100 + (level - 10) * 350);
      if (totalXp < threshold + step) {
        prevThreshold = threshold;
        break;
      }
      threshold += step;
      level++;
    }

    const xpInCurrentLevel = Math.max(0, totalXp - prevThreshold);
    const xpNeededForLevel = step;
    const percent = Math.min(100, Math.round((xpInCurrentLevel / xpNeededForLevel) * 100));

    const titles = [
      'Novice Thinker',
      'Curious Mind',
      'Apprentice Strategist',
      'Logic Specialist',
      'Pattern Analyst',
      'Puzzle Veteran',
      'Tactical Operative',
      'Cognitive Ace',
      'Mind Maestro',
      'Grandmaster Mind'
    ];
    const rankTitle = (level <= titles.length) ? titles[level - 1] : `Grandmaster Tier ${level - 9}`;

    return {
      level,
      totalXp,
      xpInCurrentLevel,
      xpNeededForLevel,
      remainingXp: Math.max(0, xpNeededForLevel - xpInCurrentLevel),
      percent,
      rankTitle
    };
  }

  function updateAccountLevelUI() {
    if (!isUserLoggedIn) return;

    const totalXp = calculateTotalXP();
    const data = getLevelData(totalXp);

    // 1. Sidebar Profile Updates
    const badge = document.getElementById('profileLevelBadge');
    const title = document.getElementById('profileRankTitle');
    const xpText = document.getElementById('profileXpText');
    const xpFill = document.getElementById('profileXpFill');
    const xpPct = document.getElementById('profileXpPercent');
    const xpRem = document.getElementById('profileXpRemaining');

    if (badge) badge.innerText = 'LVL ' + data.level;
    if (title) title.innerText = data.rankTitle;
    if (xpText) xpText.innerText = data.xpInCurrentLevel.toLocaleString() + ' / ' + data.xpNeededForLevel.toLocaleString() + ' XP';
    if (xpFill) xpFill.style.width = data.percent + '%';
    if (xpPct) xpPct.innerText = data.percent + '%';
    if (xpRem) xpRem.innerText = data.remainingXp.toLocaleString() + ' XP to next lvl';

    // 2. Header Meta Pill Updates
    const metaPill = document.getElementById('metaLevelPill');
    const metaLvl = document.getElementById('metaLevelText');
    const metaXp = document.getElementById('metaXpText');
    if (metaPill) metaPill.style.display = 'inline-flex';
    if (metaLvl) metaLvl.innerText = 'LVL ' + data.level;
    if (metaXp) metaXp.innerText = data.totalXp.toLocaleString() + ' XP';

    // 3. Brain Stats Spotlight Card Updates
    const spotLvl = document.getElementById('spotlightLevelNum');
    const spotRank = document.getElementById('spotlightRankTitle');
    const spotTotalXp = document.getElementById('spotlightTotalXp');
    const spotBar = document.getElementById('spotlightXpBar');
    const spotDetail = document.getElementById('spotlightXpDetail');
    const spotRem = document.getElementById('spotlightXpRemaining');

    if (spotLvl) spotLvl.innerText = data.level;
    if (spotRank) spotRank.innerText = data.rankTitle;
    if (spotTotalXp) spotTotalXp.innerText = data.totalXp.toLocaleString() + ' XP';
    if (spotBar) spotBar.style.width = data.percent + '%';
    if (spotDetail) spotDetail.innerText = data.xpInCurrentLevel.toLocaleString() + ' / ' + data.xpNeededForLevel.toLocaleString() + ' XP (' + data.percent + '%)';
    if (spotRem) spotRem.innerText = data.remainingXp.toLocaleString() + ' XP to next level';
  }

  // =========================================================
  // FRAMER MOTION KINETIC ENGINE & CAMERA DEPTH TRANSITION
  // =========================================================
  const portal = document.getElementById('landingPortal');
  const motionCurtain = document.getElementById('motionCurtain');

  function getMotionEngine() {
    return (typeof window !== 'undefined' && window.Motion) ? window.Motion : null;
  }

  function kineticNavigate(url) {
    if (!url) return;
    const curtain = document.getElementById('motionCurtain') || document.getElementById('cyberWipeOverlay');
    const mainEl = document.querySelector('main');
    const asideEl = document.querySelector('aside');

    // 1. Camera depth recession on page content
    if (mainEl) {
      mainEl.classList.remove('camera-restoring');
      mainEl.classList.add('camera-receding');
    }
    if (asideEl) {
      asideEl.classList.remove('camera-restoring');
      asideEl.classList.add('camera-receding');
    }

    // 2. Framer Motion Spring Transition for the Curtain
    const Motion = getMotionEngine();
    if (curtain) {
      curtain.classList.add('active');
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(curtain, { opacity: [0, 1], scale: [1.02, 1] }, { duration: 0.24, ease: [0.16, 1, 0.3, 1] });
      }
    }

    // 3. Responsive, snappy exit navigation (<230ms)
    setTimeout(() => {
      window.location.href = url;
    }, 220);
  }

  // Universal alias for all buttons and legacy handlers
  function cyberNavigate(url) {
    kineticNavigate(url);
  }

  function triggerFastEnter(targetIdentity, completionMsg, onCompleteCallback) {
    const Motion = getMotionEngine();
    if (portal) {
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(portal, { opacity: [1, 0], scale: [1, 1.12], filter: ['blur(0px)', 'blur(10px)'] }, { duration: 0.30, ease: [0.16, 1, 0.3, 1] })
          .then(() => {
            portal.classList.add('dismissed');
            document.body.classList.add('portal-entered');
            sessionStorage.setItem('hub_portal_passed', 'true');
            if (onCompleteCallback) onCompleteCallback();
          });
      } else {
        portal.classList.add('zoom-through');
        setTimeout(() => {
          portal.classList.add('dismissed');
          portal.classList.remove('zoom-through');
          document.body.classList.add('portal-entered');
          sessionStorage.setItem('hub_portal_passed', 'true');
          if (onCompleteCallback) onCompleteCallback();
        }, 320);
      }
    } else {
      document.body.classList.add('portal-entered');
      sessionStorage.setItem('hub_portal_passed', 'true');
      if (onCompleteCallback) onCompleteCallback();
    }
  }

  // Backward-compatible alias
  function triggerDoorTransition(targetIdentity, completionMsg, onCompleteCallback) {
    triggerFastEnter(targetIdentity, completionMsg, onCompleteCallback);
  }

  function showPortal() {
    kineticNavigate('auth.jsp');
  }

  // Auto-dismiss portal if user already completed entrance in this browser tab
  if (sessionStorage.getItem('hub_portal_passed') === 'true') {
    if (portal) portal.classList.add('dismissed');
    document.body.classList.add('portal-entered');
  }

  window.addEventListener('pageshow', () => {
    const curtain = document.getElementById('motionCurtain');
    if (curtain) curtain.classList.remove('active');
    const legacyOverlay = document.getElementById('cyberWipeOverlay');
    if (legacyOverlay) legacyOverlay.classList.remove('active');
    const legacyShutter = document.getElementById('cyberShutter');
    if (legacyShutter) legacyShutter.classList.remove('active');

    // Camera Restoration with Spring Physics
    const mainEl = document.querySelector('main');
    const asideEl = document.querySelector('aside');
    [mainEl, asideEl].forEach(el => {
      if (!el) return;
      el.classList.remove('camera-receding');
      el.classList.add('camera-restoring');
      setTimeout(() => el.classList.remove('camera-restoring'), 380);
    });

    const modalBox = document.querySelector('#launchModal .modal-box');
    if (modalBox) {
      modalBox.style.transform = '';
      modalBox.style.filter = '';
      modalBox.style.opacity = '';
    }

    // Framer Motion Staggered Card Cascade
    const Motion = getMotionEngine();
    const cards = document.querySelectorAll('.game-card');
    if (cards.length > 0) {
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(
          cards,
          { opacity: [0, 1], transform: ['translateY(16px) scale(0.96)', 'translateY(0) scale(1)'] },
          { delay: Motion.stagger ? Motion.stagger(0.04, { startDelay: 0.05 }) : 0.04, duration: 0.42, ease: [0.16, 1, 0.3, 1] }
        );
      } else {
        cards.forEach((card, i) => {
          card.style.animation = 'none';
          void card.offsetWidth;
          card.style.animation = 'gameCardSpringIn 0.45s cubic-bezier(0.16, 1, 0.3, 1) ' + (0.03 + i * 0.045) + 's forwards';
        });
      }
    }
  });

  // --- TAB NAVIGATION (GATED FOR GUESTS) ---
  function switchTab(tab, btn) {
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.view-panel').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    
    setTimeout(() => {
      if (tab === 'library') {
        document.getElementById('libraryView').classList.add('active');
        document.getElementById('viewTitle').innerText = 'Games';
      } else if (tab === 'scores') {
        document.getElementById('scoresView').classList.add('active');
        document.getElementById('viewTitle').innerText = isUserLoggedIn ? 'Brain Stats & Records' : 'Brain Stats (Locked)';
        const lockedCard = document.getElementById('scoresLockedCard');
        const contentWrap = document.getElementById('scoresContentWrap');
        if (isUserLoggedIn) {
          if (lockedCard) lockedCard.style.display = 'none';
          if (contentWrap) contentWrap.style.display = 'block';
          syncCloudScores();
          renderCognitiveRadarChart();
          updateAccountLevelUI();
        } else {
          if (lockedCard) lockedCard.style.display = 'block';
          if (contentWrap) contentWrap.style.display = 'none';
        }
      } else if (tab === 'settings') {
        document.getElementById('settingsView').classList.add('active');
        document.getElementById('viewTitle').innerText = isUserLoggedIn ? 'Settings' : 'Settings (Locked)';
        const lockedCard = document.getElementById('settingsLockedCard');
        const contentWrap = document.getElementById('settingsContentWrap');
        if (isUserLoggedIn) {
          if (lockedCard) lockedCard.style.display = 'none';
          if (contentWrap) contentWrap.style.display = 'block';
        } else {
          if (lockedCard) lockedCard.style.display = 'block';
          if (contentWrap) contentWrap.style.display = 'none';
        }
      }
    }, 40);
  }

  function scrollCarousel(dist) {
    document.getElementById('carousel').scrollBy({ left: dist, behavior: 'smooth' });
  }

  // =========================================================
  // FEATURE: LINEAR NEURAL INTEGRATION BUS CONTROLLER
  // =========================================================
  const NEURAL_GAMES = {
    chess: {
      title: 'Cyber Chess',
      tag: '// AI STRATEGY ENGINE',
      desc: 'Challenge deep neural chess engines with move evaluation, rating progression, and PGN export.',
      statLabel: 'AI Rating:',
      statKey: 'chess',
      url: 'Chess/index.jsp',
      color: '#38bdf8'
    },
    bomb: {
      title: 'Defusal Protocol',
      tag: '// CRISIS SIM v3.0',
      desc: 'Disarm 5 tactical mini-games (Snake, Reactor, Maze, Banana Wires, Freq Tuner) under a 3-minute clock with 3 containment charges.',
      statLabel: 'Record Score:',
      statKey: 'defuse',
      url: 'Bomb_Defuse/index.jsp',
      color: '#f43f5e'
    },
    snake: {
      title: 'Cyber Snake',
      tag: '// ARCADE CLASSIC',
      desc: 'Balanced, fluid snake arcade experience with adjustable tick clocks, touch D-pads, and node tracking.',
      statLabel: 'High Score:',
      statKey: 'snake',
      url: 'Snake/index.jsp',
      color: '#10e6a8'
    },
    maze: {
      title: 'Cyber Maze',
      tag: '// PROCEDURAL LABYRINTH',
      desc: 'Navigate randomized labyrinth architectures and locate extraction gates before system telemetry resets.',
      statLabel: 'Nodes Cleared:',
      statKey: 'maze',
      url: 'Maze/index.jsp',
      color: '#a855f7'
    },
    guess: {
      title: 'Cipher Guesser',
      tag: '// QUANTUM DECRYPTION',
      desc: 'Crack the server-side encrypted integer between 1 and 100 in minimal probe iterations.',
      statLabel: 'Fewest Tries:',
      statKey: 'guess',
      url: 'Game1/index.jsp',
      color: '#facc15'
    },
    reactor: {
      title: 'Reactor Meltdown',
      tag: '// CORE MEMORY PUZZLE',
      desc: 'Replicate glowing reactor sequences under a 20s timer. Clear stages to expand from 3x3 to 4x4 matrix.',
      statLabel: 'Core Record:',
      statKey: 'reactor',
      url: 'Reactor_Meltdown/index.jsp',
      color: '#00f0ff'
    }
  };

  let activeNeuralGameKey = null;
  let briefingHideTimer = null;

  function getNeuralGameStatValue(gameKey) {
    const isGuest = !isUserLoggedIn;
    switch (gameKey) {
      case 'chess': {
        const el = document.getElementById('preview-chess');
        return (el && el.innerText) ? el.innerText : (isGuest ? (localStorage.getItem('hub_chess_rating') || '1200') : '1200');
      }
      case 'bomb': {
        const el = document.getElementById('preview-defuse');
        return (el && el.innerText) ? el.innerText : (isGuest ? (localStorage.getItem('hub_defuse_high') || '0') + ' pts' : '0 pts');
      }
      case 'snake': {
        const el = document.getElementById('preview-snake');
        return (el && el.innerText) ? el.innerText : (isGuest ? (localStorage.getItem('hub_snake_high') || '0') + ' pts' : '0 pts');
      }
      case 'maze': {
        const el = document.getElementById('preview-maze');
        return (el && el.innerText) ? el.innerText : (isGuest ? (localStorage.getItem('hub_maze_clears') || '0') : '0');
      }
      case 'guess': {
        const el = document.getElementById('preview-guess');
        return (el && el.innerText) ? el.innerText : (isGuest ? (localStorage.getItem('hub_guess_best') || '--') : '--');
      }
      case 'reactor': {
        const el = document.getElementById('preview-reactor');
        return (el && el.innerText) ? el.innerText : (isGuest ? (localStorage.getItem('hub_reactor_high') || '0') + ' pts' : '0 pts');
      }
      default:
        return '--';
    }
  }

  function setLibraryMode(mode) {
    const busContainer = document.getElementById('neuralBusContainer');
    const carousel = document.getElementById('carousel');
    const carouselControls = document.querySelector('.carousel-controls');
    const btnNeural = document.getElementById('modeBtnNeural');
    const btnCarousel = document.getElementById('modeBtnCarousel');

    const isNeural = mode === 'neural';

    if (btnNeural) {
      btnNeural.classList.toggle('active', isNeural);
      btnNeural.setAttribute('aria-selected', isNeural ? 'true' : 'false');
    }
    if (btnCarousel) {
      btnCarousel.classList.toggle('active', !isNeural);
      btnCarousel.setAttribute('aria-selected', !isNeural ? 'true' : 'false');
    }

    if (busContainer) {
      busContainer.classList.toggle('hidden-mode', !isNeural);
    }
    if (carousel) {
      carousel.classList.toggle('hidden-mode', isNeural);
    }
    if (carouselControls) {
      carouselControls.classList.toggle('hidden-mode', isNeural);
    }

    localStorage.setItem('hub_library_mode', mode);

    // If switching out of neural, hide any orphaned briefing
    if (!isNeural) {
      hideNeuralBriefing(null, true);
    }
  }

  function highlightNeuralLine(gameKey, state) {
    if (!gameKey) return;
    const base = document.getElementById('trace-base-' + gameKey);
    const pulse = document.getElementById('trace-pulse-' + gameKey);
    const node = document.getElementById('node-' + gameKey);

    if (base) base.classList.toggle('highlighted', state);
    if (pulse) pulse.classList.toggle('highlighted', state);
    if (node) node.classList.toggle('active-hover', state);
  }

  function positionBriefingPopover(nodeElem) {
    const container = document.getElementById('neuralBusContainer');
    const card = document.getElementById('neuralBriefingCard');
    if (!container || !card || !nodeElem) return;

    if (window.innerWidth <= 768) {
      card.style.left = '';
      card.style.top = '';
      card.style.right = '';
      card.style.bottom = '';
      return;
    }

    const cRect = container.getBoundingClientRect();
    const nRect = nodeElem.getBoundingClientRect();

    const nodeCenterX = nRect.left + nRect.width / 2 - cRect.left;
    const nodeCenterY = nRect.top + nRect.height / 2 - cRect.top;

    const cardWidth = 290;
    const cardHeight = card.offsetHeight || 220;

    let left, top;

    // Horizontal positioning: place card towards the center/opposite side of node
    if (nodeCenterX < cRect.width * 0.4) {
      // Node is on left side -> place card to the right of node
      left = nodeCenterX + (nRect.width / 2) + 18;
    } else if (nodeCenterX > cRect.width * 0.6) {
      // Node is on right side -> place card to the left of node
      left = nodeCenterX - (nRect.width / 2) - cardWidth - 18;
    } else {
      // Node is near horizontal center
      left = nodeCenterX - cardWidth / 2;
    }

    // Vertical positioning: center vertically on node, clamped within container
    top = nodeCenterY - (cardHeight / 2);

    left = Math.max(16, Math.min(cRect.width - cardWidth - 16, left));
    top = Math.max(16, Math.min(cRect.height - cardHeight - 16, top));

    card.style.left = Math.round(left) + 'px';
    card.style.top = Math.round(top) + 'px';
    card.style.right = 'auto';
    card.style.bottom = 'auto';
  }

  function showNeuralBriefing(gameKey, elem) {
    if (briefingHideTimer) {
      clearTimeout(briefingHideTimer);
      briefingHideTimer = null;
    }

    const game = NEURAL_GAMES[gameKey];
    if (!game) return;

    if (activeNeuralGameKey && activeNeuralGameKey !== gameKey) {
      highlightNeuralLine(activeNeuralGameKey, false);
    }

    activeNeuralGameKey = gameKey;
    highlightNeuralLine(gameKey, true);

    const card = document.getElementById('neuralBriefingCard');
    const bTag = document.getElementById('briefingTag');
    const bTitle = document.getElementById('briefingTitle');
    const bDesc = document.getElementById('briefingDesc');
    const bStatLabel = document.getElementById('briefingStatLabel');
    const bStatVal = document.getElementById('briefingStatVal');

    if (bTag) bTag.innerText = game.tag;
    if (bTitle) bTitle.innerText = game.title;
    if (bDesc) bDesc.innerText = game.desc;
    if (bStatLabel) bStatLabel.innerText = game.statLabel;
    if (bStatVal) bStatVal.innerText = getNeuralGameStatValue(gameKey);

    if (card) {
      card.classList.add('active');
      positionBriefingPopover(elem);
    }
  }

  function hideNeuralBriefing(gameKey, immediate = false) {
    if (immediate) {
      if (briefingHideTimer) {
        clearTimeout(briefingHideTimer);
        briefingHideTimer = null;
      }
      const card = document.getElementById('neuralBriefingCard');
      if (card) card.classList.remove('active');
      if (activeNeuralGameKey) {
        highlightNeuralLine(activeNeuralGameKey, false);
        activeNeuralGameKey = null;
      }
      return;
    }

    briefingHideTimer = setTimeout(() => {
      const card = document.getElementById('neuralBriefingCard');
      if (card) card.classList.remove('active');
      if (activeNeuralGameKey) {
        highlightNeuralLine(activeNeuralGameKey, false);
        activeNeuralGameKey = null;
      }
    }, 140);
  }

  function launchActiveNeuralGame() {
    if (!activeNeuralGameKey) return;
    const game = NEURAL_GAMES[activeNeuralGameKey];
    if (!game) return;
    triggerGameLaunch(game.url);
  }

  function handleNeuralNodeClick(gameKey, elem) {
    if (window.innerWidth <= 768) {
      const card = document.getElementById('neuralBriefingCard');
      if (card && card.classList.contains('active') && activeNeuralGameKey === gameKey) {
        hideNeuralBriefing(gameKey, true);
      } else {
        showNeuralBriefing(gameKey, elem);
      }
    } else {
      const game = NEURAL_GAMES[gameKey];
      if (game) {
        openLaunchModal(game.url, game.title, game.desc);
      }
    }
  }

  // =========================================================
  // VECTOR CYBER ICONS GENERATOR
  // =========================================================
  function getGameIconSvg(key) {
    switch (key) {
      case 'chess':
        return `<svg class="node-cyber-svg svg-chess" viewBox="0 0 40 40" fill="none">
          <defs>
            <linearGradient id="mGradChess" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#38bdf8" />
              <stop offset="100%" stop-color="#818cf8" />
            </linearGradient>
          </defs>
          <path d="M12 34 h16 v-3 h-16 v3 z" fill="url(#mGradChess)" opacity="0.8" />
          <path d="M14 31 h12 c0 -3 -2 -5 -3 -7 h1 c1.5 0 2.5 -1.5 2 -3 l-1 -3 c2 -1 3 -3 3 -5 c0 -3 -2.5 -5 -6 -5 c-1.5 0 -3 0.5 -4 1.5 c-3 0 -5 2 -6 5 c-1 3 0 5 2 6.5 c-1 2 -2 4.5 -2 7 c0 2 1 3 3 3 z" fill="url(#mGradChess)" />
          <line x1="20" y1="13" x2="25" y2="14" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" />
          <circle cx="21" cy="14" r="1.2" fill="#00f0ff" />
        </svg>`;
      case 'bomb':
        return `<svg class="node-cyber-svg svg-bomb" viewBox="0 0 40 40" fill="none">
          <defs>
            <linearGradient id="mGradBomb" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#f43f5e" />
              <stop offset="100%" stop-color="#fb7185" />
            </linearGradient>
          </defs>
          <circle cx="20" cy="22" r="13" stroke="url(#mGradBomb)" stroke-width="1.8" stroke-dasharray="8 3" />
          <circle cx="20" cy="22" r="9" fill="rgba(244, 63, 94, 0.25)" stroke="#f43f5e" stroke-width="1.5" />
          <rect x="17.5" y="6" width="5" height="4" rx="1" fill="#fb7185" />
          <path d="M20 6 C20 3 24 3 24 1" stroke="#facc15" stroke-width="1.8" stroke-linecap="round" />
          <circle cx="24" cy="1" r="1.5" fill="#facc15" />
          <text x="20" y="23" font-size="5.5" font-weight="900" font-family="monospace" fill="#ffffff" text-anchor="middle" dominant-baseline="central">00:07</text>
        </svg>`;
      case 'snake':
        return `<svg class="node-cyber-svg svg-snake" viewBox="0 0 40 40" fill="none">
          <defs>
            <linearGradient id="mGradSnake" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#10e6a8" />
              <stop offset="100%" stop-color="#34d399" />
            </linearGradient>
          </defs>
          <path d="M28 10 C28 6 22 6 20 9 C18 12 11 12 11 17 C11 22 17 23 20 25 C24 27 27 29 27 33 C27 36 23 37 20 37 C15 37 12 34 12 30" stroke="url(#mGradSnake)" stroke-width="3" stroke-linecap="round" fill="none" />
          <circle cx="28" cy="10" r="3.5" fill="url(#mGradSnake)" />
          <circle cx="29.2" cy="9.2" r="1" fill="#040918" />
          <circle cx="16" cy="19" r="1.4" fill="#ffffff" />
          <circle cx="24" cy="29" r="1.4" fill="#ffffff" />
        </svg>`;
      case 'maze':
        return `<svg class="node-cyber-svg svg-maze" viewBox="0 0 40 40" fill="none">
          <defs>
            <linearGradient id="mGradMaze" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#c084fc" />
              <stop offset="100%" stop-color="#a855f7" />
            </linearGradient>
          </defs>
          <rect x="7" y="7" width="26" height="26" rx="5" stroke="url(#mGradMaze)" stroke-width="2" fill="rgba(168, 85, 247, 0.12)" />
          <path d="M7 16 H20 V24 H13 V33" stroke="url(#mGradMaze)" stroke-width="1.8" stroke-linecap="round" fill="none" />
          <path d="M26 7 V18 H33" stroke="url(#mGradMaze)" stroke-width="1.8" stroke-linecap="round" fill="none" />
          <path d="M20 28 H27 V33" stroke="url(#mGradMaze)" stroke-width="1.8" stroke-linecap="round" fill="none" />
          <circle cx="20" cy="20" r="2.2" fill="#ffffff" />
        </svg>`;
      case 'guess':
        return `<svg class="node-cyber-svg svg-guess" viewBox="0 0 40 40" fill="none">
          <defs>
            <linearGradient id="mGradGuess" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#facc15" />
              <stop offset="100%" stop-color="#fde047" />
            </linearGradient>
          </defs>
          <rect x="7" y="7" width="26" height="26" rx="5" stroke="url(#mGradGuess)" stroke-width="2" fill="rgba(250, 204, 21, 0.12)" />
          <text x="14" y="16" font-size="7.5" font-weight="900" font-family="monospace" fill="#facc15" text-anchor="middle" dominant-baseline="central">1</text>
          <text x="26" y="16" font-size="7.5" font-weight="900" font-family="monospace" fill="#ffffff" text-anchor="middle" dominant-baseline="central">0</text>
          <text x="14" y="27" font-size="7.5" font-weight="900" font-family="monospace" fill="#ffffff" text-anchor="middle" dominant-baseline="central">? </text>
          <text x="26" y="27" font-size="7.5" font-weight="900" font-family="monospace" fill="#facc15" text-anchor="middle" dominant-baseline="central">7</text>
          <circle cx="20" cy="20" r="1.5" fill="#fde047" />
        </svg>`;
      case 'reactor':
        return `<svg class="node-cyber-svg svg-reactor" viewBox="0 0 40 40" fill="none">
          <defs>
            <linearGradient id="mGradReactor" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#00f0ff" />
              <stop offset="100%" stop-color="#38bdf8" />
            </linearGradient>
          </defs>
          <ellipse cx="20" cy="20" rx="14" ry="5.5" stroke="url(#mGradReactor)" stroke-width="1.8" transform="rotate(-30 20 20)" stroke-dasharray="14 4" />
          <ellipse cx="20" cy="20" rx="14" ry="5.5" stroke="url(#mGradReactor)" stroke-width="1.8" transform="rotate(30 20 20)" stroke-dasharray="14 4" />
          <ellipse cx="20" cy="20" rx="14" ry="5.5" stroke="#ffffff" stroke-width="1.2" transform="rotate(90 20 20)" stroke-dasharray="10 6" />
          <circle cx="20" cy="20" r="4.5" fill="#00f0ff" />
          <circle cx="20" cy="20" r="2.2" fill="#ffffff" />
        </svg>`;
      default:
        return '';
    }
  }

  // =========================================================
  // MASTER GAMES LIBRARY CONTROLLER
  // =========================================================
  let activeMasterCategory = 'all';

  function openMasterLibraryModal() {
    renderMasterGamesList('', activeMasterCategory);
    openModal('masterLibraryModal');
  }

  function renderMasterGamesList(filterText = '', filterCat = 'all') {
    const grid = document.getElementById('masterGamesGrid');
    if (!grid) return;

    const query = filterText.toLowerCase().trim();

    const games = [
      {
        key: 'chess',
        title: 'Cyber Chess',
        category: 'strategy',
        categoryLabel: 'AI Strategy',
        desc: 'Deep neural chess engine with Stockfish evaluation, rating progression, and PGN export.',
        url: 'Chess/index.jsp',
        iconSvg: getGameIconSvg('chess'),
        statLabel: 'AI Rating',
        statVal: getNeuralGameStatValue('chess')
      },
      {
        key: 'bomb',
        title: 'Defusal Protocol',
        category: 'tactical',
        categoryLabel: 'Crisis Sim',
        desc: 'Disarm 5 tactical mini-games under a 3-minute clock with 3 containment charges.',
        url: 'Bomb_Defuse/index.jsp',
        iconSvg: getGameIconSvg('bomb'),
        statLabel: 'Record',
        statVal: getNeuralGameStatValue('bomb')
      },
      {
        key: 'snake',
        title: 'Cyber Snake',
        category: 'arcade',
        categoryLabel: 'Arcade Classic',
        desc: 'Fluid neon serpent arcade experience with dynamic tick rates, touch D-pads, and node tracking.',
        url: 'Snake/index.jsp',
        iconSvg: getGameIconSvg('snake'),
        statLabel: 'Best Score',
        statVal: getNeuralGameStatValue('snake')
      },
      {
        key: 'maze',
        title: 'Cyber Maze',
        category: 'puzzle',
        categoryLabel: 'Labyrinth',
        desc: 'Procedurally generated randomized labyrinth nodes with recursive backtracking algorithms.',
        url: 'Maze/index.jsp',
        iconSvg: getGameIconSvg('maze'),
        statLabel: 'Cleared',
        statVal: getNeuralGameStatValue('maze')
      },
      {
        key: 'guess',
        title: 'Cipher Guesser',
        category: 'puzzle',
        categoryLabel: 'Decryption',
        desc: 'Crack the encrypted integer between 1 and 100 in minimal probe iterations.',
        url: 'Game1/index.jsp',
        iconSvg: getGameIconSvg('guess'),
        statLabel: 'Fewest',
        statVal: getNeuralGameStatValue('guess')
      },
      {
        key: 'reactor',
        title: 'Reactor Meltdown',
        category: 'tactical',
        categoryLabel: 'Core Memory',
        desc: 'Replicate glowing reactor sequences under a 20s timer. Clear stages to expand grid size.',
        url: 'Reactor_Meltdown/index.jsp',
        iconSvg: getGameIconSvg('reactor'),
        statLabel: 'Core Record',
        statVal: getNeuralGameStatValue('reactor')
      }
    ];

    grid.innerHTML = '';
    const filtered = games.filter(g => {
      const matchCat = filterCat === 'all' || g.category === filterCat;
      const matchText = !query || g.title.toLowerCase().includes(query) || g.desc.toLowerCase().includes(query) || g.categoryLabel.toLowerCase().includes(query);
      return matchCat && matchText;
    });

    if (filtered.length === 0) {
      grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 2.5rem; color: var(--text-muted); font-size: 0.9rem;">No simulation protocols matched your query.</div>';
      return;
    }

    filtered.forEach(g => {
      const card = document.createElement('div');
      card.className = 'master-card';
      card.innerHTML = `
        <div>
          <div class="master-card-top">
            <div class="master-card-icon-wrap">` + g.iconSvg + `</div>
            <div>
              <div class="master-card-category">// ` + g.categoryLabel + `</div>
              <div class="master-card-title">` + g.title + `</div>
            </div>
          </div>
          <div class="master-card-desc">` + g.desc + `</div>
        </div>
        <div class="master-card-footer">
          <div class="master-card-stat">` + g.statLabel + `: <span>` + g.statVal + `</span></div>
          <button class="btn-master-play" onclick="closeModal('masterLibraryModal'); triggerGameLaunch('` + g.url + `')">
            <span>▶</span> PLAY
          </button>
        </div>
      `;
      grid.appendChild(card);
    });
  }

  function filterMasterCategory(cat, btn) {
    activeMasterCategory = cat;
    document.querySelectorAll('.master-pill').forEach(b => b.classList.remove('active'));
    if (btn) btn.classList.add('active');
    const input = document.getElementById('masterGameSearch');
    renderMasterGamesList(input ? input.value : '', activeMasterCategory);
  }

  function filterMasterGames(val) {
    renderMasterGamesList(val, activeMasterCategory);
  }

  // =========================================================
  // ANIMATED SHADER ENGINE FOR GAME HUB CORE
  // Hypnotic Dithered Plasma Vortex (Sphere/Swirl/Ripple)
  // =========================================================
  function initHubShaderEngine() {
    const canvas = document.getElementById('hubShaderCanvas');
    if (!canvas) return;

    let speedMultiplier = 1.0;
    const hubCore = document.getElementById('neuralHubCore');
    if (hubCore) {
      hubCore.addEventListener('mouseenter', () => { speedMultiplier = 2.4; });
      hubCore.addEventListener('mouseleave', () => { speedMultiplier = 1.0; });
    }

    const gl = canvas.getContext('webgl', { alpha: true, antialias: false, powerPreference: 'low-power' });
    if (!gl) {
      initFallback2DShader(canvas);
      return;
    }

    const vsSource = `
      attribute vec2 a_pos;
      void main() {
        gl_Position = vec4(a_pos, 0.0, 1.0);
      }
    `;

    const fsSource = `
      precision mediump float;
      uniform vec2 u_res;
      uniform float u_time;
      uniform float u_speed;

      float bayer4(vec2 p) {
        vec2 m = floor(mod(p, 4.0));
        float i = m.x + m.y * 4.0;
        if (i == 0.0) return 0.0/16.0; if (i == 1.0) return 8.0/16.0;
        if (i == 2.0) return 2.0/16.0; if (i == 3.0) return 10.0/16.0;
        if (i == 4.0) return 12.0/16.0; if (i == 5.0) return 4.0/16.0;
        if (i == 6.0) return 14.0/16.0; if (i == 7.0) return 6.0/16.0;
        if (i == 8.0) return 3.0/16.0; if (i == 9.0) return 11.0/16.0;
        if (i == 10.0) return 1.0/16.0; if (i == 11.0) return 9.0/16.0;
        if (i == 12.0) return 15.0/16.0; if (i == 13.0) return 7.0/16.0;
        if (i == 14.0) return 13.0/16.0; return 5.0/16.0;
      }

      void main() {
        vec2 uv = (gl_FragCoord.xy - 0.5 * u_res) / min(u_res.x, u_res.y);
        float r = length(uv);
        float a = atan(uv.y, uv.x);

        float t = u_time * u_speed;
        float swirl = sin(a * 4.0 + r * 14.0 - t * 2.5) * 0.5 + 0.5;
        float ripple = sin(r * 20.0 - t * 3.2) * 0.5 + 0.5;
        float sphere = smoothstep(0.48, 0.16, r);
        float val = (swirl * 0.65 + ripple * 0.35) * sphere;

        float dither = bayer4(gl_FragCoord.xy / 2.0);
        float threshold = step(dither, val);

        vec3 frontColor = vec3(0.0, 0.94, 1.0);
        vec3 backColor = vec3(0.01, 0.06, 0.18);
        vec3 col = mix(backColor, frontColor, threshold);

        float alpha = smoothstep(0.49, 0.44, r) * (threshold * 0.85 + 0.15);
        gl_FragColor = vec4(col * alpha, alpha);
      }
    `;

    function compileShader(src, type) {
      const s = gl.createShader(type);
      gl.shaderSource(s, src);
      gl.compileShader(s);
      if (!gl.getShaderParameter(s, gl.COMPILE_STATUS)) {
        console.warn('Shader compile err:', gl.getShaderInfoLog(s));
        return null;
      }
      return s;
    }

    const vs = compileShader(vsSource, gl.VERTEX_SHADER);
    const fs = compileShader(fsSource, gl.FRAGMENT_SHADER);
    if (!vs || !fs) {
      initFallback2DShader(canvas);
      return;
    }

    const prog = gl.createProgram();
    gl.attachShader(prog, vs);
    gl.attachShader(prog, fs);
    gl.linkProgram(prog);
    gl.useProgram(prog);

    const posBuf = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, posBuf);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
      -1, -1,
       1, -1,
      -1,  1,
       1,  1
    ]), gl.STATIC_DRAW);

    const aPos = gl.getAttribLocation(prog, 'a_pos');
    gl.enableVertexAttribArray(aPos);
    gl.vertexAttribPointer(aPos, 2, gl.FLOAT, false, 0, 0);

    const uRes = gl.getUniformLocation(prog, 'u_res');
    const uTime = gl.getUniformLocation(prog, 'u_time');
    const uSpeed = gl.getUniformLocation(prog, 'u_speed');

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.uniform2f(uRes, canvas.width, canvas.height);

    let startTime = performance.now();
    let currentSpeed = 1.0;

    function renderShader(now) {
      if (!document.getElementById('hubShaderCanvas')) return;
      currentSpeed += (speedMultiplier - currentSpeed) * 0.08;
      const elapsed = (now - startTime) / 1000;
      gl.uniform1f(uTime, elapsed);
      gl.uniform1f(uSpeed, currentSpeed);

      gl.clearColor(0, 0, 0, 0);
      gl.clear(gl.COLOR_BUFFER_BIT);
      gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

      requestAnimationFrame(renderShader);
    }
    requestAnimationFrame(renderShader);
  }

  function initFallback2DShader(canvas) {
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    let t = 0;
    function render2D() {
      t += 0.03;
      const w = canvas.width, h = canvas.height;
      ctx.clearRect(0, 0, w, h);
      const cx = w / 2, cy = h / 2, r = w * 0.42;

      const grad = ctx.createRadialGradient(cx, cy, 2, cx, cy, r);
      grad.addColorStop(0, 'rgba(0, 240, 255, 0.6)');
      grad.addColorStop(0.5, 'rgba(2, 132, 199, 0.35)');
      grad.addColorStop(1, 'rgba(0, 240, 255, 0)');

      ctx.fillStyle = grad;
      ctx.beginPath();
      ctx.arc(cx, cy, r, 0, Math.PI * 2);
      ctx.fill();

      ctx.save();
      ctx.translate(cx, cy);
      ctx.rotate(t * 1.5);
      ctx.strokeStyle = 'rgba(0, 240, 255, 0.4)';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.arc(0, 0, r * 0.75, 0, Math.PI * 1.2);
      ctx.stroke();
      ctx.restore();

      requestAnimationFrame(render2D);
    }
    requestAnimationFrame(render2D);
  }

  function triggerGameLaunch(url) {
    const modalBox = document.querySelector('#launchModal .modal-box');
    const Motion = getMotionEngine();

    if (modalBox) {
      if (Motion && typeof Motion.animate === 'function') {
        Motion.animate(modalBox, { scale: [1, 0.94], filter: ['blur(0px)', 'blur(5px)'], opacity: [1, 0.4] }, { duration: 0.22, ease: [0.16, 1, 0.3, 1] });
      } else {
        modalBox.style.transform = 'scale(0.94)';
        modalBox.style.filter = 'blur(5px)';
        modalBox.style.opacity = '0.4';
        modalBox.style.transition = 'all 0.22s cubic-bezier(0.16, 1, 0.3, 1)';
      }
    }

    kineticNavigate(url);
  }

  function openLaunchModal(url, title, desc) {
    targetUrl = url;
    document.getElementById('modalTitle').innerText = title;
    document.getElementById('modalDesc').innerText = desc;
    document.getElementById('confirmLaunchBtn').onclick = () => triggerGameLaunch(targetUrl);
    openModal('launchModal');
  }

  function openModal(id) {
    const modal = document.getElementById(id);
    if (!modal) return;
    modal.style.display = 'flex';
    void modal.offsetWidth;
    modal.classList.add('active');

    const modalBox = modal.querySelector('.modal-box');
    const Motion = getMotionEngine();
    if (modalBox && Motion && typeof Motion.animate === 'function') {
      Motion.animate(
        modalBox,
        { opacity: [0, 1], scale: [0.93, 1], y: [16, 0] },
        { duration: 0.3, ease: [0.16, 1, 0.3, 1] }
      );
    }

    if (window.innerWidth > 768) {
      const input = modal.querySelector('input');
      if (input) input.focus();
    }
  }

  function closeModal(id) {
    const modal = document.getElementById(id);
    if (!modal) return;
    const modalBox = modal.querySelector('.modal-box');
    const Motion = getMotionEngine();

    // UI/UX Pro Max rule: Exit faster than enter (snappy 160ms deceleration)
    if (modalBox && Motion && typeof Motion.animate === 'function') {
      Motion.animate(
        modalBox,
        { opacity: [1, 0], scale: [1, 0.94], y: [0, 8] },
        { duration: 0.16, ease: [0.7, 0, 0.84, 0] }
      ).then(() => {
        modal.classList.remove('active');
        modal.style.display = 'none';
        modalBox.style.opacity = '';
        modalBox.style.transform = '';
      });
    } else {
      modal.classList.remove('active');
      setTimeout(() => { modal.style.display = 'none'; }, 160);
    }
  }

  function openLoginModal() {
    window.location.href = 'auth.jsp?mode=login';
  }

  function openSignupModal() {
    window.location.href = 'auth.jsp?mode=signup';
  }

  function setBanner(elemId, type, text) {
    const el = document.getElementById(elemId);
    if (!el) return;
    el.className = 'auth-msg ' + type;
    const icon = (type === 'success') ? '✓ ' : '⚠️ ';
    el.innerHTML = icon + text;
    el.style.display = 'flex';
  }

  // --- ASYNC AUTH HANDLERS ---
  async function submitLogin() {
    const u = document.getElementById('loginUsername').value.trim();
    const p = document.getElementById('loginPassword').value;
    const btn = document.getElementById('loginSubmitBtn');
    const btnText = document.getElementById('loginBtnText');

    if (!u || !p) {
      setBanner('loginMsg', 'error', 'Username and password required.');
      return;
    }

    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner"></span> Logging in...';

    try {
      const res = await fetch('login.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ username: u, password: p })
      });

      const rawText = await res.text();
      let data = null;

      try {
        data = JSON.parse(rawText);
      } catch (jsonErr) {
        setBanner('loginMsg', 'error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
        btn.disabled = false;
        btnText.innerText = 'Log In';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('loginMsg', 'success', 'Welcome back! Entering Game Hub...');
        enforceAccountBoundary(u);
        setTimeout(() => {
          closeModal('loginModal');
          triggerDoorTransition(u.toUpperCase(), 'LOGGED IN // WELCOME BACK', () => {
            window.location.reload();
          });
        }, 400);
      } else {
        setBanner('loginMsg', 'error', data.message || 'Invalid username or password.');
        btn.disabled = false;
        btnText.innerText = '⚡ AUTHENTICATE';
      }
    } catch (netErr) {
      setBanner('loginMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = '⚡ AUTHENTICATE';
    }
  }

  async function submitSignup() {
    const u = document.getElementById('signupUsername').value.trim();
    const p = document.getElementById('signupPassword').value;
    const c = document.getElementById('signupPasswordConfirm').value;
    const btn = document.getElementById('signupSubmitBtn');
    const btnText = document.getElementById('signupBtnText');

    if (!u || !p || !c) {
      setBanner('signupMsg', 'error', 'Please fill in all fields.');
      return;
    }
    if (p !== c) {
      setBanner('signupMsg', 'error', 'Passwords do not match.');
      return;
    }
    if (p.length < 6) {
      setBanner('signupMsg', 'error', 'Password must be at least 6 characters.');
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

      const rawText = await res.text();
      let data = null;

      try {
        data = JSON.parse(rawText);
      } catch (jsonErr) {
        setBanner('signupMsg', 'error', 'Database offline. Verify MySQL connection or check DB_URL on Render.');
        btn.disabled = false;
        btnText.innerText = '⚡ ENLIST PROFILE';
        return;
      }

      if (data.status === 'success' || data.success) {
        setBanner('signupMsg', 'success', 'Profile enlisted! Entering Game Hub...');
        enforceAccountBoundary(u);
        setTimeout(() => {
          closeModal('signupModal');
          triggerDoorTransition(u.toUpperCase(), 'ACCOUNT READY // WELCOME', () => {
            window.location.reload();
          });
        }, 400);
      } else {
        setBanner('signupMsg', 'error', data.message || 'Registration failed.');
        btn.disabled = false;
        btnText.innerText = '⚡ ENLIST PROFILE';
      }
    } catch (netErr) {
      setBanner('signupMsg', 'error', 'Gateway unreachable. Verify connection or wait if Render is waking up.');
      btn.disabled = false;
      btnText.innerText = '⚡ ENLIST PROFILE';
    }
  }

  async function performLogout() {
    sessionStorage.removeItem('hub_portal_passed');
    enforceAccountBoundary('');
    try {
      await fetch('logout.jsp', { headers: { 'Accept': 'application/json' } });
      window.location.href = 'auth.jsp';
    } catch (e) {
      window.location.href = 'logout.jsp';
    }
  }

  // --- Dynamic Client Session Check ---
  async function checkLiveSession() {
    try {
      const res = await fetch('session_check.jsp');
      const text = await res.text();
      const data = JSON.parse(text);
      if (data.status === 'success' && data.loggedIn) {
        isUserLoggedIn = true;
        currentUsername = data.username || data.user_session;
        const u = currentUsername;

        enforceAccountBoundary(u);

        const widget = document.getElementById('authWidget');
        if (widget) {
          widget.innerHTML = `
            <div class="auth-avatar-wrap">
              <div class="auth-avatar">${u.substring(0, 1).toUpperCase()}</div>
              <div class="auth-avatar-pulse"></div>
            </div>
            <div class="auth-name">
              ${u}
              <span class="profile-level-badge" id="profileLevelBadge">LVL 1</span>
            </div>
            <div class="player-rank-title" id="profileRankTitle">Novice Thinker</div>
            <div class="profile-xp-box" id="profileXpBox">
              <div class="xp-header-row">
                <span>// XP PROGRESS</span>
                <span class="xp-val" id="profileXpText">0 / 200 XP</span>
              </div>
              <div class="xp-bar-track">
                <div class="xp-bar-fill" id="profileXpFill" style="width: 0%;"></div>
              </div>
              <div class="xp-subtext">
                <span id="profileXpPercent">0%</span>
                <span id="profileXpRemaining">200 XP to next lvl</span>
              </div>
            </div>
            <button class="btn-auth btn-logout" onclick="performLogout()" style="margin-top: 12px;">
              <span>⏻ DISCONNECT</span>
            </button>
          `;
        }

        // Unlock Nav Buttons & Meta Pill
        const lockBadge = document.getElementById('navLockScores');
        if (lockBadge) lockBadge.remove();

        const navSetIcon = document.getElementById('navSettingsIcon');
        const navSetText = document.getElementById('navSettingsText');
        if (navSetIcon) navSetIcon.innerText = '⚙️';
        if (navSetText) navSetText.innerText = 'Settings';

        const metaPill = document.getElementById('metaLevelPill');
        if (metaPill) metaPill.style.display = 'inline-flex';

        const spotUser = document.querySelector('.spotlight-username');
        if (spotUser) spotUser.innerText = u;

        updateAccountLevelUI();
      } else {
        isUserLoggedIn = false;
      }
    } catch (e) {
      console.warn('Session polling offline:', e);
    }
  }

  // --- MULTI-GAME TELEMETRY SYNC ---
  async function syncCloudScores() {
    const isGuest = !isUserLoggedIn;

    // 1. Defusal Protocol Metrics
    const localDefuse = isGuest ? (localStorage.getItem('hub_defuse_high') || '0') : (scoresFetchedFromCloud ? (verifiedCloudScores.defuse || 0) : '0');
    const localDefuseLvl = isGuest ? (localStorage.getItem('hub_defuse_level') || '1') : '1';
    const localDefuseDisarms = isGuest ? (localStorage.getItem('hub_defuse_disarms') || '0') : '0';
    const localDefuseStrikes = isGuest ? (localStorage.getItem('hub_defuse_strikes_avoided') || '0') : '0';

    const pDefuse = document.getElementById('preview-defuse');
    const sDefuseBest = document.getElementById('statDefuseBest');
    const sDefuseLevel = document.getElementById('statDefuseLevel');
    const sDefuseDisarms = document.getElementById('statDefuseDisarms');
    const sDefuseStrikes = document.getElementById('statDefuseStrikes');

    if (pDefuse) pDefuse.innerText = localDefuse + ' pts';
    if (sDefuseBest) sDefuseBest.innerText = localDefuse + ' pts';
    if (sDefuseLevel) sDefuseLevel.innerText = 'Level ' + localDefuseLvl;
    if (sDefuseDisarms) sDefuseDisarms.innerText = localDefuseDisarms;
    if (sDefuseStrikes) sDefuseStrikes.innerText = localDefuseStrikes;

    // 2. Cyber Chess Metrics
    const localChessRating = isGuest ? (localStorage.getItem('hub_chess_rating') || '1200') : (scoresFetchedFromCloud ? (verifiedCloudScores.chessPlayed ? verifiedCloudScores.chessRating : '1200 (Unranked)') : '1200 (Unranked)');
    const localChessWins = isGuest ? parseInt(localStorage.getItem('hub_chess_wins') || '0', 10) : (scoresFetchedFromCloud ? verifiedCloudScores.chessWins : 0);
    const localChessLosses = isGuest ? parseInt(localStorage.getItem('hub_chess_losses') || '0', 10) : 0;
    const totalMatches = localChessWins + localChessLosses;
    const winRatio = totalMatches > 0 ? Math.round((localChessWins / totalMatches) * 100) : 0;

    const pChess = document.getElementById('preview-chess');
    const sChessRating = document.getElementById('statChessRating');
    const sChessWins = document.getElementById('statChessWins');
    const sChessLosses = document.getElementById('statChessLosses');
    const sChessRatio = document.getElementById('statChessRatio');

    if (pChess) pChess.innerText = localChessRating;
    if (sChessRating) sChessRating.innerText = localChessRating;
    if (sChessWins) sChessWins.innerText = localChessWins;
    if (sChessLosses) sChessLosses.innerText = localChessLosses;
    if (sChessRatio) sChessRatio.innerText = winRatio + '%';

    // 3. Cyber Snake Metrics
    const localSnake = isGuest ? (localStorage.getItem('hub_snake_high') || '0') : (scoresFetchedFromCloud ? (verifiedCloudScores.snake || 0) : '0');
    const localSnakeNodes = isGuest ? (localStorage.getItem('hub_snake_nodes') || '0') : '0';

    const pSnake = document.getElementById('preview-snake');
    const sSnakeBest = document.getElementById('statSnakeBest');
    const sSnakeNodes = document.getElementById('statSnakeNodes');

    if (pSnake) pSnake.innerText = localSnake + ' pts';
    if (sSnakeBest) sSnakeBest.innerText = localSnake + ' pts';
    if (sSnakeNodes) sSnakeNodes.innerText = localSnakeNodes;

    // 4. Cyber Maze Metrics
    const localMazeClears = isGuest ? (localStorage.getItem('hub_maze_clears') || '0') : (scoresFetchedFromCloud ? (verifiedCloudScores.maze || 0) : '0');
    const localMazeBestTime = isGuest ? (localStorage.getItem('hub_maze_best_time') || '0') : '0';

    const pMaze = document.getElementById('preview-maze');
    const sMazeClears = document.getElementById('statMazeClears');
    const sMazeBestTime = document.getElementById('statMazeBestTime');

    if (pMaze) pMaze.innerText = localMazeClears;
    if (sMazeClears) sMazeClears.innerText = localMazeClears;
    if (sMazeBestTime) sMazeBestTime.innerText = localMazeBestTime > 0 ? localMazeBestTime + 's' : '--';

    // 5. Cipher Guesser Metrics
    const localGuess = isGuest ? (localStorage.getItem('hub_guess_best') || '--') : (scoresFetchedFromCloud ? ((verifiedCloudScores.guess > 0) ? verifiedCloudScores.guess : '--') : '--');
    const pGuess = document.getElementById('preview-guess');
    const sGuessBest = document.getElementById('statGuessBest');

    if (pGuess) pGuess.innerText = (localGuess !== '--') ? localGuess + ' tries' : '--';
    if (sGuessBest) sGuessBest.innerText = (localGuess !== '--') ? localGuess + ' tries' : '--';

    // 6. Reactor Meltdown Metrics
    const localReactor = isGuest ? (localStorage.getItem('hub_reactor_high') || '0') : (scoresFetchedFromCloud ? (verifiedCloudScores.reactor || 0) : '0');
    const localReactorStage = isGuest ? (localStorage.getItem('hub_reactor_stage') || 'Sector 1') : 'Sector 1';

    const pReactor = document.getElementById('preview-reactor');
    const sReactorBest = document.getElementById('statReactorBest');
    const sReactorStage = document.getElementById('statReactorStage');

    if (pReactor) pReactor.innerText = localReactor + ' pts';
    if (sReactorBest) sReactorBest.innerText = localReactor + ' pts';
    if (sReactorStage) sReactorStage.innerText = localReactorStage;

    // 7. RANS0M Crisis Metrics (Inside Settings)
    const localRansom = isGuest ? (localStorage.getItem('hub_ransom_high') || '0') : (scoresFetchedFromCloud ? (verifiedCloudScores.ransom || 0) : '0');
    const sRansomSettings = document.getElementById('statRansomBestSettings');
    if (sRansomSettings) sRansomSettings.innerText = localRansom + ' pts';

    // Query Database High Scores & Global Leaderboards
    try {
      const res = await fetch('get_scores.jsp');
      if (res.ok) {
        const data = await res.json();
        if (data && data.userScores && isUserLoggedIn) {
          const uScores = data.userScores;

          // Database is authoritative for logged-in accounts (defaulting unplayed to 0)
          const dbSnake = uScores.snake !== undefined ? Number(uScores.snake) : 0;
          const dbDefuse = uScores.bomb_defuse !== undefined ? Number(uScores.bomb_defuse) : 0;
          const dbReactor = uScores.reactor_meltdown !== undefined ? Number(uScores.reactor_meltdown) : 0;
          const dbMaze = (uScores.maze !== undefined) ? Number(uScores.maze) : ((uScores.cyber_maze !== undefined) ? Number(uScores.cyber_maze) : 0);
          const dbGuess = (uScores.number_guess !== undefined) ? Number(uScores.number_guess) : ((uScores.guess !== undefined) ? Number(uScores.guess) : 0);
          const dbRansom = uScores.ransom !== undefined ? Number(uScores.ransom) : 0;

          verifiedCloudScores.snake = dbSnake;
          verifiedCloudScores.defuse = dbDefuse;
          verifiedCloudScores.reactor = dbReactor;
          verifiedCloudScores.maze = dbMaze;
          verifiedCloudScores.guess = dbGuess;
          verifiedCloudScores.ransom = dbRansom;

          if (uScores.chess !== undefined) {
            verifiedCloudScores.chessRating = Number(uScores.chess);
            verifiedCloudScores.chessPlayed = true;
            verifiedCloudScores.chessWins = Math.max(0, Math.floor((verifiedCloudScores.chessRating - 1200) / 25));
          } else {
            verifiedCloudScores.chessRating = 1200;
            verifiedCloudScores.chessPlayed = false;
            verifiedCloudScores.chessWins = 0;
          }

          scoresFetchedFromCloud = true;

          // Store verified values in localStorage
          localStorage.setItem('hub_snake_high', dbSnake);
          localStorage.setItem('hub_defuse_high', dbDefuse);
          localStorage.setItem('hub_chess_rating', verifiedCloudScores.chessRating);
          localStorage.setItem('hub_chess_wins', verifiedCloudScores.chessWins);
          localStorage.setItem('hub_reactor_high', dbReactor);
          localStorage.setItem('hub_maze_clears', dbMaze);
          localStorage.setItem('hub_ransom_high', dbRansom);
          if (dbGuess > 0) {
            localStorage.setItem('hub_guess_best', dbGuess);
          } else {
            localStorage.removeItem('hub_guess_best');
          }

          // Authoritative DOM updates for carousel cards
          if (pSnake) pSnake.innerText = dbSnake + ' pts';
          if (pDefuse) pDefuse.innerText = dbDefuse + ' pts';
          if (pChess) pChess.innerText = verifiedCloudScores.chessPlayed ? verifiedCloudScores.chessRating : '1200 (Unranked)';
          if (pReactor) pReactor.innerText = dbReactor + ' pts';
          if (pMaze) pMaze.innerText = dbMaze;
          if (pGuess) pGuess.innerText = (dbGuess > 0) ? dbGuess + ' tries' : '--';

          // Authoritative DOM updates for stats view & settings
          if (sSnakeBest) sSnakeBest.innerText = dbSnake + ' pts';
          if (sDefuseBest) sDefuseBest.innerText = dbDefuse + ' pts';
          if (sChessRating) sChessRating.innerText = verifiedCloudScores.chessPlayed ? verifiedCloudScores.chessRating : '1200 (Unranked)';
          if (sChessWins) sChessWins.innerText = verifiedCloudScores.chessWins;
          if (sReactorBest) sReactorBest.innerText = dbReactor + ' pts';
          if (sMazeClears) sMazeClears.innerText = dbMaze;
          if (sGuessBest) sGuessBest.innerText = (dbGuess > 0) ? dbGuess + ' tries' : '--';
          if (sRansomSettings) sRansomSettings.innerText = dbRansom + ' pts';

          // Re-render UI with authoritative cloud values
          updateAccountLevelUI();
          renderCognitiveRadarChart();
        }

        if (data && data.leaders) {
          const lSnake = document.getElementById('statSnakeLeader');
          const lDefuse = document.getElementById('statDefuseLeader');
          const lReactor = document.getElementById('statReactorLeader');
          const lRansom = document.getElementById('statRansomLeader');
          if (lSnake && data.leaders.snake) {
            lSnake.innerText = data.leaders.snake.username + ' (' + data.leaders.snake.score + ' pts)';
          }
          if (lDefuse && data.leaders.bomb_defuse) {
            lDefuse.innerText = data.leaders.bomb_defuse.username + ' (' + data.leaders.bomb_defuse.score + ' pts)';
          }
          if (lReactor && data.leaders.reactor_meltdown) {
            lReactor.innerText = data.leaders.reactor_meltdown.username + ' (' + data.leaders.reactor_meltdown.score + ' pts)';
          }
          if (lRansom && data.leaders.ransom) {
            lRansom.innerText = data.leaders.ransom.username + ' (' + data.leaders.ransom.score + ' pts)';
          }
        }
      }
    } catch (e) {
      console.warn('Cloud score sync offline; relying on local telemetry.');
    }
    // Update Cognitive Radar Chart & Account Level
    renderCognitiveRadarChart();
    updateAccountLevelUI();
  }

  // --- COGNITIVE RADAR CHART (SPIDER GRAPH) ---
  function renderCognitiveRadarChart() {
    const canvas = document.getElementById('radarChartCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let defuseBest = 0;
    let chessRating = 1200;
    let chessPlayed = false;
    let snakeBest = 0;
    let mazeClears = 0;
    let reactorBest = 0;

    if (isUserLoggedIn) {
      if (scoresFetchedFromCloud) {
        defuseBest = verifiedCloudScores.defuse || 0;
        chessRating = verifiedCloudScores.chessRating || 1200;
        chessPlayed = verifiedCloudScores.chessPlayed;
        snakeBest = verifiedCloudScores.snake || 0;
        mazeClears = verifiedCloudScores.maze || 0;
        reactorBest = verifiedCloudScores.reactor || 0;
      }
    } else {
      defuseBest = parseFloat(localStorage.getItem('hub_defuse_high') || '0');
      chessRating = parseFloat(localStorage.getItem('hub_chess_rating') || '1200');
      chessPlayed = localStorage.getItem('hub_chess_rating') !== null;
      snakeBest = parseFloat(localStorage.getItem('hub_snake_high') || '0');
      mazeClears = parseFloat(localStorage.getItem('hub_maze_clears') || '0');
      reactorBest = parseFloat(localStorage.getItem('hub_reactor_high') || '0');
    }

    const hasAnyScore = (defuseBest > 0 || reactorBest > 0 || snakeBest > 0 || mazeClears > 0 || (chessPlayed && chessRating > 1200));

    // Normalized scores between 0.08 and 1.0
    const pctMemory = reactorBest > 0 ? Math.min(100, Math.round((reactorBest / 300) * 100)) : 0;
    const pctLogic = defuseBest > 0 ? Math.min(100, Math.round((defuseBest / 500) * 100)) : 0;
    const pctSpeed = snakeBest > 0 ? Math.min(100, Math.round((snakeBest / 100) * 100)) : 0;
    const pctSpatial = mazeClears > 0 ? Math.min(100, Math.round((mazeClears / 5) * 100)) : 0;
    const pctStrategy = (chessPlayed && chessRating > 1200) ? Math.min(100, Math.round(((chessRating - 1200) / 600) * 100)) : 0;

    const scoreMemory = Math.min(1.0, Math.max(0.08, pctMemory / 100));
    const scoreLogic = Math.min(1.0, Math.max(0.08, pctLogic / 100));
    const scoreSpeed = Math.min(1.0, Math.max(0.08, pctSpeed / 100));
    const scoreSpatial = Math.min(1.0, Math.max(0.08, pctSpatial / 100));
    const scoreStrategy = Math.min(1.0, Math.max(0.08, pctStrategy / 100));

    // Update percentage indicators in DOM
    const elMem = document.getElementById('valMetricMemory');
    const elLog = document.getElementById('valMetricLogic');
    const elSpd = document.getElementById('valMetricSpeed');
    const elSpa = document.getElementById('valMetricSpatial');
    const elStr = document.getElementById('valMetricStrategy');
    const elIndex = document.getElementById('overallBrainScore');

    if (elMem) elMem.innerText = pctMemory + '%';
    if (elLog) elLog.innerText = pctLogic + '%';
    if (elSpd) elSpd.innerText = pctSpeed + '%';
    if (elSpa) elSpa.innerText = pctSpatial + '%';
    if (elStr) elStr.innerText = pctStrategy + '%';

    if (elIndex) {
      if (!hasAnyScore) {
        elIndex.innerText = '--';
      } else {
        const avgScore = Math.round((pctMemory + pctLogic + pctSpeed + pctSpatial + pctStrategy) / 5);
        elIndex.innerText = avgScore;
      }
    }

    // Canvas geometry
    const w = canvas.width;
    const h = canvas.height;
    ctx.clearRect(0, 0, w, h);

    const cx = w / 2;
    const cy = h / 2 - 2;
    const r = Math.min(w, h) * 0.35; // ~95px radius
    const axes = [
      { name: 'Memory', score: scoreMemory, color: '#38bdf8' },
      { name: 'Logic', score: scoreLogic, color: '#facc15' },
      { name: 'Speed', score: scoreSpeed, color: '#10b981' },
      { name: 'Spatial', score: scoreSpatial, color: '#00f0ff' },
      { name: 'Strategy', score: scoreStrategy, color: '#ec4899' }
    ];
    const totalAxes = axes.length;

    function getCoord(axisIndex, distRatio) {
      const angle = -Math.PI / 2 + (2 * Math.PI * axisIndex / totalAxes);
      return {
        x: cx + Math.cos(angle) * (r * distRatio),
        y: cy + Math.sin(angle) * (r * distRatio)
      };
    }

    // Concentric Web Polygons
    const levels = [0.25, 0.5, 0.75, 1.0];
    levels.forEach(lvl => {
      ctx.beginPath();
      for (let i = 0; i < totalAxes; i++) {
        const pt = getCoord(i, lvl);
        if (i === 0) ctx.moveTo(pt.x, pt.y);
        else ctx.lineTo(pt.x, pt.y);
      }
      ctx.closePath();
      ctx.strokeStyle = lvl === 1.0 ? 'rgba(0, 240, 255, 0.4)' : 'rgba(0, 240, 255, 0.12)';
      ctx.lineWidth = 1;
      ctx.stroke();
    });

    // Radial Spokes
    for (let i = 0; i < totalAxes; i++) {
      const pt = getCoord(i, 1.0);
      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.lineTo(pt.x, pt.y);
      ctx.strokeStyle = 'rgba(0, 240, 255, 0.18)';
      ctx.lineWidth = 1;
      ctx.stroke();
    }

    // Only draw player polygon if at least one game was played
    if (hasAnyScore) {
      ctx.beginPath();
      for (let i = 0; i < totalAxes; i++) {
        const pt = getCoord(i, axes[i].score);
        if (i === 0) ctx.moveTo(pt.x, pt.y);
        else ctx.lineTo(pt.x, pt.y);
      }
      ctx.closePath();

      const grad = ctx.createRadialGradient(cx, cy, 10, cx, cy, r);
      grad.addColorStop(0, 'rgba(0, 240, 255, 0.45)');
      grad.addColorStop(1, 'rgba(2, 132, 199, 0.15)');
      ctx.fillStyle = grad;
      ctx.fill();

      ctx.strokeStyle = '#00f0ff';
      ctx.lineWidth = 2.5;
      ctx.stroke();

      // Vertex Points
      for (let i = 0; i < totalAxes; i++) {
        const pt = getCoord(i, axes[i].score);
        ctx.beginPath();
        ctx.arc(pt.x, pt.y, 4.5, 0, Math.PI * 2);
        ctx.fillStyle = axes[i].color;
        ctx.fill();
        ctx.strokeStyle = '#ffffff';
        ctx.lineWidth = 1.5;
        ctx.stroke();
      }
    }

    // Axis Labels
    ctx.font = '600 11px system-ui, -apple-system, sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    for (let i = 0; i < totalAxes; i++) {
      const labelPt = getCoord(i, 1.24);
      ctx.fillStyle = axes[i].color;
      ctx.fillText(axes[i].name, labelPt.x, labelPt.y);
    }
  }

  function resetLocalCache() {
    if (confirm('Purge local score and telemetry cache? Your cloud records remain safe in the database.')) {
      localStorage.clear();
      syncCloudScores();
      alert('Local telemetry purged successfully.');
    }
  }

  function togglePerformance(checkbox) {
    if (checkbox.checked) {
      document.body.style.setProperty('animation', 'none', 'important');
    } else {
      document.body.style.removeProperty('animation');
    }
  }

  function openRansomInstructionModal() {
    const modal = document.getElementById('ransomInstructionModal');
    if (modal) modal.classList.add('active');
  }

  function closeRansomInstructionModal() {
    const modal = document.getElementById('ransomInstructionModal');
    if (modal) modal.classList.remove('active');
  }

  function confirmRansomHorror(enable) {
    closeRansomInstructionModal();
    localStorage.setItem('ransom_horror_mode', enable ? 'true' : 'false');
    const toggleEl = document.getElementById('toggleRansomHorror');
    if (toggleEl) toggleEl.checked = enable;
    updateRansomIndicator();
  }

  function toggleRansomHorrorMode(checkbox) {
    if (checkbox.checked) {
      openRansomInstructionModal();
    } else {
      confirmRansomHorror(false);
    }
  }

  function updateRansomIndicator() {
    const isHorrorOn = localStorage.getItem('ransom_horror_mode') === 'true';
    const toggleEl = document.getElementById('toggleRansomHorror');
    if (toggleEl) toggleEl.checked = isHorrorOn;

    const statusPill = document.querySelector('.sys-status');
    if (statusPill) {
      if (isHorrorOn) {
        statusPill.innerHTML = '<span style="color: #ef4444; font-weight: 800;">☣ HORROR ACTIVE</span>';
      } else {
        statusPill.innerText = 'Online';
      }
    }
  }

  document.querySelectorAll('.modal-overlay').forEach(modal => {
    modal.addEventListener('click', function(e) {
      if (e.target === this) closeModal(this.id);
    });
  });

  // =========================================================
  // INTERACTIVE KINETIC GRID & CYBER HORIZON ENGINE
  // (Full Kinetic Grid Gravitational Warp + Click Shockwave Ripples + Cyber Rays)
  // =========================================================
  (function initKineticGridEngine() {
    const canvas = document.getElementById('techRaysCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let W = 0, H = 0, horizonY = 0;

    // Kinetic Grid Constants
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

    // Performance Optimization: Offscreen Pre-rendered Dot Matrix
    const dotCanvas = document.createElement('canvas');
    const dotCtx = dotCanvas.getContext('2d');

    function rebuildDotMatrix() {
      dotCanvas.width = W;
      dotCanvas.height = H;
      dotCtx.clearRect(0, 0, W, H);
      dotCtx.fillStyle = 'rgba(0, 240, 255, 0.04)';
      for (let x = DOT_SPACING / 2; x < W; x += DOT_SPACING) {
        for (let y = DOT_SPACING / 2; y < H; y += DOT_SPACING) {
          dotCtx.beginPath();
          dotCtx.arc(x, y, 0.65, 0, Math.PI * 2);
          dotCtx.fill();
        }
      }
    }

    function resize() {
      W = canvas.width = window.innerWidth;
      H = canvas.height = window.innerHeight;
      horizonY = Math.round(H * 0.78);
      rebuildDotMatrix();
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

    window.addEventListener('click', (e) => {
      ripples.push({
        x: e.clientX,
        y: e.clientY,
        radius: 0,
        opacity: 1,
        born: performance.now()
      });
      if (ripples.length > 8) ripples.shift();
    });

    function lerpN(a, b, t) { return a + (b - a) * t; }
    function lerpColor(base, active, t) {
      const r = Math.round(lerpN(base.r, active.r, t));
      const g = Math.round(lerpN(base.g, active.g, t));
      const b = Math.round(lerpN(base.b, active.b, t));
      const a = lerpN(base.a, active.a, t);
      return 'rgba(' + r + ',' + g + ',' + b + ',' + a.toFixed(3) + ')';
    }

    function getWarpedPoint(gx, gy, col, row, m, rips, cols, rows) {
      const edgeMargin = 1.5;
      const colPin = Math.min(col / edgeMargin, (cols - 1 - col) / edgeMargin, 1);
      const rowPin = Math.min(row / edgeMargin, (rows - 1 - row) / edgeMargin, 1);
      const pinFactor = colPin * colPin * rowPin * rowPin;

      const dx = gx - m.x;
      const dy = gy - m.y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      const proximity = Math.max(0, 1 - dist / INFLUENCE_RADIUS) * pinFactor;

      let rx = 0, ry = 0;
      for (let i = 0; i < rips.length; i++) {
        const r = rips[i];
        const rdx = gx - r.x;
        const rdy = gy - r.y;
        const rdist = Math.sqrt(rdx * rdx + rdy * rdy);
        const waveWidth = 55;
        const diff = rdist - r.radius;
        if (Math.abs(diff) < waveWidth) {
          const strength = (1 - Math.abs(diff) / waveWidth) * r.opacity * 18 * pinFactor;
          const angle = Math.atan2(rdy, rdx);
          const sign = diff < 0 ? -1 : 1;
          rx += Math.cos(angle) * strength * sign * -1;
          ry += Math.sin(angle) * strength * sign * -1;
        }
      }

      if (dist < INFLUENCE_RADIUS && dist > 0 && pinFactor > 0) {
        const t = dist / INFLUENCE_RADIUS;
        const eased = t < 0.01 ? 0 : (1 - t) * (1 - t) * Math.min(1, dist / 60);
        const warpAmt = eased * MAX_WARP * pinFactor;
        const angle = Math.atan2(dy, dx);
        return {
          pt: { x: gx - Math.cos(angle) * warpAmt + rx, y: gy - Math.sin(angle) * warpAmt + ry },
          proximity: proximity
        };
      }

      return { pt: { x: gx + rx, y: gy + ry }, proximity: proximity };
    }

    // Rising laser rays & particles
    const RAY_COUNT = 60;
    const rays = [];
    for (let i = 0; i < RAY_COUNT; i++) {
      const isBright = Math.random() < 0.25;
      rays.push({
        xPct: Math.random(),
        maxHeight: isBright ? (0.35 + Math.random() * 0.45) : (0.15 + Math.random() * 0.35),
        width: isBright ? (1.5 + Math.random() * 2.0) : (0.7 + Math.random() * 1.2),
        alphaBase: isBright ? (0.55 + Math.random() * 0.35) : (0.15 + Math.random() * 0.3),
        pulseSpeed: 0.015 + Math.random() * 0.03,
        pulseOffset: Math.random() * Math.PI * 2,
        colorType: Math.random() < 0.65 ? 'cyan' : 'blue'
      });
    }

    const PARTICLE_COUNT = 70;
    const particles = [];
    function createParticle(initial) {
      return {
        x: Math.random() * (W || window.innerWidth),
        y: initial ? Math.random() * (H || window.innerHeight) : (horizonY + Math.random() * 20),
        vx: (Math.random() - 0.5) * 0.35,
        vy: -(0.4 + Math.random() * 1.1),
        size: 0.8 + Math.random() * 1.6,
        alpha: 0.15 + Math.random() * 0.6,
        maxLife: 140 + Math.random() * 160,
        life: initial ? Math.random() * 180 : 0,
        color: Math.random() < 0.7 ? '#00f0ff' : '#38bdf8'
      };
    }
    for (let i = 0; i < PARTICLE_COUNT; i++) particles.push(createParticle(true));

    let time = 0;

    function render(now) {
      time++;
      if (mouse.x === -9999) {
        mouse.x = targetMouse.x;
        mouse.y = targetMouse.y;
      } else {
        mouse.x = lerpN(mouse.x, targetMouse.x, LERP_SPEED);
        mouse.y = lerpN(mouse.y, targetMouse.y, LERP_SPEED);
      }

      ctx.clearRect(0, 0, W, H);

      // Deep Space Base
      const bgGrad = ctx.createLinearGradient(0, 0, 0, H);
      bgGrad.addColorStop(0, '#010308');
      bgGrad.addColorStop(0.65, '#020614');
      bgGrad.addColorStop(horizonY / H, '#030c22');
      bgGrad.addColorStop(1, '#01040a');
      ctx.fillStyle = bgGrad;
      ctx.fillRect(0, 0, W, H);

      // 1. Static Dot Matrix (Pre-rendered single blit optimization)
      if (dotCanvas.width > 0) {
        ctx.drawImage(dotCanvas, 0, 0);
      }

      // 2. Update Shockwave Ripples
      for (let i = ripples.length - 1; i >= 0; i--) {
        const r = ripples[i];
        const age = (now - r.born) / 1000;
        r.radius = Math.max(0, age * 400);
        r.opacity = Math.max(0, 1 - age * 1.2);
        if (r.opacity <= 0) ripples.splice(i, 1);
      }

      // 3. Build Warped Grid
      const cols = Math.max(2, Math.ceil(W / CELL_SIZE)) + 1;
      const rows = Math.max(2, Math.ceil(H / CELL_SIZE)) + 1;
      const cellW = W / (cols - 1);
      const cellH = H / (rows - 1);

      const pts = [];
      const prox = [];

      for (let row = 0; row < rows; row++) {
        pts[row] = [];
        prox[row] = [];
        for (let col = 0; col < cols; col++) {
          const res = getWarpedPoint(col * cellW, row * cellH, col, row, mouse, ripples, cols, rows);
          pts[row][col] = res.pt;
          prox[row][col] = res.proximity;
        }
      }

      // Batched Base Lines (Massive draw call reduction)
      ctx.beginPath();
      ctx.strokeStyle = 'rgba(0, 240, 255, 0.16)';
      ctx.lineWidth = 0.9;
      for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols - 1; col++) {
          if ((prox[row][col] + prox[row][col + 1]) < 0.03) {
            ctx.moveTo(pts[row][col].x, pts[row][col].y);
            ctx.lineTo(pts[row][col + 1].x, pts[row][col + 1].y);
          }
        }
      }
      for (let col = 0; col < cols; col++) {
        for (let row = 0; row < rows - 1; row++) {
          if ((prox[row][col] + prox[row + 1][col]) < 0.03) {
            ctx.moveTo(pts[row][col].x, pts[row][col].y);
            ctx.lineTo(pts[row + 1][col].x, pts[row + 1][col].y);
          }
        }
      }
      ctx.stroke();

      // Active Warped Segments (only drawn where proximity > 0)
      for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols - 1; col++) {
          const avg = (prox[row][col] + prox[row][col + 1]) / 2;
          if (avg >= 0.015) {
            const t = avg * avg * (3 - 2 * avg);
            ctx.beginPath();
            ctx.moveTo(pts[row][col].x, pts[row][col].y);
            ctx.lineTo(pts[row][col + 1].x, pts[row][col + 1].y);
            ctx.strokeStyle = lerpColor(LINE_BASE, LINE_ACTIVE, t);
            ctx.lineWidth = lerpN(0.9, 2.2, t);
            ctx.stroke();
          }
        }
      }
      for (let col = 0; col < cols; col++) {
        for (let row = 0; row < rows - 1; row++) {
          const avg = (prox[row][col] + prox[row + 1][col]) / 2;
          if (avg >= 0.015) {
            const t = avg * avg * (3 - 2 * avg);
            ctx.beginPath();
            ctx.moveTo(pts[row][col].x, pts[row][col].y);
            ctx.lineTo(pts[row + 1][col].x, pts[row + 1][col].y);
            ctx.strokeStyle = lerpColor(LINE_BASE, LINE_ACTIVE, t);
            ctx.lineWidth = lerpN(0.9, 2.2, t);
            ctx.stroke();
          }
        }
      }

      // Draw Intersection Nodes
      for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols; col++) {
          const p = pts[row][col];
          const pr = prox[row][col];
          const t = pr * pr * (3 - 2 * pr);
          const r = lerpN(NODE_BASE_RADIUS, NODE_ACTIVE_RADIUS, t);

          if (t > 0.25) {
            const glowR = r + lerpN(0, 8, (t - 0.25) / 0.75);
            const grd = ctx.createRadialGradient(p.x, p.y, r * 0.5, p.x, p.y, glowR);
            grd.addColorStop(0, 'rgba(0, 240, 255, ' + (t * 0.45).toFixed(3) + ')');
            grd.addColorStop(1, 'rgba(0, 240, 255, 0)');
            ctx.beginPath();
            ctx.arc(p.x, p.y, glowR, 0, Math.PI * 2);
            ctx.fillStyle = grd;
            ctx.fill();
          }

          ctx.beginPath();
          ctx.arc(p.x, p.y, r, 0, Math.PI * 2);
          ctx.fillStyle = lerpColor({ r: 0, g: 240, b: 255, a: 0.28 }, NODE_ACTIVE, t);
          ctx.fill();
        }
      }

      // Draw Ripple Rings
      for (let i = 0; i < ripples.length; i++) {
        const r = ripples[i];
        const safeRadius = Math.max(0, r.radius);
        ctx.beginPath();
        ctx.arc(r.x, r.y, safeRadius, 0, Math.PI * 2);
        ctx.strokeStyle = 'rgba(0, 240, 255, ' + (r.opacity * 0.6).toFixed(3) + ')';
        ctx.lineWidth = 2.2;
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(r.x, r.y, Math.max(0, safeRadius - 16), 0, Math.PI * 2);
        ctx.strokeStyle = 'rgba(56, 189, 248, ' + (r.opacity * 0.35).toFixed(3) + ')';
        ctx.lineWidth = 1.2;
        ctx.stroke();
      }

      // 4. Horizon Laser Pillars & Beams
      for (let i = 0; i < rays.length; i++) {
        const ray = rays[i];
        const x = ray.xPct * W;
        const pulse = Math.sin(time * ray.pulseSpeed + ray.pulseOffset);
        const curAlpha = Math.max(0.08, Math.min(0.85, ray.alphaBase + pulse * 0.2));
        const rayLen = ray.maxHeight * horizonY * (0.85 + pulse * 0.15);
        const topY = horizonY - rayLen;

        const rayGrad = ctx.createLinearGradient(x, horizonY, x, topY);
        rayGrad.addColorStop(0, 'rgba(0, 240, 255, ' + curAlpha + ')');
        rayGrad.addColorStop(0.3, 'rgba(2, 132, 199, ' + (curAlpha * 0.6) + ')');
        rayGrad.addColorStop(1, 'transparent');
        ctx.fillStyle = rayGrad;
        ctx.fillRect(x - ray.width / 2, topY, ray.width, rayLen);
      }

      // 5. Rising Floating Particles
      for (let i = 0; i < particles.length; i++) {
        const p = particles[i];
        p.x += p.vx + Math.sin((time + i * 15) * 0.02) * 0.25;
        p.y += p.vy;
        p.life++;

        const lifeRatio = p.life / p.maxLife;
        let alpha = p.alpha;
        if (lifeRatio > 0.7) alpha *= (1 - (lifeRatio - 0.7) / 0.3);

        if (p.life >= p.maxLife || p.y < 0) {
          particles[i] = createParticle(false);
          continue;
        }

        ctx.fillStyle = p.color;
        ctx.globalAlpha = Math.max(0, Math.min(1, alpha));
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fill();
      }
      ctx.globalAlpha = 1.0;

      requestAnimationFrame(render);
    }

    requestAnimationFrame(render);
  })();

  window.addEventListener('DOMContentLoaded', () => {
    enforceAccountBoundary(currentUsername);
    checkLiveSession();
    syncCloudScores();
    if (isUserLoggedIn) updateAccountLevelUI();
    updateRansomIndicator();

    // Initialize Animated Dithered Plasma Shader for Game Hub Core
    initHubShaderEngine();

    // Initialize Linear Neural Bus Mode & Throttled Spotlight
    const savedBusMode = localStorage.getItem('hub_library_mode') || 'neural';
    setLibraryMode(savedBusMode);

    const busContainer = document.getElementById('neuralBusContainer');
    if (busContainer) {
      let busRaf = null;
      busContainer.addEventListener('mousemove', (e) => {
        if (busRaf) return;
        busRaf = requestAnimationFrame(() => {
          const rect = busContainer.getBoundingClientRect();
          const x = Math.round(e.clientX - rect.left);
          const y = Math.round(e.clientY - rect.top);
          busContainer.style.setProperty('--bus-mx', x + 'px');
          busContainer.style.setProperty('--bus-my', y + 'px');
          busRaf = null;
        });
      });
    }

    const briefingCard = document.getElementById('neuralBriefingCard');
    if (briefingCard) {
      briefingCard.addEventListener('mouseenter', () => {
        if (briefingHideTimer) {
          clearTimeout(briefingHideTimer);
          briefingHideTimer = null;
        }
      });
      briefingCard.addEventListener('mouseleave', () => {
        if (activeNeuralGameKey) {
          hideNeuralBriefing(activeNeuralGameKey);
        }
      });
    }

    // Dismiss briefing when clicking outside of nodes and briefing card
    document.addEventListener('click', (e) => {
      const card = document.getElementById('neuralBriefingCard');
      if (!card || !card.classList.contains('active')) return;
      if (e.target.closest('#neuralBriefingCard') || e.target.closest('.neural-node')) return;
      hideNeuralBriefing(null, true);
    });

    // Tactile Click Shockwave for Game Cards
    document.querySelectorAll('.game-card').forEach(card => {
      card.addEventListener('click', (e) => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const rip = document.createElement('span');
        rip.className = 'card-click-ripple';
        rip.style.left = x + 'px';
        rip.style.top = y + 'px';
        card.appendChild(rip);
        setTimeout(() => rip.remove(), 600);
      });
    });
  });
</script>
</body>
</html>