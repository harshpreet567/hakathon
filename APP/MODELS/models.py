from datetime import datetime
from sqlalchemy import Column, String, Float, Boolean, DateTime, Integer
from app.database.session import Base

class TelemetryLog(Base):
    """Stores incoming raw sensory data points over a historical timeline."""
    __tablename__ = "telemetry_logs"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    timestamp = Column(DateTime, default=datetime.utcnow, index=True)
    temperature = Column(Float, nullable=False)
    current = Column(Float, nullable=False)
    motion_detected = Column(Boolean, default=False)
    relay_active = Column(Boolean, default=True)

class AlertLog(Base):
    """Persists rule-based anomalies processed by the Situation Engine."""
    __tablename__ = "alert_logs"

    id = Column(String, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    severity = Column(String, nullable=False)  # Normal, Monitoring, Warning, Critical, Shutdown
    timestamp = Column(String, nullable=False)  # Formatted string timestamp for easy UI rendering
    recommendation = Column(String, nullable=False)

class SystemSettings(Base):
    """Tracks running threshold limits adjustable via UI endpoints."""
    __tablename__ = "system_settings"

    id = Column(Integer, primary_key=True, default=1)
    temp_warning_threshold = Column(Float, default=45.0)
    temp_critical_threshold = Column(Float, default=65.0)
    current_warning_threshold = Column(Float, default=5.0)
    current_critical_threshold = Column(Float, default=12.0)
    auto_shutdown = Column(Boolean, default=True)
    notifications_enabled = Column(Boolean, default=True)
  
