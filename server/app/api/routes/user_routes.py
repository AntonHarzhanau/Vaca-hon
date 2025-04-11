import uuid
from fastapi import APIRouter, Depends, status, HTTPException
from app.game.models.lobby import Lobby
from app.db.schemas import LobbyCreate, LobbyRead, LobbyUpdate
from sqlalchemy import select, and_
from sqlalchemy.orm import Session
from app.db.database import get_db, db_session
from fastapi import Depends
#from auth.user_manager import current_active_user

