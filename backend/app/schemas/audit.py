from datetime import datetime
from typing import Any

from pydantic import BaseModel


class AuditResponse(BaseModel):
    audit_id: int
    event_id: str
    table_id: int
    record_id: str
    operation_id: int
    old_data: Any | None
    new_data: Any | None
    changed_by: int | None
    changed_at: datetime
    change_reason: str | None
    client_id: int | None
    transaction_id: int | None
    previous_hash: str | None
    hash: str
    hash_version: int
    