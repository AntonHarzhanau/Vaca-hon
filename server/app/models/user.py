from sqlalchemy import  Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.schemas.user import UserSchema

from app.db.database import Base

class UserOrm(Base):
    __tablename__ = 'User'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String(20), unique=True, index=True, nullable=False)
    password:  Mapped[str] = mapped_column(String(50), nullable=False) 
    email: Mapped[str] = mapped_column(String(50), unique=True, index=True, nullable=False) 

    def to_read_model(self) -> UserSchema:
        return UserSchema(
            id=self.id,
            username=self.username,
            password=self.password,
            email=self.email,
        )

    def __repr__(self):
        return f"<User(id={self.id}, player_name={self.player_name}, email={self.email})>"
    