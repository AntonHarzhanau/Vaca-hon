from fastapi import APIRouter, Depends, HTTPException
from app.schemas.lobby_schema import LobbyCreateSchema, LobbyReadSchema, LobbyFilterSchema
from fastapi import Depends, Body
from typing import Annotated
from app.services.lobby_service import LobbyService
from app.api.dependencies import lobby_service


router = APIRouter(prefix="/lobbies", tags=["lobby"])

@router.post("/")
async def create_lobby(
    lobby_data: Annotated[LobbyCreateSchema, Body()],
    service: Annotated[LobbyService, Depends(lobby_service)],
) -> LobbyReadSchema:
    print("Creating lobby with data:", lobby_data)
    new_lobby = await service.create_lobby(lobby_data)
    if new_lobby is None:
        raise HTTPException(status_code=400, detail="Lobby creation failed")
    return new_lobby


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