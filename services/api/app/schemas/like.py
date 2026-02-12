from pydantic import BaseModel


class LikeCreate(BaseModel):
    post_id: int

class LikeResponse(BaseModel):
    post_id: int
    likes: int 