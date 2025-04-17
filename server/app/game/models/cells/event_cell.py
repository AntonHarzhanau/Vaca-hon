from app.game.models.cells.cell import Cell
from app.game.models.player import Player
from typing import TYPE_CHECKING
from app.game.models.cards.decks import community_chest_deck, chance_deck
if TYPE_CHECKING:
    from app.game.core.game_state import GameState
    from app.game.models.cards.card import EventCard
    

class EventCell(Cell):
    """Ячейка, запускающая событие"""
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
        card:"EventCard" = chance_deck.draw_card()
        return card.activate(player=player, state=state)

    def activate_community_chest_card(self, player: Player, state: "GameState") -> dict:
        card:"EventCard" = community_chest_deck.draw_card()
        return card.activate(player=player, state=state)



#     def gain_from_all(self, player: Player, players: list[Player], board: "GameBoard", amount: int) -> dict:
#         total = 0
#         for p in players.values():
#             if p != player:
#                 if p.pay(amount):
#                     total += amount   
#         player.earn(total)
#         return {
#             "payload": {"total_earned": total},
#             "delivery": "broadcast"
#         }

#     def pay_fine(self, player: Player, players: list[Player], board: "GameBoard", amount: int) -> dict:
#         player.pay(amount)
#         return {
#             "payload": {"amount": amount},
#             "delivery": "personal"
#         }

#     def pay_all(self, player: Player, players: list[Player], board: "GameBoard", amount: int) -> dict:
#         count = 0
#         for other in players.values():
#             if other != player:
#                 other.earn(amount)
#                 count += 1
#         player.pay(amount * count)
#         return {
#             "payload": {"amount_per_player": amount, "total": amount * count},
#             "delivery": "broadcast"
#         }

#     def get_out_of_jail(self, player: Player, players: list[Player], board: "GameBoard",) -> dict:
#         player.card_inventory.append("get_out_of_jail")
#         return {
#             "payload": {},
#             "delivery": "personal"
#         }

#     def move_to_nearest(
#     self,
#     player: Player,
#     players: list[Player],
#     board: "GameBoard",
#     target: str,
#     double_rent,
# ) -> dict:
#         start = player.current_position
#         cell_id = 0
#         for cell in board.cells[start:]:
#             if cell.cell_name == target:
#                 cell_id = cell.cell_id
#                 break
#         return player.move(cell_id - player.current_position)
#         # return {
#         #     "payload": {"target": target, "position": player.current_position},
#         #     "delivery": "broadcast"
#         # }

#     def move_to(self, player: Player, players: list[Player], board: "GameBoard", target_position: str, money_bonus: int = 0) -> dict:
#         #TODO
#         cell_id = 0
#         for cell in board.cells:
#             if cell.cell_name == target_position:
#                 cell_id == cell.cell_id
#                 break
#         # if money_bonus and target_position < player.current_position:
#         #     player.earn(money_bonus)
        
#         return player.move(cell_id)
#     # {
#     #         "payload": {"position": target_position, "bonus": money_bonus},
#     #         "delivery": "broadcast"
#     #     }

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
