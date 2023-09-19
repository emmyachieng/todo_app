defmodule TodoAppWeb.TaskHTML do
  use TodoAppWeb, :html
  use Phoenix.HTML

  embed_templates "task_html/*"

  @doc """
  Renders a task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def task_form(assigns)

  def assigned_user_email(nil), do: "No assigned user"
  
  def assigned_user_email(user_id) do
    user = TodoApp.Repo.get(TodoApp.Accounts.User, user_id)
    if user do
      user.email
    else
      "User not found"
    end
  end
end
