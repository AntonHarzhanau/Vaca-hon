from pydantic import BaseModel

class RailwayCellBase(BaseModel):
    rent: int
    cost: int

class RailwayCellCreate(RailwayCellBase):
    pass

class RailwayCell(RailwayCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    class Config:
        orm_mode = True
