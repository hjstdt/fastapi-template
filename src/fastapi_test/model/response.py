from pydantic import BaseModel


class MessageResponse(BaseModel):
    code: int
    msg: str
