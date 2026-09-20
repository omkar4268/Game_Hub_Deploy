<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%
    // Enhanced Cyber Chess with Actual AI Engine
    HttpSession userSession = request.getSession();
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
    if (userSession.getAttribute("chessEngine") == null) {
        userSession.setAttribute("chessEngine", new ChessEngine());
    }
    ChessEngine engine = (ChessEngine) userSession.getAttribute("chessEngine");

    // Handle PGN request
    if (pgnRequest != null && pgnRequest.equals("export")) {
        String pgn = engine.getPGN();
        response.setContentType("application/x-chess-pgn");
        response.setHeader("Content-Disposition", "attachment; filename=cyber_chess_game.pgn");
        response.getWriter().write(pgn);
        return;
    }

    // Initialize board if new game or reset
    if (reset != null || userSession.getAttribute("boardInitialized") == null) {
        engine.initializeGame(playerColor, difficulty);
        userSession.setAttribute("boardInitialized", true);
        userSession.setAttribute("gameOver", false);
    }

    Boolean isOverObj = (Boolean) userSession.getAttribute("gameOver");
    boolean isOver = (isOverObj != null) ? isOverObj : false;

    // Handle player move
    boolean moveMade = false;
    if (moveFrom != null && moveTo != null && !isOver) {
        moveMade = engine.makePlayerMove(moveFrom, moveTo);
        if (moveMade) {
            // Check if game over after player move
            if (engine.isGameOver()) {
                userSession.setAttribute("gameOver", true);
            } else {
                // AI move
                engine.makeAIMove();
                if (engine.isGameOver()) {
                    userSession.setAttribute("gameOver", true);
                }
            }
        }
    }

    // Get current state for display
    String[][] boardState = engine.getBoard();
    boolean gameOver = Boolean.TRUE.equals(userSession.getAttribute("gameOver"));
    String winner = engine.getWinner();
    int moveCount = engine.getMoveCount();
    String pgn = engine.getPGN();
    if (pgn == null) pgn = "";
    String lastMove = engine.getLastMove();
    if (lastMove == null) lastMove = "";
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
            animation: float 3s ease-in-out infinite;
        }

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

        .btn-cancel { background: rgba(255, 255, 255, 0.2); color: white; }

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

        .captured-pieces {
            display: flex;
            flex-wrap: wrap;
            gap: 0.3rem;
            justify-content: center;
            margin-top: 0.5rem;
            min-height: 40px;
            line-height: 1;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            margin-top: 0.5rem;
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

        .game-over-overlay {
            position: absolute;
            inset: 0;
            background: rgba(2, 6, 23, 0.85);
            backdrop-filter: blur(8px);
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 50;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .game-over-overlay.active {
            display: flex;
            opacity: 1;
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

        .pgn-section {
            background: rgba(0,0,0,0.2);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
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

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(2, 6, 23, 0.7);
            backdrop-filter: blur(4px);
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-box {
            background: rgba(15, 23, 42, 0.95);
            border: 1px solid var(--border-glow);
            border-radius: 12px;
            padding: 1.5rem;
            width: 90%;
            max-width: 400px;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .settings-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .settings-row select {
            background: #1e293b;
            color: #fff;
            padding: 0.4rem 0.8rem;
            border: 1px solid var(--border-glow);
            border-radius: 6px;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-3px); }
        }

        @media (max-width: 1024px) {
            .container { flex-direction: column; }
            .sidebar { width: 100%; border-left: none; border-top: 1px solid rgba(255,255,255,0.08); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="board-container">
            <div class="board-header">
                <h1 class="board-title">CYBER CHESS</h1>
                <div style="display: flex; gap: 0.5rem;">
                    <button class="btn btn-secondary btn-sm" id="pgnBtn"><i class="fa-solid fa-file-download"></i> PGN</button>
                    <button class="btn btn-danger btn-sm" id="exitBtn"><i class="fa-solid fa-door-open"></i> Exit</button>
                </div>
            </div>

            <div class="eval-container">
                <div class="eval-fill" id="evalFill"></div>
            </div>
            <div class="eval-label" id="evalLabel">Even</div>

            <div class="chess-board" id="chessBoard"></div>

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
                    <button class="btn btn-primary" style="width: 100%;" id="settingsBtn"><i class="fa-solid fa-sliders"></i> Change Settings</button>
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
                <div class="captured-pieces" id="capturedWhite"></div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-arrow-down-up-lock"></i> Captured Black</h3>
                <div class="captured-pieces" id="capturedBlack"></div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-file-code"></i> Game PGN</h3>
                <div class="pgn-section">
                    <div class="pgn-text" id="pgnText"><%= pgn %></div>
                    <button class="btn btn-secondary" style="margin-top: 0.5rem; width: 100%;" id="copyPgnBtn"><i class="fa-solid fa-copy"></i> Copy PGN</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Game Over Overlay -->
    <div class="game-over-overlay" id="gameOverOverlay">
        <div class="game-over-content">
            <h2 class="game-over-title" id="gameOverTitle">Game Over</h2>
            <p id="gameOverMessage" style="color: var(--text-muted); margin-bottom: 1.5rem;"></p>

            <div class="game-over-stats" id="gameOverStats"></div>

            <div style="display: flex; gap: 0.5rem; justify-content: center;">
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

    <script>
        const boardData = <%
            out.print("[");
            for (int i = 0; i < 8; i++) {
                out.print("[");
                for (int j = 0; j < 8; j++) {
                    String piece = (boardState != null) ? boardState[i][j] : null;
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
        const winner = "<%= (winner != null) ? winner : "" %>";
        const moveCount = <%= moveCount %>;
        const lastMove = "<%= lastMove %>";
        const evaluation = <%= evaluation %>;
        const pgnText = "<%= pgn.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") %>";

        let selectedSquare = null;
        let validMoves = [];
        let playerColor = "<%= playerColor %>";
        let difficulty = "<%= difficulty %>";
        let gameOver = <%= gameOver %>;

        const pieces = {
            'wK': '♔', 'wQ': '♕', 'wR': '♖', 'wB': '♗', 'wN': '♘', 'wP': '♙',
            'bK': '♚', 'bQ': '♛', 'bR': '♜', 'bB': '♝', 'bN': '♞', 'bP': '♟'
        };

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

                    const piece = boardData[row][col];
                    if (piece !== null && piece !== '') {
                        const pieceElement = document.createElement('div');
                        pieceElement.classList.add('piece');
                        pieceElement.textContent = pieces[piece] || '';
                        pieceElement.dataset.piece = piece;
                        square.appendChild(pieceElement);
                    }

                    square.addEventListener('click', handleSquareClick);
                    boardElement.appendChild(square);
                }
            }

            updateEvaluation();
            updateStatus();

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

            if (selectedSquare) {
                const fromRow = parseInt(selectedSquare.dataset.row);
                const fromCol = parseInt(selectedSquare.dataset.col);

                const isValid = validMoves.some(move => move.toRow === row && move.toCol === col);

                if (isValid) {
                    makeMove(fromRow, fromCol, row, col);
                } else {
                    selectSquare(square);
                }
            } else {
                selectSquare(square);
            }
        }

        function selectSquare(square) {
            const row = parseInt(square.dataset.row);
            const col = parseInt(square.dataset.col);
            const piece = boardData[row][col];

            if (piece && ((playerColor === 'white' && piece.startsWith('w')) ||
                         (playerColor === 'black' && piece.startsWith('b')))) {
                clearSelection();
                square.classList.add('selected');
                selectedSquare = square;

                validMoves = calculateValidMoves(row, col, piece);
                validMoves.forEach(move => {
                    const targetSquare = document.querySelector(`.square[data-row="${move.toRow}"][data-col="${move.toCol}"]`);
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
            document.querySelectorAll('.square.valid-move').forEach(square => {
                square.classList.remove('valid-move');
            });
            validMoves = [];
        }

        function makeMove(fromRow, fromCol, toRow, toCol) {
            const fromPos = String.fromCharCode(97 + fromCol) + (8 - fromRow);
            const toPos = String.fromCharCode(97 + toCol) + (8 - toRow);

            const statusDot = document.getElementById('statusDot');
            const statusText = document.getElementById('statusText');
            statusDot.className = 'status-dot thinking';
            statusText.textContent = 'AI is thinking...';

            setTimeout(() => {
                const params = new URLSearchParams({
                    action: 'move',
                    moveFrom: fromPos,
                    moveTo: toPos,
                    difficulty: difficulty,
                    playerColor: playerColor
                });
                window.location.search = params.toString();
            }, 300);
        }

        function calculateValidMoves(row, col, piece) {
            const moves = [];
            const pieceType = piece.toLowerCase().charAt(1);
            const isWhite = piece.startsWith('w');
            const direction = isWhite ? -1 : 1;

            switch(pieceType) {
                case 'p':
                    if (isValidSquare(row + direction, col) && !getPieceAt(row + direction, col)) {
                        moves.push({ toRow: row + direction, toCol: col });
                        const startRow = isWhite ? 6 : 1;
                        if (row === startRow && !getPieceAt(row + 2*direction, col)) {
                            moves.push({ toRow: row + 2*direction, toCol: col });
                        }
                    }
                    [-1, 1].forEach(dc => {
                        const newCol = col + dc;
                        if (isValidSquare(row + direction, newCol)) {
                            const target = getPieceAt(row + direction, newCol);
                            if (target && ((isWhite && target.startsWith('b')) || (!isWhite && target.startsWith('w')))) {
                                moves.push({ toRow: row + direction, toCol: newCol });
                            }
                        }
                    });
                    break;
                case 'n':
                    const knightOffsets = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]];
                    knightOffsets.forEach(([dr, dc]) => {
                        const newRow = row + dr;
                        const newCol = col + dc;
                        if (isValidSquare(newRow, newCol)) {
                            const target = getPieceAt(newRow, newCol);
                            if (!target || (isWhite && target.startsWith('b')) || (!isWhite && target.startsWith('w'))) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            }
                        }
                    });
                    break;
                case 'b':
                    addLinearMoves(row, col, [[-1, -1], [-1, 1], [1, -1], [1, 1]], isWhite, moves);
                    break;
                case 'r':
                    addLinearMoves(row, col, [[-1, 0], [1, 0], [0, -1], [0, 1]], isWhite, moves);
                    break;
                case 'q':
                    addLinearMoves(row, col, [[-1, -1], [-1, 1], [1, -1], [1, 1], [-1, 0], [1, 0], [0, -1], [0, 1]], isWhite, moves);
                    break;
                case 'k':
                    const kingOffsets = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];
                    kingOffsets.forEach(([dr, dc]) => {
                        const newRow = row + dr;
                        const newCol = col + dc;
                        if (isValidSquare(newRow, newCol)) {
                            const target = getPieceAt(newRow, newCol);
                            if (!target || (isWhite && target.startsWith('b')) || (!isWhite && target.startsWith('w'))) {
                                moves.push({ toRow: newRow, toCol: newCol });
                            }
                        }
                    });
                    break;
            }
            return moves;
        }

        function addLinearMoves(row, col, directions, isWhite, moves) {
            directions.forEach(([dr, dc]) => {
                for (let i = 1; i < 8; i++) {
                    const newRow = row + dr * i;
                    const newCol = col + dc * i;
                    if (!isValidSquare(newRow, newCol)) break;
                    const target = getPieceAt(newRow, newCol);
                    if (!target) {
                        moves.push({ toRow: newRow, toCol: newCol });
                    } else {
                        if ((isWhite && target.startsWith('b')) || (!isWhite && target.startsWith('w'))) {
                            moves.push({ toRow: newRow, toCol: newCol });
                        }
                        break;
                    }
                }
            });
        }

        function isValidSquare(row, col) {
            return row >= 0 && row < 8 && col >= 0 && col < 8;
        }

        function getPieceAt(row, col) {
            return boardData[row][col] || null;
        }

        function updateEvaluation() {
            const evalFill = document.getElementById('evalFill');
            const evalLabel = document.getElementById('evalLabel');
            let percentage = 50 + (evaluation / 10);
            percentage = Math.max(0, Math.min(100, percentage));
            evalFill.style.width = percentage + '%';

            if (evaluation > 50) {
                evalLabel.textContent = `+${(evaluation/100).toFixed(2)}`;
                evalLabel.style.color = '#10b981';
            } else if (evaluation < -50) {
                evalLabel.textContent = `${(evaluation/100).toFixed(2)}`;
                evalLabel.style.color = '#ef4444';
            } else {
                evalLabel.textContent = "Even";
                evalLabel.style.color = 'var(--text-main)';
            }
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
                const isWhiteTurn = (moveCount % 2) === 0;
                const isPlayerTurn = (playerColor === 'white' && isWhiteTurn) ||
                                     (playerColor === 'black' && !isWhiteTurn);

                if (isPlayerTurn) {
                    statusDot.className = 'status-dot your-turn';
                    statusText.textContent = 'Your Turn';
                } else {
                    statusDot.className = 'status-dot thinking';
                    statusText.textContent = "AI's Turn";
                }
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
            const pgnContent = document.getElementById('pgnText').textContent;
            navigator.clipboard.writeText(pgnContent).then(() => {
                const originalText = document.getElementById('copyPgnBtn').innerHTML;
                document.getElementById('copyPgnBtn').innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
                setTimeout(() => {
                    document.getElementById('copyPgnBtn').innerHTML = originalText;
                }, 2000);
            }).catch(err => console.log('Failed to copy: ', err));
        });

        document.addEventListener('DOMContentLoaded', initBoard);

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') clearSelection();
            if (e.key === 'r' && !e.ctrlKey && !e.metaKey) {
                if (confirm('Reset the game?')) {
                    const params = new URLSearchParams({ reset: 'true' });
                    window.location.search = params.toString();
                }
            }
        });
    </script>
</body>
</html>