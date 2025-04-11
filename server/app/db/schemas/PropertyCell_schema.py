from pydantic import BaseModel

class PropertyCellBase(BaseModel):
    price: int
    mortgaged: bool
    rent: int

class PropertyCellCreate(PropertyCellBase):
    pass

class PropertyCell(PropertyCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    class Config:
        orm_mode = True
