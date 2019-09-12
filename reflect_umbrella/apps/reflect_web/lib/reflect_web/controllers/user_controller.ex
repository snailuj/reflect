defmodule ReflectWeb.UserController do
  use ReflectWeb, :controller

  alias Reflect.Accounts
  alias Reflect.Accounts.User

  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    if not conn.assigns.current_user.is_admin do
      conn
      |> put_flash(:error, "You do not have permission to view that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end

    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user(id)

    changeset =
      cond do
        conn.assigns.current_user.is_admin -> Accounts.change_admin(user)
        conn.assigns.current_user.id == id -> Accounts.change_registration(user)
      end

    if changeset == nil do
      conn
      |> put_flash(:error, "You do not have permission to edit other users") # todo gettext
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => user_id, "user" => user_params}) do
    case Accounts.update_user(user_id, user_params) do
      {:ok, user} ->
        conn
        |> IO.inspect()
        |> put_flash(:info, "User #{user.name} updated") #todo gettext
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> ReflectWeb.Auth.login(user)
        # todo gettext
        |> put_flash(:info, "Welcome #{user.name}")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.delete_user(id) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.name} deleted") # todo gettext
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, %Ecto.Changeset{} = _errorset} ->
        conn
        # todo report specific errors using Changeset.traverse_errors()
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end

  # function plug
  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      # TODO gettext
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
