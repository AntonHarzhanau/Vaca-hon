from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import uvicorn
from connection_manager import ConnectionManager
from game_logic import GameLogic
from handlers import GameHandler

app = FastAPI()

# Create a connection manager
manager = ConnectionManager()
# Create game logic, passing references to players
game_logic = GameLogic(manager.players)
# Create an event handler
game_handler = GameHandler(game_logic, manager)

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    # Connect a new player
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            print(f"Received data: {data}")
            # Pass all incoming events to GameHandler for processing
            await game_handler.handle_event(websocket, data)
    except WebSocketDisconnect:
        await manager.disconnect(websocket)


if __name__ == "__main__":
    # In console:
    # uvicorn server2:app --host 0.0.0.0 --port 8000 --reload
    uvicorn.run(
        "server2:app",        
        host="0.0.0.0",
        port=8000,
        reload=True            # Auto-reload mode
    )
