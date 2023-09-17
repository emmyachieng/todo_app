defmodule TodoApp.Repo.Migrations.AlterTasksTable do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :assigned_user, :citext
      add :assigned_user_id, references(:users, on_delete: :nothing)
  
    end
    create index(:tasks, [:assigned_user_id])
  end
end
