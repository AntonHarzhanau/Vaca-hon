from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# URL de connexion à la base de données
SQLALCHEMY_DATABASE_URL = "postgresql://monopoly:monopoly@127.0.0.1:9876/monopoly"

#  5050 Pour le port

# Créer un moteur pour se connecter à PostgreSQL
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Créer un constructeur de session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Déclarer la base
Base = declarative_base()




# Créer toutes les tables définies dans les modèles SQLAlchemy

# Créer les tables dans la base de données

# Créer les tables dans la base de données
def create_tables():
    # from app.models import Cell
    # from app.models import Player
    # from app.models import PropertyCell
    from app.models.user import User
    from app.models.lobby import Lobby
    Base.metadata.create_all(bind=engine)

# Fonction pour récupérer la session de la base de données
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
