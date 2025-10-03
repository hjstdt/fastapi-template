from contextlib import asynccontextmanager
from typing import AsyncGenerator

from fastapi import FastAPI, APIRouter
from fastapi_test.router import health, example
from fastapi_test.app_logging import setup_logging
import logging

setup_logging(log_level="INFO")
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncGenerator[None, None]:
    logger.info("application starting up")
    yield
    logger.info("application shutting down")


app = FastAPI(lifespan=lifespan, title="FastAPI test", description="FastAPI test", version="0.1.0")

api_v1 = APIRouter(prefix="/api/v1")
api_v1.include_router(health.router)
api_v1.include_router(example.router)
app.include_router(api_v1)
