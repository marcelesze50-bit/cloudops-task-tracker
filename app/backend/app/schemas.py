from pydantic import BaseModel, ConfigDict


class TaskCreate(BaseModel):
    title: str


class TaskRead(BaseModel):
    id: int
    title: str
    done: bool

    model_config = ConfigDict(from_attributes=True)
