from typing import Dict
from fastapi import WebSocket
from app.schemas.user_schema import UserReadSchema, UserReadSchemaWithToken


    
class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[WebSocket, UserReadSchemaWithToken] = {}
        self.idle_connections: Dict[WebSocket, UserReadSchema] = {}

    async def connect(self, websocket: WebSocket, user: UserReadSchemaWithToken):
        self.active_connections[websocket] = user

    async def disconnect(self, websocket: WebSocket) -> UserReadSchemaWithToken:
        return self.active_connections.pop(websocket)
        

    async def send_personal_message(self, message: str, websocket: WebSocket):
        print(f"Sending message to {websocket}: {message}")
        await websocket.send_text(message)

    async def broadcast(self, message: str, exclude: WebSocket = None):
        print(f"Broadcasting message: {message}")
        disconnected = []

        for connection in self.active_connections:
            if connection != exclude:
                try:
                    await connection.send_text(message)
                except Exception as e:
                    print(f"⚠️ Error sending: {e}")
                    disconnected.append(connection)
        
        # Remove unavailable connections
        for conn in disconnected:
            self.active_connections.pop(conn)


# manager = ConnectionManager()
