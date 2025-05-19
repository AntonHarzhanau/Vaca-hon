from typing import Optional
from pydantic import BaseModel
from typing import TYPE_CHECKING
from app.game.models.player import Player


if TYPE_CHECKING:
    from app.game.core.game_state import GameState
    
class Cell(BaseModel):
    cell_id: int
    cell_name: str

    def activate(self, player: Player, state: "GameState"= None) -> dict:
        """Activates the cell and returns the default message."""
        return {
            "action": "nothing",
            "message": f"Player {player.id} stopped at {self.cell_name}"
        }

