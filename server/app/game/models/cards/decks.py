import json
import random
from pathlib import Path
from typing import Union, Annotated

from pydantic import TypeAdapter, Field

from app.game.models.cards.card import EventCard
from app.game.models.cards.money_event import GainMoney, GainMoneyFromAll, PayFine, PropertyRepair, PayFineToAll
from app.game.models.cards.move_event import MoveTo, MoveToNearCell, MoveAndGain, MoveSteps
from app.game.models.cards.jail_event import GoToJail, GetOutOfJail

CardUnion = Annotated[
    Union[
        GainMoney,
        GainMoneyFromAll,
        PayFine,
        PropertyRepair,
        MoveTo,
        GoToJail,
        GetOutOfJail,
        MoveToNearCell,
        MoveAndGain,
        MoveSteps,
        PayFineToAll,
        # other types of cards
    ],
    Field(discriminator="effect_type")
]

    # Adapter with discriminator field specified
adapter = TypeAdapter(list[CardUnion])


class CardDeck:
    def __init__(self, cards: list[EventCard]):
        self.cards = cards.copy()
        random.shuffle(self.cards)

    def draw_card(self) -> EventCard:
        card = self.cards.pop(0)
        self.cards.append(card)
        return card


# --- Helper function for loading JSON cards files ---
def load_json_cards(file_path: str) -> list[EventCard]:
    path = Path(file_path)
    try:
        with path.open("r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"⚠ Error: file {file_path} not found")
        return []
    except json.JSONDecodeError as e:
        print(f"⚠ Error: file {file_path} contains invalid JSON: {e}")
        return []

    try:
        cards = adapter.validate_python(data)
    except Exception as e:
        print(f"⚠ Card validation error: {e}")
        return []

    return cards
