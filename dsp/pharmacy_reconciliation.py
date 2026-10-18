"""
SvaraPrana - Chemist Blister-Pack Velocity Reconciliation Bridge
Passively reconciles neighborhood pharmacy delivery cadence with self-reported
medication compliance to detect silent omissions and stock divergence.
"""

from datetime import datetime, timedelta


def reconcile_blister_pack_velocity(
    elder_id: str,
    medication_name: str,
    dispatch_date_iso: str,
    pack_size_tablets: int = 30,
    daily_dosage: int = 1,
    current_date_iso: str = None,
    elder_reported_compliance_pct: float = 100.0,
    local_chemist_name: str = "Apollo Pharmacy (Madurai Town Branch)"
) -> dict:
    """
    Reconciles the expected exhausted date of blister pack with the current date.
    If 30-day strip was delivered on Sept 1st, expected refill is Day 30 (Oct 1st).
    If it is Day 36 (Oct 7th) and no refill is ordered while 100% compliance is reported,
    a discrepancy is flagged passively without interrogating the elder.
    """
    fmt = "%Y-%m-%d"
    dispatch_dt = datetime.strptime(dispatch_date_iso, fmt)
    current_dt = datetime.strptime(current_date_iso, fmt) if current_date_iso else datetime.now()

    days_elapsed = (current_dt - dispatch_dt).days
    expected_exhaustion_days = int(pack_size_tablets / daily_dosage)
    expected_exhaustion_dt = dispatch_dt + timedelta(days=expected_exhaustion_days)

    expected_tablets_remaining = max(0, pack_size_tablets - (days_elapsed * daily_dosage))
    actual_days_overdue = max(0, days_elapsed - expected_exhaustion_days)

    # Calculate stock divergence
    # If overdue > 4 days and no refill requested while elder claims they took every dose
    divergence_flagged = actual_days_overdue > 3 and elder_reported_compliance_pct >= 90.0

    if divergence_flagged:
        status = "STOCK_DIVERGENCE_DETECTED"
        divergence_severity = "HIGH" if actual_days_overdue > 6 else "MODERATE"
        clinical_note = (
            f"Expected refill overdue by {actual_days_overdue} days. "
            f"If 100% compliant, blister pack of {medication_name} would be depleted on "
            f"{expected_exhaustion_dt.strftime('%b %d')}. Divergence flags potential skipped doses "
            f"without confronting the elder."
        )
        suggested_action = "Inquire gently during next pharmacy delivery sync or morning Chai Check."
    elif actual_days_overdue > 0:
        status = "REFILL_DUE"
        divergence_severity = "LOW"
        clinical_note = f"Prescription reached scheduled end date ({expected_exhaustion_dt.strftime('%b %d')})."
        suggested_action = "Notify chemist for automated doorstep refill."
    else:
        status = "ACTIVE_ON_SCHEDULE"
        divergence_severity = "NONE"
        clinical_note = f"{expected_tablets_remaining} tablets remaining. Consumption matches pharmacy cadence."
        suggested_action = "Normal cadence. No action needed."

    return {
        "elder_id": elder_id,
        "medication_name": medication_name,
        "local_chemist": local_chemist_name,
        "dispatch_date": dispatch_date_iso,
        "days_elapsed": days_elapsed,
        "pack_size": pack_size_tablets,
        "daily_dosage": daily_dosage,
        "expected_exhaustion_date": expected_exhaustion_dt.strftime(fmt),
        "days_overdue": actual_days_overdue,
        "expected_tablets_remaining": expected_tablets_remaining,
        "elder_reported_compliance_pct": elder_reported_compliance_pct,
        "divergence_flagged": divergence_flagged,
        "divergence_severity": divergence_severity,
        "status": status,
        "clinical_note": clinical_note,
        "suggested_action": suggested_action
    }
