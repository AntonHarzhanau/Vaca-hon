import uuid
from fastapi import APIRouter, Depends, status, HTTPException
from app.models.lobby import Lobby
from app.models.user import User
from data.schemas import LobbyCreate, LobbyRead, LobbyUpdate
from sqlalchemy.future import select
#from sqlalchemy.ext.asyncio import Session
from sqlalchemy.orm import Session
from data.database import get_db
from fastapi import Depends
#from auth.user_manager import current_active_user

session = get_db()

router = APIRouter(prefix="/lobbies")

@router.get('', tags=["lobby"], response_model=list[LobbyRead])
def get_all_lobbies(
    session: Session = Depends(get_db)
):
    result = session.execute(select(Lobby))
    return result.scalars().all()


@router.post('', tags=["lobby"], status_code=status.HTTP_201_CREATED)
def create_lobby(
    lobby_data: LobbyCreate, 
    session: Session = Depends(get_db)
):
    current_user = {
        "id": 1,
        "username": "superadmin"
    }
    new_lobby = Lobby(
        nb_player_max=lobby_data.nb_player_max,
        time_sec=lobby_data.time_sec,
        owner_id=current_user["id"], 
        is_private=lobby_data.is_private,
        secret=lobby_data.secret
    )
    session.add(new_lobby)
    session.commit()
    session.refresh(new_lobby)  # Refresh to get the new ID

    return new_lobby


@router.patch('/{lobby_id}', tags=["lobby"])
def update_lobby(
    lobby_id: uuid.UUID,
    lobby_data: LobbyUpdate,
    session: Session = Depends(get_db)
):
    # Fetch the lobby from the database
    result = session.execute(select(Lobby).where(Lobby.id == lobby_id))
    lobby = result.scalars().first()

    if not lobby:
        raise HTTPException(status_code=404, detail="Lobby not found")

    # Ensure the user is the owner
    # if str(lobby.owner_id) != str(current_user.id):  
    #     raise HTTPException(status_code=403, detail="You are not the owner of this lobby")

    # Update only provided fields
    for field, value in lobby_data.dict(exclude_unset=True).items():
        setattr(lobby, field, value)

    session.commit()
    session.refresh(lobby)  # Refresh to get updated values

    return lobby


@router.get('/{lobby_id}', tags=["lobby"], response_model=LobbyRead)
def get_lobby_by_id(
    lobby_id: int, 
    session: Session = Depends(get_db)
    ):
    result = session.execute(select(Lobby).where(Lobby.id == lobby_id))
    return result.scalars().first()


@router.delete("/{lobby_id}", tags=["lobby"], status_code=204)
def delete_lobby(
    lobby_id: uuid.UUID,
    session: Session = Depends(get_db)
):
    # Fetch the lobby from the database
    result = session.execute(select(Lobby).where(Lobby.id == lobby_id))
    lobby = result.scalars().first()

    if not lobby:
        raise HTTPException(status_code=404, detail="Lobby not found")

    # Ensure the user is the owner
    # if str(lobby.owner_id) != str(current_user.id):  
    #     raise HTTPException(status_code=403, detail="You are not the owner of this lobby")

    # Delete the lobby
    session.delete(lobby)
    session.commit()

    return None 