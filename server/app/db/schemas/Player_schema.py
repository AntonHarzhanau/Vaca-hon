from pydantic import BaseModel, field_validator
from typing import List

class PlayerBase(BaseModel):
    player_name: str
    email: str
    username: str
    password: str
    money: int = 1500
    current_position: int = 0
    nb_turn_jail: int = 0
    nb_railway: int = 0
    nb_utility: int = 0
    timer_turn: int = 30
    properties_owned: List[int] = []  # Provide default empty list

    @field_validator('properties_owned', mode='before')
    def split_properties_owned(cls, v):
        if isinstance(v, str):
            if not v.strip():  # If empty string
                return []
            return [int(x) for x in v.split(',') if x.strip()]
        return v
   










class PlayerCreate(PlayerBase):
    pass

class Player(PlayerBase):
    id: int

    class Config:
        orm_mode = True
