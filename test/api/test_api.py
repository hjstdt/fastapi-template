from fastapi.testclient import TestClient
from api import app, MessageResponse


client = TestClient(app)


def test_get_root() -> None:
    response = client.get("/")

    response_data = MessageResponse.model_validate(response.json())
    assert response_data.code == 200
    assert response_data.msg == "FastAPI is running..."
