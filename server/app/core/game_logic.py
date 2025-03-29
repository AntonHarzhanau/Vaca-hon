import random
from typing import Dict
from app.models.player import Player
from app.models.game_board import GameBoard

class GameLogic:
    def __init__(self, players: Dict[int, Player], board: GameBoard, current_turn: int):
        self.players = players
        self.board = board
        self.current_turn_player_id = current_turn

    def roll_dice(self) -> dict:
        dice1 = random.randint(1, 6)
        dice2 = random.randint(1, 6)
        return {
            "action": "roll_dice",
            "dice1": dice1,
            "dice2": dice2,
        }

    def next_turn(self) -> int:
        if not self.players:
            return 0
        player_ids = sorted(self.players.keys())
        if self.current_turn_player_id not in player_ids:
            self.current_turn_player_id = player_ids[0]
            return self.current_turn_player_id

        current_index = player_ids.index(self.current_turn_player_id)
        next_index = (current_index + 1) % len(player_ids)
        self.current_turn_player_id = player_ids[next_index]
        return self.current_turn_player_id

    def move_player(self, player_id: int, steps: int) -> dict:
        player = self.players[player_id]
        move_data = player.move(steps)
        return move_data

    def cell_action(self, player_id: int) -> dict:
        player = self.players[player_id]
        current_cell_id = player.current_position
        return self.board.cells[current_cell_id].activate(player)

    def buy_property(self, player_id: int) -> dict:
        player = self.players[player_id]
        cell = self.board.get_cell(player.current_position) 
        return cell.buy_property(player)
   

    def sell_property(self, player_id: int, cell_id: int) -> dict:
        house_counter: int = 0
        cell = self.board.cells[cell_id]
        player = cell.cell_owner
        if type(cell).__name__ == "StreetCell" and cell.has_monopoly(self.board):
            for street in player.properties:
                if type(street).__name__ == "StreetCell" and street.group_color == cell.group_color:
                    house_counter += street.nb_houses
        if house_counter > 0:
            return {"action": "error", "message": "First, sell all the houses in your monopoly."}
        return cell.sell_property(player)
    
    def buy_house(self, player_id: int, cell_id: int):
        player = self.players[player_id]
        cell = player.get_property(cell_id)
        
        if cell:
            return cell.buy_house(self.board)
        else:
            return {"action": "error", "message": "Cell not found"}
        

    def sell_house(self, player_id: int, cell_id: int):
        player = self.players[player_id]
        cell = player.get_property(cell_id)
        
        if cell:
            return cell.sell_house(self.board)
        else:
            return {"action": "error", "message": "Cell not found"}