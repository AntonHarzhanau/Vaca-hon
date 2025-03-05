
class Cell:
    """Базовый класс для всех ячеек."""
    def __init__(self, cell_id: int, cell_name: str):
        self.cell_id = cell_id
        self.cell_name = cell_name

    def activate(self, player):
        """Метод, который будет переопределяться в дочерних классах."""
        return self.cell_name

class PropertyCell(Cell):
    """Класс для ячеек собственности."""
    def __init__(self, cell_id: int, cell_name: str, price: int, rent: list[int]):
        super().__init__(cell_id, cell_name)
        self.price = price
        self.rent = rent
        self.cell_owner = None  # Владелец ячейки, пока None

    def activate(self, player):
        if self.cell_owner is None:
            self.buy_property(player)
            return f"{player} купил {self.cell_name}"

    def buy_property(self, player):
        """Метод для покупки собственности игроком."""
        if self.cell_owner is None:
            self.cell_owner = player
            if player.money >= self.price:
                player.money -= self.price
            print(f"🏠 {player} купил {self.cell_name} за {self.price}")
        else:
            player.money -= self.rent
            self.cell_owner.money += self.rent
            print(f"⚠ {self.cell_name} уже куплена игроком {self.cell_owner}")
