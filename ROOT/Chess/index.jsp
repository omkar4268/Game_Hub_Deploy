<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>CYBER CHESS // STOCKFISH API</title>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/@chrisoakman/chessboardjs@1.0.0/dist/chessboard-1.0.0.min.css">
    <script src="https://unpkg.com/@chrisoakman/chessboardjs@1.0.0/dist/chessboard-1.0.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chess.js/0.10.3/chess.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    

    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="../css/ransom_horror.css">
</head>
<body>
    <!-- Universal Cyber-Scanner Wipe Transition -->
    <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
        <div class="cyber-wipe-beam"></div>
    </div>

    <div class="navbar">
        <h1 class="title">CYBER CHESS <span style="font-size:0.8rem; color:var(--text-muted);">v3.0 OMNI-ROUTING</span></h1>
        <div style="display:flex; align-items:center; gap:8px;">
            <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn btn-secondary" style="text-decoration:none; padding: 6px 12px; font-size:0.82rem;"><i class="fa-solid fa-arrow-left"></i> Hub</a>
            <button class="menu-toggle" id="menuToggle"><i class="fa-solid fa-bars"></i></button>
        </div>
    </div>

    <!-- Standardized Pre-Game Interactive Startup Screen -->
    <div id="chessStartupModal" class="chess-overlay-screen">
        <div class="overlay-icon">♟️</div>
        <h2 class="overlay-title">
            CYBER CHESS
            <span class="header-badge">AI GRANDMASTER</span>
        </h2>
        <p class="overlay-sub">Engage neural Stockfish chess engines with real-time evaluation, rating progression, and tactical PGN analysis.</p>
        
        <div class="overlay-stats">
            <div>Tactical Rating<span id="splashChessRating">1200</span></div>
            <div>Win Ratio<span id="splashChessRatio">0%</span></div>
        </div>

        <div class="menu-actions" style="max-width: 320px;">
            <button class="btn-cyber btn-cyber-primary" onclick="startChessMatch()">▶ INITIATE MATCH</button>
            <div style="display:flex; gap:8px; width:100%;">
                <button class="btn-cyber btn-cyber-secondary" style="flex:1;" onclick="openChessIntel()">⚙ PROTOCOL</button>
                <a href="javascript:void(0)" onclick="cyberNavigate('../index.jsp')" class="btn-cyber btn-cyber-secondary" style="flex:1;">‹ HUB</a>
            </div>
        </div>
    </div>

    <!-- Chess Intel Modal -->
    <div id="chessIntelModal" class="intel-modal">
        <div class="intel-title">
            <span>SECURITY DIRECTIVE</span>
            <button class="btn btn-secondary" style="padding: 4px 10px;" onclick="closeChessIntel()">✕ Close</button>
        </div>

        <div class="intel-row">
            <strong>🎮 GAMEPLAY RULES</strong>
            Standard chess rules with drag-and-drop movement, pawn promotions, and automated checkmate detection.
        </div>

        <div class="intel-row">
            <strong>⚡ NEURAL AI DIFFICULTY</strong>
            Switch Stockfish engine search depth from Level 1 (Novice) up to Level 5 (Grandmaster) via the sidebar selector.
        </div>

        <div class="intel-row">
            <strong>🎯 TACTICAL RATING</strong>
            Victory against the neural engine awards +30 rating points. Defeat subtracts -15 rating points. All ratings sync to your central arcade records!
        </div>

        <button class="btn-cyber btn-cyber-primary" style="margin-top: auto;" onclick="closeChessIntel(); startChessMatch();">
            ▶ COMMENCE MATCH
        </button>
    </div>

    <div class="game-layout">
        <div class="board-section" id="boardArea">
            <div id="myBoard"></div>
            <div class="status-box" id="status">White to move</div>
        </div>

        <div class="sidebar" id="sidebar">
            <div class="control-group">
                <label><i class="fa-solid fa-microchip"></i> Engine Difficulty</label>
                <select id="aiDepth" class="neon-select">
                    <option value="2">Level 1: Novice (Depth 2)</option>
                    <option value="5" selected>Level 2: Casual (Depth 5)</option>
                    <option value="8">Level 3: Advanced (Depth 8)</option>
                    <option value="10">Level 4: Master (Depth 10)</option>
                    <option value="12">Level 5: Grandmaster (Depth 12)</option>
                </select>
            </div>

            <div class="control-group">
                <button class="btn btn-primary" id="startBtn"><i class="fa-solid fa-play"></i> New Game</button>
                <button class="btn btn-secondary" id="flipBtn"><i class="fa-solid fa-retweet"></i> Flip Board</button>
                <button class="btn btn-danger" id="exitBtn"><i class="fa-solid fa-door-open"></i> Exit Hub</button>
            </div>

            <div class="control-group" style="flex: 1; display: flex; flex-direction: column;">
                <label><i class="fa-solid fa-list-check"></i> Move History (PGN)</label>
                <div class="pgn-box" id="pgn">Game history will appear here...</div>
            </div>
        </div>
    </div>

    <script src="js/engine.js"></script>
    <script src="../js/ransom_horror.js"></script>
</body>
</html>