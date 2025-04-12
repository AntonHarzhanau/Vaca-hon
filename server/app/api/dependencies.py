from app.services.user import UserService
from app.db.repositories.user import UserRepository

from app.db.repositories.lobby import LobbyRepository
from app.services.lobby import LobbyService

def user_service() -> UserService:
    return UserService(UserRepository)

def lobby_service() -> LobbyService:
    return LobbyService(LobbyRepository)