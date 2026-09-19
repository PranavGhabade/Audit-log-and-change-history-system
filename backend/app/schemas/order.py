from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict


class OrderCreate(BaseModel):
    product_id: int
    quantity: int
    total_amount: Decimal
    status: str = "PENDING"


class OrderResponse(BaseModel):
    order_id: int
    user_id: int
    product_id: int
    quantity: int
    total_amount: Decimal
    status: str
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)