import json
from schemas.structures import SystemMetricsIn
from engine.evaluator import SituationEvaluator

def run_diagnostic_simulation(label: str, raw_input: dict):
    """Helper runner to format execution output directly into structured JSON strings."""
    print(f"\n=== SIMULATION NODE: {label} ===")
    
    # 1. Ingest raw inputs through validation schemas
    validated_input = SystemMetricsIn(**raw_input)
    
    # 2. Compute diagnostics using the engine
    evaluated_output = SituationEvaluator.process(validated_input)
    
    # 3. Export clean JSON responses
    print(json.dumps(evaluated_output.model_dump(), indent=2))

if __name__ == "__main__":
    # Case A: Workspace operates normally within safe limits
    run_diagnostic_simulation("NOMINAL OPERATION", {
        "temperature": 23.4,
        "current": 1.4,
        "motion_detected": True,
        "relay_active": True
    })

    # Case B: High electrical current draw
    run_diagnostic_simulation("CURRENT OVERLOAD RULE EXECUTED", {
        "temperature": 25.0,
        "current": 6.8,
        "motion_detected": True,
        "relay_active": True
    })

    # Case C: Temperature rises with operators inside the zone
    run_diagnostic_simulation("THERMAL THRESHOLD CRITICAL", {
        "temperature": 68.2,
        "current": 2.1,
        "motion_detected": True,
        "relay_active": True
    })

    # Case D: High heat detected while the space is empty (Threat Level Escalated)
    run_diagnostic_simulation("COMPOUND RULE DRIFT ESCALATION", {
        "temperature": 48.5,
        "current": 1.2,
        "motion_detected": False,  # No motion triggers threat upgrade
        "relay_active": True
    })

    # Case E: The safety loop opens
    run_diagnostic_simulation("SYSTEM SHUTDOWN OVERRIDE", {
        "temperature": 22.1,
        "current": 0.0,
        "motion_detected": False,
        "relay_active": False  # Broken circuit takes top priority
    })
