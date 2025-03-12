from pydantic import BaseModel
from datetime import datetime

class LobbyCreate(BaseModel):
    is_private: bool = False
    secret: str = ""

class LobbyRead(BaseModel):
    id: int
    owner_id: str
    is_active: bool
    created_at: datetime
    last_action_at: datetime | None  # Can be null

    class Config:
        from_attributes = True  # Allows conversion from SQLAlchemy models

class LobbyUpdate(BaseModel):
    is_private: bool | None = None
    is_active: bool | None = None
    secret: str | None = None