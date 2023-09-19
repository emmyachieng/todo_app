defmodule TodoAppWeb.TaskController do
  use TodoAppWeb, :controller

  alias TodoApp.Accounts.User
  alias TodoApp.Todos
  alias TodoApp.Todos.Task
  import Ecto.Query, warn: false
  alias TodoApp.Repo

  def index(conn, params) do
    tasks = Todos.list_tasks(Map.get(params, "search_query"))
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

  # def create(conn, %{"task" => task_params}) do
  #   task_params =
  #     if task_params["assigned_user"] == "" or is_nil(task_params["assigned_user"]) do
  #       Map.delete(task_params, "assigned_user")
  #     else
  #       email = task_params["assigned_user"]
  #       assigned_user = find_or_create_user_by_email(email)
  #       Map.put(task_params, "assigned_user_id", assigned_user.id)
  #     end

  #   # Handle file upload
  #   {conn, task_params_with_files} = handle_file_upload(conn, task_params)

  #   task_changeset = %Task{}
  #     |> Task.changeset(task_params_with_files)

  #   case Repo.insert(task_changeset) do
  #     {:ok, _task} ->
  #       conn
  #       |> put_flash(:info, "Task created successfully.")
  #       |> redirect(to: ~p"/tasks")

  #     {:error, changeset} ->
  #       render(conn, :new, task: changeset)
  #   end
  # end

  # defp handle_file_upload(conn, task_params) do
  #   case Arc.Store.uploads(conn, :file) do
  #     [] -> {conn, task_params}
  #     [file | _] ->
  #       {conn, Map.put(task_params, "file", %Arc.File{file | original_name: file.name})}
  #   end
  # end

  # def create_task_with_documents(attrs) do
  #   task_params = Map.take(attrs, ~w(title description assigned_user_email priority))
  #   task_documents = Map.get(attrs, "task_documents", [])

  #   case Tasks.create_task(task_params) do
  #     {:ok, task} ->
  #       task
  #       |> Task.add_task_documents(task_documents)
  #       |> Repo.preload(:task_documents)
  #       |> {:ok, task}

  #     {:error, changeset} ->
  #       {:error, changeset}
  #   end
  # end

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
