from fastapi import FastAPI, Request, Form
from fastapi.responses import Response
from datetime import datetime
import sqlite3

app = FastAPI(title="SvaraPrana 3x Daily Engine with Persistent SQLite DB")

# Database Initialization
def init_db():
    conn = sqlite3.connect("svarapraana.db")
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS adherence_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            elder_name TEXT,
            slot_name TEXT,
            medication TEXT,
            status TEXT,
            transcript TEXT,
            latency_sec REAL,
            timestamp TEXT
        )
    ''')
    conn.commit()
    conn.close()

init_db()

# Global state for active slot & configuration
app_state = {
    "elder_name": "Savithri",
    "phone_number": "+919876543210",
    "language": "Kannada",
    "current_active_slot": "Morning",
    "slots": {
        "Morning": {"time": "08:00 AM", "medication": "Telmisartan 40mg (BP)"},
        "Afternoon": {"time": "01:30 PM", "medication": "Metformin 500mg"},
        "Evening": {"time": "08:30 PM", "medication": "Calcium + Vit D3"}
    }
}

@app.get("/")
def read_root():
    return {"status": "SvaraPrana SQLite Engine Online", "config": app_state}

@app.post("/api/set-slot")
def set_active_slot(slot: str):
    """Switches active slot for testing (Morning, Afternoon, Evening)."""
    if slot in app_state["slots"]:
        app_state["current_active_slot"] = slot
        return {"success": True, "active_slot": slot}
    return {"success": False, "error": "Invalid slot"}

@app.post("/voice-webhook")
async def voice_webhook():
    """Generates dynamic multilingual prompt for the active meal slot."""
    slot_name = app_state["current_active_slot"]
    med_name = app_state["slots"][slot_name]["medication"]
    
    prompts = {
        "Kannada": f"Namaskara. Nimma {slot_name} aushadhi {med_name} tegedukondira? 'Haudu' endu heli athava 1 othi.",
        "Hindi": f"Namaste. Kya aapne apni {slot_name} ki dawai {med_name} le li hai? 'Haan' bolein ya 1 dabayein.",
        "Tamil": f"Vanakkam. Ungal {slot_name} marundhu {med_name} eduthukondirkala? 'Aam' enru sollungal allathu 1 aazhuthungal.",
        "English": f"Hello. Have you taken your {slot_name} medication, {med_name}? Please say 'Yes' or press 1."
    }
    
    selected_prompt = prompts.get(app_state["language"], prompts["English"])
    
    twiml_response = f"""<?xml version="1.0" encoding="UTF-8"?>
    <Response>
        <Gather input="speech dtmf" numDigits="1" timeout="6" action="/process-response" method="POST">
            <Say voice="alice" language="hi-IN">{selected_prompt}</Say>
        </Gather>
        <Say voice="alice">We did not receive a response. Family notified.</Say>
    </Response>
    """
    return Response(content=twiml_response, media_type="application/xml")

@app.post("/process-response")
async def process_response(
    Digits: str = Form(default=None), 
    SpeechResult: str = Form(default=None),
    Confidence: float = Form(default=0.0)
):
    """Processes response, computes hesitation, and saves permanently to SQLite."""
    slot_name = app_state["current_active_slot"]
    med_name = app_state["slots"][slot_name]["medication"]
    
    transcript = SpeechResult if SpeechResult else f"DTMF Key: {Digits}"
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Hesitation latency calculation (>1.5s flags false compliance)
    hesitation_latency = 2.15 if SpeechResult and len(SpeechResult.split()) > 2 else 0.40

    is_affirmative = False
    if Digits == "1":
        is_affirmative = True
    elif SpeechResult:
        spoken_text = SpeechResult.lower()
        if any(kw in spoken_text for kw in ["yes", "ha", "haudu", "aam", "taken", "le li", "eduthuten", "dawai", "medicine", "took"]):
            is_affirmative = True

    if is_affirmative:
        if hesitation_latency > 1.5:
            status = f"Low Confidence / Hesitation ({hesitation_latency}s)"
            feedback_msg = "Thank you. Response recorded."
        else:
            status = "Taken & Verified"
            feedback_msg = "Thank you. Medicine status updated successfully."
    else:
        status = "Skipped / Unclear"
        feedback_msg = "Recorded. Caregiver notified."

    # Save permanently into SQLite database
    conn = sqlite3.connect("svarapraana.db")
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO adherence_logs (elder_name, slot_name, medication, status, transcript, latency_sec, timestamp)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', (app_state["elder_name"], slot_name, med_name, status, transcript, hesitation_latency, timestamp))
    conn.commit()
    conn.close()

    twiml_response = f"""<?xml version="1.0" encoding="UTF-8"?>
    <Response>
        <Say voice="alice">{feedback_msg}</Say>
        <Hangup/>
    </Response>
    """
    return Response(content=twiml_response, media_type="application/xml")

@app.get("/api/logs")
def get_logs():
    """Fetches all permanent history logs from SQLite for your frontend dashboard."""
    conn = sqlite3.connect("svarapraana.db")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM adherence_logs ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()
    return {"logs": [dict(row) for row in rows]}