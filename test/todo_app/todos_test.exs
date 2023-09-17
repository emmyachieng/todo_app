defmodule TodoApp.TodosTest do
  use TodoApp.DataCase

  alias TodoApp.Todos

  describe "tasks" do
    alias TodoApp.Todos.Task

    import TodoApp.TodosFixtures

    @invalid_attrs %{assigned_user_id: nil, description: nil, priority: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Todos.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Todos.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{assigned_user_id: 2, description: "some description", priority: "high", title: "some title"}

      assert {:ok, %Task{} = task} = Todos.create_task(valid_attrs)
      assert task.assigned_user_id == 2
      assert task.description == "some description"
      assert task.priority == "high"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{assigned_user_id: 2, description: "some updated description", priority: "low", title: "some updated title"}

      assert {:ok, %Task{} = task} = Todos.update_task(task, update_attrs)
      assert task.assigned_user_id == 2
      assert task.description == "some updated description"
      assert task.priority == "low"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_task(task, @invalid_attrs)
      assert task == Todos.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Todos.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Todos.change_task(task)
    end
  end
end
