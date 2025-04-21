from typing import List, TYPE_CHECKING
from pydantic import BaseModel, Field

if TYPE_CHECKING:
    from app.game.models.cells.property_cell import PropertyCell
    from app.game.models.cells.street_cell import StreetCell
    

class Player(BaseModel):
    id: int
    name: str
    money: int = 500
    current_position: int = 0
    nb_turn_jail: int = 0
    nb_railway: int = 0
    nb_utility: int = 0
    timer_turn: int = 30
    card_inventory: List[str] = Field(default_factory=list)
    properties: List["PropertyCell"] = Field(default_factory=list)
    selected_token: str = None

    def get_property(self, cell_id: int):
        for property in self.properties:
            if property.cell_id == cell_id:
                return property
        return None
        
        
    def move(self, steps: int) -> dict:
        old_position = self.current_position
        new_position = (self.current_position + steps) % 40

        prime = False
        if steps > 0 and new_position < old_position:
            self.money += 200  # bonus for passing through the start
            prime = True

        self.current_position = new_position

        print(f"Player {self.id} moved from {old_position} to {self.current_position} ({'+' if steps > 0 else ''}{steps} steps)")

        return {
            "action": "move_player",
            "player_id": self.id,
            "current_position": self.current_position,
            "steps": steps,
            "prime": prime
        }


    def pay(self, amount: int) -> bool:
        # if self.money < amount:
        #     return False
        self.money -= amount
        return True

    def earn(self, amount: int) -> None:
        self.money += amount

    def use_card(self):
        pass

    def capital(self):
        total = self.money
        for property in self.properties:
            if isinstance(property, StreetCell):
                total += property.nb_houses * property.house_cost
            total += property.price
        return total