from sqlalchemy import Integer, String, DateTime
from sqlalchemy.orm import Mapped, mapped_column
from app.schemas.user_schema import UserSchema

from datetime import datetime
from app.db.database import Base

class UserOrm(Base):
    __tablename__ = 'User'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String(20), unique=True, index=True, nullable=False)
    password:  Mapped[str] = mapped_column(String(255), nullable=False) 
    email: Mapped[str] = mapped_column(String(100), unique=True, index=True, nullable=False) 
    confirm_code: Mapped[str] = mapped_column(String(100), nullable=True)
    confirm_code_expiry: Mapped[datetime] = mapped_column(DateTime, nullable=True)
    is_active: Mapped[bool] = mapped_column(default=False, nullable=False)


    def to_read_model(self) -> UserSchema:
        return UserSchema(
            id=self.id,
            username=self.username,
            password=self.password,
            email=self.email,
            confirm_code=self.confirm_code,
            confirm_code_expiry=self.confirm_code_expiry,
            is_active=self.is_active
        )

    def __repr__(self):
        return f"<User(id={self.id}, player_name={self.player_name}, email={self.email})>"
    