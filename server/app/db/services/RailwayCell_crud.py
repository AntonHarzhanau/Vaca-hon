from sqlalchemy.orm import Session
from app.models import RailwayCell
from app.schemas.RailwayCell_schema import RailwayCellCreate, RailwayCellBase


class CRUD:
    # CRUD for RailwayCell
    @staticmethod
    def create_railway_cell(db: Session, railway_cell: RailwayCellCreate):
        db_railway_cell = RailwayCell(**railway_cell.dict())
        db.add(db_railway_cell)
        db.commit()
        db.refresh(db_railway_cell)
        return db_railway_cell

    @staticmethod
    def get_railway_cell(db: Session, cell_id: int):
        return db.query(RailwayCellBase).filter(RailwayCell.id == cell_id).first()

    @staticmethod
    def update_railway_cell(db: Session, cell_id: int, cell_data: dict):
        db_cell = db.query(RailwayCellBase).filter(RailwayCell.id == cell_id).first()
        if db_cell:
            for key, value in cell_data.items():
                setattr(db_cell, key, value)
            db.commit()
            db.refresh(db_cell)
        return db_cell

    @staticmethod
    def delete_railway_cell(db: Session, cell_id: int):
        db_cell = db.query(RailwayCellBase).filter(RailwayCell.id == cell_id).first()
        if db_cell:
            db.delete(db_cell)
            db.commit()
        return db_cell