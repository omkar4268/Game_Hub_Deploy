<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    boolean isLoggedIn = (username != null && !username.trim().isEmpty());
    if (!isLoggedIn) {
        username = "Guest Operative";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RANS0M // Cyber Threat Simulation</title>
    
    <!-- Framer Motion Browser Engine -->
    <script src="https://cdn.jsdelivr.net/npm/motion@11.11.13/dist/motion.js"></script>

    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" type="image/png" href="assets/sprites/spr_stop_sign.png">
</head>
<body>
    <!-- Dedicated Fullscreen Red Alert Glitch Matrix Canvas -->
    <canvas id="ransomBgCanvas" class="ransom-bg-canvas"></canvas>

    <!-- Retro CRT Visual Filters -->
    <div class="crt-overlay"></div>
    <div class="crt-vignette"></div>

    <!-- Blinding White Flash on Infection -->
    <div id="flashOverlay"></div>

    <!-- Simulated OS Desktop -->
    <div id="desktop">
        <!-- Top Operational Desktop Bar (Obsidian Space Glass) -->
        <header class="desktop-bar">
            <div class="bar-brand">
                <img src="assets/sprites/spr_stop_sign.png" style="width: 20px; height: 20px; image-rendering: pixelated;" alt="Icon">
                <span>TERMINAL_OS //</span> <strong>RANS0M <span class="hollow-text">THREAT SIM</span></strong>
            </div>
            <div class="bar-controls">
                <button class="bar-btn" id="soundToggleBtn" onclick="toggleSound()">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path></svg>
                    <span>SOUND: ON</span>
                </button>
                <button class="bar-btn" onclick="restartGame()">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
                    <span>REBOOT</span>
                </button>
                <a href="../index.jsp" onclick="exitToHub(); return false;" class="bar-btn">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                    <span>GAME HUB</span>
                </a>
            </div>
        </header>

        <!-- PHASE 1: FAKE TROJAN DOWNLOAD WINDOW (Obsidian Space Glass) -->
        <div class="os-window" id="downloadWindow">
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

            <div class="win-titlebar">
                <span>FILE_RECEIVER_v1.0.exe [CONNECTING...]</span>
                <div class="win-buttons">
                    <div class="win-btn">_</div>
                    <div class="win-btn">□</div>
                    <div class="win-btn close">✕</div>
                </div>
            </div>
            <div class="download-body">
                <div class="download-text-wrap">
                    <div class="download-title" id="downloadTitle">DOWNLOADING...</div>
                    <div class="download-percent" id="downloadPercent">0%</div>
                </div>
                <div class="progress-container">
                    <div class="progress-fill" id="downloadProgressFill"></div>
                </div>
                <div class="download-subtext">INCOMING PACKET STREAM: payload_x64.bin [SOURCE: UNKNOWN HOST]</div>
            </div>
        </div>

        <!-- PHASE 2: MAIN RANSOMWARE HOSTAGE WINDOW (Obsidian Space Glass) -->
        <div class="os-window" id="ransomWindow">
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

            <div class="win-titlebar">
                <span>RANS0M.exe - SECURE HOSTAGE LOCKDOWN</span>
                <div class="win-buttons">
                    <div class="win-btn">_</div>
                    <div class="win-btn">□</div>
                    <div class="win-btn close" onclick="triggerGlitchShake(500)">✕</div>
                </div>
            </div>
            <div class="ransom-body">
                <!-- Threat Banner -->
                <div class="ransom-banner">
                    <img class="ransom-icon" src="assets/sprites/spr_stop_sign.png" alt="Threat Icon">
                    <div class="ransom-headline">
                        <h2>ALL YOUR FILES ARE ENCRYPTED!</h2>
                        <p>Military-Grade AES-256 System Lockdown in Progress</p>
                    </div>
                </div>

                <!-- Ticking Countdown Timer -->
                <div class="timer-box">
                    <div class="timer-label">TOTAL SYSTEM PURGE IN:</div>
                    <div class="timer-digits" id="timerDigits">02:00</div>
                </div>

                <!-- Ransom Demands -->
                <div class="demand-text">
                    Your documents, photos, databases, and critical system sectors have been encrypted.<br>
                    To receive the private decryption hash, transfer <strong>$500.00 BTC</strong> or input the <strong>OVERRIDE CIPHER</strong> before time expires.
                </div>

                <!-- Decryption Input Console -->
                <div class="decrypt-box">
                    <div class="decrypt-label">
                        <span>INPUT 5-LETTER OVERRIDE KEY:</span>
                        <span id="decryptHint" style="color: #facc15;">[HINT: POPUPS HIDE RETRIEVAL CLUES]</span>
                    </div>
                    <div class="decrypt-inputs">
                        <input type="text" id="keyInput" class="key-input" maxlength="12" placeholder="_ _ _ _ _" autocomplete="off" spellcheck="false" autofocus>
                        <button class="decrypt-btn btn-cyber-primary" onclick="submitKey()">DECRYPT</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- PHASE 4: JUMPSCARE MELTDOWN SCREEN -->
        <div id="jumpscareScreen">
            <img class="jumpscare-face" src="assets/sprites/spr_ransom_jumpscare.png" alt="Jumpscare Face">
            <div class="jumpscare-text">SYSTEM PURGED // TIME EXPIRED</div>
        </div>

        <!-- PHASE 5: GOOD ENDING DECRYPTION SCREEN (Obsidian Space Glass) -->
        <div id="goodEndingScreen">
            <div class="good-dialog">
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

                <img class="good-sign-img" src="assets/sprites/spr_good_sign.png" alt="Decryption Success">
                <img class="good-thankyou-img" src="assets/sprites/spr_good_text.png" alt="Thank You">
                <p style="color: #22c55e; font-size: 18px; font-weight: 800; letter-spacing: 1px;">ALL SYSTEM FILES SAFELY RESTORED!</p>
                <div class="good-stats" id="goodEndingStats"></div>
                <div class="action-btn-row">
                    <button class="btn-cyber btn-cyber-primary" onclick="restartGame()">PLAY AGAIN</button>
                    <a href="../index.jsp" onclick="exitToHub(); return false;" class="btn-cyber btn-cyber-secondary">RETURN TO GAME HUB</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Core Game Engine -->
    <script src="js/engine.js"></script>
</body>
</html>
