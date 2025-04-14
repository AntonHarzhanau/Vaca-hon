from app.utils.repository import AbstractRepository
from app.schemas.user_schema import UserCreateScema, UserReadSchema, UserFilterSchema, UserLoginSchema
from typing import Union

class UserService():
    def __init__(self, user_repository: AbstractRepository):
        self.user_repository: AbstractRepository = user_repository()
        
    async def add_user(self, user: UserCreateScema) -> UserReadSchema:
        user_dict = user.model_dump()
        user = await self.user_repository.add(user_dict)
        print(user)
        return user
    
    async def get_users(
        self,
        user_id: int | None = None,
        filters: UserFilterSchema | None = None
    ) -> Union[UserReadSchema, list[UserReadSchema]]:
        
        users = await self.user_repository.get(user_id=user_id, filters=filters)

        if user_id is not None:
            return users if users else None  # one object or None
        else:
            return users  # list of objects or empty list
        
    async def update_user(self, user_id: int, user_data: UserReadSchema) -> UserReadSchema | None:
        user = await self.user_repository.update(user_id, user_data.model_dump(exclude_unset=True))
        return user
        
    async def delete_user(self, user_id: int) -> UserReadSchema | None:
        user = await self.user_repository.delete(user_id)
        return user
    

    async def authenticate_user(self, email: str = None, username: str = None, password: str = ""):
        filters = UserFilterSchema(email=email, username=username)
        users = await self.user_repository.get(filters=filters)

        if users:
            user = users[0]
            if user.password == password:
                return user
        
        return None
