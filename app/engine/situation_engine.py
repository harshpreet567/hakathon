import uuid
from datetime import datetime
from app.models.models import SystemSettings, AlertLog, TelemetryLog

class SituationEngine:
    """Modular diagnostic evaluator applying systemic rule engines on runtime states."""

    @staticmethod
    def evaluate(telemetry: TelemetryLog, settings: SystemSettings) -> AlertLog:
        """
        Applies functional rules logic to parse telemetry into alerts.
        """
        # Base status parameters
        severity = "Normal"
        title = "System Baseline Healthy"
        desc = "All sensory inputs are matching safe operating constraints."
        recommendation = "Maintain regular polling configurations."

        # Rule evaluation pipeline
        temp_breached_critical = telemetry.temperature > settings.temp_critical_threshold
        temp_breached_warning = telemetry.temperature > settings.temp_warning_threshold
        current_breached_critical = telemetry.current > settings.current_critical_threshold
        current_breached_warning = telemetry.current > settings.current_warning_threshold

        # Phase 1: Current Overload Audits
        if current_breached_warning:
            severity = "Warning"
            title = "Current Draw Overload"
            desc = f"Measured current draw at {telemetry.current}A exceeds Warning threshold ({settings.current_warning_threshold}A)."
            recommendation = "Balance load vectors or decouple auxiliary rigs."
        
        if current_breached_critical:
            severity = "Critical"
            title = "Critical Overcurrent Spike"
            desc = f"Dangerous power draw at {telemetry.current}A exceeds Critical threshold ({settings.current_critical_threshold}A)."
            recommendation = "Isolate circuit immediately to safeguard testing nodes."

        # Phase 2: Thermal Boundary Audits
        if temp_breached_warning and severity != "Critical":
            severity = "Warning"
            title = "Thermal Limit Elevated"
            desc = f"Ambient test environment has reached {telemetry.temperature}°C."
            recommendation = "Engage active localized cooling units."

        if temp_breached_critical:
            severity = "Critical"
            title = "Critical Thermal Overheating"
            desc = f"Extreme thermal load tracking at {telemetry.temperature}°C breaches bounds."
            recommendation = "Recommend structural system shutdown via safety bus."

        # Phase 3: Compound Rule — Missing Motion + Elevated Heat
        # If no workspace motion is detected but temperature is climbing past warning line, bump severity up.
        if not telemetry.motion_detected and temp_breached_warning:
            if severity == "Warning":
                severity = "Critical"
                title = "Unattended Thermal Build-up"
                desc += " Unattended environment compound warning triggered."
                recommendation = "Trip mechanical cutoff or dispatch personnel."

        # Generate standard timestamp for UI readability
        time_str = datetime.now().strftime("%I:%M %p")

        return AlertLog(
            id=str(uuid.uuid4())[:8],  # Compiles short hexadecimal strings matching UI logic structures
            title=title,
            description=desc,
            severity=severity,
            timestamp=time_str,
            recommendation=recommendation
        )
