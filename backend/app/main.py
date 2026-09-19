from fastapi import Depends, FastAPI
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.db.dependencies import get_database
from app.routes.employee import router as employee_router
from app.routes.auth import router as auth_router
from app.routes.product import router as product_router
from app.routes.order import router as order_router
from app.routes.audit import router as audit_router

app = FastAPI(
    title="Immutable Audit Log API",
    description="Audit Log and Change History System",
    version="1.0.0",
)
app.include_router(auth_router)
app.include_router(employee_router)
app.include_router(product_router)
app.include_router(order_router)
app.include_router(audit_router)


@app.get("/")
def root():
    return {
        "message": "Immutable Audit Log API is running"
    }


@app.get("/health")
def health_check(
    db: Session = Depends(get_database),
):
    db.execute(text("SELECT 1"))

    return {
        "status": "ok",
        "database": "connected",
    }