import os
from dotenv import load_dotenv
from sqlalchemy import create_engine,text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import OperationalError
# Charger les variables d'environnement
load_dotenv()

# Récupérer l'URL de la base de données
SQLALCHEMY_DATABASE_URL = os.getenv("SQLALCHEMY_DATABASE_URL")

# Créer l'engine SQLAlchemy
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})

# Créer une session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def test_connection():
    try:
        # Crée une session pour tester la connexion
        session = SessionLocal()
        
        # Exécute la requête SELECT * FROM cells
        result = session.execute(text('SELECT * FROM cells')).fetchall()  # Utilise text() pour la requête SQL
        
        # Affiche les résultats
        print("Résultats de la requête SELECT * FROM cells :")
        for row in result:
            print(row)
        
        session.close()  # Ferme la session

    except OperationalError as e:
        print(f"Erreur de connexion à la base de données : {e}")
    except Exception as e:
        print(f"Une erreur s'est produite : {e}")

# Exécute la fonction pour tester la connexion
test_connection()