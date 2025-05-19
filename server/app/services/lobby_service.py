from app.schemas.lobby_schema import LobbyReadSchema, LobbyCreateSchema, LobbyFilterSchema, LobbyUpdateSchema, LobbyReadWithPass
from app.utils.repository import AbstractRepository
from fastapi import HTTPException

class LobbyService:
    def __init__(self, lobby_repository: AbstractRepository):
        self.lobby_repository: AbstractRepository = lobby_repository()

    async def get_lobbies(
        self, 
        lobby_id: int| None = None, 
        filters: LobbyFilterSchema | None = None
        ) -> list[LobbyReadWithPass]:
        
        lobbies = await self.lobby_repository.get(lobby_id, filters, chose=True)
        return lobbies
    
    async def create_lobby(self, lobby_data: LobbyCreateSchema) -> LobbyReadSchema:
        lobby_dict = lobby_data.model_dump()
        try:
            lobby = await self.lobby_repository.add(lobby_dict)
            print(type(lobby).__name__)
            return lobby
        except HTTPException as e:
            raise e
        
    async def update_lobby(self, lobby_id: int, data: LobbyUpdateSchema) -> LobbyReadSchema:
        lobby_data = data.model_dump(exclude_unset=True)
        updated_lobby = await self.lobby_repository.update(lobby_id, lobby_data)

        if not updated_lobby:
            raise HTTPException(status_code=404, detail="Lobby not found")
        return updated_lobby
        
    async def delete_lobby(self, lobby_id: int) -> LobbyReadSchema | None:
        lobby = await self.lobby_repository.delete(lobby_id)
        return lobby