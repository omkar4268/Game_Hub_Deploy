<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession sess = request.getSession();
    Integer snakeBest = (Integer) sess.getAttribute("snake_highscore");
    if (snakeBest == null) snakeBest = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Game Station - Library</title>
    <style>
        :root {
            --bg-base: #0a0b10;
            --bg-surface: #13151f;
            --bg-card: #1c1f2e;
            --accent: #6366f1;
            --accent-hover: #4f46e5;
            --neon-green: #00ffa3;
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
            --border: rgba(255, 255, 255, 0.08);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            user-select: none;
        }

        body {
            background-color: var(--bg-base);
            color: var(--text-main);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar Navigation */
        aside {
            width: 240px;
            background: var(--bg-surface);
            border-right: 1px solid var(--border);
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #fff;
        }

        .brand span {
            background: var(--accent);
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
        }

        .nav-links {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .nav-item {
            padding: 10px 14px;
            border-radius: 8px;
            cursor: pointer;
            color: var(--text-dim);
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .nav-item.active, .nav-item:hover {
            background: rgba(99, 102, 241, 0.12);
            color: #fff;
        }

        /* Main Content Library */
        main {
            flex: 1;
            padding: 32px 40px;
            overflow-y: auto;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }

        .top-bar h1 {
            font-size: 26px;
            font-weight: 800;
        }

        .game-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 24px;
        }

        /* Game Card */
        .game-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.2s, border-color 0.2s, box-shadow 0.2s;
            position: relative;
        }

        .game-card:hover {
            transform: translateY(-5px);
            border-color: var(--accent);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.4), 0 0 15px rgba(99, 102, 241, 0.2);
        }

        .card-banner {
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
        }

        .banner-guesser {
            background: linear-gradient(135deg, #1e1b4b, #4338ca);
        }

        .banner-snake {
            background: linear-gradient(135deg, #064e3b, #059669);
        }

        .card-body {
            padding: 16px;
        }

        .card-tag {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 4px;
        }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .card-desc {
            font-size: 13px;
            color: var(--text-dim);
            line-height: 1.4;
        }

        /* Detail Modal Drawer */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(8px);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.2s ease;
            z-index: 100;
        }

        .modal-overlay.open {
            opacity: 1;
            pointer-events: auto;
        }

        .detail-panel {
            background: var(--bg-surface);
            border: 1px solid var(--border);
            width: 440px;
            border-radius: 18px;
            padding: 28px;
            display: flex;
            flex-direction: column;
            gap: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.8);
            transform: scale(0.95);
            transition: transform 0.2s ease;
        }

        .modal-overlay.open .detail-panel {
            transform: scale(1);
        }

        .detail-header {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .detail-icon {
            font-size: 40px;
            background: var(--bg-card);
            padding: 12px;
            border-radius: 12px;
        }

        .detail-actions {
            display: flex;
            gap: 12px;
            margin-top: 10px;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
        }

        .btn:active {
            transform: scale(0.98);
        }

        .btn-launch {
            background: var(--neon-green);
            color: #0b0c10;
        }

        .btn-launch:hover {
            opacity: 0.9;
        }

        .btn-close {
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-main);
        }

        .btn-close:hover {
            background: rgba(255, 255, 255, 0.12);
        }

        /* Immersive Game Arcade Stage (Iframe Runner) */
        #gameStage {
            position: fixed;
            inset: 0;
            background: var(--bg-base);
            z-index: 200;
            display: flex;
            flex-direction: column;
            transform: translateY(100%);
            transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        #gameStage.active {
            transform: translateY(0);
        }

        .stage-header {
            height: 56px;
            background: var(--bg-surface);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
        }

        .btn-exit {
            background: #ef4444;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-exit:hover {
            background: #dc2626;
        }

        #gameFrame {
            flex: 1;
            width: 100%;
            height: 100%;
            border: none;
            background: transparent;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <aside>
        <div class="brand">
            GAME<span>HUB</span>
        </div>
        <ul class="nav-links">
            <li class="nav-item active">📚 Library</li>
            <li class="nav-item">🏆 High Scores</li>
            <li class="nav-item">⚙️ Settings</li>
        </ul>
    </aside>

    <!-- Library Content -->
    <main>
        <div class="top-bar">
            <h1>Game Library</h1>
            <span style="font-size: 13px; color: var(--text-dim);">Tomcat Web Server &bull; Localhost</span>
        </div>

        <div class="game-grid">
            <!-- Card 1 -->
            <div class="game-card" onclick="openGamePrompt('Game1.jsp', 'Number Guesser', '🔢', 'A server-side deduction puzzle. The Java backend creates a secret random integer, and session variables count your attempts.', 'Server-Side JSP')">
                <div class="card-banner banner-guesser">🔢</div>
                <div class="card-body">
                    <div class="card-tag">Session Puzzle</div>
                    <div class="card-title">Number Guesser</div>
                    <div class="card-desc">Crack the secret integer generated by the server session.</div>
                </div>
            </div>

            <!-- Card 2 -->
            <div class="game-card" onclick="openGamePrompt('Snake.jsp', 'Cyber Snake', '🐍', 'Classic arcade neon snake game running inside HTML5 canvas. High scores sync dynamically to your Tomcat session.', 'High Score: <%= snakeBest %>')">
                <div class="card-banner banner-snake">🐍</div>
                <div class="card-body">
                    <div class="card-tag">Arcade Classic</div>
                    <div class="card-title">Cyber Snake</div>
                    <div class="card-desc">Steer your cyber serpent, consume data nodes, and break your record.</div>
                </div>
            </div>
        </div>
    </main>

    <!-- Details / Launch Prompt Dialog -->
    <div class="modal-overlay" id="promptModal">
        <div class="detail-panel">
            <div class="detail-header">
                <div class="detail-icon" id="modalIcon">🎮</div>
                <div>
                    <h2 id="modalTitle" style="font-size: 20px;">Game Title</h2>
                    <span id="modalMeta" style="font-size: 12px; color: var(--neon-green);">Tag Info</span>
                </div>
            </div>
            <p id="modalDesc" style="font-size: 14px; color: var(--text-dim); line-height: 1.5;"></p>
            <div class="detail-actions">
                <button class="btn btn-close" onclick="closePrompt()">Cancel</button>
                <button class="btn btn-launch" id="confirmPlayBtn">▶ Play Game</button>
            </div>
        </div>
    </div>

    <!-- Live Game Stage Modal (With persistent exit bar) -->
    <div id="gameStage">
        <div class="stage-header">
            <span id="stageGameTitle" style="font-weight: 700; font-size: 15px;">Now Playing</span>
            <button class="btn-exit" onclick="exitToLibrary()">
                ✕ Exit to Library
            </button>
        </div>
        <iframe id="gameFrame" src=""></iframe>
    </div>

    <script>
        let selectedGameUrl = "";

        function openGamePrompt(url, title, icon, desc, meta) {
            selectedGameUrl = url;
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalIcon').innerText = icon;
            document.getElementById('modalDesc').innerText = desc;
            document.getElementById('modalMeta').innerText = meta;
            
            document.getElementById('confirmPlayBtn').onclick = () => launchGame(url, title);
            document.getElementById('promptModal').classList.add('open');
        }

        function closePrompt() {
            document.getElementById('promptModal').classList.remove('open');
            selectedGameUrl = "";
        }

        function launchGame(url, title) {
            closePrompt();
            document.getElementById('stageGameTitle').innerText = "Now Playing: " + title;
            
            const frame = document.getElementById('gameFrame');
            frame.src = url; // Load the JSP into the stage
            
            document.getElementById('gameStage').classList.add('active');
        }

        function exitToLibrary() {
            const frame = document.getElementById('gameFrame');
            frame.src = ""; // Unload the game to stop sounds/intervals
            document.getElementById('gameStage').classList.remove('active');
        }

        // Close prompt modal if clicking outside panel
        document.getElementById('promptModal').addEventListener('click', (e) => {
            if (e.target.id === 'promptModal') closePrompt();
        });
    </script>
</body>
</html>