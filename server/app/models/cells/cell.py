from typing import Optional
from pydantic import BaseModel
from app.models.player import Player

class Cell(BaseModel):
    cell_id: int
    cell_name: str

    def activate(self, player: Player) -> dict:
        """Activates the cell and returns the default message."""
        return {
            "action": "nothing",
            "message": f"Player {player.id} stopped at {self.cell_name}"
        }

