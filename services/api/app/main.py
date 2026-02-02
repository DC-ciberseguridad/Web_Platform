from fastapi import FastAPI
from routers import health, items

app = FastAPI(
    title="Web Platform",
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
)

app.include_router(health.router, prefix="/api")
app.include_router(items.router, prefix="/api")

@app.get("/api")
def root():
    return {"message": "FastAPI is running 🚀"}
