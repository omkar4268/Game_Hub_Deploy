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

    <!-- Framer Motion Browser Engine -->
    <script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

    <!-- Link to the separated CSS file -->
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>
    <!-- Dedicated Fullscreen Tactical Hazard Radar Canvas -->
    <canvas id="defuseBgCanvas" class="defuse-bg-canvas"></canvas>

    <!-- Universal Cyber-Scanner Wipe Transition -->
    <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
        <div class="cyber-wipe-beam"></div>
    </div>

    <!-- STANDARDIZED PRE-GAME STARTUP SCREEN (Obsidian Space Glass) -->
    <div id="screen-startup" class="screen active">
        <div class="menu-container startup-box" style="max-width: 460px; padding: 26px 22px;">
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

            <div class="overlay-icon">
                <svg class="hazard-trefoil-svg" viewBox="0 0 64 64" fill="none">
                    <circle cx="32" cy="32" r="7" fill="url(#hazardGrad)" />
                    <circle cx="32" cy="32" r="3.5" fill="#ffffff" />
                    <path d="M32 7 C25 7 19 12 19 19 C19 23 22 27 26 29 C28 26 30 25 32 25 C34 25 36 26 38 29 C42 27 45 23 45 19 C45 12 39 7 32 7 Z" fill="url(#hazardGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5" />
                    <path d="M10 45 C6 38 9 30 16 26 C19 24 24 25 28 28 C26 31 25 33 25 35 C25 38 26 40 29 43 C26 46 22 48 17 48 C14 48 12 47 10 45 Z" fill="url(#hazardGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5" />
                    <path d="M54 45 C56 38 53 30 46 26 C43 24 38 25 34 28 C36 31 37 33 37 35 C37 38 36 40 33 43 C36 46 40 48 45 48 C48 48 50 47 54 45 Z" fill="url(#hazardGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5" />
                    <defs>
                        <linearGradient id="hazardGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="#ffffff"/>
                            <stop offset="50%" stop-color="#f43f5e"/>
                            <stop offset="100%" stop-color="#9f1239"/>
                        </linearGradient>
                    </defs>
                </svg>
            </div>

            <h1 class="menu-title">DEFUSAL <span class="hollow-text">PROTOCOL</span></h1>
            <div class="hazard-badge">CRISIS SIM // MULTI-MODULE v3.1</div>
            
            <p class="startup-desc">
                High-stakes tactical bomb defusal simulation. Disarm diverse security modules (Snake, Reactor, Maze, Banana Wires, Frequency Tuner) before the 3-minute detonation clock runs out.
            </p>

            <div class="startup-stats">
                <div class="stat-col">
                    <span class="stat-label">RECORD SCORE</span>
                    <span class="stat-val" id="splashDefuseScore">0 pts</span>
                </div>
                <div class="stat-col">
                    <span class="stat-label">DISARMS</span>
                    <span class="stat-val" id="splashDefuseDisarms" style="color:var(--neon-green)">0</span>
                </div>
            </div>

            <div class="menu-actions">
                <button class="btn-cyber btn-cyber-primary" onclick="openLevelSelect()">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                    <span>ENGAGE PROTOCOL</span>
                </button>
                <div class="menu-actions-row">
                    <button class="btn-cyber btn-cyber-secondary" onclick="openDefuseIntel()">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                        <span>PROTOCOLS</span>
                    </button>
                    <button class="btn-cyber btn-cyber-secondary" onclick="cyberNavigate('../index.jsp')">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        <span>HUB</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- INTEL & CONTROLS MODAL (Obsidian Space Glass) -->
    <div id="defuseIntelModal" class="intel-modal">
        <div class="intel-title">
            <div style="display:flex; align-items:center; gap:8px;">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#38bdf8" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
                <span>HOW TO PLAY & MODULE GUIDE</span>
            </div>
            <button class="btn-icon-close" onclick="closeDefuseIntel()">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#f43f5e" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                3-MINUTE DETONATION CLOCK
            </strong>
            You have precisely 180 seconds to solve and bypass all active modules installed inside the briefcase chassis.
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                3 CONTAINMENT CHARGES (STRIKES)
            </strong>
            You possess 3 integrity charges. Dying in Snake, mis-clicking a Reactor sequence, cutting the wrong Banana wire, or failing a module burns 1 charge. 3 strikes trigger immediate detonation!
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#22c55e" stroke-width="2"><path d="M12 2a10 10 0 1 0 10 10"/></svg>
                DATA SERPENT (SNAKE MODULE)
            </strong>
            Pilot the snake to absorb energy bytes. Reach the target score (Easy: 10 pts, Med: 15 pts, Hard: 20 pts) to bypass the module. Crashing costs 1 charge!
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#facc15" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M12 2a10 10 0 0 0-8.66 5l3.46 2A6 6 0 0 1 12 6V2z"/></svg>
                REACTOR STABILIZATION MATRIX
            </strong>
            High-intensity memory sequence. Starts directly at 3 glowing tiles (Easy), 4 tiles (Med), or 5 tiles (Hard). Replicate the pattern in sequence to disarm!
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
                FIREWALL MAZE ROUTING
            </strong>
            Guide the player node through the maze to the glowing green exit. Guaranteed solvable path with multiple routes!
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#fbbf24" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>
                BANANA WIRE MATRIX (BOMBANANA)
            </strong>
            Inspect physical colored wire bundles. Open the Rule Slider anytime to consult the 4 rules and cut the target wire. Wrong cut burns 1 charge!
        </div>

        <div class="intel-row">
            <strong>
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><circle cx="12" cy="12" r="2"/><path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"/></svg>
                FREQUENCY OSCILLOSCOPE TUNER
            </strong>
            Interactive slider & direct canvas dragging! Modulate Frequency and Phase until resonance locks!
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: 1rem; width: 100%;" onclick="closeDefuseIntel(); openLevelSelect();">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
            <span>SELECT LEVEL</span>
        </button>
    </div>

    <!-- MAIN MENU (LEVEL SELECT) -->
    <div id="screen-menu" class="screen">
        <div class="menu-container" style="max-width: 820px; position:relative;">
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

            <h1 class="menu-title">SELECT <span class="hollow-text">SECTOR</span></h1>
            <p style="color: var(--text-muted); letter-spacing: 2px; font-size: 0.82rem; margin-top: 4px;">CHOOSE YOUR THREAT LEVEL</p>
            
            <div class="level-grid" id="levelGrid">
                <!-- Generated by JS -->
            </div>
            
            <div style="margin-top: 25px; display: flex; justify-content: center; gap: 12px;">
                <button class="btn-cyber btn-cyber-secondary" onclick="showStartupScreen()">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    <span>BACK</span>
                </button>
                <button class="btn-cyber btn-cyber-secondary" onclick="cyberNavigate('../index.jsp')">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                    <span>EXIT TO HUB</span>
                </button>
            </div>
        </div>
    </div>

    <!-- GAMEPLAY CHASSIS (Obsidian Space Glass Briefcase) -->
    <div id="screen-game" class="screen">
        <div class="briefcase">
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

            <div class="header">
                <button class="btn-abort" onclick="abortToMenu()">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                    <span>EXIT</span>
                </button>
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

                    <!-- Workstation Header -->
                    <div class="mg-header">
                        <div class="mg-header-left">
                            <span class="mg-icon" id="mgIcon">
                                <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="#38bdf8" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
                            </span>
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
                            <div class="wires-top-bar">
                                <button class="rule-slider-toggle-btn" id="ruleSliderToggleBtn" onclick="toggleRuleDrawer()">
                                    <span>VIEW RULES MANUAL [4 RULES]</span>
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"/></svg>
                                </button>
                            </div>

                            <div class="wires-board" id="wiresBoard">
                                <!-- Dynamic wires injected by JS -->
                            </div>
                            <div class="wires-hint">CLICK / TAP WIRE TO CUT • WRONG CUT BURNS 1 CHARGE</div>

                            <!-- SLIDE-OUT RULE DRAWER / SLIDER -->
                            <div class="wires-rule-drawer" id="wiresRuleDrawer">
                                <div class="drawer-header">
                                    <span class="drawer-title">BANANA WIRE PROTOCOL MANUAL</span>
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
                                    CAREFULLY CONSULT RULES 1–4 IN SEQUENCE • CUT THE TARGET WIRE
                                </div>
                            </div>
                        </div>

                        <!-- 5. FREQUENCY TUNER CONTAINER -->
                        <div class="mg-game-container" id="mgFreqContainer" style="display: none;">
                            <div class="freq-screen-wrap">
                                <canvas id="freqCanvas" width="320" height="130"></canvas>
                                <div class="freq-canvas-hint">DRAG CANVAS TO SCRUB FREQUENCY & PHASE</div>
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
                    <div class="mg-footer" style="display: flex; gap: 10px; margin-top: 6px;">
                        <button class="btn-cyber btn-cyber-secondary" style="flex: 1; padding: 10px;" onclick="closeMiniGame(false)">
                            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                            <span>BACK TO BRIEFCASE</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- GAME OVER / SUCCESS SCREENS (Obsidian Space Glass) -->
    <div id="screen-result" class="screen">
        <div class="ending-box" id="resultBox">
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

            <h1 id="resultTitle" style="font-size: clamp(2rem, 5vh, 3.2rem); margin: 0; font-weight: 900;"></h1>
            <p id="resultSub" style="margin: 15px 0 25px 0; font-size: 1rem; line-height: 1.5; color: var(--text-muted);"></p>
            <button class="btn-cyber btn-cyber-primary" style="min-height: 44px; padding: 12px 24px;" onclick="abortToMenu()">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                <span>RETURN TO SECTORS</span>
            </button>
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
