defmodule ReflectWeb.ReflectionController do
  use ReflectWeb, :controller

  alias Reflect.Reflections
  alias Reflect.Reflections.Reflection

  def index(conn, _params) do
    reflections = Reflections.list_reflections()
    render(conn, "index.html", reflections: reflections)
  end

  def new(conn, _params) do
    changeset = Reflections.change_reflection(%Reflection{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reflection" => reflection_params}) do
    case Reflections.create_reflection(reflection_params) do
      {:ok, reflection} ->
        conn
        |> put_flash(:info, "Reflection created successfully.")
        |> redirect(to: Routes.reflection_path(conn, :show, reflection))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reflection = Reflections.get_reflection!(id)
    render(conn, "show.html", reflection: reflection)
  end

  def edit(conn, %{"id" => id}) do
    reflection = Reflections.get_reflection!(id)
    changeset = Reflections.change_reflection(reflection)
    render(conn, "edit.html", reflection: reflection, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reflection" => reflection_params}) do
    reflection = Reflections.get_reflection!(id)

    case Reflections.update_reflection(reflection, reflection_params) do
      {:ok, reflection} ->
        conn
        |> put_flash(:info, "Reflection updated successfully.")
        |> redirect(to: Routes.reflection_path(conn, :show, reflection))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reflection: reflection, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reflection = Reflections.get_reflection!(id)
    {:ok, _reflection} = Reflections.delete_reflection(reflection)

    conn
    |> put_flash(:info, "Reflection deleted successfully.")
    |> redirect(to: Routes.reflection_path(conn, :index))
  end
end
