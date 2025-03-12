import uuid
from typing import Optional
from fastapi_users import schemas
from pydantic import Field
from pydantic.json_schema import SkipJsonSchema


class UserRead(schemas.BaseUser[uuid.UUID]):
    username: str
    # Hide fields from the response
    is_active: Optional[bool] = Field(None, exclude=True)
    is_superuser: Optional[bool] = Field(None, exclude=True)
    is_verified: Optional[bool] = Field(None, exclude=True)


class UserCreate(schemas.BaseUserCreate):
    username: str
    # Hide fields from user create schema
    is_active: SkipJsonSchema[bool] = None
    is_superuser: SkipJsonSchema[bool] = None
    is_verified: SkipJsonSchema[bool] = None


class UserUpdate(schemas.BaseUserUpdate):
    username: str