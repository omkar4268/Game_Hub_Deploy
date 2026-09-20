<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>CYBER CHESS // STOCKFISH API</title>
    
    <!-- Core Dependencies -->
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

        /* Digital Ambient Background */
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

        /* Top Navbar */
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

        /* Mobile Menu Toggle */
        .menu-toggle {
            display: none;
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1.8rem;
            cursor: pointer;
            text-shadow: 0 0 10px var(--primary);
        }

        /* Layout Container */
        .game-layout {
            display: flex;
            height: calc(100vh - 70px);
            position: relative;
            overflow: hidden;
        }

        /* Chess Board Area */
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
        }

        .thinking-spinner {
            display: none;
            margin-left: 10px;
            color: var(--danger);
            animation: spin 1s linear infinite;
        }

        @keyframes spin { 100% { transform: rotate(360deg); } }

        /* Sliding Sidebar */
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

        /* Mobile Responsive Overlays */
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
            .sidebar.open {
                transform: translateX(0);
            }
            #myBoard {
                max-width: 95vw;
                width: 95vw;
            }
        }
    </style>
</head>
<body>

    <!-- Mobile-friendly Overlay controls -->
    <div class="navbar">
        <h1 class="title">CYBER CHESS <span style="font-size:0.8rem; color:var(--text-muted);">v2.0 STOCKFISH</span></h1>
        <button class="menu-toggle" id="menuToggle"><i class="fa-solid fa-bars"></i></button>
    </div>

    <div class="game-layout">
        <!-- Main Board Area -->
        <div class="board-section" id="boardArea">
            <div id="myBoard"></div>
            <div class="status-box">
                <span id="status">White to move</span>
                <i class="fa-solid fa-circle-notch thinking-spinner" id="spinner"></i>
            </div>
        </div>

        <!-- Sliding Sidebar Panels -->
        <div class="sidebar" id="sidebar">
            <div class="control-group">
                <label><i class="fa-solid fa-microchip"></i> Engine Difficulty</label>
                <select id="aiDepth" class="neon-select">
                    <option value="1">Level 1: Novice (Depth 1)</option>
                    <option value="4" selected>Level 2: Casual (Depth 4)</option>
                    <option value="8">Level 3: Advanced (Depth 8)</option>
                    <option value="12">Level 4: Master (Depth 12)</option>
                    <option value="15">Level 5: Grandmaster (Depth 15)</option>
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
        // DOM Elements
        const $status =$('#status');
        const $spinner =$('#spinner');
        const $pgn =$('#pgn');
        const $sidebar =$('#sidebar');
        
        // Game Logic Variables
        let board = null;
        let game = new Chess();
        let isAiThinking = false;
        let isWhitePlayer = true; // Flips if user plays as Black

        // Mobile Sidebar Toggle
        $('#menuToggle').on('click', function(e) {
            e.stopPropagation();
            $sidebar.toggleClass('open');
        });
        $('#boardArea').on('click', function() {
            if ($(window).width() <= 900) {$sidebar.removeClass('open');
            }
        });

        // Fetch best move from Stockfish API
        async function makeAiMove() {
            if (game.game_over()) return;

            isAiThinking = true;
            $status.html('AI is calculating...');$spinner.show();
            
            const depth = parseInt($('#aiDepth').val(), 10);
            
            try {
                // REST API call to chess-api.com
                const response = await fetch('https://chess-api.com/v1', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        fen: game.fen(),
                        depth: depth
                    })
                });

                if (!response.ok) throw new Error("API Network Error");
                
                const data = await response.json();
                
                // Ensure data exists to prevent crashes
                if(data && data.from && data.to) {
                    game.move({
                        from: data.from,
                        to: data.to,
                        promotion: data.promotion || 'q'
                    });
                } else {
                    throw new Error("Invalid API Response");
                }

                board.position(game.fen());
                
            } catch (error) {
                console.error("Engine Error:", error);
                $status.html('<span style="color:var(--danger)">Connection lost. Try again.</span>');
            } finally {
                isAiThinking = false;
                $spinner.hide();
                updateStatus();
            }
        }

        // Chessboard.js Drag validation
        function onDragStart(source, piece, position, orientation) {
            // Prevent interaction if game over or AI is thinking
            if (game.game_over() || isAiThinking) return false;

            // Only allow picking up pieces of the user's color
            if ((orientation === 'white' && piece.search(/^b/) !== -1) ||
                (orientation === 'black' && piece.search(/^w/) !== -1)) {
                return false;
            }
        }

        function onDrop(source, target) {
            // Validate move with chess.js
            const move = game.move({
                from: source,
                to: target,
                promotion: 'q' // Auto-promote to queen
            });

            // If illegal move, snap back
            if (move === null) return 'snapback';

            updateStatus();

            // Trigger AI response if game isn't over
            if (!game.game_over()) {
                window.setTimeout(makeAiMove, 300);
            }
        }

        // Update board state after snap animation
        function onSnapEnd() {
            board.position(game.fen());
        }

        // UI Updates for Check, Checkmate, and Draw
        function updateStatus() {
            let statusHTML = '';
            let moveColor = (game.turn() === 'w') ? 'White' : 'Black';

            if (game.in_checkmate()) {
                statusHTML = `<span style="color:var(--danger)">Game Over: ${moveColor} is in checkmate.</span>`;
            } else if (game.in_draw()) {
                statusHTML = `<span style="color:var(--text-muted)">Game Over: Drawn position.</span>`;
            } else {
                statusHTML = `${moveColor} to move`;
                if (game.in_check()) {
                    statusHTML += ` <span style="color:var(--danger)">(Check)</span>`;
                }
            }

            if (!isAiThinking) $status.html(statusHTML);
            
            // Format PGN
            let history = game.pgn({ max_width: 5, newline_char: '<br>' });
            $pgn.html(history || "Game history will appear here...");
            
            // Auto-scroll PGN to bottom
            const pgnEl = document.getElementById("pgn");
            pgnEl.scrollTop = pgnEl.scrollHeight;
        }

        // Initialize Board
        const config = {
            draggable: true,
            position: 'start',
            onDragStart: onDragStart,
            onDrop: onDrop,
            onSnapEnd: onSnapEnd,
            pieceTheme: 'https://chessboardjs.com/img/chesspieces/wikipedia/{piece}.png'
        };

        board = Chessboard('myBoard', config);
        
        // Fix responsive resize issue with chessboard.js
        $(window).resize(function() {
            board.resize();
        });

        // Controls
        $('#startBtn').on('click', function() {
            game.reset();
            board.start();
            isAiThinking = false;
            
            // Close sidebar on mobile after clicking start
            if ($(window).width() <= 900)$sidebar.removeClass('open');
            
            updateStatus();

            // If player flipped the board, AI (White) needs to move first
            if (board.orientation() === 'black') {
                window.setTimeout(makeAiMove, 300);
            }
        });

        $('#flipBtn').on('click', function() {
            board.flip();
        });
        
        $('#exitBtn').on('click', function() {
            window.location.href = 'index.jsp';
        });

        // Initial setup call
        updateStatus();
    </script>
</body>
</html>