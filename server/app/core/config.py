from pydantic_settings import BaseSettings, SettingsConfigDict

class DotEnvConfig(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8')
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    FASTAPI_PORT: int = 7000
    FASTAPI_ROOT_PATH: str = "/"
    DATABASE_URL: str = "postgresql://monopoly:monopoly@127.0.0.1:5432/monopoly"
    POSTGRES_USER: str
    POSTGRES_PASSWORD: str
    POSTGRES_DB: str
    POSTGRES_PORT: int

dotenv_config = DotEnvConfig()