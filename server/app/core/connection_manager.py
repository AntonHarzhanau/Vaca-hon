import json
from typing import Dict
from fastapi import WebSocket
from app.models.player import Player

class ConnectionManager:
    
    def __init__(self):
        self.active_connections: Dict[WebSocket, int] = {}  # WebSocket -> player_id
        self.players: Dict[int, Player] = {}  # player_id -> Player
        self.next_id: int = 0

    async def connect(self, websocket: WebSocket) -> None:
        await websocket.accept()

        new_player = Player(id=self.next_id, name="Player" + str(self.next_id))
        self.players[self.next_id] = new_player
        self.active_connections[websocket] = self.next_id
        self.next_id += 1

        print(f"🔗 New player connected: ID {new_player.id}")


        # Отправляем игроку его ID
        await websocket.send_text(json.dumps({
            "action": "your_id",
            "player_id": new_player.id
        }))
        
        # Отправляем новому игроку список подключённых игроков
        await websocket.send_text(json.dumps({
            "action": "player_connected",
            "players": [player.model_dump() for player in self.players.values()]
        }))

        # Уведомляем остальных игроков
        new_player_data = json.dumps({
            "action": "player_connected",
            "players": [new_player.model_dump()]
        })
        await self.broadcast(new_player_data, exclude=websocket)

    async def disconnect(self, websocket: WebSocket) -> None:
        if websocket in self.active_connections:
            player_id = self.active_connections.pop(websocket)
            if player_id in self.players:
                del self.players[player_id]
                print(f"Player {player_id} disconnected")
                await self.broadcast(json.dumps({
                    "action": "player_disconnected",
                    "player_id": player_id
                }))

    async def send_personal_message(self, message: str, websocket: WebSocket) -> None:
        print(message)
        await websocket.send_text(message)

    async def broadcast(self, message: str, exclude: WebSocket = None) -> None:
        print(message)
        for connection in self.active_connections:
            if connection != exclude:
                await connection.send_text(message)
