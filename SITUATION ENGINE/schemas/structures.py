from pydantic import BaseModel, Field
from typing import Optional

class SystemMetricsIn(BaseModel):
    """Validates structured raw metrics coming from hardware channels."""
    temperature: float = Field(..., description="Ambient temperature reading in Celsius")
    current: float = Field(..., description="Current draw load in Amperes")
    motion_detected: bool = Field(..., description="Presence radar status")
    relay_active: bool = Field(..., description="Current physical state of the power bus relay")

class EngineOutputOut(BaseModel):
    """Structures the finalized analytical output payload into a JSON object."""
    workspace_status: str = Field(..., description="Text breakdown of current stability state")
    severity: str = Field(..., description="Calculated priority tier (Normal, Warning, Critical, etc.)")
    recommendation: str = Field(..., description="Actionable safety guidance text block")
    alert_triggered: bool = Field(..., description="Flag indicating if a structural anomaly occurred")
    status_color: str = Field(..., description="Hex color value mapping directly to UI components")
  
