from sqlalchemy import  Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from app.db.database import Base




class CornerCell(Base):
    __tablename__ = 'corner_cells'

    id = Column(Integer, primary_key=True, autoincrement=True)
    cell_id = Column(Integer, ForeignKey('cells.id'), nullable=False)
    cell = relationship('Cell', back_populates='corner_cells')
