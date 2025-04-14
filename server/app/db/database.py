import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.orm import declarative_base

# Load environment variables from .env
load_dotenv() 
# URL de connexion à la base de données
# SQLALCHEMY_DATABASE_URL = os.getenv(DATABASE_URL)
# SQLALCHEMY_DATABASE_URL = "postgresql+asyncpg://postgres:2547@localhost:5432/monopoly" <- async postgress
SQLALCHEMY_DATABASE_URL = "sqlite+aiosqlite:///./test.db" #   <- async sqlite

# Déclarer la base
Base = declarative_base()

# Créer un moteur pour se connecter à PostgreSQL
engine = create_async_engine(
    SQLALCHEMY_DATABASE_URL,
    echo=False,    
)

# Créer un constructeur de session
async_session_maker = async_sessionmaker(
    engine, 
    expire_on_commit=False,
    autoflush=False,
    autocommit=False,
)

# async def get_async_session():
#     async with async_session_maker() as session:
#         yield session 

# Créer toutes les tables définies dans les modèles SQLAlchemy

# Créer les tables dans la base de données
async def create_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

# For testing purposes
async def delete_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
