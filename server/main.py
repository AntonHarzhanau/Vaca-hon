import os
from dotenv import load_dotenv
import uvicorn
from fastapi import FastAPI
from app.api.routes.lobby_routes import router as lobby_router
from app.api.routes.user_routes import router as user_router
# from app.api.routes.websocket import router as websocket_router
from app.db.database import create_tables, delete_tables
from contextlib import asynccontextmanager
import logging



# Load environment variables from .env
load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("monopoly-server")

@asynccontextmanager
async def lifespan(app: FastAPI):
   await create_tables()
   print("База готова")
   yield
#    await delete_tables()


app = FastAPI(lifespan=lifespan,root_path=os.getenv("FASTAPI_ROOT_PATH"))

# Include routes
app.include_router(lobby_router)
# app.include_router(websocket_router)
app.include_router(user_router)

if __name__ == "__main__":
    # In console:
    #  uvicorn main:app --host 0.0.0.0 --port 8000 --reload     
    uvicorn.run(
        "main:app",  
        host="0.0.0.0",     
        port=int(os.getenv("FASTAPI_PORT")),
        reload=True            # Auto-reload mode
    )
