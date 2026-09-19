from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, EmailStr


class EmployeeCreate(BaseModel):
    name: str
    email: EmailStr
    department: str | None = None
    designation: str | None = None
    salary: Decimal
    is_active: bool = True


class EmployeeResponse(BaseModel):
    employee_id: int
    name: str
    email: EmailStr
    department: str | None
    designation: str | None
    salary: Decimal
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)