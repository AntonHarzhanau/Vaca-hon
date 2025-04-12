from pydantic import BaseModel, field_validator
from typing import Optional

class UserSchema(BaseModel):
    id: int
    email: str
    username: str
    password: str
    
    class Config:
        from_attributes = True


class UserCreateScema(BaseModel):
    email: str
    username: str
    password: str

class UserReadSchema(BaseModel):
    id: int
    email:str
    username:str
    
class UserUpdateSchema(BaseModel):
    email: Optional[str] = None
    username: Optional[str] = None
    password: Optional[str]
    
class UserDeleteSchema(BaseModel):
    user_id: int

class UserFilterSchema(BaseModel):
    email: Optional[str] = None
    username: Optional[str] = None

class UserLoginSchema(UserFilterSchema):

    password: str