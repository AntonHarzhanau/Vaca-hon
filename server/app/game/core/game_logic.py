import random
from typing import Dict, TYPE_CHECKING


if TYPE_CHECKING:
    from app.game.models.player import Player
    from app.game.models.game_board import GameBoard
    from app.game.core.game_state import GameState
    from app.game.models.cells.property_cell import PropertyCell
    from app.game.models.cells.street_cell import StreetCell
    from app.game.models.cells.utility_cell import UtilityCell

class GameLogic:
    def __init__(self, state: "GameState"):
        self.state = state

    def roll_dice(self, test) -> dict:
        dice1 = random.randint(1, 6)
        dice2 = random.randint(1, 6)
        if test:
            dice2 = dice1
        return {
            "action": "roll_dice",
            "dice1": dice1,
            "dice2": dice2,
        }

    def next_turn(self) -> int:
        if not self.state.players:
            return 0
        player_ids = sorted(self.state.players.keys())
        if self.state.current_turn_player_id not in player_ids:
            self.state.current_turn_player_id = player_ids[0]
            
            return self.state.current_turn_player_id

        current_index = player_ids.index(self.state.current_turn_player_id)
        next_index = (current_index + 1) % len(player_ids)
        self.state.current_turn_player_id = player_ids[next_index]
        return self.state.current_turn_player_id

    def move_player(self, player_id: int, steps: int) -> dict:
        player = self.state.players[player_id]
        if player.nb_turn_jail > 0:
            return {"action": "error", "message": "You are in jail", "delivery": "personal"}
        move_data = player.move(steps, with_prime=True)
        return move_data

    def cell_action(self, player_id: int) -> dict:
        player = self.state.players[player_id]
        current_cell_id = player.current_position
        cell = self.state.board.get_cell(current_cell_id)
            
        if cell:
            return cell.activate(player, self.state)
     
        return {"action": "error", "message": "Cell not found"}

    def buy_property(self, player_id: int) -> dict:
        player = self.state.players[player_id]
        cell: "PropertyCell" = self.state.board.get_cell(player.current_position) 
        return cell.buy_property(player) if cell else {"action": "error", "message": "Cell not found"}

    def sell_property(self, player_id: int, cell_id: int) -> dict:
        house_counter: int = 0
        cell: "PropertyCell" = self.state.board.get_cell(cell_id)
        player = self.state.players[player_id]
        if type(cell).__name__ == "StreetCell" and cell.has_monopoly(self.state.board):
            for street in player.properties:
                if type(street).__name__ == "StreetCell" and street.group_color == cell.group_color:
                    house_counter += street.nb_houses
        if house_counter > 0:
            return {"action": "error", "message": "First, sell all the houses in your monopoly."}
        return cell.sell_property(player)
    
    def buy_house(self, player_id: int, cell_id: int):
        player = self.state.players[player_id]
        cell = player.get_property(cell_id)
        
        if cell:
            return cell.buy_house(self.state.board)
        else:
            return {"action": "error", "message": "Cell not found"}
        

    def sell_house(self, player_id: int, cell_id: int):
        player = self.state.players[player_id]
        cell: "StreetCell" = player.get_property(cell_id)
        
        if cell:
            return cell.sell_house(self.state.board)
        else:
            return {"action": "error", "message": "Cell not found"}
    
    def pay_utility_rent(self, player_id: int, dice_result: int) -> dict:
        player = self.state.players[player_id]
        cell: "UtilityCell" = self.state.board.get_cell(player.current_position)
        if cell:
            return cell.calculate_rent(player, dice_result)
        return {"action": "error", "message": "Cell not found"}
    
    def jail_decision(self, player_id: int, decistion: bool) -> dict:
        player = self.state.players[player_id]
        if decistion:
            player.nb_turn_jail = 0
            player.pay(50)
            return {"action": "get_out_jail", "money": 50, "delivery": "personal"}
        else:
            return {"action": "jail_decision", "message": "You are still in jail", "delivery": "personal"}
    
    def get_out_of_jail(self, player_id, dice1, dice2):
        if dice1 == dice2:
            player = self.state.players[player_id]
            player.nb_turn_jail = 0
            return {"action": "get_out_jail", "money": 0, "delivery": "personal"}
        else:
            return {"action": "jail_decision", "message": "You are still in jail", "delivery": "personal"}
        
    def accept_fly(self, player_id: int, cell_id: int) -> dict:
        player = self.state.players[player_id]
        cell = self.state.board.get_cell(cell_id)
        if cell:
            player.move(10, with_prime=False)
            return {
                "action": "fly_to_airport",
                "player_id": player.id,
                "cell_id": cell.cell_id,
                "delivery": "broadcast"
            }
        return {"action": "error", "message": "Cell not found"}