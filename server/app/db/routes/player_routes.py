from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.schemas.Player_schema import PlayerCreate, PlayerBase
from app.models import Player
from app.data.database import get_db
from app.services.Player_crud import CRUD

router = APIRouter(prefix="/players", tags=["Players"])

@router.post("/", response_model=PlayerCreate)
def create_player(player: PlayerCreate, db: Session = Depends(get_db)):
    return CRUD.create_player(db, player)

@router.get("/{player_id}", response_model=PlayerBase)
def get_player(player_id: int, db: Session = Depends(get_db)):
    player = CRUD.get_player(db, player_id)
    if player is None:
        raise HTTPException(status_code=404, detail="Player not found")
    return player

@router.get("/", response_model=list[PlayerBase])
def get_all_players(db: Session = Depends(get_db)):
    players = db.query(Player).all()
    return players

@router.put("/{player_id}", response_model=PlayerBase)
def update_player(player_id: int, player_data: PlayerBase, db: Session = Depends(get_db)):
    updated_player = CRUD.update_player(db, player_id, player_data.dict(exclude_unset=True))
    if updated_player is None:
        raise HTTPException(status_code=404, detail="Player not found")
    return updated_player

@router.delete("/{player_id}", response_model=PlayerBase)
def delete_player(player_id: int, db: Session = Depends(get_db)):
    deleted_player = CRUD.delete_player(db, player_id)
    if deleted_player is None:
        raise HTTPException(status_code=404, detail="Player not found")
    return deleted_player
