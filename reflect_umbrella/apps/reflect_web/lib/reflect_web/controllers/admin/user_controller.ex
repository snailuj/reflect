defmodule ReflectWeb.Admin.UserController do
  use ReflectWeb, :controller

  alias Reflect.Accounts
  alias Reflect.Courses
  alias Reflect.Accounts.User

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def edit(conn, %{"id" => id}) do
    user =
      Accounts.get_user(id)
      |> Courses.load_courses()

    changeset = Accounts.change_admin(user)

    render(conn, "edit.html", changeset: changeset, user: user)
  end

  def update(conn, %{"id" => user_id, "user" => user_params}) do
    case Accounts.update_user_admin(user_id, user_params) do
      {:ok, user} ->
        conn
        # todo gettext
        |> put_flash(:info, "User #{user.name} updated")
        |> redirect(to: Routes.admin_user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.delete_user(id) do
      {:ok, user} ->
        conn
        # todo gettext
        |> put_flash(:info, "User #{user.name} deleted")
        |> redirect(to: Routes.admin_user_path(conn, :index))
        |> halt()

      {:error, %Ecto.Changeset{} = _errorset} ->
        conn
        # todo report specific errors using Changeset.traverse_errors()
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: Routes.admin_user_path(conn, :index))
        |> halt()
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_admin(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user_admin(user_params) do
      {:ok, user} ->
        conn
        # todo gettext
        |> put_flash(:info, "User #{user.name} created")
        |> redirect(to: Routes.admin_user_path(conn, :index))
        |> halt()

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end
end
