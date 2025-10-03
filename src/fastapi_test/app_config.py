from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", case_sensitive=False, extra="ignore")

    app_name: str = "FastAPI-test"
    app_description: str = "FastAPI-test application"
    app_version: str = "0.0.1"
    environment: str = "dev"

    debug: bool = False
    api_prefix: str = "/api/v1"
    log_level: str = "INFO"
    host: str = "0.0.0.0"
    port: int = 8000


settings = Settings()
