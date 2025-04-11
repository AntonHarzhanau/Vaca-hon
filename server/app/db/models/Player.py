from sqlalchemy import   JSON, Column, Integer, String, Boolean, ForeignKey

from app.db.database import Base




class Player(Base):
    __tablename__ = 'Player'

    id = Column(Integer, primary_key=True, autoincrement=True)
    player_name = Column(String, nullable=False)
    email = Column(String, nullable=False)
    username = Column(String, nullable=False)
    password = Column(String, nullable=False)
    money = Column(Integer, default=1500)
    current_position = Column(Integer, default=0)
    nb_turn_jail = Column(Integer, default=0)
    nb_railway = Column(Integer, default=0)
    nb_utility = Column(Integer, default=0)
    timer_turn = Column(Integer, default=30)
    properties_owned = Column(String, default="")  # Stocké sous forme de chaîne séparée par des virgules


    def __repr__(self):
        return f"<Player(id={self.id}, player_name={self.player_name}, email={self.email})>"