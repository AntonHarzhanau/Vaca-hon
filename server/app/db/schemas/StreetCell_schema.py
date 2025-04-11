from pydantic import BaseModel, field_validator
from typing import List, Optional

class StreetCellBase(BaseModel):
    cost: int
    color: Optional[str] = None
    rent: List[int]  
    group_id: int
    house_cost: int

    @field_validator('rent', mode='before')
    def parse_rent(cls, v):
        if isinstance(v, str):
            # Remove brackets and split by commas
            return [int(x) for x in v.strip('[]').split(',')]
        elif isinstance(v, list):
            return v
        raise ValueError("Rent must be either a list or a string representation of a list")















class StreetCellCreate(StreetCellBase):
    pass

class StreetCell(StreetCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    class Config:
        orm_mode = True
