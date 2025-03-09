from pydantic import BaseModel, Field
from models.Player import Player

class Cell(BaseModel):
    cell_id: int
    cell_name: str
    
    def activate(self, player: Player):
        return {
            "action": "nothing",
            "message": f"Player {player.id} stopped at {self.cell_name}"
        }

class PropertyCell(Cell):
    price: int
    rent: int
    cell_owner: Player = None

    def activate(self, player: Player):
        if self.cell_owner is None:
            return {
                "action": "offer_to_buy",
                "cell_id": self.cell_id,
                "cell_name": self.cell_name,
                "price": self.price
            }
        elif self.cell_owner != player:
            return self.pay_rent(player)
        return {"action": "nothing"}

    def buy_property(self, player: Player):      
        if player.pay(self.price):
            self.cell_owner = player
            player.properties.append(self)
            return {
                "action": "buy_property",
                "player_id": player.id,
                "cell_id": self.cell_id,
                "price": self.price
            }

    def pay_rent(self, player: Player):
        if player.pay(self.rent):
            self.cell_owner.earn(self.rent)
            return {
                "action": "pay_rent",
                "player_id": player.id,
                "cell_owner_id": self.cell_owner.id,
                "rent": self.rent
            }
        else:
            self.cell_owner.earn(player.money)
            player.money = 0
            # TODO: Implement bankruptcy mechanics
            return {
                "action": "bankrupt",
                "player_id": player.id,
                "cell_owner_id": self.cell_owner.id,
                "rent": self.rent
            }
