from typing import Dict, TYPE_CHECKING
from app.game.models.game_board import GameBoard
from app.game.models.cards.decks import CardDeck, load_json_cards

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
        self.dice_context = ["move","jail", "utility_rent", "event", "get_out_of_jail"]
        self.current_dice_context = self.dice_context[0]
        self.double_roll = False
        self.double_roll_count = 0
        
        # Initialize the decks of event cards
        self.chance_deck = CardDeck(load_json_cards("app/data/chance_cards.json"))
        self.community_chest_deck = CardDeck(load_json_cards("app/data/community_chest_cards.json"))