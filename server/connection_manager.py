from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from models.Player import Player
import json

class ConnectionManager:
    
    def __init__(self):
        self.active_connections: dict[WebSocket, int] = {}  # {WebSocket: player_id}
        self.players: dict[int, Player] = {}  # {player_id: Player}
        self.id = 0

    async def connect(self, websocket: WebSocket):
        """Handles a new player's connection."""
        await websocket.accept()

        new_player = Player(id=self.id)
        self.players[self.id] = new_player
        self.active_connections[websocket] = self.id
        self.id += 1

        print(f"🔗 New player connected: ID {new_player.id}")

        # Send the new player a list of all already connected players
        await websocket.send_text(json.dumps({
            "action": "player_connected",
            "players": [player.model_dump() for player in self.players.values()]
        }))
        await websocket.send_text(json.dumps({
            "action": "your_id",
            "player_id": new_player.id
        }))

        # Notify all other players about the newly connected player
        new_player_data = json.dumps({
            "action": "player_connected",
            "players": [new_player.model_dump()]
        })
        await self.broadcast(new_player_data, exclude=websocket)

    async def disconnect(self, websocket: WebSocket):
        """Removes a player upon disconnection and releases their ID."""
        if websocket in self.active_connections:
            player_id = self.active_connections.pop(websocket)
            if player_id in self.players:
                del self.players[player_id]
                self.id -= 1
                print(f"Player {player_id} disconnected and ID released")
                await self.broadcast(json.dumps({
                    "action": "player_disconnected",
                    "player_id": player_id
                }))

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str, exclude: WebSocket = None):
        for connection in self.active_connections:
            if connection != exclude:  # Do not send to the sender (if provided)
                await connection.send_text(message)
