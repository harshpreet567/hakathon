from config import EngineConfig

class ThermalRule:
    """Evaluates standalone thermodynamic boundaries."""
    
    @staticmethod
    def evaluate(temp: float) -> dict:
        """
        Rule 1: Simple Thermal Boundaries
        - Temperature exceeds Critical (65°C): Mark as Critical, advise shutdown.
        - Temperature exceeds Warning (45°C): Mark as Warning.
        """
        if temp >= EngineConfig.TEMP_CRITICAL:
            return {
                "severity": "Critical",
                "status": "CRITICAL THERMAL EXCEEDED",
                "rec": "Critical system temperature boundary breached. Trigger hard shutdown sequence."
            }
        if temp >= EngineConfig.TEMP_WARNING:
            return {
                "severity": "Warning",
                "status": "THERMAL LOAD HIGH",
                "rec": "Temperature has passed safety baseline. Engage cooling array loops."
            }
        return {"severity": "Normal", "status": "NOMINAL", "rec": "Thermal load within nominal balance."}


class CurrentRule:
    """Evaluates electrical load impedances and current consumption safety."""
    
    @staticmethod
    def evaluate(current: float) -> dict:
        """
        Rule 2: Simple Amperage Overload Boundaries
        - Amperage exceeds Critical (12.0A): Mark as Critical.
        - Amperage exceeds Warning (5.0A): Mark as Warning.
        """
        if current >= EngineConfig.CURRENT_CRITICAL:
            return {
                "severity": "Critical",
                "status": "CRITICAL CURRENT INTRUSH",
                "rec": "Dangerous overcurrent draw. Isolate structural load rails immediately."
            }
        if current >= EngineConfig.CURRENT_WARNING:
            return {
                "severity": "Warning",
                "status": "CURRENT LOAD ELEVATED",
                "rec": "Electrical draw exceeds standard running threshold. Audit operational components."
            }
        return {"severity": "Normal", "status": "NOMINAL", "rec": "Power profile consumption stable."}


class CompoundRules:
    """Processes relational conditions where multiple sensor profiles match danger flags."""
    
    @staticmethod
    def evaluate_unattended_risk(metrics, highest_severity: str) -> tuple[str, str, str]:
        """
        Rule 3: Compound Context Assessment (Unattended Thermal Drift)
        - Condition: If No Motion is detected AND the temperature is already at or above Warning.
        - Effect: Elevate safety threat levels immediately by one complete tier. 
          (Warning turns into a Critical event because no human is around to manage an expanding thermal drift).
        """
        severity = highest_severity
        status_msg = ""
        rec_msg = ""
        
        if not metrics.motion_detected and metrics.temperature >= EngineConfig.TEMP_WARNING:
            if severity == "Warning":
                severity = "Critical"
                status_msg = "UNATTENDED THERMAL DRIFT INTERCEPTED"
                rec_msg = "Thermal risk compounding due to unstaffed zone footprint. Dispatch safety response team."
                
        return severity, status_msg, rec_msg
