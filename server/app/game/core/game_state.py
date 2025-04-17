from typing import Dict, TYPE_CHECKING
from app.game.models.game_board import GameBoard

if TYPE_CHECKING:
    from app.game.models.player import Player
    

class GameState:
    """
    Stores the state of the game: the list of players, the playing field, and the current move.
    """
    def __init__(self, players: Dict[int, "Player"]):
        self.players = players
        self.board = GameBoard()
        self.current_turn_player_id: int = 0
        self.last_dice_roll: Dict = {"dice1": 0, "dice2": 0}
        self.dice_context = ["move", "utility_rent", "property_rent", "go_to_jail"]
        self.current_dice_context = self.dice_context[0]