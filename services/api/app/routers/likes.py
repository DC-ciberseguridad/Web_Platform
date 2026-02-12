from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func

from app.database import get_db
from app.models.like import Like
from app.schemas.like import LikeCreate, LikeResponse

router = APIRouter(prefix="/likes", tags=["likes"])

FAKE_USER_ID = 1


@router.post("/")
def toggle_like(data: LikeCreate, db: Session = Depends(get_db)):
    existing = db.query(Like).filter(
        Like.post_id == data.post_id,
        Like.user_id == FAKE_USER_ID
    ).first()

    if existing:
        db.delete(existing)
        db.commit()
        return {"message": "Like removed"}

    like = Like(post_id=data.post_id, user_id=FAKE_USER_ID)
    db.add(like)
    db.commit()
    return {"message": "Like added"}


@router.get("/post/{post_id}", response_model=LikeResponse)
def count_likes(post_id: int, db: Session = Depends(get_db)):
    total = db.query(func.count(Like.id)).filter(
        Like.post_id == post_id
    ).scalar()

    return {"post_id": post_id, "likes": total}
