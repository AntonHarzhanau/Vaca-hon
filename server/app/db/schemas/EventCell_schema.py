from pydantic import BaseModel

class EventCellBase(BaseModel):
    pass  # Pas de champs spécifiques, juste une référence à Cell

class EventCellCreate(EventCellBase):
    pass

class EventCell(EventCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    class Config:
        orm_mode = True
