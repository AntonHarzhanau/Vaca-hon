from abc import ABC, abstractmethod
from sqlalchemy import insert, select, or_
from app.db.database import async_session_maker
from pydantic import BaseModel
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException

class AbstractRepository(ABC):
    """
    Abstract base class for repositories.
    """

    @abstractmethod
    async def add(self, item):
        """
        Add an item to the repository.
        """
        raise NotImplementedError("Subclasses must implement this method.")
    
    @abstractmethod
    async def get(self, item_id: int | None = None, filters: BaseModel | None = None):
        """
        Get all items from the repository.
        """
        raise NotImplementedError("Subclasses must implement this method.")

    @abstractmethod
    async def update(self, item):
        """
        Update an existing item in the repository.
        """
        raise NotImplementedError("Subclasses must implement this method.")

    @abstractmethod
    async def delete(self, item_id):
        """
        Delete an item from the repository by its ID.
        """
        raise NotImplementedError("Subclasses must implement this method.")
    
class SqlAlchemyRepository(AbstractRepository):
    """
    SQLAlchemy implementation of the repository pattern.
    """
    model = None  # This should be set to the SQLAlchemy model class
    
    async def add(self, data: dict):
        async with async_session_maker() as session:
            stmt = insert(self.model).values(**data).returning(self.model)
            try:
                res = await session.execute(stmt)
            except IntegrityError as e:   
                await session.rollback()
                print(e.orig)
                raise HTTPException(status_code=400, detail="A non-existent foreign key was specified.")
            
            await session.commit()
            return res.scalar_one().to_read_model()
        
    async def get(self, user_id: int | None = None, filters: BaseModel | None = None):
        async with async_session_maker() as session:
            stmt = select(self.model)

            if user_id is not None:
                stmt = stmt.where(self.model.id == user_id)
                result = await session.execute(stmt)
                user = result.scalar_one_or_none()
                return user.to_read_model() if user else None

            if filters:
                conditions = [
                    getattr(self.model, field) == value
                    for field, value in filters.model_dump(exclude_unset=True).items()
                    if hasattr(self.model, field)
                ]
                stmt = stmt.where(or_(*conditions))

            result = await session.execute(stmt)
            return [row[0].to_read_model() for row in result.all()]

    
    async def update(self, item_id:int, item_data: dict):
        async with async_session_maker() as session:
            db_obj = await session.get(self.model, item_id)
            if db_obj is None:
                return None
            for key, value in item_data.items():
                setattr(db_obj, key, value)
            await session.commit()
            await session.refresh(db_obj)
            return db_obj.to_read_model()
    
    async def delete(self, item_id):
        async with async_session_maker() as session:
            obj = await session.get(self.model, item_id)
            if obj is None:
                return None
            await session.delete(obj)
            await session.commit()
        return obj.to_read_model()