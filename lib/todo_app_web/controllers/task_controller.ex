defmodule TodoAppWeb.TaskController do
  use TodoAppWeb, :controller

  alias TodoApp.Accounts.User
  alias TodoApp.Todos
  alias TodoApp.Todos.Task
  import Ecto.Query, warn: false
  alias TodoApp.Repo

  def index(conn, _params) do
    tasks = Todos.list_tasks()
    render(conn, :index, tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Todos.change_task(%Task{})
    render(conn, :new, changeset: changeset)
  end


  def create(conn, %{"task" => task_params}) do
    task_params =
      if task_params["assigned_user"] == "" or is_nil(task_params["assigned_user"]) do
        Map.delete(task_params, "assigned_user")
      else
        email = task_params["assigned_user"]
        assigned_user = find_or_create_user_by_email(email)
        Map.put(task_params, "assigned_user_id", assigned_user.id)
      end

    task_changeset = %Task{}
      |> Task.changeset(task_params)

    case Repo.insert(task_changeset) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, changeset} ->
        render(conn, :new, task: changeset)
    end
  end

  defp find_or_create_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        %User{email: email}
        |> User.registration_changeset(%{password: "some_default_password"})
        |> Repo.insert()
      user -> user
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
