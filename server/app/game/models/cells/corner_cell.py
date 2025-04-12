from app.game.models.cells.cell import Cell
from app.game.models.player import Player

class CornerCell(Cell):
    
    event_type: str
    
    def activate(self, player: Player) -> None:
        """
        Activate the corner cell. This method should be overridden by subclasses.
        """
        if self.event_type == "go_to_jail":
            return self.go_to_jail(player)
        else:
            return super().activate(player)
    
    
    def go_to_jail(self, player: Player) -> dict:
        """
        Send the player to jail.
        """
        player.current_position = 10
        player.nb_turn_jail = 3
        return {
            "action": "go_to_jail",
            "player_id": player.id,
            "delivery": "broadcast",
            
        }
        