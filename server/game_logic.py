import random
from models.Player import Player
from models.GameBoard import GameBoard  # Убедись, что путь правильный


class GameLogic:
    def __init__(self, players):

        self.players : list[Player] = players
        self.board = GameBoard()

    def move_player(self, player_id, steps):
        player = self.players[player_id]
        player.move(steps)
        action = self.board.cells[player.current_position].activate(player)
        print(player.money)
        return {"action": "move_player", "player_id": player.id, "current_position": steps, "money": player.money, "event": action}
    
    def roll_dice(self):
        return({
            "action" : "roll_dice",
            "dice1" : random.randint(1, 6), 
            "dice2" : random.randint(1, 6)
            })