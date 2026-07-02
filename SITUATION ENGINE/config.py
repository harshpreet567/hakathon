class EngineConfig:
    """Central configuration for safety rule thresholds and UX color profiles."""
    
    # Thermal thresholds (°C)
    TEMP_WARNING = 45.0
    TEMP_CRITICAL = 65.0
    
    # Amperage thresholds (A)
    CURRENT_WARNING = 5.0
    CURRENT_CRITICAL = 12.0

    # High-Fidelity Cyberpunk Hex Color Maps
    COLOR_NORMAL = "#00FF66"      # Success Neon Green
    COLOR_MONITORING = "#00F0FF"  # Cyber Blue
    COLOR_WARNING = "#FFFFB800"   # Warning Amber
    COLOR_CRITICAL = "#FFFF3333"  # Critical Red
    COLOR_SHUTDOWN = "#A020F0"    # Emergency Purple
