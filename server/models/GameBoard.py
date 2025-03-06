import json
from pydantic import BaseModel, Field
from models.Cells import Cell, PropertyCell  # Импортируем классы ячеек

class GameBoard(BaseModel):
    """Класс игрового поля. Загружает данные из JSON и хранит ячейки."""
    cells: list[Cell] = Field(default_factory=list)  # Гарантируем, что cells всегда список

    def __init__(self, **data):
        """Инициализация поля: загружает JSON и создаёт ячейки."""
        super().__init__(**data)  # Обязательно вызвать super() для корректной работы Pydantic
        self.load_board_from_json("data/data.json")

    def load_board_from_json(self, file_path):
        """Загружает игровое поле из JSON и создаёт объекты ячеек."""
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                data = json.load(file)
        except FileNotFoundError:
            print(f"⚠ Ошибка: файл {file_path} не найден")
            return
        except json.JSONDecodeError:
            print(f"⚠ Ошибка: файл {file_path} содержит некорректный JSON")
            return

        for index, cell_data in enumerate(data):
            cell_name = cell_data["name"]
            cell_type = cell_data["type"]

            if "cost" in cell_data:  # Если есть цена, значит это собственность
                property_cell = PropertyCell(
                    cell_id=index,
                    cell_name=cell_name,
                    price=cell_data["cost"],
                    rent=cell_data["rent"]
                )
                self.cells.append(property_cell)
            else:
                self.cells.append(Cell(cell_id=index, cell_name=cell_name))

    def get_cell(self, cell_id: int):
        """Возвращает ячейку по её ID."""
        if 0 <= cell_id < len(self.cells):
            return self.cells[cell_id]
        return None

    def display_board(self):
        """Выводит игровое поле в консоль."""
        for cell in self.cells:
            cell_type = type(cell).__name__
            print(f"ID: {cell.cell_id}, Name: {cell.cell_name}, Type: {cell_type}")
