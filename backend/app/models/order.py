from datetime import datetime
from decimal import Decimal

from sqlalchemy import BigInteger, DateTime, ForeignKey, Integer, Numeric, String, text
from sqlalchemy.orm import Mapped, mapped_column

from app.db.database import Base


class Order(Base):
    __tablename__ = "app_order"

    order_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )

    user_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("app_user.user_id"),
        nullable=False,
    )

    product_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("product.product_id"),
        nullable=False,
    )

    quantity: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
    )

    total_amount: Mapped[Decimal] = mapped_column(
        Numeric(12, 2),
        nullable=False,
    )

    status: Mapped[str] = mapped_column(
        String(30),
        nullable=False,
        server_default=text("'PENDING'"),
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