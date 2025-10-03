from fastapi.testclient import TestClient
from fastapi_template.app import app

client = TestClient(app)


def test_get_test() -> None:
    response = client.get("/api/v1/example/")
    assert response.status_code == 200
    assert response.json()["message"] == "success"
