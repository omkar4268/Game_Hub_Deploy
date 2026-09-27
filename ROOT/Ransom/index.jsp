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
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" type="image/png" href="assets/sprites/spr_stop_sign.png">
</head>
<body>
    <!-- Retro CRT Visual Filters -->
    <div class="crt-overlay"></div>
    <div class="crt-vignette"></div>

    <!-- Blinding White Flash on Infection -->
    <div id="flashOverlay"></div>

    <!-- Simulated OS Desktop -->
    <div id="desktop">
        <!-- Top Operational Desktop Bar -->
        <div class="desktop-bar">
            <div class="bar-brand">
                <img src="assets/sprites/spr_stop_sign.png" style="width: 20px; height: 20px; image-rendering: pixelated;" alt="Icon">
                <span>TERMINAL_OS //</span> <strong>RANS0M CRISIS SIMULATOR</strong>
            </div>
            <div class="bar-controls">
                <button class="bar-btn" id="soundToggleBtn" onclick="toggleSound()">🔊 SOUND: ON</button>
                <button class="bar-btn" onclick="restartGame()">↺ REBOOT</button>
                <button class="bar-btn" onclick="exitToHub()">⌂ GAME HUB</button>
            </div>
        </div>

        <!-- PHASE 1: FAKE TROJAN DOWNLOAD WINDOW -->
        <div class="os-window" id="downloadWindow">
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

        <!-- PHASE 2: MAIN RANSOMWARE HOSTAGE WINDOW -->
        <div class="os-window" id="ransomWindow">
            <div class="win-titlebar">
                <span>RANS0M.exe - SECURE LOCKDOWN</span>
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
                    <div class="timer-label">TOTAL PURGE IN:</div>
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
                        <button class="decrypt-btn" onclick="submitKey()">DECRYPT</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- PHASE 4: JUMPSCARE MELTDOWN SCREEN -->
        <div id="jumpscareScreen">
            <img class="jumpscare-face" src="assets/sprites/spr_ransom_jumpscare.png" alt="Jumpscare Face">
            <div class="jumpscare-text">SYSTEM PURGED // TIME EXPIRED</div>
        </div>

        <!-- PHASE 5: GOOD ENDING DECRYPTION SCREEN -->
        <div id="goodEndingScreen">
            <div class="good-dialog">
                <img class="good-sign-img" src="assets/sprites/spr_good_sign.png" alt="Decryption Success">
                <img class="good-thankyou-img" src="assets/sprites/spr_good_text.png" alt="Thank You">
                <p style="color: #22c55e; font-size: 18px; font-weight: 700; letter-spacing: 1px;">ALL SYSTEM FILES SAFELY RESTORED!</p>
                <div class="good-stats" id="goodEndingStats"></div>
                <div class="action-btn-row">
                    <button class="btn-primary" onclick="restartGame()">PLAY AGAIN</button>
                    <button class="btn-secondary" onclick="exitToHub()">RETURN TO GAME HUB</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Core Game Engine -->
    <script src="js/engine.js"></script>
</body>
</html>
