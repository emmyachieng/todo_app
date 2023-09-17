defmodule TodoApp.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :assigned_user, :string
      add :priority, :string

      timestamps()
    end
  end
end
