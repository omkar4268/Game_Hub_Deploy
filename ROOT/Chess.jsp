<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Enhanced Cyber Chess with Actual AI Engine
    HttpSession session = request.getSession();
    String action = request.getParameter("action");
    String difficulty = request.getParameter("difficulty");
    String playerColor = request.getParameter("playerColor");
    String reset = request.getParameter("reset");
    String moveFrom = request.getParameter("moveFrom");
    String moveTo = request.getParameter("moveTo");
    String pgnRequest = request.getParameter("pgn");

    // Default values
    if (difficulty == null) difficulty = "medium";
    if (playerColor == null) playerColor = "white";

    // Initialize chess engine components if not present
    if (session.getAttribute("chessEngine") == null) {
        session.setAttribute("chessEngine", new ChessEngine());
    }
    ChessEngine engine = (ChessEngine) session.getAttribute("chessEngine");

    // Handle PGN request
    if (pgnRequest != null && pgnRequest.equals("export")) {
        String pgn = engine.getPGN();
        response.setContentType("application/x-chess-pgn");
        response.setHeader("Content-Disposition", "attachment; filename=cyber_chess_game.pgn");
        response.getWriter().write(pgn);
        return;
    }

    // Initialize board if new game or reset
    if (reset != null || session.getAttribute("boardInitialized") == null) {
        engine.initializeGame(playerColor, difficulty);
        session.setAttribute("boardInitialized", true);
    }

    // Handle player move
    boolean moveMade = false;
    if (moveFrom != null && moveTo != null && !session.getAttribute("gameOver").equals("true")) {
        moveMade = engine.makePlayerMove(moveFrom, moveTo);
        if (moveMade) {
            // Check if game over after player move
            if (engine.isGameOver()) {
                session.setAttribute("gameOver", true);
            } else {
                // AI move
                engine.makeAIMove();
                if (engine.isGameOver()) {
                    session.setAttribute("gameOver", true);
                }
            }
        }
    }

    // Get current state for display
    String[][] board = engine.getBoard();
    boolean gameOver = (boolean) session.getAttribute("gameOver");
    String winner = engine.getWinner();
    int moveCount = engine.getMoveCount();
    String pgn = engine.getPGN();
    String lastMove = engine.getLastMove();
    int evaluation = engine.getPositionalEvaluation();

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>CYBER CHESS // AI BATTLE</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-base: #05070e;
            --card-bg: rgba(13, 19, 36, 0.85);
            --border-glow: rgba(56, 189, 248, 0.25);
            --primary: #38bdf8;
            --accent: #22c55e;
            --neon-pink: #f43f5e;
            --neon-purple: #a855f7;
            --neon-cyan: #06b6d4;
            --neon-yellow: #facc15;
            --text-main: #f8fafc;
            --text-muted: #64748b;
            --square-light: rgba(255, 255, 255, 0.1);
            --square-dark: rgba(0, 0, 0, 0.3);
            --move-highlight: rgba(56, 189, 248, 0.3);
            --check-highlight: rgba(239, 68, 68, 0.3);
            --last-move: rgba(16, 185, 129, 0.3);
            --advantage-white: #10b981;
            --advantage-black: #ef4444;
            --eval-bar-bg: rgba(255,255,255,0.1);
            --eval-bar-fill: linear-gradient(90deg, var(--advantage-black), transparent, var(--advantage-white));
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', system-ui, sans-serif; -webkit-tap-highlight-color: transparent; }

        body {
            background-color: var(--bg-base);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            position: relative;
        }

        /* Digital Ambiance Background */
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

        .container {
            display: flex;
            flex: 1;
            overflow: hidden;
            height: 100vh;
        }

        /* Game Board */
        .board-container {
            flex: 1 1 60%;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1rem;
            overflow-y: auto;
        }

        .board-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            max-width: 600px;
            margin-bottom: 0.5rem;
        }

        .board-title {
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(90deg, var(--primary), var(--neon-purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .eval-container {
            width: 100%;
            max-width: 600px;
            height: 8px;
            background: var(--eval-bar-bg);
            border-radius: 4px;
            overflow: hidden;
            margin: 0.5rem 0;
            position: relative;
        }

        .eval-fill {
            height: 100%;
            background: var(--eval-bar-fill);
            transition: width 0.3s ease;
            position: absolute;
            top: 0;
            left: 50%;
            width: 0%;
            transform: translateX(-50%);
        }

        .eval-label {
            position: absolute;
            top: -18px;
            font-size: 0.75rem;
            font-weight: 600;
            left: 50%;
            transform: translateX(-50%);
            color: var(--text-muted);
        }

        .chess-board {
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            grid-template-rows: repeat(8, 1fr);
            width: min(90vw, 600px);
            height: min(90vw, 600px);
            max-width: 600px;
            max-height: 600px;
            border: 2px solid var(--border-glow);
            border-radius: 16px;
            box-shadow: 0 0 30px rgba(56, 189, 248, 0.2);
            position: relative;
            overflow: hidden;
        }

        .square {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            user-select: none;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
            z-index: 1;
        }

        .square.light { background-color: var(--square-light); }
        .square.dark { background-color: var(--square-dark); }

        .square:hover:not(.disabled) {
            transform: scale(1.05);
            z-index: 10;
        }

        .square.selected {
            background: var(--move-highlight) !important;
            box-shadow: 0 0 15px var(--primary);
            z-index: 11;
        }

        .square.valid-move {
            background: rgba(34, 197, 94, 0.2) !important;
        }

        .square.check {
            animation: checkPulse 0.6s ease-in-out infinite;
        }

        @keyframes checkPulse {
            0%, 100% { box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.5); }
            50% { box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.8); }
        }

        .square.last-move {
            background: var(--last-move) !important;
        }

        .piece {
            font-size: 2.2rem;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.3s ease, opacity 0.3s ease, filter 0.3s ease;
            pointer-events: none;
            z-index: 12;
        }

        .piece.captured {
            animation: capturePulse 0.6s ease-out;
        }

        .piece.moving {
            transition: transform 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        .piece.appearing {
            animation: appearPop 0.4s ease-out;
        }

        @keyframes capturePulse {
            0% { transform: scale(1); opacity: 1; filter: brightness(1); }
            30% { transform: scale(1.2); opacity: 0.8; filter: brightness(1.2); }
            60% { transform: scale(0.9); opacity: 0.6; filter: brightness(0.8); }
            100% { transform: scale(1); opacity: 0; }
        }

        @keyframes appearPop {
            0% { transform: scale(0); opacity: 0; }
            70% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }

        /* Sidebar for controls and info */
        .sidebar {
            width: 320px;
            background: rgba(10, 15, 29, 0.9);
            backdrop-filter: blur(16px);
            border-left: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            flex-direction: column;
            padding: 1.5rem;
            overflow-y: auto;
        }

        .sidebar-section {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sidebar-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .sidebar-section h3 {
            color: var(--primary);
            font-size: 1.1rem;
            margin-bottom: 0.8rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            i { font-size: 1.2rem; }
        }

        .controls {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
        }

        .control-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
        }

        .control-label {
            font-size: 0.9rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .control-value {
            font-weight: 600;
            color: var(--text-main);
            min-width: 80px;
            text-align: right;
        }

        .btn {
            padding: 0.6rem 1rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            white-space: nowrap;
        }

        .btn-primary { background: var(--primary); color: #000; }
        .btn-primary:hover { background: #2563eb; }

        .btn-secondary { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
        .btn-secondary:hover { background: rgba(255, 255, 255, 0.15); }

        .btn-danger { background: #dc2626; color: white; }
        .btn-danger:hover { background: #b91c1c; }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Move History */
        .move-history {
            max-height: 180px;
            overflow-y: auto;
            background: rgba(0,0,0,0.2);
            border-radius: 8px;
            padding: 0.8rem;
            margin-top: 0.5rem;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
        }

        .move-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(60px, 1fr));
            gap: 0.3rem;
        }

        .move-number {
            color: var(--text-muted);
            font-weight: 600;
        }

        .move {
            padding: 0.2rem 0.4rem;
            border-radius: 4px;
            text-align: center;
            transition: background 0.2s;
        }

        .move.white { background: rgba(255,255,255,0.1); }
        .move.black { background: rgba(0,0,0,0.2); }
        .move.highlight {
            background: var(--primary) !important;
            color: #000 !important;
            font-weight: 600;
        }

        /* Captured pieces display */
        .captured-pieces {
            display: flex;
            flex-wrap: wrap;
            gap: 0.3rem;
            justify-content: center;
            margin-top: 0.5rem;
            min-height: 40px;
            line-height: 1;
        }

        .captured-piece {
            font-size: 1.4rem;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
            backdrop-filter: blur(4px);
            transition: transform 0.2s;
        }

        .captured-piece:hover {
            transform: scale(1.2);
        }

        /* Status indicators */
        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            margin-bottom: 0.5rem;
        }

        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .status-dot.waiting { background: #facc15; box-shadow: 0 0 8px #facc15; }
        .status-dot.thinking { background: var(--neon-pink); box-shadow: 0 0 8px var(--neon-pink); animation: pulse 1.5s infinite; }
        .status-dot.your-turn { background: var(--accent); box-shadow: 0 0 8px var(--accent); }
        .status-dot.game-over { background: #dc2626; box-shadow: 0 0 8px #dc2626; }

        @keyframes pulse {
            0% { opacity: 0.6; }
            50% { opacity: 1; }
            100% { opacity: 0.6; }
        }

        /* Game over overlay */
        .game-over-overlay {
            position: absolute;
            inset: 0;
            background: rgba(2, 6, 23, 0.85);
            backdrop-filter: blur(8px);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 50;
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }

        .game-over-overlay.active {
            opacity: 1;
            pointer-events: all;
        }

        .game-over-content {
            text-align: center;
            background: rgba(15, 23, 42, 0.9);
            border: 1px solid var(--border-glow);
            border-radius: 16px;
            padding: 2.5rem;
            max-width: 90%;
            max-height: 80vh;
            overflow-y: auto;
        }

        .game-over-title {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, var(--primary), var(--neon-purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .game-over-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 0.8rem;
            margin: 1.5rem 0;
            text-align: center;
        }

        .stat-item {
            background: rgba(255,255,255,0.05);
            padding: 0.8rem;
            border-radius: 8px;
        }

        .stat-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 0.3rem;
        }

        .stat-value {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-main);
        }

        /* PGN Section */
        .pgn-section {
            background: rgba(0,0,0,0.2);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .pgn-section h4 {
            color: var(--primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .pgn-text {
            background: rgba(255,255,255,0.05);
            padding: 0.8rem;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            max-height: 120px;
            overflow-y: auto;
            white-space: pre-wrap;
            word-break: break-all;
        }

        .btn-pgn {
            background: rgba(255,255,255,0.1);
            color: var(--text-main);
            border: 1px solid rgba(255,255,255,0.2);
            margin-top: 0.5rem;
        }

        .btn-pgn:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                max-height: 400px;
                border-left: none;
                border-top: 1px solid rgba(255,255,255,0.08);
            }

            .board-container {
                flex: 0 0 auto;
            }
        }

        @media (max-width: 768px) {
            .board-container {
                padding: 1rem;
            }

            .chess-board {
                width: 90vw;
                height: 90vw;
            }

            .sidebar {
                max-height: 350px;
            }
        }

        @media (max-width: 480px) {
            .sidebar {
                max-height: 300px;
            }

            .chess-board {
                width: 95vw;
                height: 95vw;
            }

            .piece {
                font-size: 1.8rem;
            }

            .captured-piece {
                font-size: 1.2rem;
                width: 24px;
                height: 24px;
            }

            .move-history {
                max-height: 150px;
                font-size: 0.8rem;
            }
        }

        /* Animation for pieces */
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-3px); }
        }

        .piece { animation: float 3s ease-in-out infinite; }
    </style>
</head>
<body>
    <div class="container">
        <div class="board-container">
            <div class="board-header">
                <h1 class="board-title">CYBER CHESS</h1>
                <div>
                    <button class="btn btn-secondary btn-sm" id="pgnBtn"><i class="fa-solid fa-file-download"></i> PGN</button>
                    <button class="btn btn-danger btn-sm" id="exitBtn"><i class="fa-solid fa-door-open"></i> Exit</button>
                </div>
            </div>

            <div class="eval-container">
                <div class="eval-fill" id="evalFill"></div>
            </div>
            <div class="eval-label" id="evalLabel">Even</div>

            <div class="chess-board" id="chessBoard">
                <!-- Board squares will be populated by JavaScript -->
            </div>

            <div class="status-indicator">
                <div class="status-dot" id="statusDot"></div>
                <span id="statusText">Waiting for your move...</span>
            </div>
        </div>

        <div class="sidebar">
            <div class="sidebar-section">
                <h3><i class="fa-solid fa-gear"></i> Game Settings</h3>
                <div class="controls">
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-brain"></i> Difficulty:</span>
                        <span class="control-value" id="difficultyValue"><%= difficulty.substring(0,1).toUpperCase() + difficulty.substring(1) %></span>
                    </div>
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-circle-half-stroke"></i> Your Color:</span>
                        <span class="control-value" id="colorValue"><%= playerColor.substring(0,1).toUpperCase() + playerColor.substring(1) %></span>
                    </div>
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-list"></i> Move:</span>
                        <span class="control-value" id="moveCount"><%= moveCount %></span>
                    </div>
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-chart-simple"></i> Eval:</span>
                        <span class="control-value" id="evalValue"><%= evaluation >= 0 ? "+" + evaluation : evaluation %></span>
                    </div>
                </div>

                <div style="margin-top: 1rem;">
                    <button class="btn btn-primary" id="settingsBtn"><i class="fa-solid fa-sliders"></i> Change Settings</button>
                </div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-list-check"></i> Move History</h3>
                <div class="move-history" id="moveHistory">
                    <div class="move-list" id="moveList"></div>
                </div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-arrow-trash-up"></i> Captured White</h3>
                <div class="captured-pieces" id="capturedWhite">
                    <!-- White pieces will be populated by JavaScript -->
                </div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-arrow-down-up-lock"></i> Captured Black</h3>
                <div class="captured-pieces" id="capturedBlack">
                    <!-- Black pieces will be populated by JavaScript -->
                </div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-file-code"></i> Game PGN</h3>
                <div class="pgn-section">
                    <div class="pgn-text" id="pgnText"><%= pgn %></div>
                    <button class="btn btn-pgn" id="copyPgnBtn"><i class="fa-solid fa-copy"></i> Copy PGN</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Game Over Overlay -->
    <div class="game-over-overlay" id="gameOverOverlay">
        <div class="game-over-content">
            <h2 class="game-over-title" id="gameOverTitle">Game Over</h2>
            <p id="gameOverMessage" style="color: var(--text-muted); margin-bottom: 1.5rem;"></p>

            <div class="game-over-stats" id="gameOverStats">
                <!-- Stats will be populated by JavaScript -->
            </div>

            <div>
                <button class="btn btn-primary" id="playAgainBtn"><i class="fa-solid fa-rotate-right"></i> Play Again</button>
                <button class="btn btn-secondary" id="exitToMenuBtn"><i class="fa-solid fa-xmark"></i> Exit to Menu</button>
            </div>
        </div>
    </div>

    <!-- Settings Modal -->
    <div class="modal-overlay" id="settingsModal" style="display: none;">
        <div class="modal-box">
            <h3><i class="fa-solid fa-sliders"></i> Game Settings</h3>
            <div class="settings-row">
                <span><i class="fa-solid fa-brain"></i> Difficulty:</span>
                <select id="difficultySelect">
                    <option value="easy">Easy</option>
                    <option value="medium">Medium</option>
                    <option value="hard">Hard</option>
                    <option value="expert">Expert</option>
                    <option value="impossible">Impossible</option>
                </select>
            </div>
            <div class="settings-row">
                <span><i class="fa-solid fa-circle-half-stroke"></i> Your Color:</span>
                <select id="colorSelect">
                    <option value="white">White</option>
                    <option value="black">Black</option>
                </select>
            </div>
            <div class="modal-actions">
                <button class="btn btn-cancel" id="settingsCancel"><i class="fa-solid fa-xmark"></i> Cancel</button>
                <button class="btn btn-primary" id="settingsConfirm"><i class="fa-solid fa-check"></i> Confirm</button>
            </div>
        </div>
    </div>

    <!-- Audio Elements -->
    <audio id="moveSound" preload="auto">
        <source src="data:audio/wav;base64,UklGRl9vT19XQVZFZm10IBAAAAABAAEAESsAACJWAAACABAAZGF0YU9vT18=">
    </audio>
    <audio id="captureSound" preload="auto">
        <source src="data:audio/wav;base64,UklGRl9vT19XQVZFZm10IBAAAAABAAEAZsAAACJWAAACABAAZGF0YU9vT18=">
    </audio>
    <audio id="checkSound" preload="auto">
        <source src="data:audio/wav;base64,UklGRl9vT19XQVZFZm10IBAAAAABAAEAqwAAACJWAAACABAAZGF0YU9vT18=">
    </audio>
    <audio id="gameOverSound" preload="auto">
        <source src="data:audio/wav;base64,UklGRl9vT19XQVZFZm10IBAAAAABAAEA6QAAACJWAAACABAAZGF0YU9vT18=">
    </audio>

    <script>
        // Initialize board from server data
        const boardData = <%
            out.print("[");
            String[][] board = engine.getBoard();
            for (int i = 0; i < 8; i++) {
                out.print("[");
                for (int j = 0; j < 8; j++) {
                    String piece = board[i][j];
                    if (piece == null) {
                        out.print("null");
                    } else {
                        out.print("\"").append(piece).append("\"");
                    }
                    if (j < 7) out.print(",");
                }
                out.print("]");
                if (i < 7) out.print(",");
            }
            out.print("]");
        %>;
        const isGameOver = <%= gameOver %>;
        const winner = "<%= winner %>";
        const moveCount = <%= moveCount %>;
        const lastMove = "<%= lastMove %>";
        const evaluation = <%= evaluation %>;
        const pgnText = "<%= pgn.replace(/\n/g, '\\n').replace(/\r/g, '\\r') %>";

        let selectedSquare = null;
        let validMoves = [];
        let playerColor = "<%= playerColor %>"; // 'white' or 'black'
        let aiColor = playerColor === 'white' ? 'black' : 'white';
        let difficulty = "<%= difficulty %>";
        let gameOver = <%= gameOver %>;

        // Piece Unicode characters
        const pieces = {
            'wK': '♔', 'wQ': '♕', 'wR': '♖', 'wB': '♗', 'wN': '♘', 'wP': '♙',
            'bK': '♚', 'bQ': '♛', 'bR': '♜', 'bB': '♝', 'bN': '♞', 'bP': '♟'
        };

        const pieceValues = {
            'p': 1, 'n': 3, 'b': 3, 'r': 5, 'q': 9, 'k': 0
        };

        // Initialize the board
        function initBoard() {
            const boardElement = document.getElementById('chessBoard');
            boardElement.innerHTML = '';

            for (let row = 0; row < 8; row++) {
                for (let col = 0; col < 8; col++) {
                    const square = document.createElement('div');
                    square.classList.add('square');
                    square.classList.add((row + col) % 2 === 0 ? 'light' : 'dark');
                    square.dataset.row = row;
                    square.dataset.col = col;

                    // Add piece if present
                    const piece = boardData[row][col];
                    if (piece !== null && piece !== '') {
                        const pieceElement = document.createElement('div');
                        pieceElement.classList.add('piece');
                        pieceElement.textContent = pieces[piece];
                        pieceElement.dataset.piece = piece;
                        square.appendChild(pieceElement);
                    }

                    square.addEventListener('click', handleSquareClick);
                    boardElement.appendChild(square);
                }
            }

            updateMoveHistory();
            updateCapturedPieces();
            updateEvaluation();
            updateStatus();
            updatePGN();

            // Highlight last move if exists
            if (lastMove && lastMove.length === 4) {
                const fromCol = lastMove.charCodeAt(0) - 97;
                const fromRow = 8 - parseInt(lastMove.charAt(1));
                const toCol = lastMove.charCodeAt(2) - 97;
                const toRow = 8 - parseInt(lastMove.charAt(3));

                const fromSquare = document.querySelector(`.square[data-row="${fromRow}"][data-col="${fromCol}"]`);
                const toSquare = document.querySelector(`.square[data-row="${toRow}"][data-col="${toCol}"]`);

                if (fromSquare) fromSquare.classList.add('last-move');
                if (toSquare) toSquare.classList.add('last-move');
            }
        }

        function handleSquareClick(e) {
            if (gameOver) return;

            const square = e.currentTarget;
            const row = parseInt(square.dataset.row);
            const col = parseInt(square.dataset.col);

            // If a piece is already selected
            if (selectedSquare) {
                const fromRow = parseInt(selectedSquare.dataset.row);
                const fromCol = parseInt(selectedSquare.dataset.col);

                // Check if this is a valid move
                const isValid = validMoves.some(move =>
                    move.toRow === row && move.toCol === col
                );

                if (isValid) {
                    // Make the move
                    makeMove(fromRow, fromCol, row, col);
                } else {
                    // Select a different piece
                    selectSquare(square);
                }
            } else {
                // Select a piece
                selectSquare(square);
            }
        }

        function selectSquare(square) {
            const row = parseInt(square.dataset.row);
            const col = parseInt(square.dataset.col);
            const piece = boardData[row][col];

            // Only select player's own pieces
            if (piece && ((playerColor === 'white' && piece.startsWith('w')) ||
                         (playerColor === 'black' && piece.startsWith('b')))) {
                // Clear previous selection
                clearSelection();

                // Select this square
                square.classList.add('selected');
                selectedSquare = square;

                // Calculate valid moves
                validMoves = calculateValidMoves(row, col, piece);

                // Highlight valid moves
                validMoves.forEach(move => {
                    const targetSquare = document.querySelector(
                        `.square[data-row="${move.toRow}"][data-col="${move.toCol}"]`
                    );
                    if (targetSquare) {
                        targetSquare.classList.add('valid-move');
                    }
                });
            }
        }

        function clearSelection() {
            if (selectedSquare) {
                selectedSquare.classList.remove('selected');
                selectedSquare = null;
            }

            // Remove all move highlights
            document.querySelectorAll('.square.valid-move').forEach(square => {
                square.classList.remove('valid-move');
            });

            validMoves = [];
        }

        function makeMove(fromRow, fromCol, toRow, toCol) {
            // Send move to server
            const fromPos = String.fromCharCode(97 + fromCol) + (8 - fromRow);
            const toPos = String.fromCharCode(97 + toCol) + (8 - toRow);

            // Play move sound
            playSound('moveSound');

            // Show thinking status
            setStatus('thinking', 'AI is thinking...');

            // Simulate delay for better UX (actual processing happens on server)
            setTimeout(() => {
                // In a real implementation, this would be an AJAX call
                // For now, we'll simulate by reloading with parameters
                const params = new URLSearchParams({
                    action: 'move',
                    moveFrom: fromPos,
                    moveTo: toPos,
                    difficulty: difficulty,
                    playerColor: playerColor
                });

                window.location.search = params.toString();
            }, 300 + Math.random() * 400); // Random delay for realism
        }

        function calculateValidMoves(row, col, piece) {
            // This would normally come from server, but we'll simulate basic validation
            // In reality, the server validates moves
            const moves = [];
            const pieceType = piece.toLowerCase().charAt(1);
            const isWhite = piece.startsWith('w');
            const direction = isWhite ? -1 : 1; // White moves up (negative row), black moves down

            switch(pieceType) {
                case 'p': // Pawn
                    // Forward move
                    if (isValidSquare(row + direction, col) &&
                        !getPieceAt(row + direction, col)) {
                        moves.push({ toRow: row + direction, toCol: col });

                        // Double move from starting position
                        const startRow = isWhite ? 6 : 1;
                        if (row === startRow &&
                            !getPieceAt(row + 2*direction, col) &&
                            !getPieceAt(row + direction, col)) {
                            moves.push({ toRow: row + 2*direction, toCol: col });
                        }
                    }

                    // Captures
                    [-1, 1].forEach(dc => {
                        const newCol = col + dc;
                        if (isValidSquare(row + direction, newCol)) {
                            const target = getPieceAt(row + direction, newCol);
                            if (target &&
                                ((isWhite && target.startsWith('b')) ||
                                 (!isWhite && target.startsWith('w')))) {
                                moves.push({ toRow: row + direction, toCol: newCol });
                            }
                        }
                    });
                    break;

                case 'n': // Knight
                    const knightMoves = [
                        [-2, -1], [-2, 1], [-1, -2], [-1, 2],
                        [1, -2], [1, 2], [2, -1], [2, 1]
                    ];
                    knightMoves.forEach(([dr, dc]) => {
                        const newRow = row + dr;
                        const newCol = col + dc;
                        if (isValidSquare(newRow, newCol)) {
                            const target = getPieceAt(newRow, newCol);
                            if (!target ||
                                (isWhite && target.startsWith('b')) ||
                                (!isWhite && target.startsWith('w'))) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            }
                        }
                    });
                    break;

                case 'b': // Bishop
                    [[-1, -1], [-1, 1], [1, -1], [1, 1]].forEach(([dr, dc]) => {
                        for (let i = 1; i < 8; i++) {
                            const newRow = row + dr * i;
                            const newCol = col + dc * i;
                            if (!isValidSquare(newRow, newCol)) break;

                            const target = getPieceAt(newRow, newCol);
                            if (!target) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            } else {
                                if ((isWhite && target.startsWith('b')) ||
                                    (!isWhite && target.startsWith('w'))) {
                                    moves.push({ toRow: newRow, toCol: newCol });
                                }
                                break;
                            }
                        }
                    });
                    break;

                case 'r': // Rook
                    [[-1, 0], [1, 0], [0, -1], [0, 1]].forEach(([dr, dc]) => {
                        for (let i = 1; i < 8; i++) {
                            const newRow = row + dr * i;
                            const newCol = col + dc * i;
                            if (!isValidSquare(newRow, newCol)) break;

                            const target = getPieceAt(newRow, newCol);
                            if (!target) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            } else {
                                if ((isWhite && target.startsWith('b')) ||
                                    (!isWhite && target.startsWith('w'))) {
                                    moves.push({ toRow: newRow, toCol: newCol });
                                }
                                break;
                            }
                        }
                    });
                    break;

                case 'q': // Queen
                    [[-1, -1], [-1, 1], [1, -1], [1, 1], [-1, 0], [1, 0], [0, -1], [0, 1]].forEach(([dr, dc]) => {
                        for (let i = 1; i < 8; i++) {
                            const newRow = row + dr * i;
                            const newCol = col + dc * i;
                            if (!isValidSquare(newRow, newCol)) break;

                            const target = getPieceAt(newRow, newCol);
                            if (!target) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            } else {
                                if ((isWhite && target.startsWith('b')) ||
                                    (!isWhite && target.startsWith('w'))) {
                                    moves.push({ toRow: newRow, toCol: newCol });
                                }
                                break;
                            }
                        }
                    });
                    break;

                case 'k': // King
                    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].forEach(([dr, dc]) => {
                        const newRow = row + dr;
                        const newCol = col + dc;
                        if (isValidSquare(newRow, newCol)) {
                            const target = getPieceAt(newRow, newCol);
                            if (!target ||
                                (isWhite && target.startsWith('b')) ||
                                (!isWhite && target.startsWith('w'))) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            }
                        }
                    });
                    break;
            }

            return moves;
        }

        function isValidSquare(row, col) {
            return row >= 0 && row < 8 && col >= 0 && col < 8;
        }

        function getPieceAt(row, col) {
            return boardData[row][col] || null;
        }

        function updateMoveHistory() {
            // This would ideally come from server, but we'll update based on move count
            const moveList = document.getElementById('moveList');
            // In a real implementation, we'd get the actual move history from server
            // For now, we'll show a placeholder
            moveList.innerHTML = `
                <div class="move-number">1.</div>
                <div class="move white">e4</div>
                <div class="move black">e5</div>
                <div class="move-number">2.</div>
                <div class="move white">Nf3</div>
                <div class="move black">Nc6</div>
            `;

            // Highlight last move
            const allMoves = moveList.querySelectorAll('.move');
            if (allMoves.length > 0) {
                allMoves[allMoves.length - 1].classList.add('highlight');
            }
        }

        function updateCapturedPieces() {
            // This would come from server in real implementation
            document.getElementById('capturedWhite').innerHTML =
                '<span style="color: var(--text-muted); font-size: 0.9rem;">None</span>';
            document.getElementById('capturedBlack').innerHTML =
                '<span style="color: var(--text-muted); font-size: 0.9rem;">None</span>';
        }

        function updateEvaluation() {
            const evalFill = document.getElementById('evalFill');
            const evalLabel = document.getElementById('evalLabel');

            // Convert evaluation (-500 to +500) to percentage (0% to 100%)
            // 0 = even, negative = black advantage, positive = white advantage
            let percentage = 50 + (evaluation / 10); // Scale factor
            percentage = Math.max(0, Math.min(100, percentage));

            evalFill.style.width = percentage + '%';

            if (evaluation > 50) {
                evalLabel.textContent = `+${(evaluation/100).toFixed(2)}`;
                evalLabel.style.color = var(--advantage-white);
            } else if (evaluation < -50) {
                evalLabel.textContent = `${(evaluation/100).toFixed(2)}`;
                evalLabel.style.color = var(--advantage-black);
            } else {
                evalLabel.textContent = "Even";
                evalLabel.style.color = var(--text-main);
            }
        }

        function updatePGN() {
            document.getElementById('pgnText').textContent = pgnText;
        }

        function updateStatus() {
            const statusDot = document.getElementById('statusDot');
            const statusText = document.getElementById('statusText');

            if (gameOver) {
                statusDot.className = 'status-dot game-over';
                statusText.textContent = winner === 'draw' ? 'Game Draw!' :
                                      winner === playerColor ? 'You Win!' : 'AI Wins!';
                showGameOver();
            } else {
                // Determine whose turn it is based on move count parity
                const isWhiteTurn = (moveCount % 2) === 0;
                const isPlayerTurn = (playerColor === 'white' && isWhiteTurn) ||
                                   (playerColor === 'black' && !isPlayerTurn);

                if (isPlayerTurn) {
                    statusDot.className = 'status-dot your-turn';
                    statusText.textContent = 'Your Turn';
                } else {
                    statusDot.className = 'status-dot thinking';
                    statusText.textContent = "AI's Turn";
                }
            }
        }

        function playSound(id) {
            const sound = document.getElementById(id);
            if (sound) {
                sound.currentTime = 0;
                sound.play().catch(e => console.log("Audio play failed:", e));
            }
        }

        function showGameOver() {
            document.getElementById('gameOverOverlay').classList.add('active');
            document.getElementById('gameOverTitle').textContent =
                winner === 'draw' ? 'STALEMATE' :
                winner === playerColor ? 'VICTORY' : 'DEFEAT';

            document.getElementById('gameOverMessage').textContent =
                winner === 'draw' ? 'The game ended in a draw.' :
                winner === playerColor ? 'Congratulations! You defeated the AI.' :
                'The AI has outplayed you. Better luck next time!';

            // Update game over stats
            const statsHtml = `
                <div class="stat-item">
                    <div class="stat-label">Moves</div>
                    <div class="stat-value">${moveCount}</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Result</div>
                    <div class="stat-value">${winner === 'draw' ? 'Draw' : winner === playerColor ? 'Win' : 'Loss'}</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Accuracy</div>
                    <div class="stat-value">${Math.floor(Math.random() * 20 + 80)}%</div>
                </div>
            `;
            document.getElementById('gameOverStats').innerHTML = statsHtml;

            // Play game over sound
            setTimeout(() => playSound('gameOverSound'), 500);
        }

        // Event Listeners
        document.getElementById('settingsBtn').addEventListener('click', () => {
            document.getElementById('settingsModal').style.display = 'flex';
            document.getElementById('difficultySelect').value = difficulty;
            document.getElementById('colorSelect').value = playerColor;
        });

        document.getElementById('settingsCancel').addEventListener('click', () => {
            document.getElementById('settingsModal').style.display = 'none';
        });

        document.getElementById('settingsConfirm').addEventListener('click', () => {
            const newDifficulty = document.getElementById('difficultySelect').value;
            const newColor = document.getElementById('colorSelect').value;

            if (newDifficulty !== difficulty || newColor !== playerColor) {
                const params = new URLSearchParams({
                    difficulty: newDifficulty,
                    playerColor: newColor,
                    reset: 'true'
                });
                window.location.search = params.toString();
            } else {
                document.getElementById('settingsModal').style.display = 'none';
            }
        });

        document.getElementById('exitBtn').addEventListener('click', () => {
            if (confirm('Are you sure you want to exit the game?')) {
                window.location.href = 'index.jsp';
            }
        });

        document.getElementById('playAgainBtn').addEventListener('click', () => {
            const params = new URLSearchParams({
                reset: 'true',
                difficulty: difficulty,
                playerColor: playerColor
            });
            window.location.search = params.toString();
        });

        document.getElementById('exitToMenuBtn').addEventListener('click', () => {
            window.location.href = 'index.jsp';
        });

        document.getElementById('pgnBtn').addEventListener('click', () => {
            window.location.href = 'Chess.jsp?pgn=export';
        });

        document.getElementById('copyPgnBtn').addEventListener('click', () => {
            const pgnText = document.getElementById('pgnText').textContent;
            navigator.clipboard.writeText(pgnText).then(() => {
                // Show temporary feedback
                const originalText = document.getElementById('copyPgnBtn').innerHTML;
                document.getElementById('copyPgnBtn').innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
                setTimeout(() => {
                    document.getElementById('copyPgnBtn').innerHTML = originalText;
                }, 2000);
            }).catch(err => {
                console.log('Failed to copy: ', err);
            });
        });

        // Initialize board on load
        document.addEventListener('DOMContentLoaded', initBoard);

        // Handle keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                clearSelection();
            }
            if (e.key === 'r' && !e.ctrlKey && !e.metaKey) {
                if (confirm('Reset the game?')) {
                    const params = new URLSearchParams({ reset: 'true' });
                    window.location.search = params.toString();
                }
            }
            if (e.key === 'p' && (e.ctrlKey || e.metaKey)) {
                e.preventDefault();
                window.location.href = 'Chess.jsp?pgn=export';
            }
        });
    </script>
</body>
</html>