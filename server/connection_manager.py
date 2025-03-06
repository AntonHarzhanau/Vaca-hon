from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from models.Player import Player
import json
class ConnectionManager:
    
    def __init__(self):
        self.active_connections: dict[WebSocket, int] = {}  # {WebSocket: player_id}
        self.players: dict[int, Player] = {}  # {player_id: Player}
        self.id = 0

    async def connect(self, websocket: WebSocket):
        """Обрабатывает подключение нового игрока."""
        await websocket.accept()

        new_player = Player(id=self.id)
        self.players[self.id] = new_player
        self.active_connections[websocket] = self.id
        self.id += 1

        print(f"🔗 Новый игрок подключен: ID {new_player.id}")

        # Отправляем новому игроку список всех уже подключенных игроков
        await websocket.send_text(json.dumps({
            "action": "player_connected",
            "players": [player.model_dump() for player in self.players.values()]
        }))
        await websocket.send_text(json.dumps({
            "action": "your_id",
            "player_id": new_player.id
        }))

        # Сообщаем всем остальным игрокам о новом подключенном игроке
        new_player_data = json.dumps({
            "action": "player_connected",
            "players": [new_player.model_dump()]
        })
        await self.broadcast(new_player_data, exclude=websocket)

    async def disconnect(self, websocket: WebSocket):
        """Удаляет игрока при отключении и освобождает его ID."""
        if websocket in self.active_connections:
            player_id = self.active_connections.pop(websocket)
            if player_id in self.players:
                del self.players[player_id]
                self.id -= 1
                print(f" Игрок {player_id} отключился и ID освобожден")
                await self.broadcast(json.dumps({
                    "action": "player_disconnected",
                    "player_id": player_id
                }))

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str, exclude: WebSocket = None):
        for connection in self.active_connections:
            if connection != exclude:  # Не отправляем отправителю (если передан)
                await connection.send_text(message)