from typing import TYPE_CHECKING, Literal
from app.game.models.cards.card import EventCard

if TYPE_CHECKING:
    from app.game.models.player import Player
    from app.game.core.game_state import GameState

class MoveTo(EventCard):
    effect_type:Literal["move_to"]
    target:str
    steps: int = 0
    money_bonus:int
    
    def activate(self, player: "Player", state:"GameState"):
        for i in state.board.cells:
            if self.target == i.cell_name: 
                current_position = player.current_position
                board_size = len(state.board.cells)
                self.steps = (i.cell_id - current_position) % board_size
                player.move(self.steps)
                break
        return super().activate(player)
    
class MoveToNearCell(EventCard):
    effect_type:Literal["move_to_nearest"]
    steps:int = 0
    prime:bool = False
    target:str
    # activate: bool = True
    def activate(self, player: "Player", state:"GameState"):
        start_position = player.current_position
        for i in state.board.cells[start_position:]:
            if self.target == type(i).__name__:
                current_position = player.current_position
                board_size = len(state.board.cells)
                self.steps = (i.cell_id - current_position) % board_size
                res = player.move(self.steps)
                self.prime = res.get("prime", False)
                break
        return super().activate(player)
    
class MoveAndGain(EventCard):
    effect_type:Literal["move_and_gain"]
    target:str
    steps:int = 0
    amount:int
    
    def activate(self, player: "Player", state:"GameState"):
        player.earn(self.amount)
        return super().activate(player)

class MoveSteps(EventCard):
    effect_type:Literal["move_steps"]
    steps:int
    
    def activate(self, player: "Player", state:"GameState"):
        player.move(self.steps)
        return super().activate(player)