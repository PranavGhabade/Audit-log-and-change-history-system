from datetime import datetime

from sqlalchemy import BigInteger, Boolean, DateTime, ForeignKey, String, text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class Role(Base):
    __tablename__ = "role"

    role_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    role_name: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        unique=True,
    )

    description: Mapped[str | None] = mapped_column(
        String,
        nullable=True,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=text("CURRENT_TIMESTAMP"),
    )


class AppUser(Base):
    __tablename__ = "app_user"

    user_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    username: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        unique=True,
    )

    password_hash: Mapped[str] = mapped_column(
        String,
        nullable=False,
    )

    full_name: Mapped[str] = mapped_column(
        String(150),
        nullable=False,
    )

    email: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        unique=True,
    )

    role_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("role.role_id"),
        nullable=False,
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        server_default=text("TRUE"),
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=text("CURRENT_TIMESTAMP"),
    )

    last_login: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )

    role: Mapped[Role] = relationship(
        "Role",
        lazy="joined",
    )