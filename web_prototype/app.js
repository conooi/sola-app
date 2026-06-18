/**
 * SereneStep — Application Controller
 * Handles screen transitions, symptom routing, breathing timers,
 * interactive grounding, and the simulated AI Writing Companion.
 */

// Application State
const state = {
  currentScreen: 'screen-home',
  selectedSymptoms: new Set(),
  activeGroundingStep: 4, // Starts at 4 in the wireframe (5 is already completed)
  breathingInterval: null,
  breathingSecondsLeft: 4,
  breathingPhase: 'inhale', // inhale, hold-in, exhale, hold-out
  selectedTrigger: null,
  selectedFeelings: new Set(),
  constellationStars: 0
};

// Constant Configuration
const BREATHING_PHASES = {
  inhale: { text: 'Breathe In', duration: 4, next: 'hold-in', guide: 'Slowly draw in warm, calming air...' },
  'hold-in': { text: 'Hold', duration: 4, next: 'exhale', guide: 'Feel the quiet strength inside you...' },
  exhale: { text: 'Breathe Out', duration: 4, next: 'hold-out', guide: 'Release all the tension and worries...' },
  'hold-out': { text: 'Hold', duration: 4, next: 'inhale', guide: 'Rest in this still, quiet space...' }
};

// Crisis Keywords for AI Guardrail demonstration
const CRISIS_KEYWORDS = [
  'end it all', 'kill myself', 'suicide', 'die', 'want to die', 
  'hurt myself', 'no point in living', 'end my life', 'cutting'
];

/* ==========================================================================
   Initialization & Event Listeners
   ========================================================================== */
document.addEventListener('DOMContentLoaded', () => {
  initSymptomPills();
  initGroundingList();
  initReflectionControls();
  initBreathingControls();
});

/* ==========================================================================
   Navigation Engine
   ========================================================================== */
function navigateTo(screenId) {
  // Hide current screen
  const current = document.getElementById(state.currentScreen);
  if (current) current.classList.remove('active');
  
  // Show new screen
  const target = document.getElementById(screenId);
  if (target) {
    target.classList.add('active');
    state.currentScreen = screenId;
  }
  
  // Custom screen entrance actions
  if (screenId === 'screen-grounding') {
    startBreathingTimer('small');
  } else if (screenId !== 'immersive-breather') {
    stopBreathingTimer();
  }
}

/* ==========================================================================
   Symptom Checker Module
   ========================================================================== */
function initSymptomPills() {
  const pills = document.querySelectorAll('#screen-symptoms .pill-btn');
  const beginBtn = document.getElementById('begin-grounding-btn');
  
  pills.forEach(pill => {
    pill.addEventListener('click', () => {
      const symptom = pill.dataset.symptom;
      
      // Toggle selection
      if (state.selectedSymptoms.has(symptom)) {
        state.selectedSymptoms.delete(symptom);
        pill.classList.remove('active');
      } else {
        state.selectedSymptoms.add(symptom);
        pill.classList.add('active');
      }
      
      // Enable button if at least one symptom is selected
      beginBtn.disabled = state.selectedSymptoms.size === 0;
    });
  });

  beginBtn.addEventListener('click', () => {
    // Apply Relief Logic Matrix routing
    routeGroundingFlow();
  });
}

/**
 * Relief Logic Matrix Router
 * Dynamically configures the Grounding Flow based on symptom selection.
 */
function routeGroundingFlow() {
  const hasRapidHeart = state.selectedSymptoms.has('sym_heart_rapid');
  const hasDetached = state.selectedSymptoms.has('sym_detached');
  const hasShortBreath = state.selectedSymptoms.has('sym_breath_short');
  const hasRacingThoughts = state.selectedSymptoms.has('sym_racing_thoughts');
  
  const titleText = document.getElementById('grounding-title-text');
  
  if (hasRapidHeart && hasDetached) {
    // Pathway A: High Arousal + Dissociation (5-4-3-2-1 Grounding)
    titleText.textContent = "5-4-3-2-1 Method";
    setupGroundingList('54321');
  } else if (hasShortBreath || hasRacingThoughts) {
    // Pathway B: Respiratory Panic + Racing Mind (Physiological Sigh focus)
    titleText.textContent = "Carbon Reset Method";
    setupGroundingList('sigh');
  } else {
    // Default Fallback
    titleText.textContent = "5-4-3-2-1 Method";
    setupGroundingList('54321');
  }
  
  navigateTo('screen-grounding');
}

/* ==========================================================================
   Interactive Grounding Flow Module (5-4-3-2-1)
   ========================================================================== */
function initGroundingList() {
  // Initialize the visual state of items based on state.activeGroundingStep (which is 4)
  updateGroundingUI();
}

function setupGroundingList(pathwayType) {
  const container = document.getElementById('interactive-grounding-list');
  
  if (pathwayType === 'sigh') {
    // Inject custom cards for Carbon Reset / Respiratory Pathway
    container.innerHTML = `
      <div class="grounding-item active" data-step="1">
        <div class="item-circle">1</div>
        <div class="item-details">
          <span class="item-label">STEP 1</span>
          <span class="item-desc">Physiological Sigh</span>
        </div>
        <div class="item-input-drawer" style="display:block;">
          <p class="drawer-instruction">Take two quick, deep breaths in through your nose, then let out a very long, slow sigh through your mouth. Repeat this 3 times.</p>
          <button class="drawer-submit-btn w-full" onclick="advanceToReflection()">I've completed the sighs</button>
        </div>
      </div>
    `;
  } else {
    // Restore default 5-4-3-2-1 list structure
    container.innerHTML = `
      <!-- 5 Things (Completed in wireframe) -->
      <div class="grounding-item completed" data-step="5">
        <div class="item-circle">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
            <circle cx="12" cy="12" r="3"></circle>
          </svg>
        </div>
        <div class="item-details">
          <span class="item-label">5 THINGS</span>
          <span class="item-desc">You can see around you</span>
        </div>
        <div class="item-status">
          <svg class="check-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="transform: scale(1);">
            <polyline points="20 6 9 17 4 12"></polyline>
          </svg>
        </div>
      </div>

      <!-- 4 Things (Active in wireframe) -->
      <div class="grounding-item active" data-step="4">
        <div class="item-circle">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M18 11V6a2 2 0 0 0-2-2v0a2 2 0 0 0-2 2v0"></path>
            <path d="M14 10V4a2 2 0 0 0-2-2v0a2 2 0 0 0-2 2v0"></path>
            <path d="M10 10.5V6a2 2 0 0 0-2-2v0a2 2 0 0 0-2 2v0"></path>
            <path d="M6 14v-3a2 2 0 0 0-2-2v0a2 2 0 0 0-2 2v11a4 4 0 0 0 4 4h9a5 5 0 0 0 5-5v-7a2 2 0 0 0-2-2v0a2 2 0 0 0-2 2"></path>
          </svg>
        </div>
        <div class="item-details">
          <span class="item-label">4 THINGS</span>
          <span class="item-desc">You can touch or feel</span>
        </div>
        <div class="item-status">
          <svg class="check-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="20 6 9 17 4 12"></polyline>
          </svg>
        </div>
        <div class="item-input-drawer">
          <p class="drawer-instruction">Focus on textures or temperatures: a cool desk, a soft shirt. Acknowledge them.</p>
          <div class="drawer-inputs">
            <input type="text" placeholder="Something cool..." class="grounding-input">
            <input type="text" placeholder="Something soft..." class="grounding-input">
            <input type="text" placeholder="Something solid..." class="grounding-input">
            <input type="text" placeholder="Something textured..." class="grounding-input">
            <button class="drawer-submit-btn" onclick="advanceGroundingStep(4)">I've found them</button>
          </div>
        </div>
      </div>

      <!-- 3 Things -->
      <div class="grounding-item" data-step="3">
        <div class="item-circle">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M11 5L6 9H2v6h4l5 4V5z"></path>
            <path d="M15.54 8.46a5 5 0 0 1 0 7.07"></path>
            <path d="M19.07 4.93a10 10 0 0 1 0 14.14"></path>
          </svg>
        </div>
        <div class="item-details">
          <span class="item-label">3 THINGS</span>
          <span class="item-desc">You can hear right now</span>
        </div>
        <div class="item-status">
          <svg class="check-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="20 6 9 17 4 12"></polyline>
          </svg>
        </div>
        <div class="item-input-drawer">
          <p class="drawer-instruction">Close your eyes for a second. What background sounds stand out?</p>
          <div class="drawer-inputs">
            <input type="text" placeholder="A distant car..." class="grounding-input">
            <input type="text" placeholder="The hum of the fan..." class="grounding-input">
            <input type="text" placeholder="My own breathing..." class="grounding-input">
            <button class="drawer-submit-btn" onclick="advanceGroundingStep(3)">I've heard them</button>
          </div>
        </div>
      </div>

      <!-- 2 Things -->
      <div class="grounding-item" data-step="2">
        <div class="item-circle">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12.8 19.6a3.8 3.8 0 0 1-5.6-3.7"></path>
            <path d="M16 12a4 4 0 0 1-4 4"></path>
          </svg>
        </div>
        <div class="item-details">
          <span class="item-label">2 THINGS</span>
          <span class="item-desc">You can smell</span>
        </div>
        <div class="item-status">
          <svg class="check-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="20 6 9 17 4 12"></polyline>
          </svg>
        </div>
        <div class="item-input-drawer">
          <p class="drawer-instruction">Breathe in deeply. Can you sense a scent of wood, tea, or rain?</p>
          <div class="drawer-inputs">
            <input type="text" placeholder="A hint of coffee..." class="grounding-input">
            <input type="text" placeholder="Fresh laundry..." class="grounding-input">
            <button class="drawer-submit-btn" onclick="advanceGroundingStep(2)">I've smelled them</button>
          </div>
        </div>
      </div>

      <!-- 1 Thing -->
      <div class="grounding-item" data-step="1">
        <div class="item-circle">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
          </svg>
        </div>
        <div class="item-details">
          <span class="item-label">1 THING</span>
          <span class="item-desc">You can taste</span>
        </div>
        <div class="item-status">
          <svg class="check-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="20 6 9 17 4 12"></polyline>
          </svg>
        </div>
        <div class="item-input-drawer">
          <p class="drawer-instruction">What taste linger on your tongue? Or simply focus on the feeling of swallow.</p>
          <div class="drawer-inputs">
            <input type="text" placeholder="A trace of mint..." class="grounding-input">
            <button class="drawer-submit-btn" onclick="advanceGroundingStep(1)">I've tasted it</button>
          </div>
        </div>
      </div>
    `;
    state.activeGroundingStep = 4; // reset step count
    updateGroundingUI();
  }
}

function advanceGroundingStep(stepNum) {
  // Mark current active step as completed
  const currentItem = document.querySelector(`.grounding-item[data-step="${stepNum}"]`);
  if (currentItem) {
    currentItem.classList.remove('active');
    currentItem.classList.add('completed');
  }
  
  // Advance to next step
  state.activeGroundingStep = stepNum - 1;
  
  if (state.activeGroundingStep >= 1) {
    updateGroundingUI();
  } else {
    // All steps finished! Highlight the CTA
    const finishBtn = document.querySelector('#screen-grounding .primary-btn');
    finishBtn.classList.add('pulse-highlight');
    advanceToReflection();
  }
}

function updateGroundingUI() {
  const items = document.querySelectorAll('.grounding-item');
  items.forEach(item => {
    const step = parseInt(item.dataset.step);
    if (step === state.activeGroundingStep) {
      item.classList.add('active');
      item.classList.remove('completed');
    } else if (step > state.activeGroundingStep) {
      item.classList.add('completed');
      item.classList.remove('active');
    } else {
      item.classList.remove('active', 'completed');
    }
  });
}

function advanceToReflection() {
  setTimeout(() => {
    navigateTo('screen-reflection');
  }, 600);
}

/* ==========================================================================
   Breathing Guide Engine (Box Breathing 4-4-4-4)
   ========================================================================== */
function initBreathingControls() {
  const panicBtn = document.getElementById('main-panic-btn');
  panicBtn.addEventListener('click', () => {
    // Trigger the fullscreen immersive breather
    startBreathingOnly();
  });
}

function startBreathingOnly() {
  const overlay = document.getElementById('immersive-breather');
  overlay.classList.add('active');
  startBreathingTimer('large');
}

function stopBreathingOnly() {
  const overlay = document.getElementById('immersive-breather');
  overlay.classList.remove('active');
  stopBreathingTimer();
  navigateTo('screen-home');
}

function startBreathingTimer(type = 'large') {
  // Clear any existing timers
  stopBreathingTimer();
  
  state.breathingSecondsLeft = 4;
  state.breathingPhase = 'inhale';
  
  updateBreathingUI(type);
  
  state.breathingInterval = setInterval(() => {
    state.breathingSecondsLeft--;
    
    if (state.breathingSecondsLeft <= 0) {
      // Transition to next phase
      const currentPhaseConfig = BREATHING_PHASES[state.breathingPhase];
      state.breathingPhase = currentPhaseConfig.next;
      state.breathingSecondsLeft = BREATHING_PHASES[state.breathingPhase].duration;
    }
    
    updateBreathingUI(type);
  }, 1000);
}

function stopBreathingTimer() {
  if (state.breathingInterval) {
    clearInterval(state.breathingInterval);
    state.breathingInterval = null;
  }
}

function updateBreathingUI(type) {
  const config = BREATHING_PHASES[state.breathingPhase];
  
  if (type === 'large') {
    const overlay = document.getElementById('immersive-breather');
    const stageText = document.getElementById('large-breath-text');
    const timerText = document.getElementById('large-breath-timer');
    const guideText = document.getElementById('large-breath-instruction');
    
    // Update labels
    stageText.textContent = config.text;
    timerText.textContent = state.breathingSecondsLeft;
    guideText.textContent = config.guide;
    
    // Update container classes to trigger premium CSS animations
    overlay.className = 'breathing-overlay active ' + state.breathingPhase;
  } else {
    // Small banner breather on Grounding Screen
    const instruction = document.getElementById('breath-instruction');
    const node = document.getElementById('breath-node');
    
    instruction.textContent = `${config.text} (${state.breathingSecondsLeft}s)`;
    
    // Trigger sizing classes
    if (state.breathingPhase === 'inhale' || state.breathingPhase === 'hold-in') {
      node.style.transform = 'scale(1.08)';
      node.style.backgroundColor = 'var(--sage-light)';
    } else {
      node.style.transform = 'scale(0.95)';
      node.style.backgroundColor = 'var(--sage-accent)';
    }
  }
}

/* ==========================================================================
   Reassurance Hub Accordion
   ========================================================================== */
function toggleAccordion(element) {
  // Close all other accordions
  const allAccordions = document.querySelectorAll('.info-accordion');
  allAccordions.forEach(acc => {
    if (acc !== element) acc.classList.remove('open');
  });
  
  // Toggle target accordion
  element.classList.toggle('open');
}

/* ==========================================================================
   Reflection & Journaling Module (AI Simulator)
   ========================================================================== */
function initReflectionControls() {
  const triggerCards = document.querySelectorAll('.trigger-card');
  const feelingPills = document.querySelectorAll('.pill-btn-feeling');
  const saveBtn = document.getElementById('save-journal-btn');
  
  // Trigger Selection (exclusive single select)
  triggerCards.forEach(card => {
    card.addEventListener('click', () => {
      const trigger = card.dataset.trigger;
      
      if (state.selectedTrigger === trigger) {
        state.selectedTrigger = null;
        card.classList.remove('active');
      } else {
        // Clear others
        triggerCards.forEach(c => c.classList.remove('active'));
        state.selectedTrigger = trigger;
        card.classList.add('active');
      }
    });
  });
  
  // Feelings Selection (multi-select)
  feelingPills.forEach(pill => {
    pill.addEventListener('click', () => {
      const feeling = pill.dataset.feeling;
      
      if (state.selectedFeelings.has(feeling)) {
        state.selectedFeelings.delete(feeling);
        pill.classList.remove('active');
      } else {
        state.selectedFeelings.add(feeling);
        pill.classList.add('active');
      }
    });
  });
  
  // Save to Journal (AI Response generation)
  saveBtn.addEventListener('click', () => {
    generateAICompanionResponse();
  });
}

function generateAICompanionResponse() {
  const noteText = document.getElementById('journal-textarea').value.trim();
  const responseBlock = document.getElementById('ai-response-block');
  const responseText = document.getElementById('ai-response-text');
  const saveBtn = document.getElementById('save-journal-btn');
  
  responseBlock.style.display = 'block';
  responseText.textContent = 'Typing a supportive reflection...';
  
  // 1. Check for crisis keywords first
  let isCrisis = false;
  const lowerText = noteText.toLowerCase();
  for (const keyword of CRISIS_KEYWORDS) {
    if (lowerText.includes(keyword)) {
      isCrisis = true;
      break;
    }
  }
  
  setTimeout(() => {
    if (isCrisis) {
      // Trigger strict crisis redirection
      responseText.innerHTML = `<strong>Writing Companion:</strong> I hear how incredibly painful and overwhelming things are right now. Because I want you to be safe and supported by real people who can help, please reach out to someone who can hold space for you. You can connect with a supportive voice at the Crisis Text Line by texting HOME to 741741, or call 988. You do not have to carry this alone.`;
      responseText.style.color = 'var(--coral-soft)';
      return;
    }
    
    // 2. Generate contextual response based on selected triggers and feelings
    let response = "";
    const hasWorkTrigger = state.selectedTrigger === 'work';
    const hasSocialTrigger = state.selectedTrigger === 'social';
    const hasHealthTrigger = state.selectedTrigger === 'health';
    
    const isExhausted = state.selectedFeelings.has('exhausted');
    const isRelieved = state.selectedFeelings.has('relieved');
    const isShaky = state.selectedFeelings.has('shaky');
    
    // Core prompt logic: Validate -> Somatic Grounding -> Compassionate Agency
    if (hasWorkTrigger) {
      response = "I hear how much pressure you've been carrying with work. It makes complete sense that you feel " + 
                 (isExhausted ? "exhausted" : "overwhelmed") + " right now. You don't have to carry the whole project today. If it feels okay, try releasing your shoulders away from your ears and letting out a slow sigh. You are safe in this moment.";
    } else if (hasSocialTrigger) {
      response = "Social settings can demand so much energy, and it's completely valid that you needed to step away. I hear you. If you feel up to it, place both feet flat on the floor and feel the solid ground holding you up. You are allowed to take up space and go at your own pace.";
    } else if (hasHealthTrigger) {
      response = "Health worries can feel extremely frightening and real. Your body was trying to protect you, even if it felt scary. Your heart rate is slowing down now, and you are safe. Try touching something warm nearby, like a cup, and focus on that simple warmth. I am right here with you.";
    } else {
      // Fallback response focusing purely on somatic grounding
      response = "Thank you for putting your thoughts down. It is completely okay to feel " + 
                 (isShaky ? "shaky" : "uncertain") + " after a panic spike. You have survived 100% of these waves, and this one is dissolving too. Take a slow, gentle breath, and let your body settle. You are doing wonderfully.";
    }
    
    responseText.innerHTML = `<strong>Writing Companion:</strong> ${response}`;
    responseText.style.color = 'var(--text-primary)';
    
    // Trigger Habit Design: Add a glowing star to their home constellation
    triggerConstellationReward();
    
    // Swap button text to indicate complete state
    saveBtn.textContent = "Journal Saved";
    saveBtn.style.backgroundColor = "var(--slate-light)";
    saveBtn.disabled = true;
    
    // Redirect to home after review
    setTimeout(() => {
      navigateTo('screen-home');
      resetReflectionScreen();
    }, 5500);
    
  }, 1800); // Realistic typing delay
}

function triggerConstellationReward() {
  state.constellationStars++;
  
  // Create a beautiful floating star element that flies to the top
  const star = document.createElement('div');
  star.className = 'floating-star';
  star.innerHTML = `
    <svg width="24" height="24" viewBox="0 0 24 24" fill="#F4D068" stroke="none">
      <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
    </svg>
  `;
  
  document.body.appendChild(star);
  
  // Clean up star after animation finishes
  setTimeout(() => {
    star.remove();
  }, 2000);
}

function resetReflectionScreen() {
  document.getElementById('journal-textarea').value = "";
  document.getElementById('ai-response-block').style.display = 'none';
  
  const saveBtn = document.getElementById('save-journal-btn');
  saveBtn.textContent = "Save to Journal";
  saveBtn.style.backgroundColor = "var(--sage-primary)";
  saveBtn.disabled = false;
  
  // Clear active states
  document.querySelectorAll('.trigger-card').forEach(c => c.classList.remove('active'));
  document.querySelectorAll('.pill-btn-feeling').forEach(p => p.classList.remove('active'));
  state.selectedTrigger = null;
  state.selectedFeelings.clear();
}
