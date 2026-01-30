from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from .models import UserType, UserStatus

class UserBase(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    type: UserType = UserType.ADMIN
    status: UserStatus = UserStatus.ACTIVE

class UserCreate(UserBase):
    pass

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    status: Optional[UserStatus] = None
    # Note: 'type', 'created_at', 'user_id' are excluded to ensure immutability 

class UserResponse(UserBase):
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True