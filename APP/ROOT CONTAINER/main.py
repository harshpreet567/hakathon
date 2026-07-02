from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database.session import Base, engine
from app.api.routes import router as api_router
from app.services.pulse_service import PulseService
from app.database.session import SessionLocal

# Auto-generate schema migration paths on local SQLite footprints
Base.metadata.create_all(bind=engine)

# Initialize defaults on initialization
db_context = SessionLocal()
try:
    PulseService.initialize_base_configurations(db_context)
finally:
    db_context.close()

# Instantiate FastAPI Core Engine
app = FastAPI(
    title="Pulse Core Telemetry Engine",
    version="1.0.0",
    description="Clean Architecture embedded IoT analytics hub for monitoring power line boundaries and tracking structural safety relays."
)

# Enable connection permissions for desktop/mobile clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permits debugging connections across external dev endpoints
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Connect architecture route nodes
app.include_router(api_router, prefix="/api")

@app.get("/")
def read_root():
    """Simple connection validation endpoint."""
    return {"status": "online", "system": "Pulse Core Matrix API", "version": "1.0.0"}
