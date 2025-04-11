from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.StreetCell_schema import StreetCellCreate, StreetCellBase
from app.models import StreetCell
from app.data.database import get_db
from app.services.StreetCell_crud import CRUD


router = APIRouter(prefix="/street_cells", tags=["Street Cells"])

# Créer une StreetCell
@router.post("/", response_model=StreetCellBase)
def create_street_cell(street_cell: StreetCellCreate, db: Session = Depends(get_db)):
    return CRUD.create_street_cell(db, street_cell)

# Obtenir toutes les StreetCells
@router.get("/", response_model=list[StreetCellBase])
def get_all_street_cells(db: Session = Depends(get_db)):
    return db.query(StreetCell).all()

# Obtenir une StreetCell par ID
@router.get("/{cell_id}", response_model=StreetCellBase)
def get_street_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.get_street_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="StreetCell not found")
    return cell

# Mettre à jour une StreetCell
@router.put("/{cell_id}", response_model=StreetCellBase)
def update_street_cell(cell_id: int, cell_data: dict, db: Session = Depends(get_db)):
    cell = CRUD.update_street_cell(db, cell_id, cell_data)
    if not cell:
        raise HTTPException(status_code=404, detail="StreetCell not found")
    return cell

# Supprimer une StreetCell
@router.delete("/{cell_id}")
def delete_street_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.delete_street_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="StreetCell not found")
    return {"message": "StreetCell deleted successfully"}
