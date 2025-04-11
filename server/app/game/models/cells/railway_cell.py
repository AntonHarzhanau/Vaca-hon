from app.game.models.cells.property_cell import PropertyCell
from app.game.models.player import Player

class RailWayCell(PropertyCell):
    def buy_property(self, player):
        player.nb_railway += 1
        self.current_rent = self.initial_rent * player.nb_railway
        result = super().buy_property(player)
        for railway in player.properties:
            if isinstance(railway, RailWayCell):
                railway.current_rent = railway.initial_rent * player.nb_railway
        return result
    
    def sell_property(self, player):
        player.nb_railway -= 1
        self.current_rent = self.initial_rent * player.nb_railway
        result = super().sell_property(player)
        for railway in player.properties:
            if isinstance(railway, RailWayCell):
                railway.current_rent = railway.initial_rent * player.nb_railway
        return result
    
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