"""
SvaraPrana - 4-Tier Automated Escalation & Safety Protocol Matrix
Coordinates family caregiver updates via WhatsApp Cloud API format and
manages emergency escalation (Tier 0 to Tier 3 SOS with 108 ambulance bridge).
"""

import time
from typing import Optional


def evaluate_safety_tier(
    vitality_composite: float,
    latency_ms: float,
    hnr_db: float,
    missed_calls_count: int = 0,
    acute_trauma_flag: bool = False
) -> dict:
    """
    Evaluates safety tier based on acoustic & behavioral signals:
    - Tier 0: Optimal (80 - 100)
    - Tier 1: Subtle Drift (60 - 79)
    - Tier 2: Actionable Concern (35 - 59)
    - Tier 3: Acute SOS (< 35) or trauma flag
    """
    if acute_trauma_flag or vitality_composite < 35.0:
        tier_level = 3
        tier_name = "TIER 3: Acute SOS Distress"
        color_code = "#EF4444"  # Red
        system_response = "Multi-party emergency bridge: open audio line established immediately to primary caregiver."
        family_escalation = "IMMEDIATE DISPATCH: High-priority phone call to adult child, SMS to verified local neighbor, and 108 ambulance beacon."
        requires_immediate_dispatch = True
    elif missed_calls_count >= 2 or hnr_db < 12.0 or vitality_composite < 60.0:
        tier_level = 2
        tier_name = "TIER 2: Actionable Concern"
        color_code = "#F59E0B"  # Amber
        system_response = "Automated urgent IVR retry with high-priority trunk; tone shift to empathetic safety check."
        family_escalation = "Direct WhatsApp alert to designated family member with recommended soft action: 'Check in with Amma today.'"
        requires_immediate_dispatch = False
    elif latency_ms > 1200.0 or missed_calls_count == 1 or vitality_composite < 80.0:
        tier_level = 1
        tier_name = "TIER 1: Subtle Drift"
        color_code = "#3B82F6"  # Blue
        system_response = "Autonomous 45-minute gentle re-attempt call by voice companion inquiring warmly about breakfast."
        family_escalation = "Subtle dashboard note; zero panicky push alarms. Soft prompt in evening digest: 'Appa seems slightly tired today.'"
        requires_immediate_dispatch = False
    else:
        tier_level = 0
        tier_name = "TIER 0: Optimal Vitality"
        color_code = "#10B981"  # Emerald
        system_response = "Silent telemetry logging in encrypted time-series datastore; zero conversational interruption."
        family_escalation = "Logged silently; included in daily 8:00 PM WhatsApp peace-of-mind summary."
        requires_immediate_dispatch = False

    return {
        "tier_level": tier_level,
        "tier_name": tier_name,
        "color_code": color_code,
        "vitality_score": vitality_composite,
        "system_response": system_response,
        "family_escalation": family_escalation,
        "requires_immediate_dispatch": requires_immediate_dispatch,
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S IST")
    }


def generate_whatsapp_caregiver_digest(
    elder_name: str,
    vitality_score: float,
    acoustic_summary: dict,
    routine_confirmed: bool = True,
    caregiver_name: str = "Ananya",
    location: str = "Madurai"
) -> dict:
    """
    Constructs an authentic WhatsApp Cloud API template message for adult children.
    Culturally warm, informative, zero alert fatigue.
    """
    if vitality_score >= 80:
        status_emoji = "🌿"
        headline = "DAILY PEACE-OF-MIND DIGEST • OPTIMAL STABILITY"
        insight_note = f"{elder_name} sounded cheerful this morning during the Chai Check. Vocal parameters show strong hydration and steady vital rhythm. Zero caregiver action required today."
        action_button = "Send Warm Audio Greeting"
    elif vitality_score >= 60:
        status_emoji = "🌤️"
        headline = "DAILY CARE BRIDGE • MILD FATIGUE NOTED"
        insight_note = f"{elder_name} completed the routine check-in with slight vocal fatigue or hesitation. You might want to have a casual chat during lunch."
        action_button = "Place 1-Click Family Call"
    elif vitality_score >= 35:
        status_emoji = "⚠️"
        headline = "CARE BRIDGE ATTENTION • ACTIONABLE CHECK-IN"
        insight_note = f"Noticeable drop in vocal clarity or 2 unanswered check-ins. Please reach out to {elder_name} or neighbor when convenient."
        action_button = "Call Mother Immediately"
    else:
        status_emoji = "🚨"
        headline = "URGENT SAFETY PROTOCOL ACTIVATED"
        insight_note = f"Acute distress acoustics detected. Open emergency bridge initialized. Local neighbor notified."
        action_button = "Join Emergency Bridge Line"

    message_body = (
        f"{status_emoji} *SVARAPRANA CARE BRIDGE • {elder_name.upper()}*\n"
        f"📅 Today at {time.strftime('%I:%M %p')} via Svara Saarthi\n"
        f"────────────────────────\n"
        f"• *Vitality Composite:* {vitality_score}/100 ({'Optimal' if vitality_score >= 80 else 'Attention Required'})\n"
        f"• *Acoustic Health:* Jitter: {acoustic_summary.get('jitter_pct', 0.82)}% | Shimmer: {acoustic_summary.get('shimmer_pct', 2.3)}% | HNR: {acoustic_summary.get('hnr_db', 22.1)} dB\n"
        f"• *Cognitive Latency:* {acoustic_summary.get('latency_ms', 450)}ms (Habitual baseline: 460ms)\n"
        f"• *Morning Tea & Routine:* {'✅ Confirmed' if routine_confirmed else '⚠️ Unverified'}\n\n"
        f"💡 *Caregiver Insight:* {insight_note}\n"
        f"────────────────────────\n"
        f"Zero video cameras | Zero wearables | DPDP Act 2023 Compliant"
    )

    return {
        "recipient": caregiver_name,
        "elder_name": elder_name,
        "location": location,
        "headline": headline,
        "status_emoji": status_emoji,
        "message_body": message_body,
        "quick_action": action_button,
        "delivered_via": "WhatsApp Cloud API",
        "timestamp": time.strftime("%I:%M %p IST")
    }


def dispatch_emergency_protocols(elder_name: str, contact_details: dict) -> dict:
    """
    Simulates Tier 3 emergency multi-dispatch:
    1. Simultaneous call to primary caregiver
    2. SMS alert to local verified neighbor
    3. National 108 Emergency ambulance beacon
    """
    dispatches = [
        {
            "channel": "VOICE_CALL_TRUNK",
            "recipient": contact_details.get("primary_child_phone", "+91 98401 23456"),
            "target": f"Adult Child ({contact_details.get('primary_child_name', 'Ananya')})",
            "status": "CONNECTING_HIGH_PRIORITY_BRIDGE",
            "latency_ms": 420
        },
        {
            "channel": "SMS_GATEWAY",
            "recipient": contact_details.get("neighbor_phone", "+91 94432 98765"),
            "target": f"Local Neighbor ({contact_details.get('neighbor_name', 'Murugan Uncle')})",
            "message": f"SvaraPrana Alert: Please check on {elder_name} next door (Flat 2B). We detected sudden distress acoustics.",
            "status": "SENT_DELIVERED",
            "latency_ms": 180
        },
        {
            "channel": "NATIONAL_108_EMERGENCY_API",
            "recipient": "108 Emergency Medical Services Hub (Madurai District)",
            "target": "Ambulance Dispatch Beacon",
            "coordinates": contact_details.get("gps_approx", "9.9252 N, 78.1198 E"),
            "status": "BEACON_ACKNOWLEDGED_CODE_YELLOW",
            "latency_ms": 310
        }
    ]

    return {
        "incident_id": f"SVP-SOS-{int(time.time())}",
        "elder_name": elder_name,
        "protocol": "TIER_3_SIMULTANEOUS_MULTI_DISPATCH",
        "dispatches": dispatches,
        "audio_stream_status": "EPHEMERAL_AUDIO_SCRUBBED_MEMSET_S",
        "telemetry_logged": True
    }
