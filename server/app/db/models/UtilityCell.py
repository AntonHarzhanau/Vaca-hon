from sqlalchemy import  Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from app.data.database import Base


class UtilityCell(Base):
    __tablename__ = 'utility_cells'

    id = Column(Integer, primary_key=True, autoincrement=True)
    cell_id = Column(Integer, ForeignKey('cells.id'), nullable=False)
    rent = Column(Integer)
    cost = Column(Integer)
    cell = relationship('Cell', back_populates='utility_cells')
