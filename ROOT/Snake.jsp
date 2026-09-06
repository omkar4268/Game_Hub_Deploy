<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Server-side session to track persistent high score on Tomcat
    HttpSession sess = request.getSession();
    Integer bestScore = (Integer) sess.getAttribute("snake_highscore");
    if (bestScore == null) {
        bestScore = 0;
        sess.setAttribute("snake_highscore", bestScore);
    }

    String updateScore = request.getParameter("score");
    if (updateScore != null) {
        try {
            int newScore = Integer.parseInt(updateScore);
            if (newScore > bestScore) {
                sess.setAttribute("snake_highscore", newScore);
                bestScore = newScore;
            }
        } catch (NumberFormatException ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cyber Snake - Game Hub</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            user-select: none;
        }

        body {
            background: radial-gradient(circle at center, #1b1b2f, #0f0f1a);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }

        .game-wrapper {
            position: relative;
            background: rgba(30, 30, 48, 0.7);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.7), 0 0 20px rgba(0, 255, 170, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .header {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding: 0 8px;
        }

        .title {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(90deg, #00ffa3, #00d8d6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .stats-board {
            display: flex;
            gap: 16px;
        }

        .stat-box {
            background: rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 8px;
            padding: 6px 14px;
            font-size: 14px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .stat-box span:first-child {
            font-size: 11px;
            color: #8f90a6;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-box span:last-child {
            font-size: 18px;
            font-weight: 700;
            color: #00ffa3;
        }

        .canvas-container {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: inset 0 0 15px rgba(0, 0, 0, 0.8), 0 0 10px rgba(0, 255, 170, 0.2);
            border: 2px solid rgba(0, 255, 170, 0.3);
        }

        canvas {
            display: block;
            background-color: #0b0c10;
        }

        /* Overlay UI Screens */
        .overlay {
            position: absolute;
            inset: 0;
            background: rgba(11, 12, 16, 0.85);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(4px);
            transition: opacity 0.2s ease;
        }

        .hidden {
            display: none !important;
        }

        .play-btn {
            background: linear-gradient(135deg, #00ffa3, #00b894);
            border: none;
            outline: none;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 0 25px rgba(0, 255, 163, 0.6);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .play-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 0 35px rgba(0, 255, 163, 0.9);
        }

        .play-btn svg {
            width: 32px;
            height: 32px;
            fill: #0b0c10;
            margin-left: 5px;
        }

        .btn-text {
            background: linear-gradient(135deg, #00ffa3, #00b894);
            color: #0b0c10;
            border: none;
            padding: 12px 28px;
            font-size: 16px;
            font-weight: 700;
            border-radius: 30px;
            cursor: pointer;
            margin-top: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 0 15px rgba(0, 255, 163, 0.4);
            transition: transform 0.2s ease;
        }

        .btn-text:hover {
            transform: scale(1.05);
        }

        .overlay-title {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: 1.5px;
        }

        .game-over-title {
            color: #ff4757;
            text-shadow: 0 0 15px rgba(255, 71, 87, 0.6);
        }

        .controls-hint {
            margin-top: 15px;
            font-size: 13px;
            color: #6c7a89;
        }
    </style>
</head>
<body>

<div class="game-wrapper">
    <div class="header">
        <div class="title">Snake</div>
        <div class="stats-board">
            <div class="stat-box">
                <span>Score</span>
                <span id="currentScore">0</span>
            </div>
            <div class="stat-box">
                <span>Best</span>
                <span id="bestScore"><%= bestScore %></span>
            </div>
        </div>
    </div>

    <div class="canvas-container">
        <canvas id="gameCanvas" width="400" height="400"></canvas>

        <!-- Start Screen -->
        <div class="overlay" id="startScreen">
            <button class="play-btn" id="startBtn" title="Click to Start">
                <svg viewBox="0 0 24 24">
                    <path d="M8 5v14l11-7z"/>
                </svg>
            </button>
            <div class="controls-hint">Use Arrow Keys to Steer</div>
        </div>

        <!-- Game Over Screen -->
        <div class="overlay hidden" id="gameOverScreen">
            <div class="overlay-title game-over-title">GAME OVER</div>
            <p style="color: #ced6e0; margin-bottom: 5px;">Final Score: <span id="finalScore" style="color: #00ffa3; font-weight: bold;">0</span></p>
            <button class="btn-text" id="restartBtn">Play Again</button>
        </div>
    </div>
</div>

<script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");

    const startScreen = document.getElementById("startScreen");
    const gameOverScreen = document.getElementById("gameOverScreen");
    const startBtn = document.getElementById("startBtn");
    const restartBtn = document.getElementById("restartBtn");
    const currentScoreEl = document.getElementById("currentScore");
    const bestScoreEl = document.getElementById("bestScore");
    const finalScoreEl = document.getElementById("finalScore");

    const GRID_SIZE = 20;
    const TILE_COUNT = canvas.width / GRID_SIZE;

    let snake = [];
    let velocity = { x: 0, y: 0 };
    let food = { x: 15, y: 15 };
    let score = 0;
    let bestScore = <%= bestScore %>;
    let gameInterval = null;
    let isRunning = false;

    function resetGame() {
        snake = [
            { x: 10, y: 10 },
            { x: 10, y: 11 },
            { x: 10, y: 12 }
        ];
        velocity = { x: 0, y: -1 }; // Start moving up
        score = 0;
        currentScoreEl.innerText = score;
        spawnFood();
    }

    function spawnFood() {
        let valid = false;
        while (!valid) {
            food.x = Math.floor(Math.random() * TILE_COUNT);
            food.y = Math.floor(Math.random() * TILE_COUNT);
            valid = !snake.some(segment => segment.x === food.x && segment.y === food.y);
        }
    }

    function startGame() {
        resetGame();
        startScreen.classList.add("hidden");
        gameOverScreen.classList.add("hidden");
        isRunning = true;
        clearInterval(gameInterval);
        gameInterval = setInterval(gameLoop, 110);
    }

    function triggerGameOver() {
        clearInterval(gameInterval);
        isRunning = false;
        finalScoreEl.innerText = score;

        if (score > bestScore) {
            bestScore = score;
            bestScoreEl.innerText = bestScore;
            // Sync new high score to Tomcat session silently
            fetch("Snake.jsp?score=" + score);
        }

        gameOverScreen.classList.remove("hidden");
    }

    function gameLoop() {
        // Calculate new head position
        const head = { x: snake[0].x + velocity.x, y: snake[0].y + velocity.y };

        // Wall collisions
        if (head.x < 0 || head.x >= TILE_COUNT || head.y < 0 || head.y >= TILE_COUNT) {
            triggerGameOver();
            return;
        }

        // Self collisions
        for (let i = 0; i < snake.length; i++) {
            if (head.x === snake[i].x && head.y === snake[i].y) {
                triggerGameOver();
                return;
            }
        }

        // Move snake
        snake.unshift(head);

        // Check food collision
        if (head.x === food.x && head.y === food.y) {
            score += 10;
            currentScoreEl.innerText = score;
            spawnFood();
        } else {
            snake.pop(); // Remove tail if no food eaten
        }

        render();
    }

    function render() {
        // Clear background
        ctx.fillStyle = "#0b0c10";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        // Draw soft grid lines
        ctx.strokeStyle = "rgba(255, 255, 255, 0.03)";
        for (let i = 0; i < canvas.width; i += GRID_SIZE) {
            ctx.beginPath();
            ctx.moveTo(i, 0);
            ctx.lineTo(i, canvas.height);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(0, i);
            ctx.lineTo(canvas.width, i);
            ctx.stroke();
        }

        // Draw neon food with glow
        ctx.save();
        ctx.shadowBlur = 15;
        ctx.shadowColor = "#ff4757";
        ctx.fillStyle = "#ff4757";
        ctx.beginPath();
        const foodRadius = GRID_SIZE / 2 - 2;
        ctx.arc(
            food.x * GRID_SIZE + GRID_SIZE / 2,
            food.y * GRID_SIZE + GRID_SIZE / 2,
            foodRadius,
            0,
            Math.PI * 2
        );
        ctx.fill();
        ctx.restore();

        // Draw glowing snake
        snake.forEach((segment, index) => {
            ctx.save();
            if (index === 0) {
                // Head has brighter glow
                ctx.fillStyle = "#00ffa3";
                ctx.shadowBlur = 10;
                ctx.shadowColor = "#00ffa3";
            } else {
                ctx.fillStyle = "#00d8d6";
                ctx.shadowBlur = 4;
                ctx.shadowColor = "#00d8d6";
            }

            ctx.fillRect(
                segment.x * GRID_SIZE + 1,
                segment.y * GRID_SIZE + 1,
                GRID_SIZE - 2,
                GRID_SIZE - 2
            );
            ctx.restore();
        });
    }

    // Input Handling
    window.addEventListener("keydown", (e) => {
        if (!isRunning) return;

        switch (e.key) {
            case "ArrowUp":
                if (velocity.y === 0) velocity = { x: 0, y: -1 };
                e.preventDefault();
                break;
            case "ArrowDown":
                if (velocity.y === 0) velocity = { x: 0, y: 1 };
                e.preventDefault();
                break;
            case "ArrowLeft":
                if (velocity.x === 0) velocity = { x: -1, y: 0 };
                e.preventDefault();
                break;
            case "ArrowRight":
                if (velocity.x === 0) velocity = { x: 1, y: 0 };
                e.preventDefault();
                break;
        }
    });

    startBtn.addEventListener("click", startGame);
    restartBtn.addEventListener("click", startGame);

    // Initial render
    resetGame();
    render();
</script>

</body>
</html>