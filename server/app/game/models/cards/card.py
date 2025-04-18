from pydantic import BaseModel
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from app.game.models.player import Player

class EventCard(BaseModel):
    action:str = "event"
    player_id: int = -1 
    effect_type: str
    description: str
    delivery: str = "broadcast"
    
    def activate(self, player: "Player", state=None) -> dict:
        self.player_id = player.id if player else -1
        return self.model_dump()