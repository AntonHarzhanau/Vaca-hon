from sqlalchemy.orm import Session
from app.models import EventCell
from app.schemas.EventCell_schema import EventCellCreate


class CRUD:
    # CRUD for EventCell
    @staticmethod
    def create_event_cell(db: Session, event_cell: EventCellCreate):
        db_event_cell = EventCell(**event_cell.dict())
        db.add(db_event_cell)
        db.commit()
        db.refresh(db_event_cell)
        return db_event_cell
    
    @staticmethod
    def get_event_cell(db: Session, cell_id: int):
        return db.query(EventCell).filter(EventCell.id == cell_id).first()
    
    @staticmethod
    def update_event_cell(db: Session, cell_id: int, cell_data: dict):
        db_cell = db.query(EventCell).filter(EventCell.id == cell_id).first()
        if db_cell:
            for key, value in cell_data.items():
                setattr(db_cell, key, value)
            db.commit()
            db.refresh(db_cell)
        return db_cell
    

    @staticmethod
    def delete_event_cell(db: Session, cell_id: int):
        db_cell = db.query(EventCell).filter(EventCell.id == cell_id).first()
        if db_cell:
            db.delete(db_cell)
            db.commit()
        return db_cell