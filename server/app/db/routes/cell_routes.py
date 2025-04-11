from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.data.database import get_db
# from data.schemas import CellBase, CellCreate  
from app.models import Cell
from app.schemas.Cell_schema import CellBase, CellCreate  

router = APIRouter(prefix="/cells", tags=["cells"])

# Route pour obtenir toutes les cellules
@router.get("/", response_model=List[CellBase])  
def get_cells(db: Session = Depends(get_db)):
    cells = db.query(Cell).all()  # Interrogation de la table Cell dans la base de données
    return cells

# Route pour obtenir une cellule par ID
@router.get("/{cell_id}", response_model=CellBase)  
def get_cell(cell_id: int, db: Session = Depends(get_db)):
    db_cell = db.query(Cell).filter(Cell.id == cell_id).first()  
    if db_cell is None:
        raise HTTPException(status_code=404, detail="Cell not found")
    return db_cell  # Vous renvoyez un Pydantic schema automatiquement

# Route pour créer une nouvelle cellule
@router.post("/", response_model=CellBase) 
def create_cell(cell: CellCreate, db: Session = Depends(get_db)):
    # Créez une instance de la cellule avec les données du body
    db_cell = Cell(name=cell.name, type=cell.type)
    db.add(db_cell)
    db.commit()
    db.refresh(db_cell)
    return db_cell  

# Route pour mettre à jour une cellule existante
@router.put("/{cell_id}", response_model=CellBase)  
def update_cell(cell_id: int, cell: CellCreate, db: Session = Depends(get_db)):
    db_cell = db.query(Cell).filter(Cell.id == cell_id).first()  
    if db_cell is None:
        raise HTTPException(status_code=404, detail="Cell not found")
    
    # Mise à jour des attributs de la cellule
    db_cell.name = cell.name
    db_cell.type = cell.type
    db.commit()
    db.refresh(db_cell)
    return db_cell  # Retourne l'objet mis à jour via Pydantic

# Route pour supprimer une cellule
@router.delete("/{cell_id}", response_model=dict)  
def delete_cell(cell_id: int, db: Session = Depends(get_db)):
    db_cell = db.query(Cell).filter(Cell.id == cell_id).first()  
    if db_cell is None:
        raise HTTPException(status_code=404, detail="Cell not found")
    
    db.delete(db_cell)
    db.commit()
    return {"message": "Cell deleted successfully"} 
