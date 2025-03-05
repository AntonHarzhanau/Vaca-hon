from pydantic import BaseModel, Field
import json

class Player(BaseModel):
    id: int
    money: int = 1500
    current_position: int = 0
    nb_turn_jail: int = 0
    nb_railway: int = 0
    nb_utility: int = 0
    timer_turn: int = 30

    def move(self, steps: int):
        self.current_position += steps
        if self.current_position >= 40:
            self.current_position -= 40
            self.money += 200
        print(f"Игрок {self.id} передвинулся на {self.current_position} позицию")
        return json.dumps({
            "action": "move_player",
            "player_id": self.id,
            "current_position": steps,
            "money": self.money
            })
    