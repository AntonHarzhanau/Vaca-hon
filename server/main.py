import uvicorn
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from app.core.connection_manager import ConnectionManager
from app.core.handlers import GameHandler
from app.core.game_manager import GameManager
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("monopoly-server")

app = FastAPI()

# Инициализация менеджера соединений, логики игры и обработчика событий
manager = ConnectionManager()
game_manager = GameManager(manager.players)
game_handler = GameHandler(game_manager, manager)

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            logger.info(f"Received data: {data}")
            await game_handler.handle_event(websocket, data)
    except WebSocketDisconnect:
        await manager.disconnect(websocket)
        #TODO: реализовать нормальную логику
        manager.next_id -= 1

if __name__ == "__main__":
    # In console:
    #  uvicorn main:app --host 0.0.0.0 --port 8000 --reload     
    uvicorn.run(
        "main:app",        
        host="0.0.0.0",
        port=8000,
        reload=True            # Auto-reload mode
    )
