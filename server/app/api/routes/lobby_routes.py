import uuid
from fastapi import APIRouter, Depends, status, HTTPException
from app.game.models.lobby import Lobby
from app.db.schemas import LobbyCreate, LobbyRead, LobbyUpdate
from sqlalchemy import select, and_
from sqlalchemy.orm import Session
from app.db.database import get_db, db_session
from fastapi import Depends
#from auth.user_manager import current_active_user


session = db_session

router = APIRouter(prefix="/lobbies", tags=["lobby"])

@router.get('', response_model=list[LobbyRead])
def get_all_lobbies(
    session: Session = Depends(get_db)
):
    query = select(Lobby).where(
            and_(
                Lobby.is_active == True
            )
        )
    result = session.execute(query)
    return result.scalars().all()


@router.post('', status_code=status.HTTP_201_CREATED)
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


@router.patch('/{lobby_id}')
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
    for field, value in lobby_data.model_dump(exclude_unset=True).items():
        setattr(lobby, field, value)

    session.commit()
    session.refresh(lobby)  # Refresh to get updated values

    return lobby


@router.get('/{lobby_id}', response_model=LobbyRead)
def get_lobby_by_id(
    lobby_id: int, 
    session: Session = Depends(get_db)
):
    result = session.execute(select(Lobby).where(Lobby.id == lobby_id))
    return result.scalars().first()


@router.delete("/{lobby_id}", status_code=204)
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

