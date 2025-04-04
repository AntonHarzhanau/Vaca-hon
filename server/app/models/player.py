from typing import List, TYPE_CHECKING
from pydantic import BaseModel, Field


if TYPE_CHECKING:
    from app.models.cells.property_cell import PropertyCell
    from app.models.cells.street_cell import StreetCell

class Player(BaseModel):
    id: int
    name: str
    money: int = 500
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
        prime = False
        self.current_position += steps
        if self.current_position >= 40:
            self.current_position %= 40
            self.money += 200  # bonus for passing through the start
            prime = True
        print(f"Player {self.id} moved to {self.current_position} position")
        return {
            "action": "move_player",
            "player_id": self.id,
            "current_position": self.current_position,
            "prime": prime
        }

    def pay(self, amount: int) -> bool:
        # if self.money < amount:
        #     return False
        self.money -= amount
        return True

    def earn(self, amount: int) -> None:
        self.money += amount


    def capital(self):
        total = self.money
        for property in self.properties:
            if isinstance(property, StreetCell):
                total += property.nb_houses * property.house_cost
            total += property.price
        return total