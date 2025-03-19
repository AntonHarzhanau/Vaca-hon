from pydantic import BaseModel
from typing import List, Optional, Union
from datetime import datetime



# Schéma pour Cell
class CellBase(BaseModel):
    cell_name: str
    cell_type: str  # Type de la cellule (ex : "Street", "Railway", etc.)

class CellCreate(CellBase):
    pass

class Cell(CellBase):
    id: int

    class Config:
        orm_mode = True






# Schéma pour PropertyCell
class PropertyCellBase(BaseModel):
    cell_name: str
    cell_type: str
    price: int
    rent: int
    owner_id: Optional[int] = None



class PropertyCell(PropertyCellBase):
    id: int  # Ajoutez l'ID pour les réponses




class PropertyCellCreate(PropertyCellBase):
    pass


class PropertyCellUpdate(BaseModel):
    name: Optional[str] = None
    price: Optional[int] = None
    rent: Optional[int] = None
    owner_id: Optional[int] = None

    class Config:
        orm_mode = True







# Schéma pour RailWayCell
class RailWayCellBase(CellBase):
    price: int
    rent: int
    owner_id: Optional[int] = None  # Optionnel, car la gare peut ne pas avoir de propriétaire

class RailWayCellCreate(RailWayCellBase):
    pass

class RailWayCell(RailWayCellBase):
    id: int

    class Config:
        orm_mode = True





# Schéma pour Player
class PlayerBase(BaseModel):
    player_name: str
    email: str
    money: int = 1500
    current_position: int = 0
    nb_turn_jail: int = 0
    nb_railway: int = 0
    nb_utility: int = 0
    timer_turn: int = 30


class PlayerCreate(PlayerBase):
    password: str

class Player(PlayerBase):
    id: int
    # Liste des propriétés possédées, y compris les RailWayCell et autres
    properties_owned: List[PropertyCellBase] = []  # liste des propriétés possédées
    railways_owned: List[RailWayCellBase] = []  # Liste des Railways possédées par ce joueur (relation)

    class Config:
        orm_mode = True


class PlayerUpdate(BaseModel):
    money: Optional[int] = None
    current_position: Optional[int] = None






# Schéma pour EventCell
class EventCellBase(BaseModel):
    description: str
    event_type: str

class EventCellCreate(EventCellBase):
    pass

class EventCell(EventCellBase):
    id: int

    class Config:
        orm_mode = True


# Schéma pour CardCell
class CardCellBase(BaseModel):
    effect_type: str  # Type d'effet de la carte (ex : "move", "pay", "receive", etc.)
    value: Optional[int] = None  # Optionnel, car certaines cartes peuvent ne pas avoir de valeur
    description: str

class CardCellCreate(CardCellBase):
    pass

class CardCell(CardCellBase):
    id: int

    class Config:
        orm_mode = True




# Schéma pour CornerCell
class CornerCellBase(BaseModel):
    corner_type: str  # Type du coin (ex : "Go", "Jail", etc.)

class CornerCellCreate(CornerCellBase):
    pass

class CornerCell(CornerCellBase):
    id: int

    class Config:
        orm_mode = True




# Schéma pour StreetCell
class StreetCellBase(PropertyCellBase):
    group_color: str  # Ex : "bleu", "rouge", etc.
    house_count: int = 0  # Nombre de maisons construites
    nb_house: int  # Nombre de maisons disponibles

class StreetCellCreate(StreetCellBase):
    pass

class StreetCell(StreetCellBase):
    id: int

    class Config:
        orm_mode = True


# Schéma pour UtilityCell
class UtilityCellBase(CellBase):
    price: int
    rent_multiplier: int
    owner_id: Optional[int] = None  # Optionnel, car la station peut ne pas avoir de propriétaire

class UtilityCellCreate(UtilityCellBase):
    pass

class UtilityCell(UtilityCellBase):
    id: int

    class Config:
        orm_mode = True


class LobbyCreate(BaseModel):
    nb_player_max: int = 4
    time_sec: int = 1800
    is_private: bool = False
    secret: str = ""

class LobbyRead(BaseModel):
    id: uuid.UUID
    nb_player_max: int = 4
    time_sec: int = 1800
    player_turn: str | None
    players: list[str]
    owner_id: uuid.UUID
    is_active: bool
    created_at: datetime
    last_action_at: datetime | None

    class Config:
        from_attributes = True  # Allows conversion from SQLAlchemy models

class LobbyUpdate(BaseModel):
    nb_player_max: Optional[int] = 4
    time_sec: Optional[int] = 1800
    is_private: bool | None = None
    is_active: bool | None = None
    secret: str | None = None
