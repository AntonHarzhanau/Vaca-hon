from typing import TYPE_CHECKING, Literal
from app.game.models.cards.card import EventCard

if TYPE_CHECKING:
    from app.game.models.player import Player
    from app.game.core.game_state import GameState

class GainMoney(EventCard):
    effect_type:Literal["gain_money"]
    amount:int
    
    def activate(self, player: "Player", state:"GameState"):
        player.earn(self.amount)
        return super().activate(player)

class PayFine(EventCard):
    effect_type:Literal["pay_fine"]
    amount:int
    
    def activate(self, player: "Player",state:"GameState"):
        player.pay(self.amount)
        return super().activate(player)
    
class GainMoneyFromAll(GainMoney):
    effect_type:Literal['gain_from_all']
    
    def activate(self, player, state):
        for p in state.players.values():
            if p != player:
                p.pay(self.amount)
                player.earn(self.amount)
        return super().activate(player, state)
    
class PayFineToAll(PayFine):
    effect_type:Literal['pay_all']
    
    def activate(self, player, state):
        for p in state.players.values():
            if p != player:
                p.pay(self.amount)
        return super().activate(player, state)
    
class PropertyRepair(EventCard):
    effect_type:Literal['property_repair']
    house_cost:int
    
    def activate(self, player, state):
        total = 0
        for cell in player.properties:
            if type(cell).__name__ == "StreetCell":
                total += self.house_cost * cell.nb_houses
        player.pay(total)
        return super().activate(player)