defmodule TodoApp.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string
    field :priority, :string
    field :title, :string
    belongs_to :users, TodoApp.Accounts.User, foreign_key: :assigned_user_id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    
    task
    |> cast(attrs, [:title, :description, :assigned_user_id, :priority])
    |> validate_required([:title, :description, :priority])
    |> validate_inclusion(:priority, ["high", "low", "medium", "deadline"])
    #|> validate_format(:assigned_user_id, ~r/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
  end
end
