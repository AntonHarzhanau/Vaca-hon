import json
from pydantic import BaseModel, Field
from models.Cells import Cell, PropertyCell

class GameBoard(BaseModel):
    """Game board class. Loads data from JSON and stores cells."""
    cells: list[Cell] = Field(default_factory=list)

    def __init__(self, **data):
        """Board initialization: loads JSON and creates cells."""
        super().__init__(**data)
        self.load_board_from_json("data/data.json")

    def load_board_from_json(self, file_path):
        """Loads the game board from JSON and creates cell objects."""
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                data = json.load(file)
        except FileNotFoundError:
            print(f"⚠ Error: file {file_path} not found")
            return
        except json.JSONDecodeError:
            print(f"⚠ Error: file {file_path} contains invalid JSON")
            return

        for index, cell_data in enumerate(data):
            cell_name = cell_data["name"]
            if "cost" in cell_data:
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
        """Returns a cell by its ID."""
        if 0 <= cell_id < len(self.cells):
            return self.cells[cell_id]
        return None

    def display_board(self):
        """Displays the game board in the console."""
        for cell in self.cells:
            cell_type = type(cell).__name__
            print(f"ID: {cell.cell_id}, Name: {cell.cell_name}, Type: {cell_type}")

