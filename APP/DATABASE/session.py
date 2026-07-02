import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# Define file storage location for SQLite database file
DATABASE_URL = "sqlite:///./pulse_workspace.db"

# Create thread-safe engine for transactional persistence
engine = create_engine(
    DATABASE_URL, 
    connect_args={"check_same_thread": False}  # Required configuration for multi-threaded FastAPI architecture
)

# Session factory for isolating request lifetimes
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Declarative base class mapping tables directly to Python structures
Base = declarative_base()

def get_db():
    """
    FastAPI Dependency Injector yielding database connection lifecycle bounds.
    Ensures that active pool tokens return back upon route completion.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
