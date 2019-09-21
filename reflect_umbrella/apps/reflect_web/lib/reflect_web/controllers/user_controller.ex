defmodule ReflectWeb.UserController do
  use ReflectWeb, :controller

  alias Reflect.Accounts
  alias Reflect.Courses
  alias Reflect.Accounts.User

  plug :is_logged_in, nil when action in [:show, :edit, :update]

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user =
      Accounts.get_user(id)
      |> Courses.load_courses()

    if user.id != conn.assigns.current_user.id do
      conn
      # todo gettext
      |> put_flash(:error, "You do not have permission to view other users")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end

    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user(id)

    if user.id != conn.assigns.current_user.id do
      conn.assigns.current_user.id |> IO.inspect(label: "JSJSJS")

      conn
      # todo gettext
      |> put_flash(:error, "You do not have permission to edit other users")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end

    changeset = Accounts.change_registration(user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => user_id, "user" => user_params}) do
    case Accounts.update_user_registration(user_id, user_params) do
      {:ok, user} ->
        conn
        # todo gettext
        |> put_flash(:info, "User #{user.name} updated")
        |> redirect(to: Routes.admin_user_path(conn, :index))

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
        |> halt()

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
