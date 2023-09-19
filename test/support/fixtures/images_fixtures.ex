defmodule TodoApp.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        image: "some image"
      })
      |> TodoApp.Images.create_image()

    image
  end
end
