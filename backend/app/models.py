from sqlalchemy import Column, Integer, String, DateTime, Enum
from sqlalchemy.sql import func
from .database import Base
import enum

class UserType(str, enum.Enum):
    ADMIN = "ADMIN"

class UserStatus(str, enum.Enum):
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"

class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    type = Column(Enum(UserType), default=UserType.ADMIN)
    status = Column(Enum(UserStatus), default=UserStatus.ACTIVE)
    created_at = Column(DateTime(timezone=True), server_default=func.now())