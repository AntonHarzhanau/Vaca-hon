from typing import TYPE_CHECKING, Literal
from app.game.models.cards.card import EventCard

if TYPE_CHECKING:
    from app.game.models.player import Player
    from app.game.core.game_state import GameState

class GoToJail(EventCard):
    effect_type:Literal["go_to_jail"]
    
    delivery:Literal["personal"] = "personal"
    def activate(self, player: "Player", state:"GameState"):
        return super().activate(player)
    
class GetOutOfJail(EventCard):
    effect_type:Literal["get_out_of_jail"]
    
    delivery:Literal["personal"] = "personal"
    def activate(self, player: "Player", state:"GameState"):
        return super().activate(player)