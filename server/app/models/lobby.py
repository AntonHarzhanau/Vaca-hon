import uuid
import datetime
from sqlalchemy import Integer, String, Boolean, DateTime, JSON, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import UUID
from data.database import Base

class Lobby(Base):
    __tablename__ = 'lobbies'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    nb_player_max: Mapped[int] = mapped_column(Integer, default=4, nullable=False)
    time_sec: Mapped[int] = mapped_column(Integer, default=1800, nullable=False)
    player_turn: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=True)
    players: Mapped[list[str]] = mapped_column(JSON, nullable=False, default=list)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    is_private: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    secret: Mapped[str] = mapped_column(String, nullable=True)
    owner_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    created_at: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    last_action_at: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    def __repr__(self) -> str:
        return f"Lobby(id={self.id!r}, is_active={self.is_active!r}, created_at={self.created_at!r}, last_action_at={self.last_action_at!r})"

    def add_player(self, player_id: uuid.UUID):
        if self.players is None:
            self.players = []

        player_str = str(player_id)
        if player_id not in self.players:
            self.players.append(player_str)

    def remove_player(self, player_id: uuid.UUID):
        if player_id in self.players:
            self.players.remove(player_id)