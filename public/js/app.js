/**
 * SvaraPrana (स्वरप्राण) - Master Application Controller
 * Handles Portal Navigation, Language i18n, Backend API Sync,
 * PWA Cross-Platform Installation, and Interactive Simulations.
 */

document.addEventListener('DOMContentLoaded', () => {
  // 1. Initialize Sub-Engines
  const dsp = new SvaraPranaDSPEngine();
  dsp.initCanvases('waveformCanvas', 'spectrogramCanvas');

  const telecom = new TelecomSimulator();
  telecom.init({
    screenTitleId: 'nokiaScreenTitle',
    screenSubId: 'nokiaScreenSub',
    callDurationId: 'nokiaScreenDuration',
    phoneChassisId: 'nokiaChassis',
    messagesContainerId: 'dialogueMessagesArea'
  });

  // 2. Setup Portal Switching
  const portalBtns = document.querySelectorAll('.portal-tab-btn');
  const portalViews = document.querySelectorAll('.portal-view');

  function switchPortal(portalId) {
    portalBtns.forEach(btn => {
      btn.classList.toggle('active', btn.getAttribute('data-portal') === portalId);
    });

    portalViews.forEach(view => {
      view.classList.toggle('active', view.id === `portal-${portalId}`);
    });

    // Handle canvas sizing on tab switch
    if (portalId === 'dsp-lab') {
      setTimeout(() => {
        dsp.renderWaveform();
        dsp.renderSpectrogram();
      }, 50);
    }
  }

  portalBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetPortal = btn.getAttribute('data-portal');
      switchPortal(targetPortal);
    });
  });

  // Check URL query parameters for direct portal routing (e.g., ?portal=caregiver)
  const urlParams = new URLSearchParams(window.location.search);
  const requestedPortal = urlParams.get('portal');
  if (requestedPortal && document.getElementById(`portal-${requestedPortal}`)) {
    switchPortal(requestedPortal);
  }

  // Quick Action Buttons
  const btnGoCaregiver = document.getElementById('btnGoCaregiver');
  if (btnGoCaregiver) btnGoCaregiver.addEventListener('click', () => switchPortal('caregiver'));

  const btnGoDspLab = document.getElementById('btnGoDspLab');
  if (btnGoDspLab) btnGoDspLab.addEventListener('click', () => switchPortal('dsp-lab'));

  const btnGoCompanion = document.getElementById('btnGoCompanion');
  if (btnGoCompanion) btnGoCompanion.addEventListener('click', () => switchPortal('companion'));

  // 3. Language Switcher (i18n)
  const langSelector = document.getElementById('langSelector');
  function updateLanguage(lang) {
    DATA_STORE.currentLanguage = lang;
    const dict = DATA_STORE.i18n[lang] || DATA_STORE.i18n.en;

    document.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (dict[key]) {
        el.textContent = dict[key];
      }
    });
  }

  if (langSelector) {
    langSelector.addEventListener('change', (e) => {
      updateLanguage(e.target.value);
    });
  }

  // 4. Microphone Audio Toggle
  const btnMicRecord = document.getElementById('btnMicRecord');
  if (btnMicRecord) {
    btnMicRecord.addEventListener('click', async () => {
      if (dsp.isRecording) {
        dsp.stopMicrophone();
        btnMicRecord.classList.remove('active');
        btnMicRecord.innerHTML = `
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2"/><line x1="12" y1="19" x2="12" y2="23"/><line x1="8" y1="23" x2="16" y2="23"/></svg>
          Start Live Microphone DSP
        `;
      } else {
        const res = await dsp.startMicrophone();
        if (res.success) {
          btnMicRecord.classList.add('active');
          btnMicRecord.innerHTML = `
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="6" y="6" width="12" height="12" rx="2"/></svg>
            Stop Live Microphone Stream
          `;
        }
      }
    });
  }

  // 5. Preset Scenario Buttons in DSP Lab
  const scenarioBtns = document.querySelectorAll('.scenario-card-btn');
  scenarioBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      scenarioBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const scenarioId = btn.getAttribute('data-scenario');
      dsp.playSyntheticScenario(scenarioId);

      // Call Backend API to demonstrate full client-server sync
      syncDSPWithBackend(scenarioId);
    });
  });

  async function syncDSPWithBackend(scenarioId) {
    try {
      const response = await fetch('/api/dsp/analyze', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ preset_scenario: scenarioId })
      });
      if (response.ok) {
        const data = await response.json();
        updateDashboardWithAPIData(data);
      }
    } catch (err) {
      console.log('Running in client-side DSP mode (offline / standalone).');
    }
  }

  function updateDashboardWithAPIData(data) {
    const bio = data.biomarkers;
    const bayesian = data.bayesian_compliance;
    const tier = data.safety_tier;

    // Update UI numbers
    setVal('dspValF0', `${bio.f0_hz} Hz`);
    setVal('dspValJitter', `${bio.jitter_pct}%`);
    setVal('dspValShimmer', `${bio.shimmer_pct}%`);
    setVal('dspValHnr', `${bio.hnr_db} dB`);
    setVal('dspValLatency', `${bio.latency_ms} ms`);
    setVal('dspValVitality', `${bio.vitality_composite} / 100`);

    // Bayesian Latency Status
    const bayesianStatusEl = document.getElementById('bayesianStatusText');
    if (bayesianStatusEl) {
      bayesianStatusEl.innerHTML = `
        <strong>${bayesian.status}</strong> (Z-Score: ${bayesian.z_score})<br/>
        <span style="font-size:0.75rem; color:#94A3B8;">${bayesian.recommended_action}</span>
      `;
    }

    // Safety Tier Card Activation
    document.querySelectorAll('.tier-card').forEach(c => c.classList.remove('active'));
    const activeTierCard = document.getElementById(`tierCard${tier.tier_level}`);
    if (activeTierCard) activeTierCard.classList.add('active');

    // Update WhatsApp message preview
    const waDigest = data.whatsapp_digest;
    const waHeadlineEl = document.getElementById('waDigestHeadline');
    if (waHeadlineEl) waHeadlineEl.textContent = waDigest.headline;
    const waBodyTextEl = document.getElementById('waDigestBodyText');
    if (waBodyTextEl) waBodyTextEl.innerHTML = waDigest.message_body.replace(/\n/g, '<br/>');
  }

  function setVal(id, text) {
    const el = document.getElementById(id);
    if (el) el.textContent = text;
  }

  // 6. Connect DSP Local Metrics Listener
  dsp.onMetricsUpdate((current, scenario) => {
    setVal('dspValF0', `${current.f0} Hz`);
    setVal('dspValJitter', `${current.jitter}%`);
    setVal('dspValShimmer', `${current.shimmer}%`);
    setVal('dspValHnr', `${current.hnr} dB`);
    setVal('dspValLatency', `${current.latency} ms`);
    setVal('dspValVitality', `${current.vitality} / 100`);

    // Safety tier cards
    document.querySelectorAll('.tier-card').forEach(c => c.classList.remove('active'));
    const targetCard = document.getElementById(`tierCard${current.tier}`);
    if (targetCard) targetCard.classList.add('active');
  });

  // 7. Blister Pack 30-Day Grid Renderer
  function renderBlisterPackGrid() {
    const gridEl = document.getElementById('blisterPackGrid');
    if (!gridEl) return;
    gridEl.innerHTML = '';

    const elder = DATA_STORE.elders.saraswati_74;
    const totalPills = elder.blisterPack.total;
    const takenPills = elder.blisterPack.taken;

    for (let i = 1; i <= totalPills; i++) {
      const slot = document.createElement('div');
      slot.className = 'pill-foil-slot';

      if (i <= takenPills) {
        slot.classList.add('taken');
        slot.textContent = '✓';
        slot.title = `Day ${i}: Taken on schedule`;
      } else {
        slot.classList.add('remaining');
        slot.textContent = i;
        slot.title = `Day ${i}: Remaining foil cell`;
      }

      gridEl.appendChild(slot);
    }
  }
  renderBlisterPackGrid();

  // 8. Nokia Feature Phone Buttons
  const btnNokiaCall = document.getElementById('btnNokiaCall');
  const btnNokiaEnd = document.getElementById('btnNokiaEnd');
  const btnTriggerChaiCheck = document.getElementById('btnTriggerChaiCheck');

  if (btnNokiaCall) {
    btnNokiaCall.addEventListener('click', () => {
      telecom.answerCall();
    });
  }

  if (btnNokiaEnd) {
    btnNokiaEnd.addEventListener('click', () => {
      telecom.endCall();
    });
  }

  if (btnTriggerChaiCheck) {
    btnTriggerChaiCheck.addEventListener('click', () => {
      telecom.startIncomingCall(DATA_STORE.elders.saraswati_74, 'ta');
    });
  }

  // 9. Safety Protocol Simulator Buttons
  const tierCards = document.querySelectorAll('.tier-card');
  tierCards.forEach(card => {
    card.addEventListener('click', () => {
      tierCards.forEach(c => c.classList.remove('active'));
      card.classList.add('active');
      const tierId = card.getAttribute('data-tier');

      if (tierId === '3') {
        // Trigger emergency sound beep
        telecom.playRingTone();
      }
    });
  });

  // 10. Platform Download & Cross-Platform Installation Modal
  const modalOverlay = document.getElementById('installModalOverlay');
  const btnInstallApp = document.getElementById('btnInstallApp');
  const btnCloseModal = document.getElementById('btnCloseModal');

  if (btnInstallApp && modalOverlay) {
    btnInstallApp.addEventListener('click', () => {
      modalOverlay.classList.add('active');
    });
  }

  if (btnCloseModal && modalOverlay) {
    btnCloseModal.addEventListener('click', () => {
      modalOverlay.classList.remove('active');
    });
  }

  if (modalOverlay) {
    modalOverlay.addEventListener('click', (e) => {
      if (e.target === modalOverlay) modalOverlay.classList.remove('active');
    });
  }

  // PWA Install Prompt
  let deferredPrompt;
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferredPrompt = e;
    if (btnInstallApp) {
      btnInstallApp.textContent = 'Install App (PWA)';
      btnInstallApp.addEventListener('click', () => {
        if (deferredPrompt) {
          deferredPrompt.prompt();
          deferredPrompt.userChoice.then(() => {
            deferredPrompt = null;
          });
        }
      });
    }
  });

  // Register Service Worker
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/service-worker.js').catch(err => {
      console.log('SW registration note:', err);
    });
  }

  // Initial load: trigger default normal scenario
  dsp.playSyntheticScenario('normal');
});
