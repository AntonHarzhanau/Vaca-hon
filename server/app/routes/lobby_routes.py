import uuid
from fastapi import APIRouter, Depends, status, HTTPException
from app.models.lobby import Lobby
from data.schemas import LobbyCreate, LobbyRead, LobbyUpdate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from models.Lobby import Lobby
from database import get_async_session
from fastapi import Depends
from auth.user_manager import current_active_user

session = get_async_session()

router = APIRouter(prefix="/lobbies")

@router.get('', tags=["lobby"], response_model=list[LobbyRead])
async def get_all_lobbies(
    session: AsyncSession = Depends(get_async_session)
):
    result = await session.execute(select(Lobby))
    return result.scalars().all()


@router.post('', tags=["lobby"], status_code=status.HTTP_201_CREATED)
async def create_lobby(
    lobby_data: LobbyCreate, 
    session: AsyncSession = Depends(get_async_session)
):
    new_lobby = Lobby(
        nb_player_max=lobby_data.nb_player_max,
        time_sec=lobby_data.time_sec,
        owner_id=current_user.id, 
        is_private=lobby_data.is_private,
        secret=lobby_data.secret
    )
    new_lobby.add_player(current_user.id)
    session.add(new_lobby)
    await session.commit()
    await session.refresh(new_lobby)  # Refresh to get the new ID

    return new_lobby


@router.patch('/{lobby_id}', tags=["lobby"])
async def update_lobby(
    lobby_id: uuid.UUID,
    lobby_data: LobbyUpdate,
    session: AsyncSession = Depends(get_async_session)
):
    # Fetch the lobby from the database
    result = await session.execute(select(Lobby).where(Lobby.id == lobby_id))
    lobby = result.scalars().first()

    if not lobby:
        raise HTTPException(status_code=404, detail="Lobby not found")

    # Ensure the user is the owner
    # if str(lobby.owner_id) != str(current_user.id):  
    #     raise HTTPException(status_code=403, detail="You are not the owner of this lobby")

    # Update only provided fields
    for field, value in lobby_data.dict(exclude_unset=True).items():
        setattr(lobby, field, value)

    await session.commit()
    await session.refresh(lobby)  # Refresh to get updated values

    return lobby


@router.get('/{lobby_id}', tags=["lobby"], response_model=LobbyRead)
async def get_lobby_by_id(
    lobby_id: int, 
    session: AsyncSession = Depends(get_async_session)
    ):
    result = await session.execute(select(Lobby).where(Lobby.id == lobby_id))
    return result.scalars().first()


@router.delete("/{lobby_id}", tags=["lobby"], status_code=204)
async def delete_lobby(
    lobby_id: uuid.UUID,
    session: AsyncSession = Depends(get_async_session)
):
    # Fetch the lobby from the database
    result = await session.execute(select(Lobby).where(Lobby.id == lobby_id))
    lobby = result.scalars().first()

    if not lobby:
        raise HTTPException(status_code=404, detail="Lobby not found")

    # Ensure the user is the owner
    # if str(lobby.owner_id) != str(current_user.id):  
    #     raise HTTPException(status_code=403, detail="You are not the owner of this lobby")

    # Delete the lobby
    await session.delete(lobby)
    await session.commit()

    return None 