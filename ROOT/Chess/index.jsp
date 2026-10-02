<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Cyber Chess // AI Stockfish Grandmaster</title>
    
    <!-- Framer Motion Browser Engine -->
    <script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/@chrisoakman/chessboardjs@1.0.0/dist/chessboard-1.0.0.min.css">
    <script src="https://unpkg.com/@chrisoakman/chessboardjs@1.0.0/dist/chessboard-1.0.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chess.js/0.10.3/chess.min.js"></script>

    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>
    <!-- Dedicated Fullscreen 3D Tactical Perspective Grid Canvas -->
    <canvas id="chessBgCanvas" class="chess-bg-canvas"></canvas>

    <!-- Universal Cyber-Scanner Wipe Transition -->
    <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
        <div class="cyber-wipe-beam"></div>
    </div>

    <header class="navbar">
        <div class="navbar-left">
            <div class="chess-logo-wrap">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none">
                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
                    <circle cx="12" cy="7" r="4" stroke="#38bdf8" stroke-width="2"/>
                    <path d="M12 2v2M8 4l1 2M16 4l-1 2" stroke="#38bdf8" stroke-width="2" stroke-linecap="round"/>
                </svg>
            </div>
            <h1 class="title">CYBER <span class="hollow-text">CHESS</span></h1>
            <span class="header-badge">AI v3.0</span>
        </div>
        <div class="navbar-right">
            <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-hub">
                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                <span>Hub</span>
            </a>
            <button class="menu-toggle" id="menuToggle" aria-label="Toggle Controls">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
        </div>
    </header>

    <!-- Standardized Pre-Game Interactive Startup Screen (Obsidian Space Glass) -->
    <div id="chessStartupModal" class="chess-overlay-screen">
        <div class="overlay-badge">
            <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
            <span>NEURAL GRANDMASTER ENGINE</span>
        </div>

        <div class="overlay-icon">
            <svg class="chess-knight-svg" viewBox="0 0 64 64" fill="none">
                <path d="M38 10 C32 8 26 12 24 18 C22 17 18 19 17 23 C16 26 18 29 20 30 C16 35 15 42 16 50 L48 50 C48 42 46 24 44 18 C43 14 41 11 38 10 Z" fill="url(#knightGrad)" stroke="rgba(255,255,255,0.4)" stroke-width="2"/>
                <circle cx="28" cy="22" r="2.5" fill="#000000" />
                <circle cx="28.5" cy="21.5" r="1" fill="#ffffff" />
                <path d="M22 28 C26 30 32 30 36 26" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
                <path d="M12 54 L52 54" stroke="#38bdf8" stroke-width="4" stroke-linecap="round"/>
                <defs>
                    <linearGradient id="knightGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#ffffff"/>
                        <stop offset="45%" stop-color="#38bdf8"/>
                        <stop offset="100%" stop-color="#0284c7"/>
                    </linearGradient>
                </defs>
            </svg>
        </div>

        <h2 class="overlay-title">
            CYBER <span class="hollow-text">CHESS</span>
        </h2>
        <p class="overlay-sub">Engage the cloud neural Stockfish engine with tactical real-time evaluation, rating progression, and PGN analysis.</p>
        
        <div class="overlay-stats">
            <div class="stat-col">
                <span class="stat-label">TACTICAL RATING</span>
                <span class="stat-val" id="splashChessRating">1200</span>
            </div>
            <div class="stat-col">
                <span class="stat-label">COMBAT WIN RATIO</span>
                <span class="stat-val" id="splashChessRatio" style="color: var(--primary);">0%</span>
            </div>
        </div>

        <div class="menu-actions" style="max-width: 340px;">
            <button class="btn-cyber btn-cyber-primary" onclick="startChessMatch()">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                <span>INITIATE MATCH</span>
            </button>
            <div class="menu-actions-row">
                <button class="btn-cyber btn-cyber-secondary" onclick="openChessIntel()">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                    <span>PROTOCOLS</span>
                </button>
                <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    <span>HUB</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Chess Intel Modal (Obsidian Space Glass) -->
    <div id="chessIntelModal" class="intel-modal">
        <div class="intel-box">
            <div class="intel-title">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#38bdf8" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
                <span>STOCKFISH GRANDMASTER PROTOCOL</span>
                <button class="btn-icon-close" onclick="closeChessIntel()">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                </button>
            </div>

            <div class="intel-row">
                <div class="intel-row-head">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                    <strong>TACTICAL GAMEPLAY</strong>
                </div>
                Standard FIDE chess rules with drag-and-drop movement, pawn promotions, legal square validation, and automated checkmate detection.
            </div>

            <div class="intel-row">
                <div class="intel-row-head">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
                    <strong>NEURAL AI ENGINE DEPTH</strong>
                </div>
                Configurable Stockfish depth: Level 1 (Depth 2 Novice) through Level 5 (Depth 12 Grandmaster). Automatic fallback heuristic ensures 100% offline uptime.
            </div>

            <div class="intel-row">
                <div class="intel-row-head">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#22c55e" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                    <strong>TACTICAL RATING TELEMETRY</strong>
                </div>
                Victory against the AI earns +30 rating points. Defeat subtracts -15 rating points. All ratings synchronize to central cloud records!
            </div>

            <button class="btn-cyber btn-cyber-primary" style="margin-top: 1rem; width: 100%;" onclick="closeChessIntel(); startChessMatch();">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                <span>COMMENCE MATCH</span>
            </button>
        </div>
    </div>

    <div class="game-layout">
        <div class="board-section" id="boardArea">
            <div class="board-wrapper-glass">
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
                <div id="myBoard"></div>
            </div>
            <div class="status-box" id="status">White to move</div>
        </div>

        <aside class="sidebar" id="sidebar">
            <div class="control-group">
                <label>
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/><line x1="9" y1="20" x2="9" y2="23"/><line x1="15" y1="20" x2="15" y2="23"/><line x1="20" y1="9" x2="23" y2="9"/><line x1="20" y1="14" x2="23" y2="14"/><line x1="1" y1="9" x2="4" y2="9"/><line x1="1" y1="14" x2="4" y2="14"/></svg>
                    <span>Engine Difficulty</span>
                </label>
                <select id="aiDepth" class="neon-select">
                    <option value="2">Level 1: Novice (Depth 2)</option>
                    <option value="5" selected>Level 2: Casual (Depth 5)</option>
                    <option value="8">Level 3: Advanced (Depth 8)</option>
                    <option value="10">Level 4: Master (Depth 10)</option>
                    <option value="12">Level 5: Grandmaster (Depth 12)</option>
                </select>
            </div>

            <div class="control-group action-buttons-group">
                <button class="btn-cyber btn-cyber-primary" id="startBtn" style="width: 100%;">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                    <span>NEW GAME</span>
                </button>
                <div style="display:flex; gap: 8px;">
                    <button class="btn-cyber btn-cyber-secondary" id="flipBtn" style="flex: 1;">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.3"/></svg>
                        <span>FLIP</span>
                    </button>
                    <button class="btn-cyber btn-cyber-secondary" id="exitBtn" style="flex: 1;">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                        <span>EXIT</span>
                    </button>
                </div>
            </div>

            <div class="control-group pgn-group">
                <label>
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#38bdf8" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                    <span>Move History (PGN)</span>
                </label>
                <div class="pgn-box" id="pgn">Game moves will stream here...</div>
            </div>
        </aside>
    </div>

    <script src="js/engine.js"></script>
    <script src="../js/ransom_horror.js"></script>
</body>
</html>