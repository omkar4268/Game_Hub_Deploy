function openRules() { document.getElementById('rulesModal').classList.add('active'); }
  function closeRules() { document.getElementById('rulesModal').classList.remove('active'); }

  function dismissGuesserStartup() {
    document.getElementById('guesserStartup').classList.add('dismissed');
    const input = document.getElementById('guessInput');
    if (input) input.focus();

    if (window.RansomHorror) {
      RansomHorror.init('number_guess', {
        onGameOver: () => triggerGuesserLoss()
      });
    }
  }

  function triggerGuesserLoss() {
    const input = document.getElementById('guessInput');
    if (input) input.disabled = true;
    const submitBtn = document.querySelector('.btn-cyber-primary');
    if (submitBtn) {
      submitBtn.innerText = 'CIRCUIT LOCKED // RESTART REQUIRED';
      submitBtn.style.background = 'var(--danger)';
    }
  }

  // Telemetry Sync
  const bestAttemptsVal = document.getElementById('bestAttemptsVal');
  const splashGuessBest = document.getElementById('splashGuessBest');
  let savedBest = parseInt(localStorage.getItem('hub_guess_best') || '0', 10);
  if (savedBest > 0) {
    bestAttemptsVal.innerText = savedBest + ' tries';
    if (splashGuessBest) splashGuessBest.innerText = savedBest + ' tries';
  }

  if (window.cipherGameWon) {
    const currentTries = window.cipherFinalAttempts || 1;
    if (savedBest === 0 || currentTries < savedBest) {
      localStorage.setItem('hub_guess_best', currentTries);
      bestAttemptsVal.innerText = currentTries + ' tries';
    }

    const calcScore = Math.max(50, (20 - currentTries) * 50);
    fetch('../save_score.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ game: 'number_guess', score: calcScore })
    }).catch(() => console.log('Offline score preserved.'));
  }

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

  window.addEventListener('DOMContentLoaded', () => {
    // If startup already dismissed
    const startup = document.getElementById('guesserStartup');
    if (startup && startup.classList.contains('dismissed')) {
      if (window.RansomHorror) {
        RansomHorror.init('number_guess', { onGameOver: () => triggerGuesserLoss() });
      }
    }
  });