from fastapi import APIRouter, Depends, HTTPException, Request
from app.schemas.user_schema import UserCreateScema, UserReadSchema, UserUpdateSchema, UserDeleteSchema, UserFilterSchema, UserLoginSchema, UserConfirmationSchemaById, RequestPasswordReset, TokenResponse, ResetPasswordRequest, UserSupportRequestSchema

from app.api.dependencies import user_service
from app.services.user_service import UserService
from typing import Annotated
from app.services.email_sender import send_confirmation_email, send_reset_email, send_support_email
import asyncio
import uuid
import jwt
from datetime import datetime, timedelta
import os
import secrets
from fastapi import Request
import logging

logger = logging.getLogger("monopoly-server")
JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")


router = APIRouter(prefix="/Users", tags=["Users"])

def create_jwt_token(username: str):
    expiration = datetime.utcnow() + timedelta(hours=3)
    payload = {"sub": username, "exp": expiration}
    return jwt.encode(payload, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)

@router.post("/login", response_model=TokenResponse)
async def login(
    login_data: UserLoginSchema,
    user_service: Annotated[UserService, Depends(user_service)]
):
    # print(login_data)
    user = await user_service.authenticate_user(
        email=login_data.login,
        username=login_data.login,
        password=login_data.password
    )
    if user is None:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    token = create_jwt_token(user.username)
    return {
        "token": token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "username": user.username
        }
    }


@router.post("/")
async def create_user(
    user: UserCreateScema,
    request : Request,
    user_service: Annotated[UserService, Depends(user_service)]
)-> UserReadSchema:
    client_ip = request.client.host
    logger.info(f"Requête de reset depuis l’IP : {client_ip}")
    created_user, confirm_code = await user_service.add_user(user)
    await send_confirmation_email(created_user.email, created_user.username, confirm_code)
    return created_user

@router.post("/confirm")
async def confirm_user(
    data: UserConfirmationSchemaById,
    user_service: Annotated[UserService, Depends(user_service)]
):
    user = await user_service.confirm_user_by_id(data.id, data.confirm_code)

    return user

@router.get("/")
async def get_users(
    user_service: Annotated[UserService, Depends(user_service)]    
) -> list[UserReadSchema]:
    users = await user_service.get_users()
    return users

@router.get("/by-filters", response_model=list[UserReadSchema])
async def get_users_by_filters(
    filters: Annotated[UserFilterSchema, Depends()],
    user_service: Annotated[UserService, Depends(user_service)]
):
    users = await user_service.get_users(filters=filters)
    if not users:
        raise HTTPException(status_code=404, detail="Users not found")
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


@router.post("/request-reset")
async def request_password_reset(data: RequestPasswordReset, user_service: Annotated[UserService, Depends(user_service)]):
    user = await user_service.get_user_by_email(data.email)
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur introuvable")

    reset_code = secrets.token_hex(4)
    expiry = datetime.utcnow() + timedelta(hours=1)
    
    await user_service.set_reset_code(user.id, reset_code, expiry)
    await send_reset_email(user.email, reset_code)
    return user

@router.post("/reset-password")
async def reset_password(
    data: ResetPasswordRequest,
    user_service: Annotated[UserService, Depends(user_service)]
):
    user = await user_service.reset_password(data)
    return {"message": "Mot de passe réinitialisé avec succès", "user_id": user.id}

# Route for Support Request
@router.post("/request-support")
async def request_support(data: UserSupportRequestSchema):
    try:
        response = await send_support_email(data)
        if response:
            return {"message": "Support request successfully sent.", "data": data}
        raise HTTPException(status_code=500, detail="Something went wrong when sending the email.")
    except Exception as e:
        raise HTTPException(status_code=400, detail=e)
