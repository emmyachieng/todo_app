defmodule TodoAppWeb.ImageController do
  use TodoAppWeb, :controller

  alias TodoApp.Images
  alias TodoApp.Images.Image

  def index(conn, _params) do
    images = Images.list_images()
    render(conn, :index, images: images)
  end

  def new(conn, _params) do
    changeset = Images.change_image(%Image{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"image" => image_params}) do
    case Images.create_image(image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: ~p"/images/#{image}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    render(conn, :show, image: image)
  end

  def edit(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    changeset = Images.change_image(image)
    render(conn, :edit, image: image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Images.get_image!(id)

    case Images.update_image(image, image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: ~p"/images/#{image}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, image: image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Images.get_image!(id)
    {:ok, _image} = Images.delete_image(image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: ~p"/images")
  end
end
