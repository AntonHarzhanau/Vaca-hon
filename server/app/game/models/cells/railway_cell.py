from app.game.models.cells.property_cell import PropertyCell
from app.game.models.player import Player

class RailWayCell(PropertyCell):
    
    def activate(self, player, state):
        if self.cell_owner == player:
            board = state.board.cells
            size = len(board)
            start = player.current_position
            next_airoport = None
            for i in range(1, size):
                idx = (start + i) % size
                cell = board[idx]
                if type(cell).__name__ == "RailWayCell":
                    next_airoport = cell
                    print("here")
                    if next_airoport is None:
                        return {
                            "action": "error",
                            "message": "No airoport found",
                            "delivery": "personal"
                        }
                    else:
                        return {
                            "action": "offer_airplane",
                            "cell_id": next_airoport.cell_id,
                            "message": f"Do you want to fly to: {next_airoport.cell_name}?",
                            "delivery": "personal"
                        }
        return super().activate(player, state)
    
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