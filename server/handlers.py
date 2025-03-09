import json
from fastapi import WebSocket
from game_logic import GameLogic
from connection_manager import ConnectionManager

class GameHandler:
    def __init__(self, game_logic: GameLogic, manager: ConnectionManager):
        self.game_logic = game_logic
        self.manager = manager

    async def handle_event(self, websocket: WebSocket, data: dict):
        """Parses the action and calls the appropriate game_logic methods."""
        player_id = self.manager.active_connections[websocket]
        action = data.get("action")

        if action == "roll_dice":
            # Check if it's the player's turn
            if player_id == self.game_logic.current_turn_player_id:
                response = self.game_logic.roll_dice()
                # Broadcast to all players
                await self.manager.broadcast(json.dumps(response))
            else:
                # Not this player's turn
                await self.manager.send_personal_message(
                    json.dumps({"action": "error", "message": "Not your turn!"}),
                    websocket
                )

        elif action == "move_player":
            if player_id == self.game_logic.current_turn_player_id:
                steps = data.get("steps", 0)
                response = self.game_logic.move_player(player_id, steps)
                await self.manager.broadcast(json.dumps(response))
            else:
                await self.manager.send_personal_message(
                    json.dumps({"action": "error", "message": "Not your turn!"}),
                    websocket
                )

        elif action == "end_turn":
            if player_id == self.game_logic.current_turn_player_id:
                new_turn_player_id = self.game_logic.next_turn()
                await self.manager.broadcast(json.dumps({
                    "action": "change_turn",
                    "player_id": new_turn_player_id
                }))
            else:
                await self.manager.send_personal_message(
                    json.dumps({"action": "error", "message": "Not your turn!"}),
                    websocket
                )

        elif action == "cell_activate":
            if player_id == self.game_logic.current_turn_player_id:
                response = self.game_logic.cell_action(player_id)
                # In this example, you were sending only to the player who activates
                await self.manager.send_personal_message(
                    json.dumps(response),
                    websocket
                )
            else:
                await self.manager.send_personal_message(
                    json.dumps({"action": "error", "message": "Not your turn!"}),
                    websocket
                )

        elif action == "accepted_offer":
            if player_id == self.game_logic.current_turn_player_id:
                response = self.game_logic.buy_property(player_id)
                await self.manager.broadcast(json.dumps(response))
            else:
                await self.manager.send_personal_message(
                    json.dumps({"action": "error", "message": "Not your turn!"}),
                    websocket
                )

        elif action == "sell_property":
            # Selling is not necessarily restricted to the player's turn,
            # but for this example, let's enforce turn checking.
            if player_id == self.game_logic.current_turn_player_id:
                cell_id = data.get("cell_id")
                response = self.game_logic.sell_property(player_id, cell_id)
                await self.manager.broadcast(json.dumps(response))
            else:
                await self.manager.send_personal_message(
                    json.dumps({"action": "error", "message": "Not your turn!"}),
                    websocket
                )

        else:
            # Unknown action
            await self.manager.send_personal_message(
                json.dumps({"action": "error", "message": "Unknown action"}),
                websocket
            )
