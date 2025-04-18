from app.services.user_service import UserService
from app.db.repositories.user_repo import UserRepository

from app.db.repositories.lobby_repo import LobbyRepository
from app.services.lobby_service import LobbyService

from app.game.core.lobby_manager import lobby_manager, LobbyManager

def user_service() -> UserService:
    return UserService(UserRepository)

def lobby_service() -> LobbyService:
    return LobbyService(LobbyRepository)

def get_lobby_manager() -> LobbyManager:
    return lobby_manager
