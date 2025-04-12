from app.utils.repository import SqlAlchemyRepository
from app.models.user import UserOrm

class UserRepository(SqlAlchemyRepository):
    model = UserOrm