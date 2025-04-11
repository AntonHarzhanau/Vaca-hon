from sqlalchemy.orm import Session
from app.models import PropertyCell
from app.schemas.PropertyCell_schema import PropertyCellCreate


class CRUD:
    # CRUD for PropertyCell
    @staticmethod
    def create_property_cell(db: Session, property_cell: PropertyCellCreate):
        db_property_cell = PropertyCell(**property_cell.dict())
        db.add(db_property_cell)
        db.commit()
        db.refresh(db_property_cell)
        return db_property_cell

    
    @staticmethod
    def get_property_cell(db: Session, cell_id: int):
        return db.query(PropertyCell).filter(PropertyCell.id == cell_id).first()

    @staticmethod
    def update_property_cell(db: Session, cell_id: int, cell_data: dict):
            db_cell = db.query(PropertyCell).filter(PropertyCell.id == cell_id).first()
            if db_cell:
                for key, value in cell_data.items():
                    setattr(db_cell, key, value)
                db.commit()
                db.refresh(db_cell)
            return db_cell

    @staticmethod
    def delete_property_cell(db: Session, cell_id: int):
            db_cell = db.query(PropertyCell).filter(PropertyCell.id == cell_id).first()
            if db_cell:
                db.delete(db_cell)
                db.commit()
            return db_cell