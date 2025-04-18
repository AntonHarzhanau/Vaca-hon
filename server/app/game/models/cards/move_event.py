from typing import TYPE_CHECKING, Literal, Callable, Tuple
from app.game.models.cards.card import EventCard

if TYPE_CHECKING:
    from app.game.models.player import Player
    from app.game.core.game_state import GameState


def _find_and_move(player: "Player", state: "GameState", match_pred: Callable[[object], bool]) -> Tuple[int, bool]:
    """
    Find the next cell matching match_pred, move the player there, and return (steps, prime).
    """
    board = state.board.cells
    size = len(board)
    start = player.current_position

    for i in range(1, size):
        idx = (start + i) % size
        cell = board[idx]
        if match_pred(cell):
            steps = (cell.cell_id - start) % size
            res = player.move(steps)
            prime = res.get("prime")
            return steps, prime

    # No matching cell found: no movement
    return 0, False


class MoveTo(EventCard):
    effect_type: Literal["move_to"]
    target: str
    steps: int = 0
    prime: bool = False

    def activate(self, player: "Player", state: "GameState"):
        self.steps, self.prime = _find_and_move(
            player,
            state,
            lambda cell: cell.cell_name == self.target,
        )
        return super().activate(player)


class MoveToNearCell(EventCard):
    effect_type: Literal["move_to_nearest"]
    target: str
    steps: int = 0
    prime: bool = False

    def activate(self, player: "Player", state: "GameState"):
        self.steps, self.prime = _find_and_move(
            player,
            state,
            lambda cell: type(cell).__name__ == self.target,
        )
        return super().activate(player)


class MoveAndGain(EventCard):
    effect_type: Literal["move_and_gain"]
    target: str
    steps: int = 0
    amount: int

    def activate(self, player: "Player", state: "GameState"):
        self.steps, _ = _find_and_move(
            player,
            state,
            lambda cell: cell.cell_name == self.target,
        )
        player.earn(self.amount)
        return super().activate(player)


class MoveSteps(EventCard):
    effect_type: Literal["move_steps"]
    steps: int

    def activate(self, player: "Player", state: "GameState"):
        player.move(self.steps)
        return super().activate(player)
