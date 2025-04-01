import uuid
from fastapi import APIRouter, Depends, status, HTTPException, WebSocket, WebSocketDisconnect
from app.models.lobby import Lobby
from app.models.user import User
from data.schemas import LobbyCreate, LobbyRead, LobbyUpdate
#from sqlalchemy.future import select
#from sqlalchemy.ext.asyncio import Session
from sqlalchemy import select, and_
from sqlalchemy.orm import Session
from data.database import get_db, db_session
from fastapi import Depends
#from auth.user_manager import current_active_user
from app.core.connection_manager import ConnectionManager
from app.core.handlers import GameHandler
from app.core.game_manager import GameManager
from app.core.global_state import lobbies_connection

session = db_session

router = APIRouter(prefix="/lobbies")

@router.get('', tags=["lobby"], response_model=list[LobbyRead])
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

@router.websocket("/join/{lobby_id}")
async def join_lobby(
    websocket: WebSocket,
    lobby_id: int
):
    connection_manager = None
    lobby_obj = session.get(Lobby, lobby_id)
    if not lobby_obj:
        raise WebSocketDisconnect

    if lobby_id in lobbies_connection:
        connection_manager = lobbies_connection[lobby_id].get_connection_manager()
        if len(connection_manager.active_connections) == lobby_obj.nb_player_max:
            raise WebSocketDisconnect
    else:
        # Create new connection manager if lobby doesn't exist in the global state
        connection_manager = ConnectionManager()

        # Attache connection manager to lobby
        lobby_obj.set_connection_manager(connection_manager)

        # Update lobbies_connection global state
        lobbies_connection[lobby_id] = lobby_obj
            
    await connection_manager.connect(websocket)

    game_manager = GameManager(connection_manager.players)
    game_handler = GameHandler(game_manager, lobby_obj)

    try:
        while True:
            data = await websocket.receive_json()
            logger.info(f"Received data: {data}")
            await game_handler.handle_event(websocket, data)
    except WebSocketDisconnect:
        await connection_manager.disconnect(websocket)
       #TODO: implement normal id assignment logic
        connection_manager.next_id -= 1