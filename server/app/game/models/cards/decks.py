import json
import random
from pathlib import Path
from typing import Union, Annotated

from pydantic import TypeAdapter, Field

from app.game.models.cards.card import EventCard
from app.game.models.cards.money_event import GainMoney, GainMoneyFromAll, PayFine, PropertyRepair, PayFineToAll
from app.game.models.cards.move_event import MoveTo, MoveToNearCell, MoveAndGain, MoveSteps
from app.game.models.cards.jail_event import GoToJail, GetOutOfJail
# Добавь сюда другие типы карточек по мере необходимости:
# from app.game.models.cards.move_card import MoveCard
# from app.game.models.cards.teleport_card import TeleportCard

# Объединение всех типов карточек
# CardUnion = Union[GainMoneyCard]  # добавляй сюда другие типы карточек
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
        # другие карточки
    ],
    Field(discriminator="effect_type")
]

# Адаптер с указанием discriminator-поля
adapter = TypeAdapter(list[CardUnion])


class CardDeck:
    def __init__(self, cards: list[EventCard]):
        self.cards = cards.copy()
        random.shuffle(self.cards)

    def draw_card(self) -> EventCard:
        card = self.cards.pop(0)
        self.cards.append(card)
        return card


# --- Вспомогательная функция загрузки JSON-файлов карточек ---
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
        print(f"⚠ Ошибка валидации карточек: {e}")
        return []

    return cards



# --- Создание глобальных колод ---
chance_deck = CardDeck(load_json_cards("app/data/chance_cards.json"))
community_chest_deck = CardDeck(load_json_cards("app/data/community_chest_cards.json"))

# print("chance_deck")
# print(len(chance_deck.cards))
# for i in chance_deck.cards:
#     print(i)
    
# print("community_chest_deck")
# print(len(community_chest_deck.cards))
# for i in community_chest_deck.cards:
#     print(i)