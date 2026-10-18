# SvaraPrana (स्वरप्राण)
### Ambient Acoustic Telephony Care Bridge & Autonomous Indic Voice Adherence Platform

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Python](https://img.shields.io/badge/Python-3.11%2B-blue)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Production_Ready-009688)](https://fastapi.tiangolo.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.x_|_Material_3-02569B)](https://flutter.dev)
[![DPDP Act](https://img.shields.io/badge/Compliance-DPDP_Act_2023-10B981)](https://www.meity.gov.in)
[![Platform](https://img.shields.io/badge/Platform-Web_|_Android_APK_|_Windows_|_iOS-6366F1)](https://github.com)

**Track:** Remote Elderly Healthcare & Family Care Coordination  
**Hackathon:** SaarthiX Hackathon 2026  
**Implementation Lead:** **Harish Hari** (Principal Software Engineer & Technical Designer)

---

## 1. Executive Summary & Problem Statement

Over **140 million Indian citizens are aged 60+**, with more than **25% living in solitary households** across Tier-2/3 towns and villages as adult children migrate to metropolitan IT hubs or abroad. Existing eldercare technology faces persistent adoption barriers:
* **72% of smartwatches and wearables are abandoned within 3 weeks** due to charging friction, skin irritation in humid climates, and being left on nightstands.
* **Smart cameras are rejected within 72 hours** as elders refuse constant optical surveillance as an invasion of dignity.
* **Touchscreen healthcare apps** require fine motor dexterity, visual sharpness, and English literacy, leaving 80%+ of elderly citizens behind.

### The SvaraPrana Innovation
Instead of demanding behavioral changes or imposing expensive gadgets, **SvaraPrana meets elders where they already are: on everyday telephone calls**.
Every senior in India knows how to answer a ringing phone. SvaraPrana turns regular voice calls into an ambient clinical diagnostic and medication adherence window:
* **₹0 New Hardware Required**: Operates over standard 2G feature phones (e.g. ₹900 Nokia 105), Samsung Guru, JioPhone, or landlines.
* **Active Semantic Telemetry & Speech-to-Text (STT)**: Direct autonomous calls verify medication intake using spoken Indic speech recognition across Kannada, Hindi, Tamil, Telugu, and English.
* **Ambient Acoustic Biomarkers**: Cycle-to-cycle vocal jitter, glottal shimmer, and harmonics-to-noise ratio (HNR) are extracted in volatile RAM to detect early hydration and respiratory distress.
* **Statutory Privacy**: 100% compliant with India's **DPDP Act 2023** (Section 6 Purpose Limitation & Section 8 Data Minimisation). Raw audio is purged from RAM in <200ms with zero persistent disk audio retention.

---

## 2. System Architecture

```
                    SVARAPRANA DUAL-ENGINE ARCHITECTURE
  
  [ Elder's Regular Phone ] (GSM / 2G / 3G / 4G / Landline — Zero App)
            │
            ▼
  ┌────────────────────────────────────────────────────────────────────────┐
  │ TELECOM MEDIA INGESTION (Asterisk / Exotel / FreeSWITCH Gateway)       │
  └───────────────────┬────────────────────────────────┬───────────────────┘
                      │                                │
                      ▼                                ▼
         [ Engine A: Live Copilot Call ]      [ Engine B: Autonomous Voice Bot ]
         Son dials parent via phone dialer;   Direct cellular call placed by Bot;
         AI listens & auto-fills adherence    Bot speaks natively in Kannada/Hindi
         spaces without user clicking chips.  and verifies pill compliance aloud.
                      │                                │
                      └────────────────┬───────────────┘
                                       │
                                       ▼
  ┌────────────────────────────────────────────────────────────────────────┐
  │ TRANSIENT 4-STAGE IN-MEMORY DSP & SEMANTIC TELEMETRY PIPELINE          │
  │                                                                        │
  │  Stage 1: 8kHz GSM Ingest (G.711/AMR) + Acoustic Noise Cancellation    │
  │  Stage 2: Real-time Indic Speech-to-Text (Wav2Vec2 / WebSpeech DSP)    │
  │  Stage 3: Clinical Entity & Adherence Extraction (BP, Sugar, Calcium)  │
  │  Stage 4: Cryptographic Zeroing (memset_s) & Audio Buffer Destruction  │
  └────────────────────────────────────┬───────────────────────────────────┘
                                       │
                                       ▼
  ┌────────────────────────────────────────────────────────────────────────┐
  │ CAREGIVER COORDINATION & TIERED ESCALATION HUB                         │
  │ (WhatsApp Cloud API Digest + 4-Tier Automated Safety Protocol Matrix)  │
  └────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Core Features & Capabilities

### A. Direct Telephony Dialing & Autonomous Voice Bot
* **Dual Call Modes**:
  1. **Son Call + Live AI Copilot**: Dials the parent directly while the AI continuously monitors the call audio to check out medication spaces in real-time.
  2. **AI Bot to Inspect**: Places a direct cellular call (`tel:`) and autonomous voice bot speaks out loud via native **Android `TextToSpeech`** in the elder's regional language to ask if they took their medication.
* **Zero Fake Clicker Chips**: All artificial simulation buttons have been eliminated. Adherence spaces (Telmisartan 40mg, Metformin 500mg, Calcium 500mg) are verified via true spoken acoustic recognition.

### B. Decoupled Web & App UI Language from Elder Profile
* Caregivers can keep their dashboard interface in English (or their language of choice) while each parent profile maintains an independent **Bot Call Language** (Kannada, Tamil, Hindi, Telugu, English).
* Switching between elder profiles (Amma, Appa, Dadi) smoothly switches contact numbers and bot speech dialects without altering the caregiver's web interface language.

### C. Tiered Safety Protocols & Real-Time SOS Dispatch
* **Tier 0**: Healthy daily routine confirmed.
* **Tier 1**: Subtle vocal drift / hesitation; scheduled gentle SMS reminder.
* **Tier 2**: Actionable deviation; automated alert dispatched to family WhatsApp care circle.
* **Tier 3 (Emergency SOS)**: Direct dispatch of distress message with live GPS coordinates to caretaker WhatsApp chat and 1-tap **108 Ambulance** dispatch bridge.

### D. Apollo Pharmacy Blister Pack Reconciliation
* Real-time 30-day velocity tracker for chronic prescriptions.
* Formatted WhatsApp prescription dispatch directly to local chemists for doorstep refills.

---

## 4. Multi-Platform Delivery Suite

| Platform | Technology | Deliverable / Package | Status |
|---|---|---|---|
| **Android Mobile App** | Flutter 3.x, Kotlin, Native TTS & Dialer Channels | `app-release.apk` (48.2 MB) | **Ready & Verified** |
| **Web & PWA Suite** | HTML5, Vanilla CSS, Web Audio API, SpeechSynthesis | `index.html` & `public/index.html` | **100% Operational** |
| **Backend REST API** | Python 3.11+, FastAPI, Uvicorn, NumPy, SciPy | `server.py` | **Live on Port 8000** |
| **Windows Desktop** | Standalone Desktop PWA & Batch Launcher | `install-svaraprana-pwa.bat` | **Ready** |

---

## 5. API Reference & Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/api/system/health` | `GET` | Health status and DPDP Act 2023 semantic telemetry audit. |
| `/api/stt/transcribe` | `POST` | Real-time Indic Speech-to-Text & semantic medication verification. |
| `/api/parent-enquiry/call` | `POST` | Direct telephony call trigger with acoustic latency evaluation. |
| `/api/dsp/analyze` | `POST` | Micro-acoustic biomarker analysis (Jitter, Shimmer, HNR, F0). |
| `/api/bayesian/evaluate` | `POST` | Longitudinal Bayesian baseline calculation. |
| `/api/emergency/dispatch` | `POST` | Tier-3 SOS dispatch with live GPS coordinates. |
| `/download/app-release.apk` | `GET` | Direct binary download of the Android release APK. |

---

## 6. Local Setup & Quickstart

### Prerequisites
* **Python 3.11+**
* **Flutter SDK 3.x** (for Android APK builds)
* **Android Studio / Android SDK** (Command-line tools)

### 1. Run the FastAPI Backend & Web Application
```bash
python server.py
```
Open **[http://localhost:8000](http://localhost:8000)** in your browser.  
Interactive Swagger documentation is available at **[http://localhost:8000/docs](http://localhost:8000/docs)**.

### 2. Run the Full Test Suite
```bash
python verify_all.py
```
Validates DSP algorithms, Bayesian latency modeling, 4-tier escalation logic, and API endpoints (100% pass rate).

### 3. Build the Flutter Android APK
```bash
flutter build apk --release
```
The compiled binary will be placed at `build/app/outputs/flutter-apk/app-release.apk` and served at `/download/app-release.apk`.

---

## 7. License & Compliance

* **License**: Apache 2.0  
* **DPDP Act 2023 Compliance**: Section 6 Purpose Limitation & Section 8 Data Minimisation & Erasure. All raw audio streams are stored exclusively in volatile RAM ring buffers and wiped immediately upon completion.
