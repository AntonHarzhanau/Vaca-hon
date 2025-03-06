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
        print(f"Игрок {self.id} передвинулся на {self.current_position} позицию")
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

    def sell_property(self, cell_id: int) -> None:
        for property in self.properties:
            if property.cell_id == cell_id:
                self.earn(property.price)
                property.cell_owner = None
                return {"action": "sell_property", "player_id": self.id, "cell_id": cell_id, "price": property.price}