<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>CYBER CHESS // NEURAL AI ENGINE</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-base: #05070e;
            --border-glow: rgba(56, 189, 248, 0.25);
            --primary: #38bdf8;
            --accent: #22c55e;
            --neon-pink: #f43f5e;
            --neon-purple: #a855f7;
            --text-main: #f8fafc;
            --text-muted: #64748b;
            --square-light: rgba(255, 255, 255, 0.08);
            --square-dark: rgba(0, 0, 0, 0.35);
            --move-highlight: rgba(56, 189, 248, 0.35);
            --last-move: rgba(16, 185, 129, 0.3);
            --danger-glow: rgba(244, 63, 94, 0.4);
            --advantage-white: #10b981;
            --advantage-black: #ef4444;
            --eval-bar-bg: rgba(255,255,255,0.1);
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
            max-width: 580px;
            margin-bottom: 0.5rem;
        }

        .board-title {
            font-size: 1.4rem;
            font-weight: 800;
            background: linear-gradient(90deg, var(--primary), var(--neon-purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 1px;
        }

        .eval-container {
            width: 100%;
            max-width: 580px;
            height: 8px;
            background: var(--eval-bar-bg);
            border-radius: 4px;
            overflow: hidden;
            margin: 0.5rem 0 0.8rem 0;
            position: relative;
        }

        .eval-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--advantage-black), #38bdf8, var(--advantage-white));
            transition: width 0.4s ease;
            position: absolute;
            top: 0;
            left: 0;
            width: 50%;
        }

        .eval-meta {
            display: flex;
            justify-content: space-between;
            width: 100%;
            max-width: 580px;
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-bottom: 0.4rem;
        }

        .chess-board {
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            grid-template-rows: repeat(8, 1fr);
            width: min(88vw, 580px);
            height: min(88vw, 580px);
            max-width: 580px;
            max-height: 580px;
            border: 2px solid var(--border-glow);
            border-radius: 12px;
            box-shadow: 0 0 35px rgba(56, 189, 248, 0.2);
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
            transition: background 0.2s, transform 0.2s;
            position: relative;
            z-index: 1;
        }

        .square.light { background-color: var(--square-light); }
        .square.dark { background-color: var(--square-dark); }
        .square:hover:not(.disabled) { z-index: 10; transform: scale(1.03); }
        .square.selected { background: var(--move-highlight) !important; box-shadow: inset 0 0 12px var(--primary); z-index: 11; }
        .square.valid-move { background: rgba(34, 197, 94, 0.28) !important; }
        .square.valid-move::after {
            content: '';
            width: 14px;
            height: 14px;
            background: #22c55e;
            border-radius: 50%;
            position: absolute;
            opacity: 0.7;
        }
        .square.last-move { background: var(--last-move) !important; }

        .piece {
            font-size: 2.2rem;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            pointer-events: none;
            z-index: 12;
            animation: float 3s ease-in-out infinite;
        }

        .sidebar {
            width: 320px;
            background: rgba(10, 15, 29, 0.95);
            backdrop-filter: blur(16px);
            border-left: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            flex-direction: column;
            padding: 1.2rem;
            overflow-y: auto;
            gap: 1.2rem;
        }

        .sidebar-section {
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        }

        .sidebar-section:last-child { border-bottom: none; }
        .sidebar-section h3 {
            color: var(--primary);
            font-size: 0.95rem;
            margin-bottom: 0.7rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            letter-spacing: 0.5px;
        }

        .controls { display: flex; flex-direction: column; gap: 0.6rem; }
        .control-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.45rem 0.7rem;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 6px;
        }

        .control-label { font-size: 0.85rem; color: var(--text-muted); display: flex; align-items: center; gap: 0.4rem; }
        .control-value { font-weight: 600; color: var(--text-main); font-size: 0.9rem; }

        .btn {
            padding: 0.55rem 0.9rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
        }

        .btn-primary { background: var(--primary); color: #000; }
        .btn-primary:hover { background: #0284c7; }
        .btn-secondary { background: rgba(255, 255, 255, 0.08); color: var(--text-main); }
        .btn-secondary:hover { background: rgba(255, 255, 255, 0.15); }
        .btn-danger { background: #dc2626; color: white; }
        .btn-danger:hover { background: #b91c1c; }

        .move-history {
            max-height: 140px;
            overflow-y: auto;
            background: rgba(0,0,0,0.3);
            border-radius: 6px;
            padding: 0.6rem;
            font-family: 'Courier New', monospace;
            font-size: 0.8rem;
        }

        .move-list { display: flex; flex-wrap: wrap; gap: 0.3rem; }
        .move { padding: 0.2rem 0.4rem; border-radius: 4px; background: rgba(255,255,255,0.08); }

        .captured-pieces {
            display: flex;
            flex-wrap: wrap;
            gap: 0.3rem;
            min-height: 35px;
            align-items: center;
        }

        .captured-piece { font-size: 1.3rem; }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 0.8rem;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            margin-top: 0.6rem;
            width: 100%;
            max-width: 580px;
        }

        .status-dot { width: 10px; height: 10px; border-radius: 50%; }
        .status-dot.thinking { background: var(--neon-pink); box-shadow: 0 0 8px var(--neon-pink); animation: pulse 1.2s infinite; }
        .status-dot.your-turn { background: var(--accent); box-shadow: 0 0 8px var(--accent); }
        .status-dot.game-over { background: #dc2626; box-shadow: 0 0 8px #dc2626; }

        @keyframes pulse { 0% { opacity: 0.5; } 50% { opacity: 1; } 100% { opacity: 0.5; } }

        .game-over-overlay {
            position: absolute;
            inset: 0;
            background: rgba(2, 6, 23, 0.88);
            backdrop-filter: blur(8px);
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 50;
        }

        .game-over-overlay.active { display: flex; }
        .game-over-content {
            text-align: center;
            background: rgba(15, 23, 42, 0.95);
            border: 1px solid var(--border-glow);
            border-radius: 12px;
            padding: 2rem;
            max-width: 90%;
        }

        @keyframes float { 0%, 100% { transform: translateY(0px); } 50% { transform: translateY(-2px); } }

        @media (max-width: 1024px) {
            .container { flex-direction: column; height: auto; }
            .sidebar { width: 100%; border-left: none; border-top: 1px solid rgba(255,255,255,0.08); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="board-container">
            <div class="board-header">
                <h1 class="board-title">CYBER CHESS <span style="font-size:0.75rem; color: var(--primary);">AI CORE</span></h1>
                <div style="display: flex; gap: 0.4rem;">
                    <button class="btn btn-secondary" id="resetBtn"><i class="fa-solid fa-rotate-right"></i> Reset</button>
                    <button class="btn btn-danger" id="exitBtn"><i class="fa-solid fa-door-open"></i> Exit</button>
                </div>
            </div>

            <div class="eval-meta">
                <span>Black Advantage</span>
                <span id="evalLabel">0.0</span>
                <span>White Advantage</span>
            </div>
            <div class="eval-container">
                <div class="eval-fill" id="evalFill"></div>
            </div>

            <div class="chess-board" id="chessBoard"></div>

            <div class="status-indicator">
                <div class="status-dot your-turn" id="statusDot"></div>
                <span id="statusText" style="font-size:0.85rem;">Your Turn (White)</span>
            </div>
        </div>

        <div class="sidebar">
            <div class="sidebar-section">
                <h3><i class="fa-solid fa-microchip"></i> Engine Status</h3>
                <div class="controls">
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-brain"></i> Depth:</span>
                        <span class="control-value">3 Plies (Minimax)</span>
                    </div>
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-bolt"></i> Positions Analyzed:</span>
                        <span class="control-value" id="nodesCount">0</span>
                    </div>
                    <div class="control-row">
                        <span class="control-label"><i class="fa-solid fa-list-ol"></i> Move:</span>
                        <span class="control-value" id="moveCount">0</span>
                    </div>
                </div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-list-check"></i> Move History</h3>
                <div class="move-history">
                    <div class="move-list" id="moveList"></div>
                </div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-arrow-trash-up"></i> Captured by AI</h3>
                <div class="captured-pieces" id="capturedWhite"><span style="color:var(--text-muted);font-size:0.8rem;">None</span></div>
            </div>

            <div class="sidebar-section">
                <h3><i class="fa-solid fa-arrow-down-up-lock"></i> Captured by You</h3>
                <div class="captured-pieces" id="capturedBlack"><span style="color:var(--text-muted);font-size:0.8rem;">None</span></div>
            </div>
        </div>
    </div>

    <div class="game-over-overlay" id="gameOverOverlay">
        <div class="game-over-content">
            <h2 id="gameOverTitle" style="font-size:1.8rem; margin-bottom: 0.8rem;">Checkmate</h2>
            <p id="gameOverMessage" style="color: var(--text-muted); margin-bottom: 1.5rem;"></p>
            <button class="btn btn-primary" style="margin: 0 auto;" id="playAgainBtn"><i class="fa-solid fa-rotate-right"></i> Play Again</button>
        </div>
    </div>

    <script>
        // Piece Base Weights
        const PIECE_WEIGHTS = { 'P': 100, 'N': 320, 'B': 330, 'R': 500, 'Q': 900, 'K': 20000 };

        // Positional Tables (PST) for AI strategic positional evaluation
        const PAWN_TABLE = [
            [0,  0,  0,  0,  0,  0,  0,  0],
            [50, 50, 50, 50, 50, 50, 50, 50],
            [10, 10, 20, 30, 30, 20, 10, 10],
            [5,  5, 10, 25, 25, 10,  5,  5],
            [0,  0,  0, 20, 20,  0,  0,  0],
            [5, -5,-10,  0,  0,-10, -5,  5],
            [5, 10, 10,-20,-20, 10, 10,  5],
            [0,  0,  0,  0,  0,  0,  0,  0]
        ];

        const KNIGHT_TABLE = [
            [-50,-40,-30,-30,-30,-30,-40,-50],
            [-40,-20,  0,  0,  0,  0,-20,-40],
            [-30,  0, 10, 15, 15, 10,  0,-30],
            [-30,  5, 15, 20, 20, 15,  5,-30],
            [-30,  0, 15, 20, 20, 15,  0,-30],
            [-30,  5, 10, 15, 15, 10,  5,-30],
            [-40,-20,  0,  5,  5,  0,-20,-40],
            [-50,-40,-30,-30,-30,-30,-40,-50]
        ];

        const BISHOP_TABLE = [
            [-20,-10,-10,-10,-10,-10,-10,-20],
            [-10,  0,  0,  0,  0,  0,  0,-10],
            [-10,  0,  5, 10, 10,  5,  0,-10],
            [-10,  5,  5, 10, 10,  5,  5,-10],
            [-10,  0, 10, 10, 10, 10,  0,-10],
            [-10, 10, 10, 10, 10, 10, 10,-10],
            [-10,  5,  0,  0,  0,  0,  5,-10],
            [-20,-10,-10,-10,-10,-10,-10,-20]
        ];

        const ROOK_TABLE = [
            [0,  0,  0,  0,  0,  0,  0,  0],
            [5, 10, 10, 10, 10, 10, 10,  5],
            [-5,  0,  0,  0,  0,  0,  0, -5],
            [-5,  0,  0,  0,  0,  0,  0, -5],
            [-5,  0,  0,  0,  0,  0,  0, -5],
            [-5,  0,  0,  0,  0,  0,  0, -5],
            [-5,  0,  0,  0,  0,  0,  0, -5],
            [0,  0,  0,  5,  5,  0,  0,  0]
        ];

        const initialBoard = [
            ['bR', 'bN', 'bB', 'bQ', 'bK', 'bB', 'bN', 'bR'],
            ['bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP'],
            [null, null, null, null, null, null, null, null],
            [null, null, null, null, null, null, null, null],
            [null, null, null, null, null, null, null, null],
            [null, null, null, null, null, null, null, null],
            ['wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP'],
            ['wR', 'wN', 'wB', 'wQ', 'wK', 'wB', 'wN', 'wR']
        ];

        let board = JSON.parse(JSON.stringify(initialBoard));
        let selectedSquare = null;
        let validMoves = [];
        let moveCounter = 0;
        let gameOver = false;
        let capturedW = [];
        let capturedB = [];
        let evaluatedNodes = 0;

        const pieces = {
            'wK': '♔', 'wQ': '♕', 'wR': '♖', 'wB': '♗', 'wN': '♘', 'wP': '♙',
            'bK': '♚', 'bQ': '♛', 'bR': '♜', 'bB': '♝', 'bN': '♞', 'bP': '♟'
        };

        function inBounds(r, c) { return r >= 0 && r < 8 && c >= 0 && c < 8; }

        function initBoard() {
            const boardEl = document.getElementById('chessBoard');
            boardEl.innerHTML = '';

            for (let r = 0; r < 8; r++) {
                for (let c = 0; c < 8; c++) {
                    const sq = document.createElement('div');
                    sq.className = `square ${(r + c) % 2 === 0 ? 'light' : 'dark'}`;
                    sq.dataset.row = r;
                    sq.dataset.col = c;

                    const p = board[r][c];
                    if (p) {
                        const pe = document.createElement('div');
                        pe.className = 'piece';
                        pe.textContent = pieces[p];
                        sq.appendChild(pe);
                    }

                    sq.addEventListener('click', () => handleSquareClick(r, c));
                    boardEl.appendChild(sq);
                }
            }
            updateEvaluationBar();
        }

        function handleSquareClick(r, c) {
            if (gameOver) return;

            if (selectedSquare) {
                const isValid = validMoves.some(m => m.toRow === r && m.toCol === c);
                if (isValid) {
                    executeMove(selectedSquare.row, selectedSquare.col, r, c);
                    clearSelection();
                    if (!gameOver) {
                        setThinking(true);
                        setTimeout(triggerAiPredictionMove, 250);
                    }
                    return;
                }
            }

            const p = board[r][c];
            if (p && p.startsWith('w')) {
                clearSelection();
                selectedSquare = { row: r, col: c };
                const sq = document.querySelector(`.square[data-row="${r}"][data-col="${c}"]`);
                if (sq) sq.classList.add('selected');

                validMoves = getValidMovesForBoard(board, r, c, p);
                validMoves.forEach(m => {
                    const t = document.querySelector(`.square[data-row="${m.toRow}"][data-col="${m.toCol}"]`);
                    if (t) t.classList.add('valid-move');
                });
            } else {
                clearSelection();
            }
        }

        function clearSelection() {
            selectedSquare = null;
            validMoves = [];
            document.querySelectorAll('.square.selected').forEach(s => s.classList.remove('selected'));
            document.querySelectorAll('.square.valid-move').forEach(s => s.classList.remove('valid-move'));
        }

        function executeMove(fromR, fromC, toR, toC) {
            const moving = board[fromR][fromC];
            const target = board[toR][toC];

            if (target) {
                if (target.startsWith('w')) capturedW.push(target);
                else capturedB.push(target);
                updateCapturedDisplay();
                if (target.endsWith('K')) {
                    endGame(target.startsWith('b') ? 'Checkmate! You won!' : 'Checkmate! AI defeated you.');
                }
            }

            // Pawn promotion to Queen
            if (moving === 'wP' && toR === 0) board[toR][toC] = 'wQ';
            else if (moving === 'bP' && toR === 7) board[toR][toC] = 'bQ';
            else board[toR][toC] = moving;

            board[fromR][fromC] = null;
            moveCounter++;
            document.getElementById('moveCount').textContent = moveCounter;

            const moveNot = `${String.fromCharCode(97 + fromC)}${8 - fromR}→${String.fromCharCode(97 + toC)}${8 - toR}`;
            const mSpan = document.createElement('div');
            mSpan.className = 'move';
            mSpan.textContent = moveNot;
            document.getElementById('moveList').appendChild(mSpan);

            initBoard();

            const fromSq = document.querySelector(`.square[data-row="${fromR}"][data-col="${fromC}"]`);
            const toSq = document.querySelector(`.square[data-row="${toR}"][data-col="${toC}"]`);
            if (fromSq) fromSq.classList.add('last-move');
            if (toSq) toSq.classList.add('last-move');
        }

        /* ---------------- MINIMAX PREDICTIVE ENGINE ---------------- */

        function triggerAiPredictionMove() {
            if (gameOver) return;
            evaluatedNodes = 0;

            // Search 3 plies deep (Black minimizing white evaluation, maximizing black score)
            const bestMove = getBestMoveMinimax(board, 3);
            document.getElementById('nodesCount').textContent = evaluatedNodes;

            if (bestMove) {
                executeMove(bestMove.fromR, bestMove.fromC, bestMove.toR, bestMove.toC);
            } else {
                endGame('Stalemate / No valid moves for AI');
            }
            setThinking(false);
        }

        function getBestMoveMinimax(currentBoard, depth) {
            let bestScore = -Infinity;
            let bestMove = null;
            const moves = getAllMoves(currentBoard, 'b');

            // Move ordering: evaluate captures first to prune faster
            moves.sort((a, b) => (b.isCapture ? 1 : 0) - (a.isCapture ? 1 : 0));

            for (let i = 0; i < moves.length; i++) {
                const move = moves[i];
                const simulatedBoard = cloneBoard(currentBoard);
                applySimulatedMove(simulatedBoard, move);

                const score = minimax(simulatedBoard, depth - 1, -Infinity, Infinity, false);
                if (score > bestScore) {
                    bestScore = score;
                    bestMove = move;
                }
            }
            return bestMove;
        }

        function minimax(simBoard, depth, alpha, beta, isAiMaximizing) {
            evaluatedNodes++;

            if (depth === 0) {
                return evaluateBoardScore(simBoard);
            }

            const color = isAiMaximizing ? 'b' : 'w';
            const moves = getAllMoves(simBoard, color);

            if (moves.length === 0) {
                return isAiMaximizing ? -10000 : 10000;
            }

            if (isAiMaximizing) {
                let maxEval = -Infinity;
                for (let i = 0; i < moves.length; i++) {
                    const nextBoard = cloneBoard(simBoard);
                    applySimulatedMove(nextBoard, moves[i]);
                    const evalScore = minimax(nextBoard, depth - 1, alpha, beta, false);
                    maxEval = Math.max(maxEval, evalScore);
                    alpha = Math.max(alpha, evalScore);
                    if (beta <= alpha) break; // Alpha-Beta Cutoff
                }
                return maxEval;
            } else {
                let minEval = Infinity;
                for (let i = 0; i < moves.length; i++) {
                    const nextBoard = cloneBoard(simBoard);
                    applySimulatedMove(nextBoard, moves[i]);
                    const evalScore = minimax(nextBoard, depth - 1, alpha, beta, true);
                    minEval = Math.min(minEval, evalScore);
                    beta = Math.min(beta, evalScore);
                    if (beta <= alpha) break; // Alpha-Beta Cutoff
                }
                return minEval;
            }
        }

        // Relative Board Evaluation: positive favours Black (AI), negative favours White (User)
        function evaluateBoardScore(b) {
            let total = 0;
            for (let r = 0; r < 8; r++) {
                for (let c = 0; c < 8; c++) {
                    const p = b[r][c];
                    if (p) {
                        const type = p[1];
                        const weight = PIECE_WEIGHTS[type] || 0;
                        let pstVal = 0;

                        if (type === 'P') pstVal = PAWN_TABLE[p.startsWith('b') ? r : 7 - r][c];
                        else if (type === 'N') pstVal = KNIGHT_TABLE[p.startsWith('b') ? r : 7 - r][c];
                        else if (type === 'B') pstVal = BISHOP_TABLE[p.startsWith('b') ? r : 7 - r][c];
                        else if (type === 'R') pstVal = ROOK_TABLE[p.startsWith('b') ? r : 7 - r][c];

                        if (p.startsWith('b')) {
                            total += (weight + pstVal);
                        } else {
                            total -= (weight + pstVal);
                        }
                    }
                }
            }
            return total;
        }

        function cloneBoard(source) {
            const copy = [];
            for (let r = 0; r < 8; r++) copy[r] = source[r].slice();
            return copy;
        }

        function applySimulatedMove(b, move) {
            const piece = b[move.fromR][move.fromC];
            if (piece === 'wP' && move.toR === 0) b[move.toR][move.toC] = 'wQ';
            else if (piece === 'bP' && move.toR === 7) b[move.toR][move.toC] = 'bQ';
            else b[move.toR][move.toC] = piece;
            b[move.fromR][move.fromC] = null;
        }

        function getAllMoves(b, side) {
            const all = [];
            for (let r = 0; r < 8; r++) {
                for (let c = 0; c < 8; c++) {
                    const p = b[r][c];
                    if (p && p.startsWith(side)) {
                        const moves = getValidMovesForBoard(b, r, c, p);
                        moves.forEach(m => {
                            all.push({
                                fromR: r, fromC: c,
                                toRow: m.toRow, toCol: m.toCol,
                                isCapture: !!b[m.toRow][m.toCol]
                            });
                        });
                    }
                }
            }
            return all;
        }

        function getValidMovesForBoard(b, r, c, p) {
            const moves = [];
            const type = p[1];
            const isW = p.startsWith('w');
            const dir = isW ? -1 : 1;

            if (type === 'P') {
                if (inBounds(r + dir, c) && !b[r + dir][c]) {
                    moves.push({ toRow: r + dir, toCol: c });
                    const startR = isW ? 6 : 1;
                    if (r === startR && !b[r + dir][c] && !b[r + 2 * dir][c]) {
                        moves.push({ toRow: r + 2 * dir, toCol: c });
                    }
                }
                [-1, 1].forEach(dc => {
                    if (inBounds(r + dir, c + dc)) {
                        const t = b[r + dir][c + dc];
                        if (t && (isW ? t.startsWith('b') : t.startsWith('w'))) {
                            moves.push({ toRow: r + dir, toCol: c + dc });
                        }
                    }
                });
            } else if (type === 'N') {
                [[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]].forEach(([dr, dc]) => {
                    if (inBounds(r + dr, c + dc)) {
                        const t = b[r + dr][c + dc];
                        if (!t || (isW ? t.startsWith('b') : t.startsWith('w'))) {
                            moves.push({ toRow: r + dr, toCol: c + dc });
                        }
                    }
                });
            } else if (type === 'B') {
                addRays(b, r, c, [[-1,-1],[-1,1],[1,-1],[1,1]], isW, moves);
            } else if (type === 'R') {
                addRays(b, r, c, [[-1,0],[1,0],[0,-1],[0,1]], isW, moves);
            } else if (type === 'Q') {
                addRays(b, r, c, [[-1,-1],[-1,1],[1,-1],[1,1],[-1,0],[1,0],[0,-1],[0,1]], isW, moves);
            } else if (type === 'K') {
                [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]].forEach(([dr, dc]) => {
                    if (inBounds(r + dr, c + dc)) {
                        const t = b[r + dr][c + dc];
                        if (!t || (isW ? t.startsWith('b') : t.startsWith('w'))) {
                            moves.push({ toRow: r + dr, toCol: c + dc });
                        }
                    }
                });
            }
            return moves;
        }

        function addRays(b, r, c, dirs, isW, moves) {
            dirs.forEach(([dr, dc]) => {
                for (let i = 1; i < 8; i++) {
                    const nr = r + dr * i;
                    const nc = c + dc * i;
                    if (!inBounds(nr, nc)) break;
                    const t = b[nr][nc];
                    if (!t) {
                        moves.push({ toRow: nr, toCol: nc });
                    } else {
                        if (isW ? t.startsWith('b') : t.startsWith('w')) {
                            moves.push({ toRow: nr, toCol: nc });
                        }
                        break;
                    }
                }
            });
        }

        function updateEvaluationBar() {
            const score = -evaluateBoardScore(board); // Positive = user advantage
            const fill = document.getElementById('evalFill');
            const label = document.getElementById('evalLabel');

            let pct = 50 + (score / 40);
            pct = Math.max(5, Math.min(95, pct));
            fill.style.width = pct + '%';
            label.textContent = (score > 0 ? '+' : '') + (score / 100).toFixed(1);
        }

        function updateCapturedDisplay() {
            const wEl = document.getElementById('capturedWhite');
            const bEl = document.getElementById('capturedBlack');
            wEl.innerHTML = capturedW.map(p => `<span class="captured-piece">${pieces[p]}</span>`).join('') || '<span style="color:var(--text-muted);font-size:0.8rem;">None</span>';
            bEl.innerHTML = capturedB.map(p => `<span class="captured-piece">${pieces[p]}</span>`).join('') || '<span style="color:var(--text-muted);font-size:0.8rem;">None</span>';
        }

        function setThinking(isThinking) {
            const dot = document.getElementById('statusDot');
            const text = document.getElementById('statusText');
            if (isThinking) {
                dot.className = 'status-dot thinking';
                text.textContent = "AI is evaluating moves...";
            } else {
                dot.className = 'status-dot your-turn';
                text.textContent = "Your Turn (White)";
            }
        }

        function endGame(msg) {
            gameOver = true;
            document.getElementById('gameOverOverlay').classList.add('active');
            document.getElementById('gameOverMessage').textContent = msg;
            document.getElementById('statusDot').className = 'status-dot game-over';
            document.getElementById('statusText').textContent = msg;
        }

        document.getElementById('resetBtn').addEventListener('click', () => location.reload());
        document.getElementById('playAgainBtn').addEventListener('click', () => location.reload());
        document.getElementById('exitBtn').addEventListener('click', () => { window.location.href = 'index.jsp'; });

        initBoard();
    </script>
</body>
</html>