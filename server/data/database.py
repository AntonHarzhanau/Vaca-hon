from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker




# URL de connexion à la base de données
SQLALCHEMY_DATABASE_URL = "postgresql://Admin:Delphine4@localhost:5432/monopoly_db"

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
    from models import Cell
    from models import Player
    from models import PropertyCell
    Base.metadata.create_all(bind=engine)
# Fonction pour récupérer la session de la base de données
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
