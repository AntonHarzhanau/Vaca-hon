import random
from models.Player import Player
from models.GameBoard import GameBoard

class GameLogic:
    def __init__(self, players: dict[int, Player]):
        # Reference to the shared dictionary of players
        self.players = players  
        self.board = GameBoard()
        # ID of the current player (starting from 0, but be careful if there are no players)
        self.current_turn_player_id = 0

    def roll_dice(self):
        return {
            "action": "roll_dice",
            "dice1": random.randint(1, 6),
            "dice2": random.randint(1, 6)
        }

    def move_player(self, player_id: int, steps: int):
        player = self.players[player_id]
        move_data = player.move(steps)
        # Return a JSON-like dictionary
        return move_data

    def cell_action(self, player_id: int):
        player = self.players[player_id]
        current_cell_id = player.current_position
        cell = self.board.get_cell(current_cell_id)
        if cell:
            return cell.activate(player)
        return {"action": "error", "message": "Cell not found"}

    def buy_property(self, player_id: int):
        player = self.players[player_id]
        cell = self.board.get_cell(player.current_position)
        if cell and hasattr(cell, "buy_property"):
            return cell.buy_property(player)
        return {"action": "error", "message": "This cell is not a property"}

    def sell_property(self, player_id: int, cell_id: int):
        player = self.players[player_id]
        return player.sell_property(cell_id)

    def next_turn(self):
        """
        Moves the turn to the next player.
        For simplicity, we assume that players are taken in ascending order of ID 
        and the turn cycles in a loop.
        """
        if not self.players:
            return 0  # or an error
        
        player_ids = sorted(self.players.keys())
        if self.current_turn_player_id not in player_ids:
            # If a player was removed, set the first one
            self.current_turn_player_id = player_ids[0]
            return self.current_turn_player_id

        current_index = player_ids.index(self.current_turn_player_id)
        next_index = (current_index + 1) % len(player_ids)
        self.current_turn_player_id = player_ids[next_index]
        return self.current_turn_player_id
