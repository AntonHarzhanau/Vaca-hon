import json
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, status
from app.services.user_service import UserService 
from app.services.lobby_service import LobbyService
from app.game.core.lobby_manager import LobbyManager
from app.game.core.lobby_instance import LobbyInstance
from app.schemas.lobby_schema import LobbyUpdateSchema
from app.schemas.user_schema import UserReadSchema, UserReadSchemaWithToken
from fastapi import Depends, Query
from typing import Annotated
from app.api.dependencies import lobby_service, user_service, get_lobby_manager

router = APIRouter(prefix="/ws")

@router.websocket("/join/{lobby_id}")
async def websocket_endpoint(
    websocket: WebSocket,
    lobby_id: int,
    user_id: Annotated[int, Query(...)],  # pass user_id as a query parameter, for example ?user_id=1
    lobby_service: Annotated[LobbyService, Depends(lobby_service)],
    user_service: Annotated[UserService, Depends(user_service)],
    lobby_manager: LobbyManager = Depends(get_lobby_manager),
):
    await websocket.accept()
    # TODO : implement authentication check
    user = await user_service.get_users(user_id=user_id)
    if not user:
        await websocket.send_json({"error": "User not found"})
        await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    
    lobby = lobby_manager.get_lobby(lobby_id)
    
    if not lobby:
        lobby = await lobby_service.get_lobbies(lobby_id)
        if not lobby:
            await websocket.send_json({"error": "Lobby not found"})
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        lobby = LobbyInstance(lobby)
        lobby_manager.add_lobby(lobby)
    
    if len(lobby.connection_manager.active_connections) >= lobby.lobby.nb_player_max:
                    await websocket.send_json({"error": "Lobby is full"})
                    await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
                    return

    # Send available tokens for selection when connected to the websocket
    await lobby.send_available_tokens(websocket)
    
    try:
        while True:
            data = await websocket.receive_json()
            print(f"Received data from user {user_id}: {data}")
            action = data.get("action")
            if action == "user_joined":
                user = await user_service.get_users(data.get("user_id"))
                selected_token = data.get('selected_token')
                await lobby.add_user(websocket, user, selected_token)
                players = [user.model_dump() for user in lobby.connection_manager.active_connections.values()]
                await lobby_service.update_lobby(
                    lobby_id, 
                    LobbyUpdateSchema(players=players)   
                )
            elif action == "start_game":
                await lobby_service.update_lobby(
                    lobby_id, 
                    LobbyUpdateSchema(is_active=False)   
                )
                await lobby.start_game(user_id)
            else:
                await lobby.game_handler.handle_event(websocket, data)
    except WebSocketDisconnect:
        await lobby.remove_user(websocket)
        players = [user.model_dump() for user in lobby.connection_manager.active_connections.values()]
        await lobby_service.update_lobby(
            lobby_id, 
            LobbyUpdateSchema(players=players)
        )
        if not lobby.connection_manager.active_connections:
            #await lobby_service.delete_lobby(lobby_id)
            #lobby_manager.remove_lobby(lobby_id)
            print("Lobby {lobby_id} destroed")
