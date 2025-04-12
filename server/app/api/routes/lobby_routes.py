from fastapi import APIRouter, Depends, status, HTTPException
from app.schemas.lobby import LobbyCreateSchema, LobbyReadSchema, LobbyUpdateSchema, LobbyFilterSchema
from sqlalchemy import select, and_
from fastapi import Depends
from typing import Annotated
from app.services.lobby import LobbyService
from app.api.dependencies import lobby_service


router = APIRouter(prefix="/lobbies", tags=["lobby"])

@router.post("/")
async def create_lobby(
    lobby_data: Annotated[LobbyCreateSchema, Depends()],
    service: Annotated[LobbyService, Depends(lobby_service)]
) -> LobbyReadSchema:
    new_lobby = await service.create_lobby(lobby_data)
    if new_lobby is None:
        raise HTTPException(status_code=400, detail="Lobby creation failed")
    return await service.create_lobby(lobby_data)


@router.get('', response_model=list[LobbyReadSchema])
async def get_all_lobbies(
    service: Annotated[LobbyService, Depends(lobby_service)] 
) -> list[LobbyReadSchema]:
    lobbies = await service.get_lobbies(filters=LobbyFilterSchema(is_active=True))
    return lobbies

@router.get("/{lobby_id}", response_model=LobbyReadSchema)
async def get_lobby(
    lobby_id: int,
    service: Annotated[LobbyService, Depends(lobby_service)]
) -> LobbyReadSchema:
    lobby = await service.get_lobbies(lobby_id)
    if lobby is None:
        raise HTTPException(status_code=404, detail="Lobby not found")
    return lobby

@router.delete("/{lobby_id}", status_code=204)
async def delete_lobby(
    lobby_id: int,
    service: Annotated[LobbyService, Depends(lobby_service)]
) -> None:
    deleted_lobby = await service.delete_lobby(lobby_id)
    if deleted_lobby is None:
        raise HTTPException(status_code=404, detail="Lobby not found")

# def delete_lobby(
#     lobby_id: int,
#     session: Session = Depends(get_db)
# ):
#     # Fetch the lobby from the database
#     result = session.execute(select(Lobby).where(Lobby.id == lobby_id))
#     lobby = result.scalars().first()

#     if not lobby:
#         raise HTTPException(status_code=404, detail="Lobby not found")

#     # Ensure the user is the owner
#     # if str(lobby.owner_id) != str(current_user.id):  
#     #     raise HTTPException(status_code=403, detail="You are not the owner of this lobby")

#     # Delete the lobby
#     session.delete(lobby)
#     session.commit()

#     return None



# @router.patch('/{lobby_id}')
# def update_lobby(
#     lobby_id: int,
#     lobby_data: LobbyUpdate,
#     session: Session = Depends(get_db)
# ):
#     # Fetch the lobby from the database
#     result = session.execute(select(Lobby).where(Lobby.id == lobby_id))
#     lobby = result.scalars().first()

#     if not lobby:
#         raise HTTPException(status_code=404, detail="Lobby not found")

#     # Ensure the user is the owner
#     # if str(lobby.owner_id) != str(current_user.id):  
#     #     raise HTTPException(status_code=403, detail="You are not the owner of this lobby")

#     # Update only provided fields
#     for field, value in lobby_data.model_dump(exclude_unset=True).items():
#         setattr(lobby, field, value)

#     session.commit()
#     session.refresh(lobby)  # Refresh to get updated values

#     return lobby
