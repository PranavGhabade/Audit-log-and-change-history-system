from sqlalchemy import select
from sqlalchemy.orm import Session

from app.auth.password import verify_password
from app.models.user import AppUser
from app.schemas.auth import TokenResponse
from app.auth.jwt import create_access_token


def authenticate_user(
    db: Session,
    username: str,
    password: str,
) -> TokenResponse | None:
    statement = (
        select(AppUser)
        .where(AppUser.username == username)
    )

    user = db.scalars(statement).first()

    if user is None:
        return None

    if not user.is_active:
        return None

    if not verify_password(
        password,
        user.password_hash,
    ):
        return None

    token = create_access_token(
        user_id=user.user_id,
        username=user.username,
        role_name=user.role.role_name,
    )

    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user_id=user.user_id,
        username=user.username,
        role=user.role.role_name,
    )