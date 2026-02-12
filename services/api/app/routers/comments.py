from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.comment import Comment
from app.schemas.comment import CommentCreate, CommentResponse

router = APIRouter(prefix="/comments", tags=["comments"])

FAKE_USER_ID = 1


@router.post("/", response_model=CommentResponse)
def create_comment(data: CommentCreate, db: Session = Depends(get_db)):
    comment = Comment(
        post_id=data.post_id,
        user_id=FAKE_USER_ID,
        content=data.content
    )
    db.add(comment)
    db.commit()
    db.refresh(comment)
    return comment


@router.get("/post/{post_id}", response_model=list[CommentResponse])
def get_comments_by_post(post_id: int, db: Session = Depends(get_db)):
    return db.query(Comment).filter(Comment.post_id == post_id).all()
