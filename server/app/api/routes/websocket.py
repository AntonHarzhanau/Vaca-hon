from fastapi import APIRouter, WebSocket, WebSocketDisconnect, status
from app.models.lobby import Lobby
from app.models.user import User
from app.api.connection_manager import ConnectionManager
from app.game.core.handlers import GameHandler
from app.game.core.game_manager import GameManager
from app.core.global_state import lobbies_connection
from app.db.database import get_db, db_session

router = APIRouter(prefix="/ws", tags=["lobby"])

session = db_session

manager = ConnectionManager()
game_manager = GameManager(manager.players)
game_handler = GameHandler(game_manager, manager)



@router.websocket("")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            await game_handler.handle_event(websocket, data)
    except WebSocketDisconnect:
        await manager.disconnect(websocket)
       #TODO: implement normal id assignment logic
        manager.next_id -= 1


@router.websocket("/join/{lobby_id}")
async def join_lobby(
    websocket: WebSocket,
    lobby_id: int
):
    connection_manager = None
    lobby_obj = session.get(Lobby, lobby_id)
    if not lobby_obj:
        raise WebSocketDisconnect

    if lobby_id in lobbies_connection:
        connection_manager = lobbies_connection[lobby_id].get_connection_manager()
        if len(connection_manager.active_connections) == lobby_obj.nb_player_max:
            raise WebSocketDisconnect
    else:
        # Create new connection manager if lobby doesn't exist in the global state
        connection_manager = ConnectionManager()

        # Attache connection manager to lobby
        lobby_obj.set_connection_manager(connection_manager)

        # Update lobbies_connection global state
        lobbies_connection[lobby_id] = lobby_obj
            
    await connection_manager.connect(websocket)

    game_manager = GameManager(connection_manager.players)
    game_handler = GameHandler(game_manager, lobby_obj)

    try:
        while True:
            data = await websocket.receive_json()
            # logger.info(f"Received data: {data}")
            await game_handler.handle_event(websocket, data)
    except WebSocketDisconnect:
        await connection_manager.disconnect(websocket)
       #TODO: implement normal id assignment logic
        connection_manager.next_id -= 1
   
   
   

     
