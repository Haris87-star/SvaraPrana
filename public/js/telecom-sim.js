/**
 * SvaraPrana - Telecom Simulator & Indic Voice Companion ("Svara Saarthi")
 * Simulates GSM telephony call state, Nokia 105 DTMF dial pad,
 * multi-lingual speech synthesis, and Cognitive Hesitation Latency measurement.
 */

class TelecomSimulator {
  constructor() {
    this.audioCtx = null;
    this.callState = 'IDLE'; // IDLE, RINGING, ACTIVE, ENDED
    this.currentTurn = 0;
    this.activeElder = DATA_STORE.elders.saraswati_74;
    this.currentLang = 'en';

    this.timerInterval = null;
    this.callDurationSec = 0;
    this.turnTimerStart = 0;

    // Nokia LCD Screen Elements
    this.screenTitleEl = null;
    this.screenSubEl = null;
    this.callDurationEl = null;
    this.phoneChassisEl = null;
    this.messagesContainerEl = null;

    // DTMF Frequencies (Row & Col Hz)
    this.dtmfFrequencies = {
      '1': [697, 1209], '2': [697, 1336], '3': [697, 1477],
      '4': [770, 1209], '5': [770, 1336], '6': [770, 1477],
      '7': [852, 1209], '8': [852, 1336], '9': [852, 1477],
      '*': [941, 1209], '0': [941, 1336], '#': [941, 1477]
    };
  }

  init(domBindings) {
    this.screenTitleEl = document.getElementById(domBindings.screenTitleId);
    this.screenSubEl = document.getElementById(domBindings.screenSubId);
    this.callDurationEl = document.getElementById(domBindings.callDurationId);
    this.phoneChassisEl = document.getElementById(domBindings.phoneChassisId);
    this.messagesContainerEl = document.getElementById(domBindings.messagesContainerId);

    this.setupKeypad();
    this.renderIdleScreen();
  }

  ensureAudioContext() {
    if (!this.audioCtx) {
      const AudioContextClass = window.AudioContext || window.webkitAudioContext;
      this.audioCtx = new AudioContextClass();
    }
    if (this.audioCtx.state === 'suspended') {
      this.audioCtx.resume();
    }
  }

  playDTMFTone(digit) {
    this.ensureAudioContext();
    const freqs = this.dtmfFrequencies[digit];
    if (!freqs) return;

    const ctx = this.audioCtx;
    const osc1 = ctx.createOscillator();
    const osc2 = ctx.createOscillator();
    const gain = ctx.createGain();

    osc1.frequency.value = freqs[0];
    osc2.frequency.value = freqs[1];

    gain.gain.setValueAtTime(0.12, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.15);

    osc1.connect(gain);
    osc2.connect(gain);
    gain.connect(ctx.destination);

    osc1.start();
    osc2.start();
    osc1.stop(ctx.currentTime + 0.16);
    osc2.stop(ctx.currentTime + 0.16);
  }

  playRingTone() {
    this.ensureAudioContext();
    const ctx = this.audioCtx;
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();

    osc.frequency.setValueAtTime(440, ctx.currentTime);
    gain.gain.setValueAtTime(0.08, ctx.currentTime);
    gain.gain.setValueAtTime(0.08, ctx.currentTime + 0.8);
    gain.gain.setValueAtTime(0.001, ctx.currentTime + 0.85);

    osc.connect(gain);
    gain.connect(ctx.destination);

    osc.start();
    osc.stop(ctx.currentTime + 0.9);
  }

  setupKeypad() {
    const keys = document.querySelectorAll('.nokia-key');
    keys.forEach(k => {
      k.addEventListener('click', () => {
        const digit = k.getAttribute('data-key');
        if (digit) {
          this.playDTMFTone(digit);
          if (this.screenSubEl && this.callState === 'IDLE') {
            this.screenSubEl.textContent += digit;
          }
        }
      });
    });
  }

  startIncomingCall(elder = null, lang = 'ta') {
    this.activeElder = elder || DATA_STORE.elders.saraswati_74;
    this.currentLang = lang;
    this.callState = 'RINGING';

    if (this.phoneChassisEl) {
      this.phoneChassisEl.classList.add('is-ringing');
    }

    if (this.screenTitleEl) {
      this.screenTitleEl.textContent = 'INCOMING GSM CALL';
    }
    if (this.screenSubEl) {
      this.screenSubEl.textContent = 'Svara Saarthi (स्वर सारथी)';
    }

    this.playRingTone();
    this.ringInterval = setInterval(() => {
      if (this.callState === 'RINGING') {
        this.playRingTone();
      } else {
        clearInterval(this.ringInterval);
      }
    }, 2500);
  }

  answerCall() {
    if (this.callState !== 'RINGING') return;

    clearInterval(this.ringInterval);
    if (this.phoneChassisEl) {
      this.phoneChassisEl.classList.remove('is-ringing');
    }

    this.callState = 'ACTIVE';
    this.currentTurn = 0;
    this.callDurationSec = 0;

    if (this.screenTitleEl) {
      this.screenTitleEl.textContent = 'CALL CONNECTED';
    }

    this.startCallTimer();
    this.runConversationalScript();
  }

  endCall() {
    clearInterval(this.ringInterval);
    clearInterval(this.timerInterval);

    if (this.phoneChassisEl) {
      this.phoneChassisEl.classList.remove('is-ringing');
    }

    this.callState = 'ENDED';
    if (this.screenTitleEl) {
      this.screenTitleEl.textContent = 'CALL DISCONNECTED';
    }
    if (this.screenSubEl) {
      this.screenSubEl.textContent = `Duration: ${this.formatDuration(this.callDurationSec)}`;
    }

    setTimeout(() => {
      this.renderIdleScreen();
    }, 3500);
  }

  renderIdleScreen() {
    this.callState = 'IDLE';
    if (this.screenTitleEl) {
      this.screenTitleEl.textContent = 'AIRTEL 2G GSM';
    }
    if (this.screenSubEl) {
      this.screenSubEl.textContent = 'Ready for Routine Check';
    }
    if (this.callDurationEl) {
      this.callDurationEl.textContent = '08:15 AM';
    }
  }

  startCallTimer() {
    clearInterval(this.timerInterval);
    this.timerInterval = setInterval(() => {
      this.callDurationSec++;
      if (this.callDurationEl) {
        this.callDurationEl.textContent = this.formatDuration(this.callDurationSec);
      }
    }, 1000);
  }

  formatDuration(sec) {
    const m = Math.floor(sec / 60).toString().padStart(2, '0');
    const s = (sec % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  }

  runConversationalScript() {
    if (!this.messagesContainerEl) return;
    this.messagesContainerEl.innerHTML = '';

    // Script dialogue turns tailored to Tamil & Hindi elder personas
    const dialogues = [
      {
        speaker: 'Svara Saarthi (AI Companion)',
        textEn: 'Good morning Amma! Did you enjoy your hot cup of tea today?',
        textIndic: 'வணக்கம் அம்மா! இன்னைக்கு காலையில நல்லா காபி, டீ குடிச்சீங்களா?',
        sender: 'companion',
        delay: 800
      },
      {
        speaker: 'Shrimati Saraswati (Elder)',
        textEn: 'Yes dear, I had my ginger tea right at seven with neighbor.',
        textIndic: 'ஆமாம் மா, காலையில ஏழு மணிக்கே சுக்கு டீ குடிச்சிட்டேன்.',
        sender: 'elder',
        latencyMs: 440,
        delay: 3500
      },
      {
        speaker: 'Svara Saarthi (Associative Memory Hook)',
        textEn: 'Wonderful Amma. Did you have that tea before or after your morning yellow tablet?',
        textIndic: 'ரொம்ப சந்தோஷம் அம்மா. அந்த மஞ்சள் மாத்திரை டீ குடிக்கிறதுக்கு முன்னாடியா இல்ல பின்னாடியா போட்டீங்க?',
        sender: 'companion',
        delay: 6000
      },
      {
        speaker: 'Shrimati Saraswati (Cognitive Recall & Latency)',
        textEn: 'Haan... I took it right after tea, completely fine.',
        textIndic: 'ஆமா... டீ குடிச்ச உடனே மறக்காம போட்டுட்டேன் மா.',
        sender: 'elder',
        latencyMs: 1850, // Latency spike!
        hesitationFlag: true,
        delay: 9500
      },
      {
        speaker: 'Svara Saarthi (Warm Closing)',
        textEn: 'Have a blessed day Amma! We will chat with Ananya in the evening.',
        textIndic: 'அருமை அம்மா! சாயங்காலம் அனன்யா பேசும்போது சொல்றேன். நல்லா இருங்க!',
        sender: 'companion',
        delay: 13000
      }
    ];

    dialogues.forEach(item => {
      setTimeout(() => {
        if (this.callState !== 'ACTIVE') return;
        this.appendDialogueBubble(item);
        this.speakText(item.textIndic || item.textEn);
      }, item.delay);
    });

    // Auto complete call after script finishes
    setTimeout(() => {
      if (this.callState === 'ACTIVE') {
        this.endCall();
      }
    }, 16500);
  }

  appendDialogueBubble(item) {
    if (!this.messagesContainerEl) return;
    const bubble = document.createElement('div');
    bubble.className = item.sender === 'companion' ? 'companion-bubble' : 'elder-bubble';

    let latencyBadge = '';
    if (item.latencyMs) {
      const isHigh = item.latencyMs > 1200;
      latencyBadge = `
        <span class="badge-tag ${isHigh ? 'warning' : 'optimal'}" style="margin-left: 0.5rem; font-size: 0.65rem;">
          Δt ${item.latencyMs}ms ${isHigh ? '(Cognitive Hesitation Z=2.8)' : '(Habitual)'}
        </span>
      `;
    }

    bubble.innerHTML = `
      <div class="${item.sender === 'companion' ? 'companion-bubble-speaker' : 'elder-bubble-speaker'}">
        ${item.speaker} ${latencyBadge}
      </div>
      <div class="${item.sender === 'companion' ? 'companion-bubble-text' : 'elder-bubble-text'}">
        ${item.textEn}
      </div>
      <div class="companion-bubble-indic" style="color: ${item.sender === 'companion' ? '#A5B4FC' : '#6EE7B7'};">
        ${item.textIndic}
      </div>
    `;

    this.messagesContainerEl.appendChild(bubble);
    this.messagesContainerEl.scrollTop = this.messagesContainerEl.scrollHeight;
  }

  speakText(text) {
    if (!('speechSynthesis' in window)) return;
    try {
      window.speechSynthesis.cancel();
      const utterance = new SpeechSynthesisUtterance(text);
      utterance.rate = 0.95;
      utterance.pitch = 1.05;

      const voices = window.speechSynthesis.getVoices();
      const indicVoice = voices.find(v => v.lang.startsWith('ta') || v.lang.startsWith('hi') || v.lang.includes('India'));
      if (indicVoice) utterance.voice = indicVoice;

      window.speechSynthesis.speak(utterance);
    } catch (e) {
      // Audio speech synthesis fallback
    }
  }
}

window.TelecomSimulator = TelecomSimulator;
