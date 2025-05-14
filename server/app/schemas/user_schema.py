from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserSchema(BaseModel):
    id: int
    email: str
    username: str
    password: str
    confirm_code: Optional[str] = None
    confirm_code_expiry: Optional[datetime] = None
    is_active: bool = False
    
    class Config:
        from_attributes = True


class UserConfirmationSchemaById(BaseModel):
    id: int
    confirm_code: str

class RequestPasswordReset(BaseModel):
    email: EmailStr

class ResetPasswordRequest(BaseModel):
    email: EmailStr
    reset_code: str
    new_password: str


class UserCreateScema(BaseModel):
    email: str
    username: str
    password: str
    confirm_code: Optional[str] = None
    confirm_code_expiry: Optional[datetime] = None
    is_active: Optional[bool] = False


class UserReadSchema(BaseModel):
    id: int
    email:str
    username:str

class TokenResponse(BaseModel):
    token: str
    token_type: str
    user: UserReadSchema

class UserReadSchemaWithToken(UserReadSchema):
    selected_token: str = None
    player_color: str = "#af52de"
    
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