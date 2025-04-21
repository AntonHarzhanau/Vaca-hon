from app.utils.repository import SqlAlchemyRepository
from app.models.user_model import UserOrm

class UserRepository(SqlAlchemyRepository):
    """Repository for the User model."""
    model = UserOrm