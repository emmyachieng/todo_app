defmodule TodoApp.Images.Image do
  use Ecto.Schema
  #use Imageer.Web, :model
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :image, TodoApp.ImageUploader.Type

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image])
    |> cast_attachments(params, [:image])
  end

end
