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

        // Triple-Routed AI Engine (Stockfish Online -> Chess-API -> Instant Tactical Fallback)
        async function makeAiMove() {
            if (game.game_over()) return;

            isAiThinking = true;
            updateStatus('<i class="fa-solid fa-circle-notch fa-spin"></i> AI is calculating...');
            
            const rawDepth = parseInt($('#aiDepth').val(), 10) || 5;
            let moveObj = null;
            let usedFallback = false;

            // Route 1: Stockfish Online (GET) - Real Stockfish with depth 5-15
            const apiDepth = Math.max(5, Math.min(15, rawDepth));
            try {
                const controller = new AbortController();
                const timeout = setTimeout(() => controller.abort(), 5000); // 5s timeout
                const fenSafe = encodeURIComponent(game.fen());
                
                const res1 = await fetch(`https://stockfish.online/api/s/v2.php?fen=${fenSafe}&depth=${apiDepth}`, {
                    signal: controller.signal
                });
                clearTimeout(timeout);
                
                if (res1.ok) {
                    const data1 = await res1.json();
                    if (data1 && data1.success && data1.bestmove) {
                        const parts = data1.bestmove.split(' '); // e.g., "bestmove e7e5 ponder..."
                        const mStr = parts[1];
                        if (mStr && mStr.length >= 4) {
                            moveObj = {
                                from: mStr.substring(0, 2),
                                to: mStr.substring(2, 4),
                                promotion: mStr.length > 4 ? mStr.substring(4, 5) : 'q'
                            };
                        }
                    }
                }
            } catch (e) {
                console.warn("Primary Stockfish API unreachable or timed out. Routing to secondary...");
            }

            // Route 2: Chess-API.com (POST)
            if (!moveObj) {
                try {
                    const controller = new AbortController();
                    const timeout = setTimeout(() => controller.abort(), 3000);
                    
                    // Sanitize en-passant square if strict parser requires it
                    let fenClean = game.fen();
                    const fenParts = fenClean.split(' ');
                    if (fenParts.length >= 4 && fenParts[3] !== '-') {
                        fenClean = fenParts.slice(0, 3).join(' ') + ' - ' + fenParts.slice(4).join(' ');
                    }

                    const res2 = await fetch('https://chess-api.com/v1', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ fen: fenClean, depth: Math.min(rawDepth, 8) }),
                        signal: controller.signal
                    });
                    clearTimeout(timeout);
                    
                    if (res2.ok) {
                        const data2 = await res2.json();
                        if (data2 && data2.from && data2.to) {
                            moveObj = { from: data2.from, to: data2.to, promotion: data2.promotion || 'q' };
                        }
                    }
                } catch (e) {
                    console.warn("Secondary API failed. Routing to local tactical fallback...");
                }
            }

            // Route 3: Embedded Tactical Heuristic Fallback (Instant, Offline & Bulletproof)
            if (!moveObj) {
                const moves = game.moves({ verbose: true });
                if (moves && moves.length > 0) {
                    usedFallback = true;
                    let bestMove = moves[0];
                    let bestScore = -99999;
                    const pieceVals = { 'p': 100, 'n': 320, 'b': 330, 'r': 500, 'q': 900, 'k': 20000 };
                    const centerSquares = ['d4', 'd5', 'e4', 'e5', 'c4', 'c5', 'f4', 'f5'];

                    // Check for immediate mate or tactical superiority
                    for (let m of moves) {
                        let score = 0;
                        
                        // Try move temporarily
                        game.move(m);
                        if (game.in_checkmate()) {
                            score += 100000;
                        } else if (game.in_check()) {
                            score += 80;
                        }
                        game.undo();

                        // Material gain (captures)
                        if (m.captured) {
                            const victimVal = pieceVals[m.captured] || 100;
                            const attackerVal = pieceVals[m.piece] || 100;
                            // Favorable exchange bonus (MVV-LVA)
                            score += (victimVal * 10) - (attackerVal);
                        }

                        // Promotion bonus
                        if (m.promotion) {
                            score += 850;
                        }

                        // Center control bonus
                        if (centerSquares.includes(m.to)) {
                            score += 35;
                        }

                        // Small random factor to prevent repetitive bot games
                        score += Math.floor(Math.random() * 20);

                        if (score > bestScore) {
                            bestScore = score;
                            bestMove = m;
                        }
                    }

                    // For novice level, 30% chance to pick a casual move
                    if (rawDepth === 2 && moves.length > 1 && Math.random() < 0.3) {
                        bestMove = moves[Math.floor(Math.random() * moves.length)];
                    }

                    moveObj = { from: bestMove.from, to: bestMove.to, promotion: bestMove.promotion || 'q' };
                }
            }

            // Execute verified move
            if (moveObj) {
                game.move(moveObj);
                board.position(game.fen());
            }

            isAiThinking = false;
            
            if (usedFallback) {
                updateStatus('<span style="color:var(--primary)"><i class="fa-solid fa-microchip"></i> AI played tactical local move.</span>');
                setTimeout(() => updateStatus(), 2500);
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

            try {
                if (window.RansomHorror && typeof window.RansomHorror.notifyChessMove === 'function') {
                    window.RansomHorror.notifyChessMove(move);
                }
            } catch (err) {
                console.warn('RansomHorror notification bypassed:', err);
            }

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
                    fetch('../save_score.jsp', {
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
            setTimeout(() => { if (board) board.resize(); }, 60);
            
            if (board.orientation() === 'black') {
                window.setTimeout(makeAiMove, 300);
            }
        });

        $('#flipBtn').on('click', () => {
            board.flip();
            setTimeout(() => { if (board) board.resize(); }, 60);
        });
        $('#exitBtn').on('click', () => cyberNavigate('../index.jsp'));

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
            setTimeout(() => { if (board) board.resize(); }, 60);

            try {
                if (window.RansomHorror && typeof window.RansomHorror.init === 'function') {
                    RansomHorror.init('chess', {
                        onGameOver: () => triggerChessLoss()
                    });
                }
            } catch (err) {
                console.warn('RansomHorror initialization bypassed:', err);
            }
        }

        function triggerChessLoss() {
            isAiThinking = false;
            updateStatus('<span style="color:var(--danger); font-weight:800;">DEFEAT: RANS0M CORRUPTED MATCH</span>');
        }

        function openChessIntel() {
            document.getElementById('chessIntelModal').classList.add('active');
        }
        function closeChessIntel() {
            document.getElementById('chessIntelModal').classList.remove('active');
        }

        loadChessTelemetry();
        updateStatus();

        // Kinetic Camera Depth Navigation Transition Handler
        function cyberNavigate(url) {
            const overlay = document.getElementById('cyberWipeOverlay');
            document.body.style.transform = 'scale(0.975)';
            document.body.style.filter = 'blur(4px)';
            document.body.style.opacity = '0.6';
            document.body.style.transition = 'all 0.22s cubic-bezier(0.16, 1, 0.3, 1)';

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
            document.body.style.transform = '';
            document.body.style.filter = '';
            document.body.style.opacity = '';
        });