from app.utils.repository import AbstractRepository
from app.schemas.user_schema import UserCreateScema, UserReadSchema, UserFilterSchema, UserReadSchemaWithToken, ResetPasswordRequest
from typing import Union
import bcrypt
from datetime import datetime, timedelta
from fastapi import HTTPException
import secrets

class UserService():
    def __init__(self, user_repository: AbstractRepository):
        self.user_repository: AbstractRepository = user_repository()
        
    async def add_user(self, user: UserCreateScema) -> UserReadSchema:
        user_dict = user.model_dump()

        hashed_password = bcrypt.hashpw(
            user_dict["password"].encode(), 
            bcrypt.gensalt()
            ).decode()
        user_dict["password"] = hashed_password

        confirm_code = secrets.token_hex(4)
        confirm_code_expiry = datetime.utcnow() + timedelta(hours=24)

        user_dict["confirm_code"] = confirm_code
        user_dict["confirm_code_expiry"] = confirm_code_expiry

        user = await self.user_repository.add(user_dict)
        print(user)
        return user, confirm_code
    
    async def get_users(
        self,
        user_id: int | None = None,
        filters: UserFilterSchema | None = None
    ) -> Union[UserReadSchema, list[UserReadSchema], UserReadSchemaWithToken]:
        
        users = await self.user_repository.get(user_id=user_id, filters=filters)

        if user_id is not None:
            return users if users else None  # one object or None
        else:
            return users  # list of objects or empty list
        
    async def update_user(self, 
                          user_id: int, 
                          user_data: UserReadSchema
                          ) -> UserReadSchema | None:
        
        user = await self.user_repository.update(user_id, user_data.model_dump(exclude_unset=True))
        return user
        
    async def delete_user(self, user_id: int) -> UserReadSchema | None:
        user = await self.user_repository.delete(user_id)
        return user
    

    async def authenticate_user(self, email: str = None, username: str = None, password: str = ""):
        filters = UserFilterSchema(email=email, username=username)
        users = await self.user_repository.get(filters=filters)
        

        if not users:
            return None
        user = users[0]
        if not user.is_active:
            raise HTTPException(status_code=403, detail="Compte non activé. Veuillez confirmer votre adresse e-mail.")

        if users:
            if bcrypt.checkpw(password.encode(), user.password.encode()):
                return user
        
        return None

    async def confirm_user_by_id(self, user_id: int, code: str) -> UserReadSchema:
        user = await self.user_repository.get(user_id)

        if not user:
            raise HTTPException(status_code=404, detail="Utilisateur introuvable")

        # Vérification du code de confirmation
        if user.confirm_code != code:
            raise HTTPException(status_code=400, detail="Code incorrect")

        # Vérification de l'expiration du code
        if user.confirm_code_expiry < datetime.utcnow():
            raise HTTPException(status_code=400, detail="Code expiré")

        # Activation de l'utilisateur
        user.is_active = True
        user.confirm_code = None
        user.confirm_code_expiry = None

        updated_user = await self.user_repository.update(user.id, user.model_dump())
        return updated_user

    async def set_reset_code(self, user_id: int, reset_code: str, expiry: datetime):
        await self.user_repository.update(user_id, {
            "confirm_code": reset_code,
            "confirm_code_expiry": expiry
        })

    async def reset_password(self, data: ResetPasswordRequest):
        user = await self.get_user_by_email(data.email)

        if not user:
            raise HTTPException(status_code=404, detail="Utilisateur introuvable")

        if not user.confirm_code or user.confirm_code != data.reset_code:
            raise HTTPException(status_code=400, detail="Code de réinitialisation invalide")

        if user.confirm_code_expiry < datetime.utcnow():
            raise HTTPException(status_code=400, detail="Code expiré")

        hashed_password = bcrypt.hashpw(data.new_password.encode(), bcrypt.gensalt()).decode()

        user.password = hashed_password
        user.confirm_code = None
        user.confirm_code_expiry = None

        updated_user = await self.user_repository.update(user.id, user.model_dump())
        return updated_user


    async def get_user_by_email(self, email: str):
        filters = UserFilterSchema(email=email)
        users = await self.user_repository.get(filters=filters)
        return users[0] if users else None


