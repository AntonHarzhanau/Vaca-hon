import random
import json

class GameLogic:
    
    def roll_dice(self):
        return json.dumps({
            "action" : "roll_dice",
            "dice1" : random.randint(1, 6), 
            "dice2" : random.randint(1, 6)
            })