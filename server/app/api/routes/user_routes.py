from fastapi import APIRouter, Depends, HTTPException
from app.schemas.user import UserCreateScema, UserReadSchema, UserUpdateSchema, UserDeleteSchema
from app.api.dependencies import user_service
from app.services.user import UserService
from typing import Annotated

router = APIRouter(prefix="/Users", tags=["Users"])

@router.post("/")
async def create_user(
    user: Annotated[UserCreateScema, Depends()],
    user_service: Annotated[UserService, Depends(user_service)]
)-> UserReadSchema:
    user = await user_service.add_user(user)
    return user

@router.get("/")
async def get_users(
    user_service: Annotated[UserService, Depends(user_service)]    
) -> list[UserReadSchema]:
    users = await user_service.get_users()
    return users

@router.get("/{user_id}")
async def get_user(
    user_id: int,
    user_service: Annotated[UserService, Depends(user_service)]
) -> UserReadSchema:
    user = await user_service.get_user(user_id)
    if user is None:
         raise HTTPException(status_code=404, detail="User not found")
    return user

@router.patch("/{user_id}")
async def update_user(
    user_id: int,
    user_data: UserUpdateSchema,
    user_service: Annotated[UserService, Depends(user_service)]
) -> UserReadSchema:
    user = await user_service.update_user(user_id, user_data)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.delete("/{user_id}")
async def delete_user(
    user_id: int,
    user_service: Annotated[UserService, Depends(user_service)]
) -> UserDeleteSchema:
    user = await user_service.delete_user(user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return {"user_id": user.id}
