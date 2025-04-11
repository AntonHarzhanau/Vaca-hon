from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.UtilityCell_schema import UtilityCellCreate, UtilityCellBase
from app.models import UtilityCell
from app.data.database import get_db
from app.services.UtilityCell_crud import CRUD

router = APIRouter(prefix="/utility_cells", tags=["Utility Cells"])

# Créer une UtilityCell
@router.post("/", response_model=UtilityCellBase)
def create_utility_cell(utility_cell: UtilityCellCreate, db: Session = Depends(get_db)):
    return CRUD.create_utility_cell(db, utility_cell)

# Obtenir toutes les UtilityCells
@router.get("/", response_model=list[UtilityCellBase])
def get_all_utility_cells(db: Session = Depends(get_db)):
    return db.query(UtilityCell).all()

# Obtenir une UtilityCell par ID
@router.get("/{cell_id}", response_model=UtilityCellBase)
def get_utility_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.get_utility_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="UtilityCell not found")
    return cell

# Mettre à jour une UtilityCell
@router.put("/{cell_id}", response_model=UtilityCellBase)
def update_utility_cell(cell_id: int, cell_data: dict, db: Session = Depends(get_db)):
    cell = CRUD.update_utility_cell(db, cell_id, cell_data)
    if not cell:
        raise HTTPException(status_code=404, detail="UtilityCell not found")
    return cell

# Supprimer une UtilityCell
@router.delete("/{cell_id}")
def delete_utility_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.delete_utility_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="UtilityCell not found")
    return {"message": "UtilityCell deleted successfully"}
