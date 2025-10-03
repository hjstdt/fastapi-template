from fastapi import APIRouter
import logging

from fastapi_test.model.response import HealthResponse

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/health", tags=["health"])


@router.get("/")
def get_health() -> HealthResponse:
    logger.info("health endpoint called")
    return HealthResponse(status="healthy")
