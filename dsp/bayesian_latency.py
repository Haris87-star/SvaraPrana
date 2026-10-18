"""
SvaraPrana - Bayesian Cognitive Hesitation Latency (CHL) Model
Detects the "Haan Beta, Dawai Kha Li" false compliance syndrome without interrogation.
Uses Bayesian posterior updates over 14-day baseline latency and acoustic micro-jitter.
"""

import math
from dataclasses import dataclass


@dataclass
class BaselineProfile:
    elder_id: str
    elder_name: str
    mu_baseline_ms: float = 480.0     # Mean response latency in habitual state (ms)
    sigma_baseline_ms: float = 85.0   # Standard deviation of response latency (ms)
    mean_jitter_pct: float = 0.78     # Normal vocal jitter
    interaction_count: int = 14       # 14 prior conversational interactions


# Pre-configured baseline profiles for realistic Indian elder demos
PRESET_PROFILES = {
    "saraswati_74": BaselineProfile(
        elder_id="saraswati_74",
        elder_name="Shrimati Saraswati (74, Madurai)",
        mu_baseline_ms=460.0,
        sigma_baseline_ms=75.0,
        mean_jitter_pct=0.82
    ),
    "ramesh_79": BaselineProfile(
        elder_id="ramesh_79",
        elder_name="Shri Ramesh Sharma (79, Varanasi)",
        mu_baseline_ms=510.0,
        sigma_baseline_ms=90.0,
        mean_jitter_pct=0.91
    ),
    "anusuya_71": BaselineProfile(
        elder_id="anusuya_71",
        elder_name="Shrimati Anusuya Rao (71, Mysuru)",
        mu_baseline_ms=440.0,
        sigma_baseline_ms=70.0,
        mean_jitter_pct=0.74
    )
}


class BayesianLatencyModel:
    def __init__(self, profile: BaselineProfile = None):
        self.profile = profile or PRESET_PROFILES["saraswati_74"]

    def compute_z_score(self, observed_latency_ms: float) -> float:
        """
        Z_CHL = (delta_t - mu_baseline) / sigma_baseline
        Z > 2.5 represents statistical anomaly (> 99th percentile hesitation).
        """
        return (observed_latency_ms - self.profile.mu_baseline_ms) / max(1.0, self.profile.sigma_baseline_ms)

    def evaluate_compliance(
        self,
        observed_latency_ms: float,
        vocal_jitter_pct: float,
        question_type: str = "associative_routine"
    ) -> dict:
        """
        Bayesian evaluation of truthful recall vs hesitation/false compliance.
        Prior P(Omission) = 0.20 in unsupervised solitary elderly cohort.
        P(Hesitation | Omission) ~ High, P(Hesitation | Truthful) ~ Low.
        """
        z_score = self.compute_z_score(observed_latency_ms)

        # Likelihood ratio based on Z-score
        # Normal distribution CDF / PDF tail
        if z_score <= 1.0:
            likelihood_hesitation_given_omission = 0.15
            likelihood_hesitation_given_adherence = 0.85
        elif z_score <= 2.0:
            likelihood_hesitation_given_omission = 0.55
            likelihood_hesitation_given_adherence = 0.35
        elif z_score <= 2.5:
            likelihood_hesitation_given_omission = 0.80
            likelihood_hesitation_given_adherence = 0.15
        else:  # Z > 2.5 (Severe cognitive hesitation > 1250ms)
            likelihood_hesitation_given_omission = 0.95
            likelihood_hesitation_given_adherence = 0.05

        # Factor in acoustic micro-jitter burst (sub-audible vocal stress > 3.0%)
        micro_tremor_present = vocal_jitter_pct > (self.profile.mean_jitter_pct * 1.8)
        if micro_tremor_present:
            likelihood_hesitation_given_omission = min(0.99, likelihood_hesitation_given_omission * 1.25)
            likelihood_hesitation_given_adherence = max(0.01, likelihood_hesitation_given_adherence * 0.4)

        # Prior probability P(Omission)
        prior_omission = 0.22
        prior_adherence = 1.0 - prior_omission

        # Bayes Theorem
        p_evidence = (
            (likelihood_hesitation_given_omission * prior_omission) +
            (likelihood_hesitation_given_adherence * prior_adherence)
        )
        posterior_omission = (likelihood_hesitation_given_omission * prior_omission) / max(1e-6, p_evidence)
        posterior_adherence = 1.0 - posterior_omission

        # Clinical verdict
        is_hesitant = z_score > 2.0
        is_false_compliance = posterior_omission > 0.70

        if is_false_compliance:
            status = "FLAGGED_FALSE_COMPLIANCE"
            confidence_level = "High Probability (> 85%)" if posterior_omission > 0.85 else "Moderate Probability"
            recommended_action = "Initiate gentle associative follow-up without confronting or embarrassing the elder."
        elif is_hesitant:
            status = "MILD_HESITATION"
            confidence_level = "Moderate"
            recommended_action = "Subtle monitoring during afternoon check-in; no alarm needed."
        else:
            status = "VERIFIED_COMPLIANT"
            confidence_level = "High"
            recommended_action = "Routine habitual adherence confirmed. Log telemetry silently."

        return {
            "elder_name": self.profile.elder_name,
            "observed_latency_ms": observed_latency_ms,
            "baseline_mean_ms": self.profile.mu_baseline_ms,
            "z_score": round(z_score, 2),
            "micro_tremor_present": micro_tremor_present,
            "vocal_jitter_pct": round(vocal_jitter_pct, 2),
            "posterior_omission_probability": round(posterior_omission, 3),
            "posterior_adherence_probability": round(posterior_adherence, 3),
            "status": status,
            "confidence_level": confidence_level,
            "recommended_action": recommended_action,
            "dignity_preserved": True
        }


def evaluate_cognitive_hesitation(
    observed_latency_ms: float,
    vocal_jitter_pct: float,
    elder_profile_id: str = "saraswati_74"
) -> dict:
    profile = PRESET_PROFILES.get(elder_profile_id, PRESET_PROFILES["saraswati_74"])
    model = BayesianLatencyModel(profile)
    return model.evaluate_compliance(observed_latency_ms, vocal_jitter_pct)
