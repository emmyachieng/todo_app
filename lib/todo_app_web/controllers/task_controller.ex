defmodule TodoAppWeb.TaskController do
  use TodoAppWeb, :controller

  alias TodoApp.Todos
  alias TodoApp.Todos.Task

  def index(conn, _params) do
    tasks = Todos.list_tasks()
    render(conn, :index, tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Todos.change_task(%Task{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Todos.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todos.get_task!(id)
    render(conn, :show, task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Todos.get_task!(id)
    changeset = Todos.change_task(task)
    render(conn, :edit, task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todos.get_task!(id)

    case Todos.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todos.get_task!(id)
    {:ok, _task} = Todos.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end
end