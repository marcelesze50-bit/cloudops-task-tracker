const API_URL = window.API_URL || "http://localhost:8000";

const taskList = document.getElementById("task-list");
const taskForm = document.getElementById("task-form");
const taskInput = document.getElementById("task-input");
const apiStatus = document.getElementById("api-status");
const apiVersion = document.getElementById("api-version");

async function loadStatus() {
  try {
    const healthResponse = await fetch(`${API_URL}/health`);
    const versionResponse = await fetch(`${API_URL}/version`);

    if (!healthResponse.ok || !versionResponse.ok) {
      throw new Error("API returned an error");
    }

    const versionData = await versionResponse.json();

    apiStatus.textContent = "API: online";
    apiVersion.textContent = `Version: ${versionData.version}`;
  } catch (error) {
    apiStatus.textContent = "API: offline";
    apiVersion.textContent = "Version: unavailable";
  }
}

async function loadTasks() {
  taskList.innerHTML = "";

  try {
    const response = await fetch(`${API_URL}/api/tasks`);

    if (!response.ok) {
      throw new Error("Could not load tasks");
    }

    const tasks = await response.json();

    tasks.forEach((task) => {
      const item = document.createElement("li");
      item.textContent = task.done ? `${task.title} - done` : task.title;
      taskList.appendChild(item);
    });
  } catch (error) {
    const item = document.createElement("li");
    item.textContent = "Could not load tasks from API.";
    taskList.appendChild(item);
  }
}

taskForm.addEventListener("submit", async (event) => {
  event.preventDefault();

  const title = taskInput.value.trim();

  if (!title) {
    return;
  }

  await fetch(`${API_URL}/api/tasks?title=${encodeURIComponent(title)}`, {
    method: "POST",
  });

  taskInput.value = "";
  await loadTasks();
});

loadStatus();
loadTasks();
