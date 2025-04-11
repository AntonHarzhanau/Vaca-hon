from pydantic import BaseModel



class CellBase(BaseModel):
    name: str
    type: str

class CellCreate(CellBase):
    pass

class Cell(CellBase):
    id: int

    class Config:
        orm_mode = True 