from fastapi.testclient import TestClient
from fastapi_test.model import MessageResponse
from fastapi_test.app import app


client = TestClient(app)


def test_get_root() -> None:
    response = client.get("/")

    response_data = MessageResponse.model_validate(response.json())
    assert response_data.code == 200
    assert response_data.msg == "FastAPI is running..."
