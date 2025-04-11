from sqlalchemy.orm import Session
from app.models import CornerCell
from app.schemas.CornerCell_schema import CornerCellCreate


class CRUD:
    # CRUD for CornerCell
    @staticmethod
    def create_corner_cell(db: Session, corner_cell: CornerCellCreate):
        db_corner_cell = CornerCell(**corner_cell.dict())
        db.add(db_corner_cell)
        db.commit()
        db.refresh(db_corner_cell)
        return db_corner_cell
    
    @staticmethod
    def get_corner_cell(db: Session, cell_id: int):
        return db.query(CornerCell).filter(CornerCell.id == cell_id).first()
    
    @staticmethod
    def update_corner_cell(db: Session, cell_id: int, cell_data: dict):
        db_cell = db.query(CornerCell).filter(CornerCell.id == cell_id).first()
        if db_cell:
            for key, value in cell_data.items():
                setattr(db_cell, key, value)
            db.commit()
            db.refresh(db_cell)
        return db_cell
    

    @staticmethod
    def delete_corner_cell(db: Session, cell_id: int):
        db_cell = db.query(CornerCell).filter(CornerCell.id == cell_id).first()
        if db_cell:
            db.delete(db_cell)
            db.commit()
        return db_cell