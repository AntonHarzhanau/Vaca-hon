from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.RailwayCell_schema import RailwayCellCreate, RailwayCellBase
from app.models import RailwayCell
from app.data.database import get_db
from app.services.RailwayCell_crud import CRUD

router = APIRouter(prefix="/railway_cells", tags=["Railway Cells"])

# Créer une RailwayCell
@router.post("/", response_model=RailwayCellBase)
def create_railway_cell(railway_cell: RailwayCellCreate, db: Session = Depends(get_db)):
    return CRUD.create_railway_cell(db, railway_cell)

# Obtenir toutes les RailwayCells
@router.get("/", response_model=list[RailwayCellBase])
def get_all_railway_cells(db: Session = Depends(get_db)):
    return db.query(RailwayCell).all()

# Obtenir une RailwayCell par ID
@router.get("/{cell_id}", response_model=RailwayCellBase)
def get_railway_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.get_railway_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="RailwayCell not found")
    return cell

# Mettre à jour une RailwayCell
@router.put("/{cell_id}", response_model=RailwayCellBase)
def update_railway_cell(cell_id: int, cell_data: dict, db: Session = Depends(get_db)):
    cell = CRUD.update_railway_cell(db, cell_id, cell_data)
    if not cell:
        raise HTTPException(status_code=404, detail="RailwayCell not found")
    return cell

# Supprimer une RailwayCell
@router.delete("/{cell_id}")
def delete_railway_cell(cell_id: int, db: Session = Depends(get_db)):
    cell = CRUD.delete_railway_cell(db, cell_id)
    if not cell:
        raise HTTPException(status_code=404, detail="RailwayCell not found")
    return {"message": "RailwayCell deleted successfully"}
