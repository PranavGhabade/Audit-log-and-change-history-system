from datetime import datetime
from decimal import Decimal

from sqlalchemy import BigInteger, Boolean, DateTime, Numeric, String, text
from sqlalchemy.orm import Mapped, mapped_column

from app.db.database import Base


class Product(Base):
    __tablename__ = "product"

    product_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )

    name: Mapped[str] = mapped_column(
        String(150), nullable=False
    )

    category: Mapped[str | None] = mapped_column(
        String(100), nullable=True
    )

    price: Mapped[Decimal] = mapped_column(
        Numeric(12, 2), nullable=False
    )

    stock_quantity: Mapped[int] = mapped_column(
        nullable=False, server_default=text("0")
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean, nullable=False, server_default=text("TRUE")
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
    