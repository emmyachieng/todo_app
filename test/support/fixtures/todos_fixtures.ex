defmodule TodoApp.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.Todos` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        assigned_user: "some assigned_user",
        description: "some description",
        priority: "high",
        title: "some title"
      })
      |> TodoApp.Todos.create_task()

    task
  end
end
