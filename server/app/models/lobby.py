import datetime
from sqlalchemy import Integer, String, Boolean, DateTime, JSON, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func
from app.db.database import Base
from app.schemas.lobby import LobbyReadSchema

class LobbyOrm(Base):
    __tablename__ = 'Lobby'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    nb_player_max: Mapped[int] = mapped_column(Integer, default=4, nullable=False)
    time_sec: Mapped[int] = mapped_column(Integer, default=1800, nullable=False)
    players: Mapped[list[str]] = mapped_column(JSON, nullable=False, default=list)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    is_private: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    secret: Mapped[str] = mapped_column(String, nullable=True)
    owner_id: Mapped[int] = mapped_column(ForeignKey("User.id"), nullable=False)
    created_at: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    last_action_at: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    def __repr__(self) -> str:
        return f"Lobby(id={self.id!r}, is_active={self.is_active!r}, created_at={self.created_at!r}, last_action_at={self.last_action_at!r})"

    def to_read_model(self) -> LobbyReadSchema:
        return LobbyReadSchema(
            id=self.id,
            nb_player_max=self.nb_player_max,
            time_sec=self.time_sec,
            players=self.players,
            owner_id=self.owner_id,
            is_active=self.is_active,
            is_private=self.is_private,
            created_at=self.created_at,
            last_action_at=self.last_action_at,        
        )
        
        
    # def add_player(self, player_id: int):
    #     if self.players is None:
    #         self.players = []

    #     player_str = str(player_id)
    #     if player_id not in self.players:
    #         self.players.append(player_str)

    # def remove_player(self, player_id: int):
    #     if player_id in self.players:
    #         self.players.remove(player_id)

    # def get_connection_manager(self):
    #     return self.connection_manager

    # def set_connection_manager(self, connection_manager: ConnectionManager):
    #     self.connection_manager = connection_manager
