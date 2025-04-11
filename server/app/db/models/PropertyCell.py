from sqlalchemy import  Column, Integer, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from app.data.database import Base





class PropertyCell(Base):
    __tablename__ = 'propertycell'

    id = Column(Integer, primary_key=True, autoincrement=True)
    cell_id = Column(Integer, ForeignKey('cells.id'), nullable=False)
    price = Column(Integer)
    mortgaged = Column(Boolean, default=False)
    rent = Column(Integer)
    cell = relationship('Cell', back_populates='property_cells')
