from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict


class ProductCreate(BaseModel):
    name: str
    category: str | None = None
    price: Decimal
    stock_quantity: int = 0
    is_active: bool = True


class ProductResponse(BaseModel):
    product_id: int
    name: str
    category: str | None
    price: Decimal
    stock_quantity: int
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
    