import json
from fastapi import WebSocket
from app.api.connection_manager import ConnectionManager
from app.game.core.game_manager import GameManager
from app.models.lobby import Lobby

class GameHandler:
    # def __init__(self, game_manager: GameManager, lobby: Lobby):
    #     self.game_manager = game_manager
        # self.connection_manager = lobby.get_connection_manager()
        
    def __init__(self, game_manager: GameManager, manager: ConnectionManager):
        self.game_manager = game_manager
        self.connection_manager = manager


    async def handle_event(self, websocket: WebSocket, data: dict) -> None:
        player_id = self.connection_manager.active_connections.get(websocket)
        if player_id is None:
            await self.connection_manager.send_personal_message(
                json.dumps({"action": "error", "message": "Player not recognized"}),
                websocket
            )
            return

        response = self.game_manager.process_action(player_id, data)
        delivery = response.get("delivery", "broadcast")
        if delivery == "personal":
            await self.connection_manager.send_personal_message(json.dumps(response), websocket)
        else:
            await self.connection_manager.broadcast(json.dumps(response))
