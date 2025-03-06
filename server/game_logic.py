import random
from models.Player import Player
from models.GameBoard import GameBoard


class GameLogic:
    def __init__(self, players):

        self.players : list[Player] = players
        self.board = GameBoard()
        # self.board.display_board()

    def roll_dice(self):
        return({
            "action" : "roll_dice",
            "dice1" : random.randint(1, 6), 
            "dice2" : random.randint(1, 6)
            })
    
    def move_player(self, player_id, steps):
        player = self.players[player_id]
        player.move(steps)
        return {"action": "move_player", "player_id": player.id, "current_position": steps}
    
    def cell_action(self, player_id):
        player = self.players[player_id]
        cell = self.board.cells[player.current_position]
        message = cell.activate(player)
        return  message
    def buy_property(self, player_id):
        player = self.players[player_id]
        cell = self.board.cells[player.current_position]
        return cell.buy_property(player)
    def sell_property(self, player_id, cell_id):
        player = self.players[player_id]
        return player.sell_property(cell_id)