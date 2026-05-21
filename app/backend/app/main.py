import os
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from pydantic import BaseModel

APP_VERSION = os.getenv("APP_VERSION", "local-dev")

app = FastAPI(title="CloudOps Task Tracker API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Task(BaseModel):
    id: int
    title: str
    done: bool = False


tasks = [
    Task(id=1, title="Create Docker image", done=False),
    Task(id=2, title="Deploy to Kubernetes", done=False),
]


@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.get("/version")
def version():
    return {"version": APP_VERSION}


@app.get("/api/tasks")
def get_tasks():
    return tasks


@app.post("/api/tasks")
def create_task(title: str):
    new_task = Task(id=len(tasks) + 1, title=title, done=False)
    tasks.append(new_task)
    return new_task
