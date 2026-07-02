from sqlalchemy.orm import Session
from datetime import datetime
from app.models.models import TelemetryLog, AlertLog, SystemSettings
from app.schemas.schemas import SensorReadingIn, SystemSettingsUpdate
from app.engine.situation_engine import SituationEngine
from app.utils.state_manager import AppStateManager

class PulseService:
    """Coordinates Clean Architecture patterns across repositories and engines."""

    @staticmethod
    def initialize_base_configurations(db: Session):
        """Ensures that standard workspace boundaries exist on boot."""
        settings = db.query(SystemSettings).first()
        if not settings:
            settings = SystemSettings()
            db.add(settings)
            db.commit()

    @staticmethod
    def ingest_telemetry(db: Session, reading: SensorReadingIn) -> AlertLog:
        """Processes and stores incoming data streams from edge devices."""
        settings = db.query(SystemSettings).first()
        
        # Enforce manual hardware override values if ESTOP has been tripped
        is_relay_active = reading.relay_active if not AppStateManager.EMERGENCY_SHUTDOWN_ACTIVE else False

        log = TelemetryLog(
            temperature=reading.temperature,
            current=reading.current,
            motion_detected=reading.motion_detected,
            relay_active=is_relay_active
        )
        db.add(log)
        db.commit()
        db.refresh(log)

        # Run Situation Engine diagnostic calculations
        alert = SituationEngine.evaluate(log, settings)
        
        # If auto-shutdown rules apply and critical state is hit, execute override
        if alert.severity == "Critical" and settings.auto_shutdown:
            AppStateManager.trigger_estop()
            alert.severity = "Shutdown"
            alert.title = "Automated Hardware Intercept"
            alert.recommendation = "Circuit automatically open. Inspect line impedances."
            log.relay_active = False
            db.commit()

        # Save alert records to history tracking tables
        if alert.severity != "Normal":
            db.add(alert)
            db.commit()
            db.refresh(alert)
            
        return alert

    @staticmethod
    def get_dashboard(db: Session):
        """Compiles standard dynamic workspace states for dashboard layouts."""
        latest = db.query(TelemetryLog).order_by(TelemetryLog.timestamp.desc()).first()
        active_alert = db.query(AlertLog).order_by(AlertLog.id.desc()).first()

        # Fallback values if no sensor logs have arrived yet
        temp = latest.temperature if latest else 24.5
        current = latest.current if latest else 0.0
        motion = latest.motion_detected if latest else False
        relay = latest.relay_active if latest else True

        status = "Optimal"
        recommendation = "All streams functioning normal. Environment stable."

        if AppStateManager.EMERGENCY_SHUTDOWN_ACTIVE:
            status = "Shutdown"
            recommendation = "Emergency Power Off state active. Structural system clear."
            relay = False
        elif active_alert:
            status = active_alert.severity
            recommendation = active_alert.recommendation

        return {
            "overallStatus": status,
            "recommendation": recommendation,
            "lastUpdated": datetime.now().strftime("%I:%M:%S %p"),
            "temperature": temp,
            "current": current,
            "motionDetected": motion,
            "relayActive": relay,
            "emergencyShutdown": AppStateManager.EMERGENCY_SHUTDOWN_ACTIVE
        }

    @staticmethod
    def get_static_devices():
        """Returns physical node link array maps matching UI specs."""
        return [
            {"id": "1", "name": "Mobile Sync App", "isOnline": True, "lastSync": "10s ago", "connectionHealth": 98},
            {"id": "2", "name": "Snapdragon AI PC", "isOnline": True, "lastSync": "2s ago", "connectionHealth": 100},
            {"id": "3", "name": "Arduino UNO Node", "isOnline": True, "lastSync": "100ms ago", "connectionHealth": 95},
            {"id": "4", "name": "Cloud Mesh Fabric", "isOnline": False, "lastSync": "5m ago", "connectionHealth": 0}
        ]

    @staticmethod
    def get_settings(db: Session):
        """Maps table tracking structures directly to unified UI parameters."""
        settings = db.query(SystemSettings).first()
        return {
            "tempThreshold": settings.temp_critical_threshold,
            "currentThreshold": settings.current_critical_threshold,
            "autoShutdown": settings.auto_shutdown,
            "notificationsEnabled": settings.notifications_enabled
        }

    @staticmethod
    def update_settings(db: Session, payload: SystemSettingsUpdate):
        """Saves setting adjustments on active worker database models."""
        settings = db.query(SystemSettings).first()
        if payload.temp_critical_threshold is not None:
            settings.temp_critical_threshold = payload.temp_critical_threshold
        if payload.current_critical_threshold is not None:
            settings.current_critical_threshold = payload.current_critical_threshold
        if payload.auto_shutdown is not None:
            settings.auto_shutdown = payload.auto_shutdown
        if payload.notifications_enabled is not None:
            settings.notifications_enabled = payload.notifications_enabled
        db.commit()
        db.refresh(settings)
        return settings
