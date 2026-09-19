from sqlalchemy import text
from sqlalchemy.orm import Session


def set_audit_context(
    db: Session,
    user_id: int,
    reason: str | None = None,
    client_id: int | None = None,
) -> None:
    db.execute(
        text(
            """
            SELECT public.set_audit_context(
                :user_id,
                :reason,
                :client_id
            )
            """
        ),
        {
            "user_id": user_id,
            "reason": reason,
            "client_id": client_id,
        },
    )