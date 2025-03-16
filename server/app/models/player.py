from typing import List, TYPE_CHECKING
from pydantic import BaseModel, Field

if TYPE_CHECKING:
    from app.models.cells.cell import PropertyCell

class Player(BaseModel):
    id: int
    name: str
    money: int = 1500
    current_position: int = 0
    nb_turn_jail: int = 0
    nb_railway: int = 0
    nb_utility: int = 0
    timer_turn: int = 30
    properties: List["PropertyCell"] = Field(default_factory=list)

    def get_property(self, cell_id: int):
        for property in self.properties:
            if property.cell_id == cell_id:
                return property
        return None
        
        
    def move(self, steps: int) -> dict:
        self.current_position += steps
        if self.current_position >= 40:
            self.current_position %= 40
            self.money += 200  # bonus for passing through the start
        print(f"Player {self.id} moved to {self.current_position} position")
        return {
            "action": "move_player",
            "player_id": self.id,
            "current_position": self.current_position,
            "money": self.money
        }

    def pay(self, amount: int) -> bool:
        if self.money < amount:
            return False
        self.money -= amount
        return True

    def earn(self, amount: int) -> None:
        self.money += amount


    def buy_property(self, property: "PropertyCell") -> dict:
        if self.pay(property.price):
            property.cell_owner = self
            self.properties.append(property)
            return {
                "action": "buy_property",
                "player_id": self.id,
                "cell_id": property.cell_id,
                "price": property.price,
                "delivery": "broadcast"
            }
        return {"action": "error", "message": "Insufficient funds", "delivery": "personal"}
    
    def sell_property(self, cell_id: int) -> dict:
        for prop in self.properties:
            if prop.cell_id == cell_id:
                self.earn(prop.price)
                prop.cell_owner = None
                self.properties.remove(prop)
                return {
                    "action": "sell_property",
                    "player_id": self.id,
                    "cell_id": cell_id,
                    "price": prop.price
                }
        return {"action": "error", "message": "No such property owned"}
