from pydantic_settings import BaseSettings, SettingsConfigDict

class DotEnvConfig(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8')
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    DATABASE_URL: str

dotenv_config = DotEnvConfig()