from __future__ import annotations
from typing import List, TYPE_CHECKING
from app.game.models.cells.property_cell import PropertyCell
from app.game.models.player import Player

if TYPE_CHECKING:
    from app.game.models.game_board import GameBoard



class StreetCell(PropertyCell):
    group_color: str
    nb_houses: int = 0
    house_cost: int = 0

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

    def has_monopoly(self, board: "GameBoard") -> bool:
        """
        Checks if the owner has collected all streets of the given group.
        """
        if self.cell_owner is None:
            return False
       
        group_cells: List[StreetCell] = board.groups.get(self.group_color, [])
        return all(cell.cell_owner == self.cell_owner for cell in group_cells)

    def can_build_evenly(self, board: "GameBoard") -> bool:
        """
        Allows construction if the given cell has the minimum number of houses in the group.
        """
        group_cells: List[StreetCell] = board.groups.get(self.group_color, [])
        if not group_cells:
            return False
        min_houses = min(cell.nb_houses for cell in group_cells)
        return self.nb_houses == min_houses

    def buy_house(self, board: "GameBoard") -> dict:
        """
        Trying to build a house on a cell.
        """
        if self.cell_owner is None:
            return {"action": "error", "message": "The property does not belong to the player"}
        if not self.has_monopoly(board):
            return {"action": "error", "message": "The monopoly is not assembled"}
        if not self.can_build_evenly(board):
            return {"action": "error", "message": "Houses should be built evenly"}
        if self.nb_houses >= 5:
            return {"action": "error", "message": "Maximum number of houses reached"}
        if not self.cell_owner.pay(self.house_cost):
            return {"action": "error", "message": "Not enough funds to build a house"}
        self.nb_houses += 1
        self.current_rent = self.initial_rent + self.nb_houses * self.house_cost
        return {
            "action": "buy_house",
            "player_id": self.cell_owner.id,
            "cell_id": self.cell_id,
            "number_of_house": self.nb_houses,
            "current_rent": self.current_rent,
            "delivery": "broadcast"
        }

    def can_sell_evenly(self, board: "GameBoard") -> bool:
        """
        Allows the sale of a house if the given cell has the maximum number of houses in the group.
        """
        group_cells: List[StreetCell] = board.groups.get(self.group_color, [])
        if not group_cells:
            return False
        max_houses = max(cell.nb_houses for cell in group_cells)
        return self.nb_houses == max_houses

    def sell_house(self, board: "GameBoard") -> dict:
        """
        Trying to sell a house on a cell.
        """
        if self.cell_owner is None:
            return {"action": "error", "message": "The property does not belong to the player"}
        if self.nb_houses == 0:
            return {"action": "error", "message": "No houses for sale"}
        if not self.can_sell_evenly(board):
            return {"action": "error", "message": "Houses should be sold evenly"}
        refund = self.house_cost #// 2
        self.cell_owner.earn(refund)
        self.nb_houses -= 1
        self.current_rent = self.initial_rent + self.nb_houses * self.house_cost
        return {
            "action": "sell_house",
            "player_id": self.cell_owner.id,
            "cell_id": self.cell_id,
            "number_of_house": self.nb_houses,
            "current_rent": self.current_rent,
            "delivery": "broadcast"
        }
