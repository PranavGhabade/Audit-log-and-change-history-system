from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.db.dependencies import get_database
from app.models.user import AppUser
from app.schemas.audit import AuditResponse


router = APIRouter(prefix="/audit", tags=["Audit"])


@router.get("/history")
def get_audit_history(
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(get_current_user),
):
    result = db.execute(
        text("""
            SELECT *
            FROM public.vw_audit_history
            ORDER BY audit_id DESC
            LIMIT 100
        """)
    )

    return [dict(row._mapping) for row in result]


@router.get("/integrity")
def verify_integrity(
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(get_current_user),
):
    result = db.execute(
        text("""
            SELECT *
            FROM public.verify_audit_integrity()
        """)
    ).mappings().first()

    if result is None:
        raise HTTPException(
            status_code=500,
            detail="Integrity verification returned no result.",
        )

    return dict(result)