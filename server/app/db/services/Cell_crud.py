from sqlalchemy.orm import Session
from app.models import Cell  
from app.schemas.Cell_schema import CellCreate   # Importation du schéma Pydantic

class CRUD:
    
    @staticmethod
    def create_cell(db: Session, cell: CellCreate):
        # Créer une nouvelle cellule dans la base de données
        db_cell = Cell(name=cell.name, type=cell.type)
        db.add(db_cell)
        db.commit()
        db.refresh(db_cell)
        return db_cell

    @staticmethod
    def get_cell(db: Session, cell_id: int):
        # Obtenir une cellule par son ID
        return db.query(Cell).filter(Cell.id == cell_id).first()

    @staticmethod
    def update_cell(db: Session, cell_id: int, cell_data: dict):
        # Mettre à jour une cellule
        db_cell = db.query(Cell).filter(Cell.id == cell_id).first()
        if db_cell:
            for key, value in cell_data.items():
                setattr(db_cell, key, value)
            db.commit()
            db.refresh(db_cell)
        return db_cell

    @staticmethod
    def delete_cell(db: Session, cell_id: int):
        # Supprimer une cellule
        db_cell = db.query(Cell).filter(Cell.id == cell_id).first()
        if db_cell:
            db.delete(db_cell)
            db.commit()
        return db_cell
