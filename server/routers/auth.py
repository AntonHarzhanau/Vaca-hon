from fastapi import APIRouter, Depends, status
from database import User, create_db_and_tables
from schemas.user import UserCreate, UserRead, UserUpdate
from auth.user_manager import auth_backend, current_active_user, fastapi_users

router = APIRouter()

router.include_router(
    fastapi_users.get_auth_router(auth_backend), prefix="", tags=["auth"]
)
router.include_router(
    fastapi_users.get_register_router(UserRead, UserCreate),
    tags=["auth"],
)
router.include_router(
    fastapi_users.get_reset_password_router(),
    tags=["auth"],
)
router.include_router(
    fastapi_users.get_users_router(UserRead, UserUpdate),
    tags=["users"],
)