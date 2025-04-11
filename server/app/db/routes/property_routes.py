from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.data.database import get_db
from app.services.PropertyCell_crud import CRUD
from app.schemas.PropertyCell_schema import PropertyCell, PropertyCellCreate



router = APIRouter(prefix="/properties", tags=["properties"])

@router.post("/", response_model=PropertyCell)
def create_property(property_cell: PropertyCellCreate, db: Session = Depends(get_db)):
    return CRUD.create_property_cell(db, property_cell)

@router.get("/{property_id}", response_model=PropertyCell)
def read_property(property_id: int, db: Session = Depends(get_db)):
    property_cell = CRUD.get_property_cell(db, property_id)
    if property_cell is None:
        raise HTTPException(status_code=404, detail="Property not found")
    return property_cell

@router.put("/{property_id}", response_model=PropertyCell)
def update_property(property_id: int, property_data: dict, db: Session = Depends(get_db)):
    return CRUD.update_property_cell(db, property_id, property_data)

@router.delete("/{property_id}", response_model=PropertyCell)
def delete_property(property_id: int, db: Session = Depends(get_db)):
    return CRUD.delete_property_cell(db, property_id)
