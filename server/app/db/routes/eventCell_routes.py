from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.schemas.EventCell_schema import EventCellBase, EventCellCreate
from app.services.EventCell_crud import CRUD
from app.data.database import get_db
from app.models import EventCell


router = APIRouter(prefix="/event_cells", tags=["Event Cells"])

@router.post("/", response_model=EventCellCreate)
def create_event_cell(event_cell: EventCellCreate, db: Session = Depends(get_db)):
    return CRUD.create_event_cell(db, event_cell)

@router.get("/{cell_id}", response_model=EventCellBase)
def get_event_cell(cell_id: int, db: Session = Depends(get_db)):
    db_event_cell = CRUD.get_event_cell(db, cell_id)
    if not db_event_cell:
        raise HTTPException(status_code=404, detail="EventCell not found")
    return db_event_cell

@router.get("/", response_model=list[EventCellBase])
def get_all_event_cells(db: Session = Depends(get_db)):
    return db.query(EventCell).all()

@router.put("/{cell_id}", response_model=EventCellBase)
def update_event_cell(cell_id: int, cell_data: dict, db: Session = Depends(get_db)):
    updated_cell = CRUD.update_event_cell(db, cell_id, cell_data)
    if not updated_cell:
        raise HTTPException(status_code=404, detail="EventCell not found")
    return updated_cell

@router.delete("/{cell_id}", response_model=EventCellBase)
def delete_event_cell(cell_id: int, db: Session = Depends(get_db)):
    deleted_cell = CRUD.delete_event_cell(db, cell_id)
    if not deleted_cell:
        raise HTTPException(status_code=404, detail="EventCell not found")
    return deleted_cell
