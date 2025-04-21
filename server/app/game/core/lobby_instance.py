import json
import asyncio
from typing import Dict
from fastapi import WebSocket
from app.schemas.lobby_schema import LobbyReadSchema
from app.schemas.user_schema import UserReadSchema, UserReadSchemaWithToken
from app.api.connection_manager import ConnectionManager
from app.game.core.game_manager import GameManager
from app.game.core.handlers import GameHandler
from app.game.models.player import Player
from app.game.core.game_state import GameState

class LobbyInstance:
    def __init__(self, lobby: LobbyReadSchema):
        self.lobby = lobby  # data from the DB (e.g. lobby.id, nb_player_max, is_active etc.)
        self.connection_manager = ConnectionManager()
        self.game_state : GameState | None = None
        self.game_manager: GameManager | None = None
        self.game_handler: GameHandler | None = None
        # TODO : Gel all available tokens from Database
        self.available_tokens = [
            "FLIGHT",
            "HELICOPTER",
            "SHIP",
            "WHALE"
        ]


    async def add_user(self, websocket: WebSocket, user: UserReadSchemaWithToken, selected_token: str) -> None:
        # for connected_user in self.connection_manager.active_connections.values():
        #     msg = {
        #         "action": "user_joined",
        #         "user_id": connected_user.id,
        #         "user_name": connected_user.username,
        #         "selected_token": connected_user.selected_token,
        #     }
        #     await self.connection_manager.send_personal_message(json.dumps(msg), websocket)

        # Add WebSocket to the list of users
        if await self.use_token(selected_token, user.id):
            user_with_token = UserReadSchemaWithToken(**user.dict())
            user_with_token.selected_token = selected_token
            await self.connection_manager.connect(websocket, user_with_token)
        else:
            msg = {
                "error": "Please select a valid token to start playing !",
            }
            await self.connection_manager.send_personal_message(json.dumps(msg), websocket)

        # Send a message to all lobby members
        await self.connection_manager.broadcast(json.dumps({
            "action": "user_joined",
            "user_id": user.id,
            "user_name": user.username,
            "selected_token": selected_token,
            "available_tokens": self.available_tokens,
            "players": [user.model_dump() for user in self.connection_manager.active_connections.values()]
        }))

    async def remove_user(self, websocket: WebSocket) -> None:
        if websocket in self.connection_manager.active_connections:
            user = await self.connection_manager.disconnect(websocket)
            # Make released token available again in the lobby
            self.available_tokens.append(user.selected_token)
            if self.game_manager:
                player = self.game_manager.state.players.pop(user.id)
                for property in player.properties:
                    if type(property).__name__ == "StreetCell":
                        property.current_rent = property.initial_rent
                        property.nb_houses = 0
                    property.cell_owner = None
                await self.connection_manager.broadcast(json.dumps({
                    "action": "player_disconnected",
                    "player_id": player.id,
                }))
                await asyncio.sleep(0.2)
            await self.connection_manager.broadcast(json.dumps({
                "action": "user_left",
                "user_id": user.id,
                "available_tokens": self.available_tokens,
                "players": [user.model_dump() for user in self.connection_manager.active_connections.values()]
            }))

    async def start_game(self, user_id:int) -> None:
        if user_id != self.lobby.owner_id:
            print(f"user {user_id} is not owner")
            return

        # Update the status in the database if required (for example, via LobbyService)???
        
        players: Dict[int, Player] = {}  # например, словарь: player_id -> Player

        for user in self.connection_manager.active_connections.values():
            # Create game entities based on user information (e.g. username, selected token, etc.)
            print(user)
            players[user.id] = Player(id=user.id, name=user.username, selected_token=user.selected_token)

        # Initialize the game state
        self.game_manager = GameManager(players)
        self.game_handler = GameHandler(self.game_manager, self.connection_manager)

        # We send everyone a message about the start of the game
        await self.connection_manager.broadcast(json.dumps({
            "action": "game_started",
        }))
        # the delay is needed so that the client has time to initialize the game
        # TODO: fix mechanics to not use delays
        await asyncio.sleep(0.5) 
        await self.connection_manager.broadcast(json.dumps({
            "action":"player_connected",
            "players": [player.model_dump() for player in players.values()]
        }))

    async def use_token(self, token_name: str, user_id: int) -> bool:
        if token_name in self.available_tokens:
            self.available_tokens.remove(token_name)
            return True
        else:
            return False

    async def send_available_tokens(self, websocket):
        await self.connection_manager.send_personal_message(message=json.dumps({
            "action": "get_available_tokens",
            "available_tokens": self.available_tokens
        }), websocket=websocket)