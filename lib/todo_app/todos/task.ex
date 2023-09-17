defmodule TodoApp.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :assigned_user, :string
    field :description, :string
    field :priority, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :assigned_user, :priority])
    |> validate_required([:title, :description, :assigned_user, :priority])
    |> validate_inclusion(:priority, ["high", "low", "medium", "deadline"])
  end
end
