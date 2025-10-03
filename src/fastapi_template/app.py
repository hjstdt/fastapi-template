from contextlib import asynccontextmanager
from typing import AsyncGenerator
from fastapi import FastAPI, APIRouter
import logging

from fastapi_template.app_config import settings
from fastapi_template.logging_config import setup_logging
from fastapi_template.router import health, example

setup_logging(log_level=settings.log_level.upper())
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncGenerator[None, None]:
    logger.info("application starting up")
    yield
    logger.info("application shutting down")


app = FastAPI(
    lifespan=lifespan, title=settings.app_name, version=settings.app_version, description=settings.app_description
)

api_v1 = APIRouter(prefix=settings.api_prefix, tags=[settings.api_prefix])
api_v1.include_router(health.router)
api_v1.include_router(example.router)
app.include_router(api_v1)
