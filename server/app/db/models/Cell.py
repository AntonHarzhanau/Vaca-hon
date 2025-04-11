from sqlalchemy import  Column, Integer, String, Boolean, ForeignKey
from app.data.database import Base
from sqlalchemy.orm import relationship


class Cell(Base):
    __tablename__ = 'cells'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    type = Column(String, nullable=False)


     # Relation vers CornerCell
    corner_cells = relationship('CornerCell', back_populates='cell')

    # Relation vers EventCell
    event_cells = relationship('EventCell', back_populates='cell')

    # Relation vers PropertyCell
    property_cells = relationship('PropertyCell', back_populates='cell')

    # Relation vers StreetCell
    street_cells = relationship('StreetCell', back_populates='cell')

    # Relation vers UtilityCell
    utility_cells = relationship('UtilityCell', back_populates='cell')

    # Relation vers RailwayCell
    railway_cells = relationship('RailwayCell', back_populates='cell')





