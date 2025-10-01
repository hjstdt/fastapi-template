from fastapi import FastAPI
from ..model.response import MessageResponse


app = FastAPI()


@app.get("/")
def get_root() -> MessageResponse:
    return MessageResponse(code=200, msg="FastAPI is running...")
