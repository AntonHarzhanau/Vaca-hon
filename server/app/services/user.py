from app.utils.repository import AbstractRepository
from app.schemas.user import UserCreateScema, UserReadSchema

class UserService():
    def __init__(self, user_repository: AbstractRepository):
        self.user_repository: AbstractRepository = user_repository()
        
    async def add_user(self, user: UserCreateScema) -> UserReadSchema:
        user_dict = user.model_dump()
        user = await self.user_repository.add(user_dict)
        return user
    
    async def get_users(self) -> list[UserReadSchema]:
        users = await self.user_repository.get()
        return users
    
    async def get_user(self, user_id: int) -> UserReadSchema:
        user = await self.user_repository.get(user_id)
        return user
    
    async def update_user(self, user_id: int, user_data: UserReadSchema) -> UserReadSchema | None:
        user = await self.user_repository.update(user_id, user_data.model_dump(exclude_unset=True))
        return user
    
    async def delete_user(self, user_id: int) -> UserReadSchema | None:
        user = await self.user_repository.delete(user_id)
        return user