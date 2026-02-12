from fastapi import FastAPI
from app.database import Base, engine

from app.routers import auth, comments, likes, health
from app.models import user, comment, like
from app.core.logging import logger

app = FastAPI(
    title="Web Platform API",
    version="1.0.0"
)

# Crear tablas
Base.metadata.create_all(bind=engine)

# =============================
# Routers
# =============================

app.include_router(health.router, prefix="/api")
# app.include_router(auth.router, prefix="/api")
app.include_router(comments.router, prefix="/api")
app.include_router(likes.router, prefix="/api")

logger.info("API Started Successfully")
