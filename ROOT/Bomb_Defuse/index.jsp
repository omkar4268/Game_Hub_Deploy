<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Defusal Protocol // Bomb Simulator</title>
    <!-- Link to the separated CSS file -->
    <link rel="stylesheet" href="css/style.css">
    <style>
        .intel-modal {
            position: fixed;
            inset: 0;
            background: rgba(3, 7, 18, 0.96);
            backdrop-filter: blur(14px);
            display: none;
            flex-direction: column;
            padding: 1.6rem;
            z-index: 1050;
            text-align: left;
            overflow-y: auto;
            max-width: 440px;
            margin: auto;
            border-radius: 16px;
            border: 1px solid rgba(56, 189, 248, 0.3);
            max-height: 80vh;
            color: #fff;
            box-sizing: border-box;
        }
        .intel-modal.active { display: flex; }
        .intel-title {
            font-size: 1.15rem;
            color: var(--neon-blue);
            font-weight: 800;
            margin-bottom: 0.8rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .intel-row {
            margin-bottom: 0.8rem;
            font-size: 0.85rem;
            line-height: 1.5;
            color: var(--text-muted);
        }
        .intel-row strong {
            color: #fff;
            display: block;
            margin-bottom: 3px;
        }
    </style>
</head>
<body>
    <!-- Universal Cyber-Scanner Wipe Transition -->
    <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
        <div class="cyber-wipe-beam"></div>
    </div>

    <!-- STANDARDIZED PRE-GAME STARTUP SCREEN -->
    <div id="screen-startup" class="screen active">
        <div class="menu-container" style="max-width: 440px; padding: 22px 18px;">
            <div style="font-size: 2.4rem; margin-bottom: 4px;">☢️</div>
            <h1 class="menu-title" style="font-size: 1.6rem; margin-bottom: 4px;">DEFUSAL PROTOCOL</h1>
            <div style="display:inline-block; background:rgba(244,63,94,0.15); border:1px solid rgba(244,63,94,0.4); color:#f43f5e; font-size:0.68rem; padding:2px 8px; border-radius:4px; font-weight:bold; margin-bottom: 10px; letter-spacing:1px;">CRISIS SIM v2.5</div>
            <p style="color: var(--text-muted); font-size: 0.82rem; line-height: 1.45; margin-bottom: 14px;">
                High-stakes 3-minute bomb defusal simulation. Complete override sequences across security modules before detonation occurs.
            </p>
            <div style="display:flex; justify-content:space-around; background:rgba(0,0,0,0.5); padding:8px 12px; border-radius:10px; border:1px solid rgba(255,255,255,0.08); margin-bottom:14px; font-size:0.8rem;">
                <div>Record Score<span id="splashDefuseScore" style="display:block; font-size:1.05rem; color:var(--neon-blue); font-weight:bold;">0 pts</span></div>
                <div>Disarms<span id="splashDefuseDisarms" style="display:block; font-size:1.05rem; color:var(--neon-green); font-weight:bold;">0</span></div>
            </div>
            <div style="display:flex; flex-direction:column; gap:8px; width:100%;">
                <button class="level-btn" style="background:var(--neon-blue); color:#000; font-weight:bold; border:none; min-height:44px;" onclick="openLevelSelect()">▶ INITIATE RUN</button>
                <div style="display:flex; gap:8px; width:100%;">
                    <button class="level-btn" style="flex:1; min-height:44px; padding:8px 6px; font-size:0.85rem;" onclick="openDefuseIntel()">⚙ PROTOCOL</button>
                    <button class="btn-abort" style="flex:1; min-height:44px; padding:8px 6px; font-size:0.85rem;" onclick="cyberNavigate('../index.jsp')">‹ HUB</button>
                </div>
            </div>
        </div>
    </div>

    <!-- INTEL & CONTROLS MODAL -->
    <div id="defuseIntelModal" class="intel-modal">
        <div class="intel-title">
            <span>TACTICAL DIRECTIVE</span>
            <button class="btn-abort" style="padding: 4px 10px;" onclick="closeDefuseIntel()">✕ Close</button>
        </div>

        <div class="intel-row">
            <strong>⏱ DETONATION CLOCK</strong>
            You have precisely 3 minutes (180s) to disarm all active modules in the briefcase chassis.
        </div>

        <div class="intel-row">
            <strong>⚠️ SYSTEM INTEGRITY & STRIKES</strong>
            Clicking modules triggers interactive override sequences. 3 system strikes will initiate immediate detonation!
        </div>

        <div class="intel-row">
            <strong>🎯 SCORING & RECORDS</strong>
            Score formula: [Level Cleared × 100] + Remaining Seconds. Scores and total successful disarms synchronize with your Cyber Hub records.
        </div>

        <button class="level-btn" style="background:var(--neon-blue); color:#000; font-weight:bold; border:none; margin-top: auto;" onclick="closeDefuseIntel(); openLevelSelect();">
            ▶ SELECT SECURITY TIER
        </button>
    </div>

    <!-- MAIN MENU (LEVEL SELECT) -->
    <div id="screen-menu" class="screen">
        <div class="menu-container">
            <h1 class="menu-title">SECURITY TIERS</h1>
            <p style="color: var(--text-muted); letter-spacing: 2px;">SELECT SECURITY CLEARANCE LEVEL</p>
            <div class="level-grid" id="levelGrid">
                <!-- Generated by JS -->
            </div>
            <div style="margin-top: 30px; display: flex; justify-content: center; gap: 15px;">
                <button class="level-btn" onclick="showStartupScreen()">‹ BACK</button>
                <button class="btn-abort" onclick="cyberNavigate('../index.jsp')">EXIT TO HUB</button>
            </div>
        </div>
    </div>

    <!-- GAMEPLAY CHASSIS -->
    <div id="screen-game" class="screen">
        <div class="briefcase">
            <div class="header">
                <button class="btn-abort" onclick="abortToMenu()">&#9888; ABORT</button>
                <div class="timer-container">
                    <div class="timer-label">DETONATION IN</div>
                    <div class="timer" id="timerDisplay">03:00:00</div>
                </div>
                <div class="strikes-container">
                    <div class="strikes-label">SYSTEM INTEGRITY</div>
                    <div class="led-group">
                        <div class="led" id="strike1"></div>
                        <div class="led" id="strike2"></div>
                        <div class="led" id="strike3"></div>
                    </div>
                </div>
            </div>

            <div class="grid-container" id="moduleGrid">
                <!-- Modules injected by JS -->
            </div>

            <!-- Mini Game Interaction Overlay -->
            <div class="minigame-overlay" id="miniGameOverlay">
                <div class="minigame-box">
                    <h2 id="mgTitle" style="color: var(--neon-blue);">MODULE OVERRIDE</h2>
                    <p id="mgDesc">Execute sequence to bypass security.</p>
                    <div style="font-size: 2rem; margin: 20px 0;" id="mgTarget">0 / 3</div>
                    <button class="hack-btn" id="hackBtn">EXECUTE OVERRIDE</button>
                    <br><br>
                    <button class="btn-abort" onclick="closeMiniGame(false)" style="margin-top: 10px;">CANCEL</button>
                </div>
            </div>
        </div>
    </div>

    <!-- GAME OVER / SUCCESS SCREENS -->
    <div id="screen-result" class="screen">
        <div class="ending-box" id="resultBox">
            <h1 id="resultTitle" style="font-size: 4rem; margin: 0;"></h1>
            <p id="resultSub"></p>
            <button class="btn-abort" style="margin-top: 20px;" onclick="abortToMenu()">RETURN TO MENU</button>
        </div>
    </div>

    <!-- Link to the separated JavaScript file -->
    <script src="js/engine.js"></script>
    <script>
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