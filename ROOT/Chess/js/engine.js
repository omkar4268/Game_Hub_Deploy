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

            if (window.RansomHorror) {
                RansomHorror.notifyChessMove(move);
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
            
            if (board.orientation() === 'black') {
                window.setTimeout(makeAiMove, 300);
            }
        });

        $('#flipBtn').on('click', () => board.flip());
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

            if (window.RansomHorror) {
                RansomHorror.init('chess', {
                    onGameOver: () => triggerChessLoss()
                });
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