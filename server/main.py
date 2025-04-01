import os
from dotenv import load_dotenv
import uvicorn
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from app.core.connection_manager import ConnectionManager
from app.core.handlers import GameHandler
from app.core.game_manager import GameManager
from app.routes.lobby_routes import router as lobby_router
from data.database import create_tables, engine, Base
import logging

# Load environment variables from .env
load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("monopoly-server")

app = FastAPI(root_path=os.getenv("FASTAPI_ROOT_PATH"))

# Initialize the connection manager, game logic and event handler
# manager = ConnectionManager()
# game_manager = GameManager(manager.players)
# game_handler = GameHandler(game_manager, manager)

# Include routes
app.include_router(lobby_router)

# Create database tables
Base.metadata.create_all(bind=engine)
create_tables()

if __name__ == "__main__":
    # In console:
    #  uvicorn main:app --host 0.0.0.0 --port 8000 --reload     
    uvicorn.run(
        "main:app",        
        host="0.0.0.0",
        port=int(os.getenv("FASTAPI_PORT")),
        reload=True            # Auto-reload mode
    )
