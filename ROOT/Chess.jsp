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

    <style>
        :root {
            --bg-base: #05070e;
            --primary: #38bdf8;
            --neon-purple: #a855f7;
            --accent: #22c55e;
            --danger: #f43f5e;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --board-glow: rgba(56, 189, 248, 0.4);
            --sidebar-bg: rgba(15, 23, 42, 0.95);
        }

        * { box-sizing: border-box; font-family: 'Segoe UI', system-ui, sans-serif; }
        
        body, html {
            margin: 0; padding: 0;
            background-color: var(--bg-base);
            color: var(--text-main);
            overflow-x: hidden;
            height: 100%;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: 
                radial-gradient(circle at 15% 20%, rgba(56, 189, 248, 0.12) 0%, transparent 40%),
                radial-gradient(circle at 85% 80%, rgba(168, 85, 247, 0.12) 0%, transparent 40%),
                linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
            background-size: 100% 100%, 100% 100%, 30px 30px, 30px 30px;
            z-index: -1;
            pointer-events: none;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background: rgba(0,0,0,0.5);
            border-bottom: 1px solid rgba(56, 189, 248, 0.2);
            backdrop-filter: blur(10px);
        }

        .title {
            font-size: 1.5rem;
            font-weight: 900;
            background: linear-gradient(90deg, var(--primary), var(--neon-purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
            letter-spacing: 1.5px;
        }

        .menu-toggle {
            display: none;
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1.8rem;
            cursor: pointer;
            text-shadow: 0 0 10px var(--primary);
        }

        .game-layout {
            display: flex;
            height: calc(100vh - 70px);
            position: relative;
            overflow: hidden;
        }

        .board-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            overflow-y: auto;
        }

        #myBoard {
            width: 100%;
            max-width: 550px;
            border: 3px solid var(--primary);
            border-radius: 4px;
            box-shadow: 0 0 35px var(--board-glow);
            background: #2b2b2b;
        }

        .status-box {
            margin-top: 1.5rem;
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid rgba(56, 189, 248, 0.3);
            padding: 1rem 2rem;
            border-radius: 8px;
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary);
            text-align: center;
            box-shadow: 0 0 15px rgba(0,0,0,0.5);
            min-width: 300px;
        }

        .sidebar {
            width: 320px;
            background: var(--sidebar-bg);
            border-left: 1px solid rgba(56, 189, 248, 0.2);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            transition: transform 0.3s ease;
            overflow-y: auto;
        }

        .control-group {
            background: rgba(0,0,0,0.3);
            padding: 1rem;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .control-group label {
            display: block;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        select.neon-select {
            width: 100%;
            padding: 0.8rem;
            background: #0f172a;
            color: white;
            border: 1px solid var(--primary);
            border-radius: 6px;
            font-size: 1rem;
            outline: none;
        }

        .btn {
            width: 100%;
            padding: 0.9rem;
            margin-bottom: 0.8rem;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-primary { background: var(--primary); color: #000; box-shadow: 0 0 10px rgba(56, 189, 248, 0.3); }
        .btn-primary:hover { background: #0284c7; color: #fff; box-shadow: 0 0 15px rgba(56, 189, 248, 0.6); }
        .btn-secondary { background: rgba(255,255,255,0.1); color: var(--text-main); }
        .btn-secondary:hover { background: rgba(255,255,255,0.2); }
        .btn-danger { background: var(--danger); color: #fff; }
        .btn-danger:hover { background: #be123c; }

        .pgn-box {
            flex: 1;
            font-family: 'Courier New', monospace;
            background: rgba(0,0,0,0.6);
            padding: 1rem;
            border-radius: 6px;
            border: 1px solid rgba(255,255,255,0.05);
            font-size: 0.85rem;
            color: var(--text-muted);
            overflow-y: auto;
            min-height: 150px;
        }

        @media (max-width: 900px) {
            .menu-toggle { display: block; }
            .sidebar {
                position: absolute;
                top: 0;
                right: 0;
                height: 100%;
                transform: translateX(100%);
                z-index: 50;
                box-shadow: -5px 0 25px rgba(0,0,0,0.8);
            }
            .sidebar.open { transform: translateX(0); }
            #myBoard { max-width: 95vw; width: 95vw; }
        }

        /* Standardized Pre-Game Startup Overlay */
        .chess-overlay-screen {
            position: fixed;
            inset: 0;
            background: rgba(3, 7, 18, 0.95);
            backdrop-filter: blur(12px);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            z-index: 1000;
            text-align: center;
            box-sizing: border-box;
            overflow-y: auto;
        }

        .overlay-icon {
            font-size: 3rem;
            margin-bottom: 0.4rem;
            filter: drop-shadow(0 0 15px rgba(56, 189, 248, 0.5));
            animation: floatChess 2.5s infinite ease-in-out;
        }
        @keyframes floatChess {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        .overlay-title {
            font-size: 1.6rem;
            font-weight: 900;
            letter-spacing: 2px;
            color: var(--primary);
            text-shadow: 0 0 15px rgba(56, 189, 248, 0.5);
            margin-bottom: 0.3rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .header-badge {
            background: rgba(56, 189, 248, 0.15);
            border: 1px solid rgba(56, 189, 248, 0.4);
            color: var(--primary);
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 6px;
            font-weight: 800;
            letter-spacing: 0.8px;
        }

        .overlay-sub {
            font-size: 0.85rem;
            color: var(--text-muted);
            max-width: 320px;
            line-height: 1.5;
            margin-bottom: 1.2rem;
        }

        .overlay-stats {
            display: flex;
            gap: 1.2rem;
            background: rgba(15, 23, 42, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.08);
            padding: 0.5rem 1.2rem;
            border-radius: 12px;
            margin-bottom: 1.2rem;
            font-size: 0.8rem;
        }
        .overlay-stats div span {
            display: block;
            font-weight: 800;
            font-size: 1.05rem;
            color: var(--accent);
        }

        .menu-actions {
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
            width: 100%;
            max-width: 260px;
        }

        .btn-cyber {
            min-height: 44px;
            padding: 0.7rem 1.2rem;
            border-radius: 10px;
            border: none;
            font-weight: 800;
            font-size: 0.88rem;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
            box-sizing: border-box;
        }
        .btn-cyber-primary {
            background: var(--primary);
            color: #000;
            box-shadow: 0 0 15px rgba(56, 189, 248, 0.4);
        }
        .btn-cyber-primary:hover {
            background: #7dd3fc;
            box-shadow: 0 0 25px rgba(56, 189, 248, 0.6);
            transform: translateY(-2px);
        }
        .btn-cyber-secondary {
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-main);
            border: 1px solid rgba(255, 255, 255, 0.12);
        }
        .btn-cyber-secondary:hover {
            background: rgba(255, 255, 255, 0.16);
            color: var(--primary);
        }

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
        }
        .intel-modal.active { display: flex; }
        .intel-title {
            font-size: 1.15rem;
            color: var(--accent);
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
            color: var(--text-main);
            display: block;
            margin-bottom: 3px;
        }

        /* Universal Cyber-Scanner Wipe Transition */
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
            background: linear-gradient(90deg, transparent 0%, rgba(56, 189, 248, 0.1) 60%, rgba(56, 189, 248, 0.5) 92%, #38bdf8 98%, #ffffff 100%);
            box-shadow: 12px 0 35px rgba(56, 189, 248, 0.8), 2px 0 15px #22c55e;
            transform: translate3d(0, 0, 0);
        }
        .cyber-wipe-overlay.active .cyber-wipe-beam {
            animation: cyberBeamSweep 0.26s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
        }
        @keyframes cyberBeamSweep {
            0% { transform: translateX(0); }
            100% { transform: translateX(200vw); }
        }

        @media (max-width: 768px) {
            .chess-overlay-screen { padding: 1.2rem 1rem; }
            .overlay-icon { font-size: 2.2rem; margin-bottom: 2px; }
            .overlay-title { font-size: 1.3rem; margin-bottom: 2px; }
            .overlay-sub { font-size: 0.8rem; line-height: 1.4; margin-bottom: 0.8rem; max-width: 300px; }
            .overlay-stats { padding: 0.4rem 1rem; margin-bottom: 0.8rem; gap: 1rem; }
            .status-box { min-width: unset; width: 90%; font-size: 0.95rem; padding: 0.6rem 1rem; margin-top: 0.8rem; }
        }
    </style>
</head>
<body>
    <!-- Universal Cyber-Scanner Wipe Transition -->
    <div id="cyberWipeOverlay" class="cyber-wipe-overlay">
        <div class="cyber-wipe-beam"></div>
    </div>

    <div class="navbar">
        <h1 class="title">CYBER CHESS <span style="font-size:0.8rem; color:var(--text-muted);">v3.0 OMNI-ROUTING</span></h1>
        <div style="display:flex; align-items:center; gap:8px;">
            <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn btn-secondary" style="text-decoration:none; padding: 6px 12px; font-size:0.82rem;"><i class="fa-solid fa-arrow-left"></i> Hub</a>
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
                <a href="javascript:void(0)" onclick="cyberNavigate('index.jsp')" class="btn-cyber btn-cyber-secondary" style="flex:1;">‹ HUB</a>
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

    <script>
        const $status =$('#status');
        const $pgn =$('#pgn');
        const $sidebar =$('#sidebar');
        
        let board = null;
        let game = new Chess();
        let isAiThinking = false;

        $('#menuToggle').on('click', function(e) {
            e.stopPropagation();
            $sidebar.toggleClass('open');
        });
        $('#boardArea').on('click', function() {
            if ($(window).width() <= 900)$sidebar.removeClass('open');
        });

        // Triple-Routed AI Engine
        async function makeAiMove() {
            if (game.game_over()) return;

            isAiThinking = true;
            updateStatus('<i class="fa-solid fa-circle-notch fa-spin"></i> AI is calculating...');
            
            const depth = parseInt($('#aiDepth').val(), 10);
            let moveObj = null;
            let usedFallback = false;

            // Route 1: chess-api.com (POST)
            try {
                const controller = new AbortController();
                const timeout = setTimeout(() => controller.abort(), 6000); // 6 sec timeout
                
                const res = await fetch('https://chess-api.com/v1', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ fen: game.fen(), depth: depth }),
                    signal: controller.signal
                });
                clearTimeout(timeout);
                
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.from && data.to) {
                        moveObj = { from: data.from, to: data.to, promotion: data.promotion || 'q' };
                    }
                }
            } catch (e) {
                console.warn("Primary API timeout/failed. Routing to secondary...");
            }

            // Route 2: stockfish.online (GET)
            if (!moveObj) {
                try {
                    const controller = new AbortController();
                    const timeout = setTimeout(() => controller.abort(), 6000);
                    const fenSafe = encodeURIComponent(game.fen());
                    
                    const res2 = await fetch(`https://stockfish.online/api/s/v2.php?fen=${fenSafe}&depth=${depth}`, {
                        signal: controller.signal
                    });
                    clearTimeout(timeout);
                    
                    if (res2.ok) {
                        const data2 = await res2.json();
                        if (data2 && data2.bestmove) {
                            const parts = data2.bestmove.split(' '); // "bestmove e7e5 ponder..."
                            const mStr = parts[1];
                            if (mStr) {
                                moveObj = {
                                    from: mStr.substring(0, 2),
                                    to: mStr.substring(2, 4),
                                    promotion: mStr.length > 4 ? mStr.substring(4, 5) : 'q'
                                };
                            }
                        }
                    }
                } catch (e) {
                    console.warn("Secondary API timeout/failed. Triggering emergency internal fallback...");
                }
            }

            // Route 3: Embedded Emergency Fallback (Guarantees the game never breaks)
            if (!moveObj) {
                usedFallback = true;
                const moves = game.moves({ verbose: true });
                let bestFallback = moves[0];
                let highestCapture = -1;
                const vals = { 'p': 1, 'n': 3, 'b': 3, 'r': 5, 'q': 9, 'k': 0 };
                
                // Seek highest value capture immediately available
                for (let m of moves) {
                    if (m.flags.includes('c') || m.flags.includes('e')) {
                        const target = game.get(m.to);
                        const val = target ? vals[target.type] : 1;
                        if (val > highestCapture) { highestCapture = val; bestFallback = m; }
                    }
                }
                
                // Random move if no captures exist
                if (highestCapture === -1) {
                    bestFallback = moves[Math.floor(Math.random() * moves.length)];
                }
                moveObj = { from: bestFallback.from, to: bestFallback.to, promotion: 'q' };
            }

            // Execute verified move
            if (moveObj) {
                game.move(moveObj);
                board.position(game.fen());
            }

            isAiThinking = false;
            
            if (usedFallback) {
                updateStatus('<span style="color:var(--danger)"><i class="fa-solid fa-triangle-exclamation"></i> Network lag: AI executed emergency move.</span>');
                setTimeout(() => updateStatus(), 3500); // Revert to normal status after 3.5s
            } else {
                updateStatus();
            }
        }

        function onDragStart(source, piece, position, orientation) {
            if (game.game_over() || isAiThinking) return false;
            if ((orientation === 'white' && piece.search(/^b/) !== -1) ||
                (orientation === 'black' && piece.search(/^w/) !== -1)) {
                return false;
            }
        }

        function onDrop(source, target) {
            const move = game.move({
                from: source,
                to: target,
                promotion: 'q' 
            });

            if (move === null) return 'snapback';
            updateStatus();

            if (!game.game_over()) {
                window.setTimeout(makeAiMove, 250);
            }
        }

        function onSnapEnd() {
            board.position(game.fen());
        }

        function updateStatus(customOverride = null) {
            if (customOverride) {
                $status.html(customOverride);
                return;
            }

            let statusHTML = '';
            let moveColor = (game.turn() === 'w') ? 'White' : 'Black';

            if (game.in_checkmate()) {
                statusHTML = `<span style="color:var(--danger)">Game Over: ${moveColor} is in checkmate.</span>`;
                
                // Track Wins / Losses / Rating
                if (!game._recorded) {
                    game._recorded = true;
                    let wins = parseInt(localStorage.getItem('hub_chess_wins') || '0', 10);
                    let losses = parseInt(localStorage.getItem('hub_chess_losses') || '0', 10);
                    let rating = parseInt(localStorage.getItem('hub_chess_rating') || '1200', 10);

                    const playerWon = (moveColor === 'Black' && board.orientation() === 'white') ||
                                      (moveColor === 'White' && board.orientation() === 'black');

                    if (playerWon) {
                        wins++;
                        rating += 30;
                        localStorage.setItem('hub_chess_wins', wins);
                        localStorage.setItem('hub_chess_rating', rating);
                        statusHTML += ` <br><span style="color:var(--accent); font-size: 1rem;">Victory! Rating: ${rating} (+30)</span>`;
                    } else {
                        losses++;
                        rating = Math.max(800, rating - 15);
                        localStorage.setItem('hub_chess_losses', losses);
                        localStorage.setItem('hub_chess_rating', rating);
                        statusHTML += ` <br><span style="color:var(--danger); font-size: 1rem;">Defeat. Rating: ${rating} (-15)</span>`;
                    }

                    // Sync to Cloud
                    fetch('save_score.jsp', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: new URLSearchParams({ game: 'chess', score: rating })
                    }).catch(() => console.log('Offline chess score saved.'));
                }
            } else if (game.in_draw()) {
                statusHTML = `<span style="color:var(--text-muted)">Game Over: Drawn position.</span>`;
            } else {
                statusHTML = `${moveColor} to move`;
                if (game.in_check()) statusHTML += ` <span style="color:var(--danger)">(Check)</span>`;
            }

            if (!isAiThinking) $status.html(statusHTML);
            
            let history = game.pgn({ max_width: 5, newline_char: '<br>' });
            $pgn.html(history || "Game history will appear here...");
            
            const pgnEl = document.getElementById("pgn");
            pgnEl.scrollTop = pgnEl.scrollHeight;
        }

        const config = {
            draggable: true,
            position: 'start',
            onDragStart: onDragStart,
            onDrop: onDrop,
            onSnapEnd: onSnapEnd,
            pieceTheme: 'https://chessboardjs.com/img/chesspieces/wikipedia/{piece}.png'
        };

        board = Chessboard('myBoard', config);
        
        $(window).resize(() => board.resize());

        $('#startBtn').on('click', function() {
            game.reset();
            board.start();
            isAiThinking = false;
            if ($(window).width() <= 900)$sidebar.removeClass('open');
            updateStatus();
            
            if (board.orientation() === 'black') {
                window.setTimeout(makeAiMove, 300);
            }
        });

        $('#flipBtn').on('click', () => board.flip());
        $('#exitBtn').on('click', () => cyberNavigate('index.jsp'));

        // Startup Screen Logic
        function loadChessTelemetry() {
            const rating = localStorage.getItem('hub_chess_rating') || '1200';
            const wins = parseInt(localStorage.getItem('hub_chess_wins') || '0', 10);
            const losses = parseInt(localStorage.getItem('hub_chess_losses') || '0', 10);
            const total = wins + losses;
            const ratio = total > 0 ? Math.round((wins / total) * 100) : 0;

            document.getElementById('splashChessRating').innerText = rating;
            document.getElementById('splashChessRatio').innerText = ratio + '% (' + wins + 'W/' + losses + 'L)';
        }

        function startChessMatch() {
            document.getElementById('chessStartupModal').style.display = 'none';
            document.getElementById('chessIntelModal').classList.remove('active');
            game.reset();
            board.start();
            isAiThinking = false;
            updateStatus();
        }

        function openChessIntel() {
            document.getElementById('chessIntelModal').classList.add('active');
        }
        function closeChessIntel() {
            document.getElementById('chessIntelModal').classList.remove('active');
        }

        loadChessTelemetry();
        updateStatus();

        // Cyber-Scanner Navigation Wipe Handler
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