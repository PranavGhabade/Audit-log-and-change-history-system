from fastapi import Depends, HTTPException, status

from app.auth.dependencies import get_current_user
from app.models.user import AppUser


def require_manager_or_admin(
    current_user: AppUser = Depends(get_current_user),
) -> AppUser:
    role_name = current_user.role.role_name

    if role_name not in {"MANAGER", "ADMIN"}:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Insufficient permissions",
        )

    return current_user