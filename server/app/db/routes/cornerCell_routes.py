from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.schemas.CornerCell_schema import CornerCellBase, CornerCellCreate
from app.db.services.CornerCell_crud import CRUD
from app.db.data.database import get_db
from app.db.models import CornerCell

router = APIRouter(prefix="/corner_cells", tags=["Corner Cells"])


@router.post("/", response_model=CornerCellCreate)
def create_corner_cell(corner_cell: CornerCellCreate, db: Session = Depends(get_db)):
    return CRUD.create_corner_cell(db, corner_cell)


@router.get("/", response_model=List[CornerCellBase])  
def get_cornerCells(db: Session = Depends(get_db)):
    cornerCells = db.query(CornerCell).all()  
    return cornerCells


@router.get("/{cell_id}", response_model=CornerCellBase)
def get_corner_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.get_corner_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="CornerCell not found")
    return cell


@router.put("/{cell_id}", response_model=CornerCellBase)
def update_corner_cell(cell_id: int, cell_data: dict, db: Session = Depends(get_db)):
    updated_cell = CRUD.update_corner_cell(db, cell_id, cell_data)
    if not updated_cell:
        raise HTTPException(status_code=404, detail="CornerCell not found")
    return updated_cell


@router.delete("/{cell_id}")
def delete_corner_cell(cell_id: int, db: Session = Depends(get_db)):
    deleted_cell = CRUD.delete_corner_cell(db, cell_id)
    if not deleted_cell:
        raise HTTPException(status_code=404, detail="CornerCell not found")
    return {"message": "CornerCell deleted successfully"}
