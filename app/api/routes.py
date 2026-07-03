from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.database.session import get_db
from app.schemas.schemas import (
    SensorReadingIn, DashboardResponse, AlertItemOut, 
    HistoryEventOut, DeviceInfoOut, SystemSettingsOut, SystemSettingsUpdate
)
from app.services.pulse_service import PulseService
from app.models.models import AlertLog, TelemetryLog
from app.utils.state_manager import AppStateManager

router = APIRouter()

@router.post("/sensor-data", response_model=AlertItemOut, status_code=status.HTTP_201_CREATED)
def post_sensor_data(reading: SensorReadingIn, db: Session = Depends(get_db)):
    """Accepts data inputs from connected microcontrollers and outputs active anomalies."""
    alert_log = PulseService.ingest_telemetry(db, reading)
    return alert_log

@router.get("/dashboard", response_model=DashboardResponse)
def get_dashboard(db: Session = Depends(get_db)):
    """Returns combined status updates for display dashboards."""
    return PulseService.get_dashboard(db)

@router.get("/alerts", response_model=List[AlertItemOut])
def get_alerts(db: Session = Depends(get_db)):
    """Retrieves chronological lists of active or historic warning log events."""
    return db.query(AlertLog).all()

@router.get("/history", response_model=List[HistoryEventOut])
def get_history(db: Session = Depends(get_db)):
    """Fetches system logs mapped to the requested interface parameters."""
    logs = db.query(TelemetryLog).order_by(TelemetryLog.timestamp.desc()).limit(50).all()
    events = []
    for log in logs:
        events.append(HistoryEventOut(
            id=log.id,
            type="Telemetry Frame",
            description="Ambient data profile log captured.",
            timestamp=log.timestamp.strftime("%Y-%m-%d %I:%M %p"),
            value=f"{log.temperature}°C / {log.current}A"
        ))
    return events

@router.get("/devices", response_model=List[DeviceInfoOut])
def get_devices():
    """Maps linked node identities across the active workspace mesh layer."""
    return PulseService.get_static_devices()

@router.get("/settings", response_model=SystemSettingsOut)
def get_settings(db: Session = Depends(get_db)):
    """Exposes operating system boundary configurations."""
    return PulseService.get_settings(db)

@router.put("/settings", response_model=SystemSettingsOut)
def update_settings(payload: SystemSettingsUpdate, db: Session = Depends(get_db)):
    """Modifies the active threshold boundaries used by the rules engine."""
    PulseService.update_settings(db, payload)
    return PulseService.get_settings(db)

@router.post("/shutdown")
def trigger_shutdown():
    """
    Manually forces an emergency system cutoff state (ESTOP).
    Disables power relays until manual re-arming commands are dispatched.
    """
    AppStateManager.trigger_estop()
    return {"status": "success", "message": "Emergency system shutdown executed. Safety lines isolated."}

@router.post("/reset-shutdown")
def reset_shutdown():
    """Clears active emergency states to resume normal data collection."""
    AppStateManager.reset_estop()
    return {"status": "success", "message": "Safety bus re-armed. Resuming sensor polling."}
