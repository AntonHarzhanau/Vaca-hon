# utils/filtering.py

from sqlalchemy.orm import DeclarativeMeta
from pydantic import BaseModel
from typing import List
from sqlalchemy.sql import and_

def build_filters(model: DeclarativeMeta, filter_obj: BaseModel) -> List:
    conditions = []
    for field, value in filter_obj.model_dump(exclude_unset=True).items():
        if hasattr(model, field):
            column = getattr(model, field)
            conditions.append(column == value)
    return conditions