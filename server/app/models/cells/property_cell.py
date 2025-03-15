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
            # Предложение покупки видно только активному игроку
            return {
                "action": "offer_to_buy",
                "cell_id": self.cell_id,
                "cell_name": self.cell_name,
                "price": self.price,
                "delivery": "personal"
            }
        elif self.cell_owner != player:
            # При оплате аренды все игроки видят сообщение
            return self.pay_rent(player)
        return {"action": "nothing", "delivery": "broadcast"}

    def buy_property(self, player: Player) -> dict:
        if player.pay(self.price):
            self.cell_owner = player
            player.properties.append(self)
            return {
                "action": "buy_property",
                "player_id": player.id,
                "cell_id": self.cell_id,
                "price": self.price,
                "delivery": "broadcast"
            }
        return {"action": "error", "message": "Insufficient funds", "delivery": "personal"}

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
