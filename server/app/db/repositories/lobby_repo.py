from app.models.lobby_model import LobbyOrm
from app.utils.repository import SqlAlchemyRepository

class LobbyRepository(SqlAlchemyRepository):
    """Repository for the Lobby model."""
    model = LobbyOrm