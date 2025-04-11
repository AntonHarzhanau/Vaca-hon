from pydantic import BaseModel

class UtilityCellBase(BaseModel):
    rent: int
    cost: int

class UtilityCellCreate(UtilityCellBase):
    pass

class UtilityCell(UtilityCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    class Config:
        orm_mode = True
