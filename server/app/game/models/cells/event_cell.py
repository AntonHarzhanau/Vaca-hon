from app.game.models.cells.cell import Cell
from app.game.models.player import Player
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from app.game.core.game_state import GameState
    from app.game.models.cards.card import EventCard
    

class EventCell(Cell):
    """
    Represents an event cell on the game board.
    """
    description: str
    event_type: str  # "chance", "community_chest", "income_tax", "luxury_tax"

    def activate(self, player: Player, state: "GameState") -> dict:
        if self.event_type == "chance":
            return self.activate_chance_card(player, state)
        elif self.event_type == "community_chest":
            return self.activate_community_chest_card(player, state)
        elif self.event_type == "income_tax":
            return self.income_tax_event(player)
        elif self.event_type == "luxury_tax":
            return self.luxury_tax_event(player)
        elif self.event_type == "go_to_jail":
            return self.go_to_jail(player)
        else:
            return super().activate(player)

    def activate_chance_card(self, player: Player, state: "GameState") -> dict:
        card:"EventCard" = state.chance_deck.draw_card()
        return card.activate(player=player, state=state)

    def activate_community_chest_card(self, player: Player, state: "GameState") -> dict:
        card:"EventCard" = state.community_chest_deck.draw_card()
        return card.activate(player=player, state=state)


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


    def income_tax_event(self, player: Player) -> dict:
        player.pay(200)
        return {
            "action": "pay",
            "player_id": player.id,
            "amount": 200,
            "delivery": "broadcast"
        }

    def luxury_tax_event(self, player: Player) -> dict:
        player.pay(100)
        return {
            "action": "pay",
            "player_id": player.id,
            "amount": 100,
            "delivery": "broadcast"
        }
