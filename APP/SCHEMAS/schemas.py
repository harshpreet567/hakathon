from pydantic import BaseModel, Field
from typing import List, Optional

class SensorReadingIn(BaseModel):
    """Validates real-time sensor metrics submitted by edge nodes."""
    temperature: float = Field(..., example=24.5)
    current: float = Field(..., example=1.8)
    motion_detected: bool = Field(..., example=True)
    relay_active: bool = Field(..., example=True)

class SystemSettingsUpdate(BaseModel):
    """Validates requests modifying functional trip wire targets."""
    temp_warning_threshold: Optional[float] = None
    temp_critical_threshold: Optional[float] = None
    current_warning_threshold: Optional[float] = None
    current_critical_threshold: Optional[float] = None
    auto_shutdown: Optional[bool] = None
    notifications_enabled: Optional[bool] = None

class DashboardResponse(BaseModel):
    """Wraps complex dashboard structures into matching high-fidelity representations."""
    overallStatus: str
    recommendation: str
    lastUpdated: str
    temperature: float
    current: float
    motionDetected: bool
    relayActive: bool
    emergencyShutdown: bool

class AlertItemOut(BaseModel):
    """Defines serialization profile for UI threat components."""
    id: str
    title: str
    description: str
    severity: str
    timestamp: str
    recommendation: str

    class Config:
        from_attributes = True

class HistoryEventOut(BaseModel):
    """Formats structural historical logs for table outputs."""
    id: int
    type: str
    description: str
    timestamp: str
    value: str

class DeviceInfoOut(BaseModel):
    """Serializes node fabric attributes."""
    id: str
    name: str
    isOnline: bool
    lastSync: str
    connectionHealth: int

class SystemSettingsOut(BaseModel):
    """Exposes operating system runtime boundaries."""
    tempThreshold: float
    currentThreshold: float
    autoShutdown: bool
    notificationsEnabled: bool
  
