<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%
    String currentUser = null;
    if (session != null) {
        currentUser = (String) session.getAttribute("user_session");
        if (currentUser == null || currentUser.trim().isEmpty()) {
            currentUser = (String) session.getAttribute("user");
        }
    }
    boolean isGuest = (session != null && session.getAttribute("isGuest") != null && (Boolean) session.getAttribute("isGuest"));
    boolean isLoggedIn = (currentUser != null && !currentUser.trim().isEmpty());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Defusal Protocol // Tactical Crisis Sim</title>
    <!-- Link to the separated CSS file -->
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="../css/ransom_horror.css">
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
            max-width: 480px;
            margin: auto;
            border-radius: 16px;
            border: 1px solid rgba(56, 189, 248, 0.3);
            max-height: 85vh;
            max-height: 85dvh;
            color: #fff;
            box-sizing: border-box;
        }
        .intel-modal.active { display: flex; }
        .intel-title {
            font-size: 1.15rem;
            color: var(--neon-blue);
            font-weight: 900;
            margin-bottom: 0.8rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .intel-row {
            margin-bottom: 0.75rem;
            font-size: 0.8rem;
            line-height: 1.45;
            color: var(--text-muted);
            background: rgba(255, 255, 255, 0.03);
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid rgba(255, 255, 255, 0.06);
        }
        .intel-row strong {
            color: #fff;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 3px;
            font-size: 0.85rem;
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
            <div style="display:inline-block; background:rgba(244,63,94,0.15); border:1px solid rgba(244,63,94,0.4); color:#f43f5e; font-size:0.68rem; padding:2px 8px; border-radius:4px; font-weight:bold; margin-bottom: 10px; letter-spacing:1px;">CRISIS SIM // MULTI-MODULE</div>
            <p style="color: var(--text-muted); font-size: 0.82rem; line-height: 1.45; margin-bottom: 14px;">
                High-stakes tactical bomb defusal game. Disarm diverse security modules (Snake, Reactor, Maze, Banana Wires, Frequency Tuner) under a 3-minute clock.
            </p>
            <div style="display:flex; justify-content:space-around; background:rgba(0,0,0,0.5); padding:8px 12px; border-radius:10px; border:1px solid rgba(255,255,255,0.08); margin-bottom:14px; font-size:0.8rem;">
                <div>Record Score<span id="splashDefuseScore" style="display:block; font-size:1.05rem; color:var(--neon-blue); font-weight:bold;">0 pts</span></div>
                <div>Disarms<span id="splashDefuseDisarms" style="display:block; font-size:1.05rem; color:var(--neon-green); font-weight:bold;">0</span></div>
            </div>
            <div style="display:flex; flex-direction:column; gap:8px; width:100%;">
                <button class="level-btn" style="background:var(--neon-blue); color:#000; font-weight:bold; border:none; min-height:44px;" onclick="openLevelSelect()">▶ PLAY NOW</button>
                <div style="display:flex; gap:8px; width:100%;">
                    <button class="level-btn" style="flex:1; min-height:44px; padding:8px 6px; font-size:0.85rem;" onclick="openDefuseIntel()">📖 HOW TO PLAY</button>
                    <button class="btn-abort" style="flex:1; min-height:44px; padding:8px 6px; font-size:0.85rem;" onclick="cyberNavigate('../index.jsp')">‹ EXIT TO HUB</button>
                </div>
            </div>
        </div>
    </div>

    <!-- INTEL & CONTROLS MODAL -->
    <div id="defuseIntelModal" class="intel-modal">
        <div class="intel-title">
            <span>HOW TO PLAY & MODULE GUIDE</span>
            <button class="btn-abort" style="padding: 4px 10px;" onclick="closeDefuseIntel()">✕ Close</button>
        </div>

        <div class="intel-row">
            <strong>⏱ 3-MINUTE DETONATION CLOCK</strong>
            You have precisely 180 seconds to solve and bypass all active modules installed inside the briefcase chassis.
        </div>

        <div class="intel-row">
            <strong>🛡 3 CONTAINMENT CHARGES (STRIKES)</strong>
            You possess 3 integrity charges. Dying in Snake, mis-clicking a Reactor sequence, cutting the wrong Banana wire, or failing a module burns 1 charge. 3 strikes trigger immediate detonation!
        </div>

        <div class="intel-row">
            <strong>🐍 DATA SERPENT (SNAKE MODULE)</strong>
            Pilot the snake to absorb energy bytes. Reach the target score (Easy: 10 pts, Med: 15 pts, Hard: 20 pts) to bypass the module. Crashing costs 1 charge!
        </div>

        <div class="intel-row">
            <strong>☢️ REACTOR STABILIZATION MATRIX</strong>
            High-intensity memory sequence. Starts directly at 3 glowing tiles (Easy), 4 tiles (Med), or 5 tiles (Hard). Replicate the pattern in sequence to disarm!
        </div>

        <div class="intel-row">
            <strong>⚡ FIREWALL MAZE ROUTING</strong>
            Guide the player node through the maze to the glowing green exit. Guaranteed solvable path with multiple routes!
        </div>

        <div class="intel-row">
            <strong>🍌 BANANA WIRE MATRIX (BOMBANANA SYSTEM)</strong>
            Inspect physical colored wire bundles. Open the Rule Slider anytime to consult the 4 rules and cut the target wire. Wrong cut burns 1 charge!
        </div>

        <div class="intel-row">
            <strong>📡 FREQUENCY OSCILLOSCOPE TUNER</strong>
            Interactive slider & direct canvas dragging! Modulate Frequency and Phase until resonance locks!
        </div>

        <button class="level-btn" style="background:var(--neon-blue); color:#000; font-weight:bold; border:none; margin-top: auto;" onclick="closeDefuseIntel(); openLevelSelect();">
            ▶ SELECT LEVEL
        </button>
    </div>

    <!-- MAIN MENU (LEVEL SELECT) -->
    <div id="screen-menu" class="screen">
        <div class="menu-container">
            <h1 class="menu-title">SELECT LEVEL</h1>
            <p style="color: var(--text-muted); letter-spacing: 2px;">CHOOSE YOUR DIFFICULTY LEVEL</p>
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
                <button class="btn-abort" onclick="abortToMenu()">✕ EXIT</button>
                <div class="timer-container">
                    <div class="timer-label">DETONATION IN</div>
                    <div class="timer" id="timerDisplay">03:00:00</div>
                </div>
                <div class="strikes-container">
                    <div class="strikes-label">CHARGES REMAINING</div>
                    <div class="led-group">
                        <div class="led active" id="strike1"></div>
                        <div class="led active" id="strike2"></div>
                        <div class="led active" id="strike3"></div>
                    </div>
                </div>
            </div>

            <div class="grid-container" id="moduleGrid">
                <!-- Modules injected by JS -->
            </div>

            <!-- INTERACTIVE TACTICAL DEFUSAL WORKSTATION -->
            <div class="minigame-overlay" id="miniGameOverlay">
                <div class="minigame-box" id="minigameBox">
                    <!-- Workstation Header -->
                    <div class="mg-header">
                        <div class="mg-header-left">
                            <span class="mg-icon" id="mgIcon">⚡</span>
                            <div>
                                <div class="mg-title" id="mgTitle">MODULE OVERRIDE</div>
                                <div class="mg-sub" id="mgSub">SYSTEM CLEARANCE LEVEL</div>
                            </div>
                        </div>
                        <div class="mg-header-right">
                            <span class="mg-diff-badge" id="mgDiffBadge">EASY</span>
                            <div class="mg-charges-box" title="Containment Charges">
                                <span class="mg-charges-label">CHARGES</span>
                                <div class="mg-charge-pips" id="mgChargePips">
                                    <div class="charge-pip active" id="chPip1"></div>
                                    <div class="charge-pip active" id="chPip2"></div>
                                    <div class="charge-pip active" id="chPip3"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Mission Objective Bar -->
                    <div class="mg-objective-bar">
                        <span class="mg-obj-label">OBJECTIVE:</span>
                        <span class="mg-obj-text" id="mgDesc">Execute sequence to bypass security.</span>
                    </div>

                    <!-- Workstation Viewport Area -->
                    <div class="mg-stage-viewport">
                        <!-- Shockwave / Hazard Flash overlay inside workstation -->
                        <div class="mg-shockwave" id="mgShockwave"></div>

                        <!-- 1. SNAKE CONTAINER -->
                        <div class="mg-game-container" id="mgSnakeContainer" style="display: none;">
                            <div class="snake-hud">
                                <span class="hud-tag">TARGET BYTES:</span>
                                <span class="hud-score" id="snakeScoreDisplay">0 / 10 pts</span>
                            </div>
                            <div class="snake-canvas-wrap">
                                <canvas id="snakeCanvas" width="280" height="280"></canvas>
                            </div>
                            <!-- Mini Touch D-Pad for Mobile -->
                            <div class="mg-dpad">
                                <button class="mg-d-btn d-up" onclick="snakeInput('UP')">▲</button>
                                <button class="mg-d-btn d-left" onclick="snakeInput('LEFT')">◀</button>
                                <button class="mg-d-btn d-down" onclick="snakeInput('DOWN')">▼</button>
                                <button class="mg-d-btn d-right" onclick="snakeInput('RIGHT')">▶</button>
                            </div>
                        </div>

                        <!-- 2. REACTOR CONTAINER -->
                        <div class="mg-game-container" id="mgReactorContainer" style="display: none;">
                            <div class="reactor-hud">
                                <span class="hud-tag" id="reactorStatusText">BROADCASTING SEQUENCE</span>
                                <span class="hud-score" id="reactorStepDisplay">0 / 3</span>
                            </div>
                            <div class="reactor-keypad-grid" id="reactorKeypad">
                                <!-- 9 tiles generated dynamically -->
                            </div>
                        </div>

                        <!-- 3. MAZE CONTAINER -->
                        <div class="mg-game-container" id="mgMazeContainer" style="display: none;">
                            <div class="maze-hud">
                                <span class="hud-score" id="mazeStatusText" style="color: var(--neon-blue); font-size: 0.85rem; letter-spacing: 0.5px;">NAVIGATE TO GREEN EXIT</span>
                            </div>
                            <div class="maze-canvas-wrap">
                                <canvas id="mazeCanvas" width="280" height="280"></canvas>
                            </div>
                            <div class="mg-dpad">
                                <button class="mg-d-btn d-up" onclick="mazeInput(0, -1)">▲</button>
                                <button class="mg-d-btn d-left" onclick="mazeInput(-1, 0)">◀</button>
                                <button class="mg-d-btn d-down" onclick="mazeInput(0, 1)">▼</button>
                                <button class="mg-d-btn d-right" onclick="mazeInput(1, 0)">▶</button>
                            </div>
                        </div>

                        <!-- 4. BANANA WIRES CONTAINER (BOMBANANA INSPIRED) -->
                        <div class="mg-game-container" id="mgWiresContainer" style="display: none;">
                            <!-- Slide-out Rule Slider Toggle Bar -->
                            <div class="wires-top-bar">
                                <button class="rule-slider-toggle-btn" id="ruleSliderToggleBtn" onclick="toggleRuleDrawer()">
                                    📖 VIEW RULES MANUAL [4 RULES] ❯
                                </button>
                            </div>

                            <!-- Physical Wire Bundle -->
                            <div class="wires-board" id="wiresBoard">
                                <!-- Dynamic wires injected by JS -->
                            </div>
                            <div class="wires-hint">⚠️ CLICK / TAP WIRE TO CUT • WRONG CUT BURNS 1 CHARGE</div>

                            <!-- SLIDE-OUT RULE DRAWER / SLIDER -->
                            <div class="wires-rule-drawer" id="wiresRuleDrawer">
                                <div class="drawer-header">
                                    <span class="drawer-title">🍌 BOMBANANA MANUAL</span>
                                    <button class="drawer-close-btn" onclick="toggleRuleDrawer(false)">✕ CLOSE</button>
                                </div>
                                <div class="drawer-body">
                                    <div class="manual-rule-card" id="mRule1">
                                        <div class="rule-badge">RULE 1</div>
                                        <div class="rule-text">If <strong>0 Hazard Ruby</strong> wires <span class="badge-dot ruby"></span> exist → Cut the <strong>2nd wire</strong>.</div>
                                    </div>
                                    <div class="manual-rule-card" id="mRule2">
                                        <div class="rule-badge">RULE 2</div>
                                        <div class="rule-text">If the <strong>last wire is Radioactive Lime</strong> <span class="badge-dot lime"></span> → Cut the <strong>last wire</strong>.</div>
                                    </div>
                                    <div class="manual-rule-card" id="mRule3">
                                        <div class="rule-badge">RULE 3</div>
                                        <div class="rule-text">If <strong>≥ 2 Carbon Purple</strong> wires <span class="badge-dot purple"></span> → Cut the <strong>last Purple wire</strong>.</div>
                                    </div>
                                    <div class="manual-rule-card" id="mRule4">
                                        <div class="rule-badge">RULE 4</div>
                                        <div class="rule-text"><strong>Otherwise</strong> → Cut the <strong>1st Banana Gold</strong> wire <span class="badge-dot gold"></span> (or wire #1 if none).</div>
                                    </div>
                                </div>
                                <div class="drawer-status" id="drawerStatusHint">
                                    ⚠️ CAREFULLY CONSULT RULES 1–4 IN SEQUENCE • CUT THE TARGET WIRE
                                </div>
                            </div>
                        </div>

                        <!-- 5. FREQUENCY TUNER CONTAINER -->
                        <div class="mg-game-container" id="mgFreqContainer" style="display: none;">
                            <div class="freq-screen-wrap">
                                <canvas id="freqCanvas" width="320" height="130"></canvas>
                                <div class="freq-canvas-hint">↔ DRAG CANVAS TO SCRUB FREQUENCY & PHASE ↕</div>
                                <div class="freq-meter-wrap">
                                    <div class="freq-meter-label"><span>RESONANCE MATCH:</span><span id="freqMatchPercent">0%</span></div>
                                    <div class="freq-meter-bar"><div class="freq-meter-fill" id="freqMeterFill"></div></div>
                                </div>
                            </div>
                            <div class="freq-controls">
                                <div class="freq-slider-group">
                                    <label><span>CARRIER FREQUENCY</span><span id="freqValText" class="val-pill">1.0x</span></label>
                                    <div class="interactive-slider-row">
                                        <button class="step-btn" onclick="adjustFreq(-0.2)" title="Fine decrease">◀ -</button>
                                        <input type="range" id="freqSlider" min="1" max="8" step="0.1" value="1" oninput="updateFreqSlider()">
                                        <button class="step-btn" onclick="adjustFreq(0.2)" title="Fine increase">+ ▶</button>
                                    </div>
                                </div>
                                <div class="freq-slider-group">
                                    <label><span>PHASE ALIGNMENT</span><span id="phaseValText" class="val-pill">0°</span></label>
                                    <div class="interactive-slider-row">
                                        <button class="step-btn" onclick="adjustPhase(-10)" title="Phase shift left">◀ -</button>
                                        <input type="range" id="phaseSlider" min="0" max="360" step="5" value="0" oninput="updatePhaseSlider()">
                                        <button class="step-btn" onclick="adjustPhase(10)" title="Phase shift right">+ ▶</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Workstation Footer Controls -->
                    <div class="mg-footer" style="display: flex; gap: 10px; margin-top: 4px;">
                        <button class="btn-abort" style="flex: 1; padding: 10px; min-height: 44px;" onclick="closeMiniGame(false)">‹ BACK TO BRIEFCASE</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- GAME OVER / SUCCESS SCREENS -->
    <div id="screen-result" class="screen">
        <div class="ending-box" id="resultBox">
            <h1 id="resultTitle" style="font-size: 3.5rem; margin: 0;"></h1>
            <p id="resultSub" style="margin: 15px 0 25px 0; font-size: 1.1rem; line-height: 1.5;"></p>
            <button class="btn-abort" style="margin-top: 10px; min-height: 44px; padding: 12px 24px;" onclick="abortToMenu()">RETURN TO LEVELS</button>
        </div>
    </div>

    <!-- Link to the separated JavaScript file -->
    <script src="js/engine.js"></script>
    <script>
      function cyberNavigate(url) {
        const overlay = document.getElementById('cyberWipeOverlay');
        document.body.style.transform = 'scale(0.975)';
        document.body.style.filter = 'blur(4px)';
        document.body.style.opacity = '0.6';
        document.body.style.transition = 'all 0.22s cubic-bezier(0.16, 1, 0.3, 1)';

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
        document.body.style.transform = '';
        document.body.style.filter = '';
        document.body.style.opacity = '';
      });
    </script>
    <script src="../js/ransom_horror.js"></script>
</body>
</html>
