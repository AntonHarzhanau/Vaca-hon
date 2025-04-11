from sqlalchemy.orm import Session
# from data.schemas import  PlayerCreate
from app.models import  Player
from app.schemas.Player_schema import PlayerCreate


class CRUD:
    # Opérations CRUD pour les joueurs (Player)
    @staticmethod
    def create_player(db: Session, player: PlayerCreate):
        db_player = Player(
            player_name=player.player_name,
            email=player.email,
            password=player.password,  
            money=player.money,
            current_position=player.current_position,
            nb_turn_jail=player.nb_turn_jail,
            nb_railway=player.nb_railway,
            nb_utility=player.nb_utility,
            timer_turn=player.timer_turn,
        )
        db.add(db_player)
        db.commit()
        db.refresh(db_player)
        return db_player

    @staticmethod
    def get_player(db: Session, player_id: int):
        return db.query(Player).filter(Player.id == player_id).first()

    @staticmethod
    def update_player(db: Session, player_id: int, player_data: dict):
        db_player = db.query(Player).filter(Player.id == player_id).first()
        if db_player:
            for key, value in player_data.items():
                setattr(db_player, key, value)
            db.commit()
            db.refresh(db_player)
        return db_player

    @staticmethod
    def delete_player(db: Session, player_id: int):
        db_player = db.query(Player).filter(Player.id == player_id).first()
        if db_player:
            db.delete(db_player)
            db.commit()
        return db_player
