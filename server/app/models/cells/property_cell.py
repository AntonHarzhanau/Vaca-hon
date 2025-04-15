from app.models.cells.cell import Cell
from app.models.player import Player
from typing import Optional

class PropertyCell(Cell):
    price: int
    initial_rent: int
    current_rent: int
    cell_owner: Optional[Player] = None

    def activate(self, player: Player) -> dict:
        if self.cell_owner is None:
            return {
                "action": "offer_to_buy",
                "cell_id": self.cell_id,
                "cell_name": self.cell_name,
                "price": self.price,
                "delivery": "personal"
            }
        elif self.cell_owner != player:
            return self.pay_rent(player)
        return {"action": "nothing", "delivery": "broadcast"}

    def pay_rent(self, player: Player) -> dict:
        if player.pay(self.current_rent):
            self.cell_owner.earn(self.current_rent)
            return {
                "action": "pay_rent",
                "player_id": player.id,
                "cell_owner_id": self.cell_owner.id,
                "rent": self.current_rent,
                "delivery": "broadcast"
            }
        else:
            self.cell_owner.earn(player.money)
            player.money = 0
            return {
                "action": "bankrupt",
                "player_id": player.id,
                "cell_owner_id": self.cell_owner.id,
                "rent": self.current_rent,
                "delivery": "broadcast"
            }
