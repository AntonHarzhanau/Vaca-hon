from typing import Dict
from app.models.player import Player
from app.models.game_board import GameBoard

class GameState:
    """
    Хранит состояние игры: список игроков, игровое поле и текущий ход.
    """
    def __init__(self, players: Dict[int, Player]):
        self.players = players
        self.board = GameBoard()
        # Изначально ход первого игрока (id = 0)
        self.current_turn: int = 0
