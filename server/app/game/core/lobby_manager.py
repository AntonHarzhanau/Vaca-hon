# app/core/lobby_manager.py

from typing import Dict
from app.game.core.lobby_instance import LobbyInstance
from app.schemas.lobby_schema import LobbyReadSchema

# app/core/lobby_manager.py

class LobbyManager:
    def __init__(self):
        self.lobbies: dict[int, LobbyInstance] = {}

    def add_lobby(self, lobby_instance: LobbyInstance) -> None:
        self.lobbies[lobby_instance.lobby.id] = lobby_instance
        
    def get_lobby(self, lobby_id: int) -> LobbyInstance | None:
        return self.lobbies.get(lobby_id)

    def remove_lobby(self, lobby_id: int) -> None:
        if lobby_id in self.lobbies:
            del self.lobbies[lobby_id]

lobby_manager:LobbyManager = LobbyManager()
