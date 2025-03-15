from typing import Dict
from app.models.player import Player
from app.models.game_board import GameBoard

class GameState:
    """
    Stores the state of the game: the list of players, the playing field, and the current move.
    """
    def __init__(self, players: Dict[int, Player]):
        self.players = players
        self.board = GameBoard()
        # Initially it's the first player's turn (id = 0)
        self.current_turn: int = 0
