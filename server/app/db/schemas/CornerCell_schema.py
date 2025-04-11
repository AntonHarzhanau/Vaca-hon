import logging
from pydantic import BaseModel



logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CornerCellBase(BaseModel):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        logger.info(f"CornerCellBase initialized with {kwargs}")

class CornerCellCreate(CornerCellBase):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        logger.info(f"CornerCellCreate initialized with {kwargs}")

class CornerCell(CornerCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        logger.info(f"CornerCell initialized with {kwargs}")

    class Config:
        orm_mode = True

class CornerCellBase(BaseModel):
    pass  # Pas de champs spécifiques, juste une référence à Cell

class CornerCellCreate(CornerCellBase):
    pass

class CornerCell(CornerCellBase):
    id: int
    cell_id: int  # Référence vers Cell

    class Config:
        orm_mode = True
