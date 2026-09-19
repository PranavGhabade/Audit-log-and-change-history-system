from datetime import datetime
from decimal import Decimal

from sqlalchemy import BigInteger, Boolean, DateTime, Numeric, String, text
from sqlalchemy.orm import Mapped, mapped_column

from app.db.database import Base


class Employee(Base):
    __tablename__ = "employee"

    employee_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
        autoincrement=True,
    )

    name: Mapped[str] = mapped_column(
        String(150),
        nullable=False,
    )

    email: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        unique=True,
    )

    department: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
    )

    designation: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
    )

    salary: Mapped[Decimal] = mapped_column(
        Numeric(12, 2),
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

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=text("CURRENT_TIMESTAMP"),
    )