from typing import Dict, Any, Callable, Tuple
from app.models.player import Player
from app.core.game_state import GameState
from app.core.game_logic import GameLogic
import logging

logger = logging.getLogger("GameManager")

class GameManager:
    def __init__(self, players: Dict[int, Player]):
        self.state = GameState(players)
        self.logic = GameLogic(self.state.players, self.state.board, self.state.current_turn)
        self.action_handlers: Dict[str, Callable[[int, dict], dict]] = {
            "roll_dice": self.handle_roll_dice,
            "dice_rolled": self.handle_dice_rolled,
            "move_player": self.handle_move_player,
            "end_turn": self.handle_end_turn,
            "cell_activate": self.handle_cell_activate,
            "accepted_offer": self.handle_accepted_offer,
            "sell_property": self.handle_sell_property,
            "buy_house" : self.handle_buy_house,
            "sell_house":self.handle_sell_house,
            "jail_decision": self.jail_decision,
        }

    def process_action(self, player_id: int, data: dict) -> dict:
        action = data.get("action")
        if action not in self.action_handlers:
            return {"action": "error", "message": "Unknown action", "delivery": "personal"}
        # for all actions we check whose turn it is
        if player_id != self.state.current_turn:
            return {"action": "error", "message": "Not your turn!", "delivery": "personal"}

        return self.action_handlers[action](player_id, data)

    def handle_roll_dice(self, player_id: int, data: dict) -> dict:
        test = data.get("test")
        result = self.logic.roll_dice(test)
        self.state.last_dice_roll["dice1"] = result["dice1"]
        self.state.last_dice_roll["dice2"] = result["dice2"]
        return result
    
    def handle_dice_rolled(self, player_id: int, data: dict) -> dict:
        context = data.get("for")
        player = self.state.players[player_id]
        dice1 = self.state.last_dice_roll["dice1"]
        dice2 = self.state.last_dice_roll["dice2"]
        
        if context == "move":
            if player.nb_turn_jail > 0 and (dice1 != dice2 or dice1 + dice2 > 0):
                return {"action": "error", "message": "You are in jail", "delivery": "personal"}
            return self.logic.move_player(player_id, self.state.last_dice_roll["dice1"] + self.state.last_dice_roll["dice2"])
        elif context == "utility_rent":
            return self.logic.pay_utility_rent(player_id, self.state.last_dice_roll["dice1"] + self.state.last_dice_roll["dice2"])
        elif context == "get_out_of_jail":
            return self.logic.get_out_of_jail(player_id, dice1, dice2)
        
        
    def handle_move_player(self, player_id: int, data: dict) -> dict:
        steps = data.get("steps", 0)
        return self.logic.move_player(player_id, steps)

    def handle_end_turn(self, player_id: int, data: dict) -> dict:
        state = self.state
        state.current_dice_context = state.dice_context[0]
        state.last_dice_roll = {"dice1": 0, "dice2": 0}
        
        new_turn = self.logic.next_turn()
        self.state.current_turn = new_turn
        self.logic.current_turn_player_id = new_turn
        player = self.state.players[new_turn]
        if player.nb_turn_jail > 0:
            player.nb_turn_jail -= 1
        return {"action": "change_turn", "player_id": new_turn, "nb_turn_jail": player.nb_turn_jail,"delivery": "broadcast"}

    def handle_cell_activate(self, player_id: int, data: dict) -> dict:
        return self.logic.cell_action(player_id)

    def handle_accepted_offer(self, player_id: int, data: dict) -> dict:
        return self.logic.buy_property(player_id)

    def handle_sell_property(self, player_id: int, data: dict) -> dict:
        cell_id = data.get("cell_id")
        return self.logic.sell_property(player_id, cell_id)
    
    def handle_buy_house(self, player_id: int, data: dict) ->dict:
        cell = data.get("cell_id")
        return self.logic.buy_house(player_id=player_id, cell_id=cell)
    
    def handle_sell_house(self, player_id: int, data: dict) ->dict:
        cell = data.get("cell_id")
        return self.logic.sell_house(player_id=player_id, cell_id=cell)
    
    def jail_decision(self, player_id: int, data: dict) -> dict:
        decision = data.get("accepted")
        # player = self.players[player_id]
        # if decision:
        #     player.nb_turn_jail = 0
            
        return self.logic.jail_decision(player_id, decision)