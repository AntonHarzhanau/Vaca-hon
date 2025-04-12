from app.models.lobby import LobbyOrm
from app.utils.repository import SqlAlchemyRepository

class LobbyRepository(SqlAlchemyRepository):
    """Repository for the Lobby model."""
    model = LobbyOrm