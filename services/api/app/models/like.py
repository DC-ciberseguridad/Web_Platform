from sqlalchemy import Column, Integer, ForeignKey
from app.database import Base

class Like(Base):
    __tablename__ = "likes"

    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, nullable=False)   # ID de WordPress
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
