from config import EngineConfig
from schemas.structures import SystemMetricsIn, EngineOutputOut
from engine.rules import ThermalRule, CurrentRule, CompoundRules

class SituationEvaluator:
    """Main arbitration component managing runtime matrix evaluations."""
    
    # Priority ranking weight matrix for evaluating which threat takes precedence
    SEVERITY_WEIGHTS = {
        "Normal": 0,
        "Monitoring": 1,
        "Warning": 2,
        "Critical": 3,
        "Shutdown": 4
    }

    @classmethod
    def process(cls, metrics: SystemMetricsIn) -> EngineOutputOut:
        """
        Aggregates sensor parameters and evaluates rules to compile output profiles.
        """
        # Run baseline rule packages
        thermal = ThermalRule.evaluate(metrics.temperature)
        electrical = CurrentRule.evaluate(metrics.current)

        # Arbitrate structural priority (Pick the highest severity conflict found)
        rules_results = [thermal, electrical]
        highest_rule = max(rules_results, key=lambda x: cls.SEVERITY_WEIGHTS[x["severity"]])
        
        final_severity = highest_rule["severity"]
        final_status = highest_rule["status"]
        final_rec = highest_rule["rec"]

        # Run multi-variable compound analysis
        compound_severity, comp_status, comp_rec = CompoundRules.evaluate_unattended_risk(
            metrics, final_severity
        )
        
        # Override baseline states if compound rules validate threat escalation
        if compound_severity != final_severity:
            final_severity = compound_severity
            final_status = comp_status
            final_rec = comp_rec

        # Hard safety override: Force Shutdown classification if the relay was physically opened
        if not metrics.relay_active:
            final_severity = "Shutdown"
            final_status = "SAFETY RELAY OPEN - LOCKED OUT"
            final_rec = "Main power path cut. Re-arm mechanical breakers before closing circuit."

        # Map active severity tier to respective hexadecimal visualization tokens
        color_map = {
            "Normal": EngineConfig.COLOR_NORMAL,
            "Monitoring": EngineConfig.COLOR_MONITORING,
            "Warning": EngineConfig.COLOR_WARNING,
            "Critical": EngineConfig.COLOR_CRITICAL,
            "Shutdown": EngineConfig.COLOR_SHUTDOWN
        }
        
        chosen_color = color_map.get(final_severity, EngineConfig.COLOR_NORMAL)
        alert_flag = final_severity in ["Warning", "Critical", "Shutdown"]

        return EngineOutputOut(
            workspace_status=final_status,
            severity=final_severity,
            recommendation=final_rec,
            alert_triggered=alert_flag,
            status_color=chosen_color
        )
