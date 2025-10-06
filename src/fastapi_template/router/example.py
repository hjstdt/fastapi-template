import logging

from fastapi import APIRouter

from fastapi_template.model.response import ApiResponse

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/example", tags=["example"])


@router.get("")
def get_example() -> ApiResponse:
    logger.info("example endpoint called")
    return ApiResponse(message="success")
