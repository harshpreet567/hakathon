class AppStateManager:
    """Global atomic storage tracks software-managed emergency trips."""
    
    # Track hardware emergency stop status outside database configurations
    EMERGENCY_SHUTDOWN_ACTIVE = False

    @classmethod
    def trigger_estop(cls):
        cls.EMERGENCY_SHUTDOWN_ACTIVE = True

    @classmethod
    def reset_estop(cls):
        cls.EMERGENCY_SHUTDOWN_ACTIVE = False
