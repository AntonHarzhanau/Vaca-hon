from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from .user_schema import UserReadSchema
from typing import List

# Schemas for Lobby
class LobbyCreateSchema(BaseModel):
    owner_id: int
    nb_player_max: int = 4
    time_sec: int = 1800
    is_private: bool = True
    is_active: bool = True
    secret: str = ""

class LobbyReadSchema(BaseModel):
    id: int
    nb_player_max: int = 4
    time_sec: int = 1800
    players: list[UserReadSchema]
    owner_id: int
    is_active: bool
    is_private: bool
    created_at: datetime
    last_action_at: datetime | None

    class Config:
        from_attributes = True  # Allows conversion from SQLAlchemy models

class LobbyUpdateSchema(BaseModel):
    nb_player_max: Optional[int] = 4
    time_sec: Optional[int] = 1800
    is_private: Optional[bool] = None
    is_active: Optional[bool] = None
    secret: Optional[str] = None
    players: Optional[List[UserReadSchema]] = None

class LobbyFilterSchema(BaseModel):
    is_active: Optional[bool] = None
    is_private: Optional[bool] = None
    owner_id: Optional[int] = None