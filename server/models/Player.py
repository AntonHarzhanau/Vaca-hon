from pydantic import BaseModel, Field
from typing import List

class Player(BaseModel):
    id: int
    money: int = 1500
    current_position: int = 0
    nb_turn_jail: int = 0
    nb_railway: int = 0
    nb_utility: int = 0
    timer_turn: int = 30
    properties: List["PropertyCell"] = Field(default_factory=list)

    def move(self, steps: int) -> dict:
        self.current_position += steps
        if self.current_position >= 40:
            self.current_position -= 40
            self.money += 200
        print(f"Player {self.id} moved to {self.current_position} position")
        return {
            "action": "move_player",
            "player_id": self.id,
            "current_position": steps,
            "money": self.money
        }

    def pay(self, amount) -> bool:
        if (self.money - amount) < 0:
            return False
        self.money -= amount
        return True

    def earn(self, amount: int) -> None:
        self.money += amount

    def sell_property(self, cell_id: int):
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
