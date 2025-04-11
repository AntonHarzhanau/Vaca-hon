from sqlalchemy import  Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.db.database import Base


class StreetCell(Base):
    __tablename__ = 'street_cells'

    id = Column(Integer, primary_key=True, autoincrement=True)
    cell_id = Column(Integer, ForeignKey('cells.id'), nullable=False)
    cost = Column(Integer)
    color = Column(String(50))
    rent = Column(String(100))  # Stored as string
    group_id = Column(Integer)
    house_cost = Column(Integer)
    cell = relationship('Cell', back_populates='street_cells')
