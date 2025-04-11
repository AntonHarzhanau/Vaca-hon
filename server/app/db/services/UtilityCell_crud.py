from sqlalchemy.orm import Session
from app.models import UtilityCell
from app.schemas.UtilityCell_schema import UtilityCellCreate


class CRUD:

    # CRUD for UtilityCell
    @staticmethod
    def create_utility_cell(db: Session, utility_cell: UtilityCellCreate):
        db_utility_cell = UtilityCell(**utility_cell.dict())
        db.add(db_utility_cell)
        db.commit()
        db.refresh(db_utility_cell)
        return db_utility_cell
    
    @staticmethod
    def get_utility_cell(db: Session, cell_id: int):
        return db.query(UtilityCell).filter(UtilityCell.id == cell_id).first()

    @staticmethod
    def update_utility_cell(db: Session, cell_id: int, cell_data: dict):
        db_cell = db.query(UtilityCell).filter(UtilityCell.id == cell_id).first()
        if db_cell:
            for key, value in cell_data.items():
                setattr(db_cell, key, value)
            db.commit()
            db.refresh(db_cell)
        return db_cell

    @staticmethod
    def delete_utility_cell(db: Session, cell_id: int):
        db_cell = db.query(UtilityCell).filter(UtilityCell.id == cell_id).first()
        if db_cell:
            db.delete(db_cell)
            db.commit()
        return db_cell