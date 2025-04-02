from app.models.cells.property_cell import PropertyCell
from app.models.player import Player

class UtilityCell(PropertyCell):
    amount: int = 0
    def activate(self, player):
        if self.cell_owner is None:
            return {
                "action": "offer_to_buy",
                "cell_id": self.cell_id,
                "cell_name": self.cell_name,
                "price": self.price,
                "current_rent": self.current_rent,
                "delivery": "personal"
            }
        elif self.cell_owner != player:
            return {
                "action": "utility_rent", 
                "player_id": player.id,
                "delivery": "personal"
                }
        return {
            "action": "nothing", 
            "delivery": "broadcast"
            }
    
    
    def buy_property(self, player):
        player.nb_utility += 1
        self.current_rent = self.initial_rent * player.nb_utility
        result = super().buy_property(player)
        for railway in player.properties:
            if isinstance(railway, UtilityCell):
                railway.current_rent = railway.initial_rent * player.nb_utility
        return result
    
    def sell_property(self, player):
        player.nb_utility -= 1
        self.current_rent = self.initial_rent * player.nb_utility
        result = super().sell_property(player)
        for railway in player.properties:
            if isinstance(railway, UtilityCell):
                railway.current_rent = railway.initial_rent * player.nb_utility
        return result
    
    def pay_rent(self, player: Player) -> dict:
        if player.pay(self.amount):
            self.cell_owner.earn(self.amount)
            return {
                "action": "pay_rent",
                "player_id": player.id,
                "cell_owner_id": self.cell_owner.id,
                "rent": self.amount,
                "delivery": "broadcast"
            }
            
    def calculate_rent(self, player: Player, dice_result: int) -> dict:
        # Calculate rent based on the number of utilities owned by the player and result of the dice roll
        self.amount = self.current_rent *  dice_result
        return self.pay_rent(player)
        