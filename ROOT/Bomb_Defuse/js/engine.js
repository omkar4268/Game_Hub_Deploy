// Level Configuration
const levelData = [
    { id: 1, modules: ['easy'] },
    { id: 2, modules: ['easy', 'easy'] },
    { id: 3, modules: ['easy', 'med'] },
    { id: 4, modules: ['med', 'med'] },
    { id: 5, modules: ['easy', 'med', 'hard'] },
    { id: 6, modules: ['med', 'med', 'hard'] },
    { id: 7, modules: ['easy', 'hard', 'hard', 'easy'] },
    { id: 8, modules: ['med', 'hard', 'hard', 'med'] },
    { id: 9, modules: ['hard', 'hard', 'hard', 'med', 'med'] },
    { id: 10, modules: ['hard', 'hard', 'hard', 'hard', 'med', 'easy'], boss: true }
];

let currentLevel = 0;
let timeRemaining = 180;
let timerInterval = null;
let strikes = 0;
let modulesToSolve = 0;
let activeModuleIndex = -1;

// Mini-game state
let mgClicks = 0;
let mgRequired = 0;

// Initialize Menu
function initMenu() {
    const grid = document.getElementById('levelGrid');
    grid.innerHTML = '';
    levelData.forEach(lvl => {
        const btn = document.createElement('button');
        btn.className = `level-btn ${lvl.boss ? 'boss' : ''}`;
        btn.innerText = `LVL ${lvl.id < 10 ? '0'+lvl.id : lvl.id}`;
        btn.onclick = () => startLevel(lvl.id);
        grid.appendChild(btn);
    });
}

// Start Game
function startLevel(levelId) {
    currentLevel = levelId;
    const lvl = levelData.find(l => l.id === levelId);
    
    strikes = 0;
    timeRemaining = 180;
    modulesToSolve = lvl.modules.length;
    document.body.classList.remove('panic-mode');
    
    updateStrikes();
    renderModules(lvl.modules);
    
    document.getElementById('screen-menu').classList.remove('active');
    document.getElementById('screen-result').classList.remove('active');
    document.getElementById('screen-game').classList.add('active');
    
    clearInterval(timerInterval);
    timerInterval = setInterval(gameTick, 1000);
    updateTimerDisplay();
}

function renderModules(modules) {
    const grid = document.getElementById('moduleGrid');
    grid.innerHTML = '';
    
    for(let i=0; i<6; i++) {
        const modDiv = document.createElement('div');
        
        if (i < modules.length) {
            const diff = modules[i];
            let diffClass, diffText, reqClicks;
            
            if (diff === 'easy') { diffClass = 'diff-easy'; diffText = 'EASY'; reqClicks = 3; }
            if (diff === 'med') { diffClass = 'diff-med'; diffText = 'MEDIUM'; reqClicks = 6; }
            if (diff === 'hard') { diffClass = 'diff-hard'; diffText = 'HARD'; reqClicks = 10; }

            modDiv.className = 'module';
            modDiv.id = `mod-${i}`;
            modDiv.innerHTML = `
                <div class="module-title">MODULE 0${i+1}</div>
                <div class="module-diff ${diffClass}">${diffText}</div>
                <div class="module-status">[ ACTIVE ]</div>
            `;
            modDiv.onclick = () => openMiniGame(i, diffText, reqClicks);
        } else {
            modDiv.className = 'module empty';
            modDiv.innerHTML = `<div class="module-title">SLOT 0${i+1}</div><div class="module-status">[ OFFLINE ]</div>`;
        }
        grid.appendChild(modDiv);
    }
}

// Timer & Panic Mode
function gameTick() {
    timeRemaining--;
    updateTimerDisplay();

    if (timeRemaining === 60) {
        document.body.classList.add('panic-mode');
    }

    if (timeRemaining <= 0) {
        triggerExplosion("TIME OUT");
    }
}

function updateTimerDisplay() {
    const m = Math.floor(timeRemaining / 60);
    const s = timeRemaining % 60;
    const ms = Math.floor(Math.random() * 99);
    document.getElementById('timerDisplay').innerText = 
        `0${m}:${s < 10 ? '0'+s : s}:${ms < 10 ? '0'+ms : ms}`;
}

function updateStrikes() {
    document.getElementById('strike1').className = strikes >= 1 ? 'led active' : 'led';
    document.getElementById('strike2').className = strikes >= 2 ? 'led active' : 'led';
    document.getElementById('strike3').className = strikes >= 3 ? 'led active' : 'led';
    
    if (strikes >= 3) {
        triggerExplosion("INTEGRITY COMPROMISED");
    }
}

// Mini Game Interaction
function openMiniGame(index, diff, requiredClicks) {
    activeModuleIndex = index;
    mgRequired = requiredClicks;
    mgClicks = 0;
    
    document.getElementById('mgTitle').innerText = `${diff} OVERRIDE`;
    document.getElementById('mgTarget').innerText = `0 / ${mgRequired}`;
    document.getElementById('miniGameOverlay').style.display = 'flex';
}

document.getElementById('hackBtn').onclick = function() {
    mgClicks++;
    document.getElementById('mgTarget').innerText = `${mgClicks} / ${mgRequired}`;
    
    if (mgRequired === 10 && Math.random() < 0.1) {
        closeMiniGame(false, true);
        return;
    }

    if (mgClicks >= mgRequired) {
        closeMiniGame(true);
    }
};

function closeMiniGame(success, causedStrike = false) {
    document.getElementById('miniGameOverlay').style.display = 'none';
    
    if (success) {
        const mod = document.getElementById(`mod-${activeModuleIndex}`);
        mod.classList.add('solved');
        mod.onclick = null;
        modulesToSolve--;
        
        if (modulesToSolve === 0) {
            triggerSuccess();
        }
    } else if (causedStrike) {
        strikes++;
        updateStrikes();
    }
}

// Game Over / Success
function triggerExplosion(reason) {
    clearInterval(timerInterval);
    document.getElementById('screen-game').classList.remove('active');
    document.body.classList.remove('panic-mode');
    
    const resBox = document.getElementById('resultBox');
    resBox.className = 'ending-box explosion';
    document.getElementById('resultTitle').innerText = "DETONATION";
    document.getElementById('resultSub').innerText = `FATAL ERROR: ${reason}`;
    document.getElementById('screen-result').classList.add('active');
}

function triggerSuccess() {
    clearInterval(timerInterval);
    document.getElementById('screen-game').classList.remove('active');
    document.body.classList.remove('panic-mode');
    
    const resBox = document.getElementById('resultBox');

    // Calculate score: Level * 100 + Remaining Seconds
    const levelScore = (currentLevel * 100) + timeRemaining;
    const existingHigh = parseInt(localStorage.getItem('hub_defuse_high') || '0', 10);
    if (levelScore > existingHigh) {
        localStorage.setItem('hub_defuse_high', levelScore);
    }

    // Extended Hub Records Tracking
    const currentDisarms = parseInt(localStorage.getItem('hub_defuse_disarms') || '0', 10) + 1;
    localStorage.setItem('hub_defuse_disarms', currentDisarms);

    const currentMaxLvl = parseInt(localStorage.getItem('hub_defuse_level') || '0', 10);
    if (currentLevel > currentMaxLvl) {
        localStorage.setItem('hub_defuse_level', currentLevel);
    }

    const strikesAvoidedThisRun = Math.max(0, 3 - strikes);
    const totalStrikesAvoided = parseInt(localStorage.getItem('hub_defuse_strikes_avoided') || '0', 10) + strikesAvoidedThisRun;
    localStorage.setItem('hub_defuse_strikes_avoided', totalStrikesAvoided);

    // Sync to Cloud
    fetch('../save_score.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ game: 'bomb_defuse', score: levelScore })
    }).catch(() => console.log("Offline mode"));
    
    if (currentLevel === 10) {
        resBox.className = 'ending-box secret-ending';
        document.getElementById('resultTitle').innerText = "GHOST PROTOCOL UNLOCKED";
        document.getElementById('resultSub').innerHTML = `
            You defused the impossible.<br><br>
            [ SCORE: ${levelScore} PTS ]<br>
            [ SYSTEM ARCHIVE ACCESS GRANTED ]<br>
            "The architect left a backdoor in Sector 7."
        `;
    } else {
        resBox.className = 'ending-box success';
        document.getElementById('resultTitle').innerText = "DEFUSED";
        document.getElementById('resultSub').innerText = `THREAT NEUTRALIZED. SCORE: ${levelScore} PTS`;
    }
    
    document.getElementById('screen-result').classList.add('active');
}

function abortToMenu() {
    clearInterval(timerInterval);
    document.body.classList.remove('panic-mode');
    document.getElementById('screen-game').classList.remove('active');
    document.getElementById('screen-result').classList.remove('active');
    document.getElementById('miniGameOverlay').style.display = 'none';
    document.getElementById('screen-menu').classList.add('active');
}

// Initial Call
initMenu();