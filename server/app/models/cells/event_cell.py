from app.models.cells.cell import Cell
from app.models.player import Player

class EventCell(Cell):
    """EventCell class represents a cell on the board that triggers an event."""
    description: str
    event_type: str  # e.g., "chance", "community_chest"
    def activate(self, player: Player) -> dict:
        if self.event_type == "chance":
            return self.chance_event(player)
        elif self.event_type == "community_chest":
            return self.community_chest_event(player)
        elif self.event_type == "income_tax":
            return self.income_tax_event(player)
        elif self.event_type == "luxury_tax":
            return self.luxury_tax_event(player)
        else:
            return super().activate(player)

    def chance_event(self, player: Player) -> dict:
        """Triggers a chance event."""
        return {
            "action": "chance_event",
            "player_id": player.id,
            "event_description": self.description,
            "delivery": "broadcast"
        }

    def community_chest_event(self, player: Player) -> dict:
        """Triggers a community chest event."""
        return {
            "action": "chance_event",
            "player_id": player.id,
            "event_description": self.description,
            "delivery": "broadcast"
        }
        
    def income_tax_event(self, player: Player) -> dict:
        """Triggers an income tax event."""
        player.pay(200)
        return {
            "action": "pay",
            "player_id": player.id,
            "amount": 200,
            "delivery": "broadcast"
        }
    def luxury_tax_event(self, player: Player) -> dict:
        """Triggers a luxury tax event."""
        player.earn(100)
        return {
            "action": "earn",
            "player_id": player.id,
            "amount": 100,
            "delivery": "broadcast"
        }