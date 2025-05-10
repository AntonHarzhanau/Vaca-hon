from typing import Dict, Callable, TYPE_CHECKING
from app.game.core.game_state import GameState
from app.game.core.game_logic import GameLogic
import logging

if TYPE_CHECKING:
    from app.game.models.player import Player

logger = logging.getLogger("GameManager")

class GameManager:
    def __init__(self, players: Dict[int, "Player"]):
        self.state = GameState(players)
        first_key = next(iter(players))
        self.state.current_turn_player_id = players[first_key].id
        self.logic = GameLogic(self.state)
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
        print(f"player_id {player_id}== current_turn {self.state.current_turn_player_id}")
        if action not in self.action_handlers:
            return {"action": "error", "message": "Unknown action", "delivery": "personal"}
        # for all actions we check whose turn it is
        if player_id != self.state.current_turn_player_id:
            return {"action": "error", "message": "Not your turn!", "delivery": "personal"}

        return self.action_handlers[action](player_id, data)

    def handle_roll_dice(self, player_id: int, data: dict) -> dict:
        test = data.get("test")
        result = self.logic.roll_dice(test)
        if result["dice1"] == result["dice2"]:
            self.state.double_roll = True
            self.state.double_roll_count += 1
            if self.state.double_roll_count >= 3:
                self.state.players[player_id].nb_turn_jail = 3
                return {"action": "go_to_jail", 
                        "player_id":player_id, 
                        "message": "You rolled three doubles in a row, go to jail!", 
                        "delivery": "broadcast"}
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
        if self.state.double_roll:
            self.state.double_roll = False
            return {"action": "double_roll", "message": "You rolled a double, you can roll again!", "delivery": "personal"} 
        self.state.current_dice_context = self.state.dice_context[0]
        self.state.last_dice_roll = {"dice1": 0, "dice2": 0}
        
        new_turn = self.logic.next_turn()
        self.state.current_turn_player_id = new_turn
        player = self.state.players[new_turn]
        
        if player.nb_turn_jail > 0:
            player.nb_turn_jail -= 1
            
        return {"action": "change_turn", "player_id": new_turn, "nb_turn_jail": player.nb_turn_jail, "delivery": "broadcast"}

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
        return self.logic.jail_decision(player_id, decision)