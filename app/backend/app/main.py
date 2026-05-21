import os
from contextlib import asynccontextmanager

from dotenv import load_dotenv
from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from sqlalchemy.orm import Session

from .database import Base, SessionLocal, engine, get_db
from .models import Task
from .schemas import TaskCreate, TaskRead

load_dotenv()

APP_VERSION = os.getenv("APP_VERSION", "local-dev")


def init_database():
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        if db.query(Task).count() == 0:
            db.add_all(
                [
                    Task(title="Create Docker image", done=False),
                    Task(title="Deploy to Kubernetes", done=False),
                ]
            )
            db.commit()
    finally:
        db.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_database()
    yield


app = FastAPI(
    title="CloudOps Task Tracker API",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health_check(db: Session = Depends(get_db)):
    db.execute(text("SELECT 1"))
    return {"status": "ok", "database": "connected"}


@app.get("/version")
def version():
    return {"version": APP_VERSION}


@app.get("/api/tasks", response_model=list[TaskRead])
def get_tasks(db: Session = Depends(get_db)):
    return db.query(Task).order_by(Task.id).all()


@app.post("/api/tasks", response_model=TaskRead, status_code=201)
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    db_task = Task(title=task.title, done=False)

    db.add(db_task)
    db.commit()
    db.refresh(db_task)

    return db_task
