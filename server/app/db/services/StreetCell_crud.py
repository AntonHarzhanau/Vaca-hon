from sqlalchemy.orm import Session
from app.models import StreetCell
from app.schemas.StreetCell_schema import StreetCellCreate


class CRUD:
    # CRUD for StreetCell
    @staticmethod
    def create_street_cell(db: Session, street_cell: StreetCellCreate):
        db_street_cell = StreetCell(**street_cell.dict())
        db.add(db_street_cell)
        db.commit()
        db.refresh(db_street_cell)
        return db_street_cell
    
    @staticmethod
    def get_street_cell(db: Session, cell_id: int):
        return db.query(StreetCell).filter(StreetCell.id == cell_id).first()
    
    @staticmethod
    def update_street_cell(db: Session, cell_id: int, cell_data: dict):
        db_cell = db.query(StreetCell).filter(StreetCell.id == cell_id).first()
        if db_cell:
            for key, value in cell_data.items():
                setattr(db_cell, key, value)
            db.commit()
            db.refresh(db_cell)
        return db_cell
    

    @staticmethod
    def delete_street_cell(db: Session, cell_id: int):
        db_cell = db.query(StreetCell).filter(StreetCell.id == cell_id).first()
        if db_cell:
            db.delete(db_cell)
            db.commit()
        return db_cell