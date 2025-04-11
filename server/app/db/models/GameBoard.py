import json
from typing import List, Optional
from pydantic import BaseModel, Field

from app.models import Cell, StreetCell,PropertyCell


class GameBoard(BaseModel):
    """
    Game board class. Loads data from JSON and creates cell objects.
    """
    cells: List[Cell] = Field(default_factory=list)
    groups: dict[str, List[StreetCell]] = Field(default_factory=dict)

    def __init__(self, **data):
        super().__init__(**data)
        self.load_board_from_json("data/data.json")

    def load_board_from_json(self, file_path: str) -> None:
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                data = json.load(file)
        except FileNotFoundError:
            print(f"⚠ Error: file {file_path} not found")
            return
        except json.JSONDecodeError:
            print(f"⚠ Error: file {file_path} contains invalid JSON")
            return
        #TODO: after implementing all cell classes, rework the logic
        for index, cell_data in enumerate(data):
            cell_name = cell_data.get("name", f"Cell {index}")
            if "cost" in cell_data:
                if cell_data.get("type") == "Street":
                    street_cell = StreetCell(
                    cell_id=index,
                    cell_name=cell_name,
                    price=cell_data["cost"],
                    initial_rent=cell_data["rent"],
                    current_rent=cell_data["rent"],
                    group_color=cell_data["color"], # group_color
                    house_cost=cell_data["house"] # house_cost
                )
                    self.cells.append(street_cell)
                    self.groups.setdefault(street_cell.group_color, []).append(street_cell)
                else:
                    property_cell = PropertyCell(
                        cell_id=index,
                        cell_name=cell_name,
                        price=cell_data["cost"],
                        initial_rent=cell_data["rent"],
                        current_rent=cell_data["rent"]
                    )
                    self.cells.append(property_cell)
            else:
                self.cells.append(Cell(cell_id=index, cell_name=cell_name))

    def get_cell(self, cell_id: int) -> Optional[Cell]:
        if 0 <= cell_id < len(self.cells):
            return self.cells[cell_id]
        return None

    def display_board(self) -> None:
        for cell in self.cells:
            cell_type = type(cell).__name__
            print(f"ID: {cell.cell_id}, Name: {cell.cell_name}, Type: {cell_type}")
