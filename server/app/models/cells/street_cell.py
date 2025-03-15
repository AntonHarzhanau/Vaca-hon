from __future__ import annotations
from typing import List
from app.models.cells.property_cell import PropertyCell

class StreetCell(PropertyCell):
    group_color: str  # Можно использовать нужный тип для цвета, например, Color
    nb_houses: int = 0
    house_cost: int = 0

    def has_monopoly(self, board: "GameBoard") -> bool:
        """
        Проверяет, собрал ли владелец все улицы данной группы.
        """
        if self.cell_owner is None:
            return False
        # Получаем список ячеек из словаря групп, где ключ — group_color.
        group_cells: List[StreetCell] = board.groups.get(self.group_color, [])
        return all(cell.cell_owner == self.cell_owner for cell in group_cells)

    def can_build_evenly(self, board: "GameBoard") -> bool:
        """
        Разрешает строительство, если данная ячейка имеет минимальное число домов в группе.
        """
        group_cells: List[StreetCell] = board.groups.get(self.group_color, [])
        if not group_cells:
            return False
        min_houses = min(cell.nb_houses for cell in group_cells)
        return self.nb_houses == min_houses

    def buy_house(self, board: "GameBoard") -> dict:
        """
        Пытается построить дом на ячейке.
        """
        if self.cell_owner is None:
            return {"action": "error", "message": "Собтвенность не принадлежит игроку"}
        if not self.has_monopoly(board):
            return {"action": "error", "message": "Монополия не собрана"}
        if not self.can_build_evenly(board):
            return {"action": "error", "message": "Дома должны строиться равномерно"}
        if not self.cell_owner.pay(self.house_cost):
            return {"action": "error", "message": "Недостаточно средств для постройки дома"}
        self.nb_houses += 1
        curent_rent = self.initial_rent + self.nb_houses * self.house_cost
        return {
            "action": "build_house",
            "cell_id": self.cell_id,
            "new_house_count": self.nb_houses,
            "player_id": self.cell_owner.id
        }

    def can_sell_evenly(self, board: "GameBoard") -> bool:
        """
        Разрешает продажу дома, если данная ячейка имеет максимальное число домов в группе.
        """
        group_cells: List[StreetCell] = board.groups.get(self.group_color, [])
        if not group_cells:
            return False
        max_houses = max(cell.nb_houses for cell in group_cells)
        return self.nb_houses == max_houses

    def sell_house(self, board: "GameBoard") -> dict:
        """
        Пытается продать дом на ячейке.
        """
        if self.cell_owner is None:
            return {"action": "error", "message": "Собственность не принадлежит игроку"}
        if self.nb_houses == 0:
            return {"action": "error", "message": "Нет домов для продажи"}
        if not self.can_sell_evenly(board):
            return {"action": "error", "message": "Дома должны продаваться равномерно"}
        refund = self.house_cost #// 2
        self.cell_owner.earn(refund)
        self.nb_houses -= 1
        current_rent = self.initial_rent + self.nb_houses * self.house_cost
        return {
            "action": "sell_house",
            "cell_id": self.cell_id,
            "new_house_count": self.nb_houses,
            "player_id": self.cell_owner.id,
            "refund": refund
        }
