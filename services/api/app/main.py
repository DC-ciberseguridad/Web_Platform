from fastapi import FastAPI
from routers import health, items

app = FastAPI(
    title= "FastAPI DevOps lab",
    version="1.0.0",

)

app.include_router(health.router)
app.include_router(items.router)

@app.get("/")
def root():
    return {"message":"FastAPI is running 🚀"}