defmodule ReflectWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias ReflectWeb.Router.Helpers, as: Routes

  alias Reflect.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user!(user_id)

    put_current_user(conn, user)
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def is_logged_in(conn = %{assigns: %{current_user: %Reflect.Accounts.User{}}}, _), do: conn

  def is_logged_in(conn, _) do
    conn
    |> IO.inspect()
    |> put_flash(:error, "You must be logged in to access that page") # todo gettext
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end

  def is_admin(conn = %{assigns: %{is_admin: true}}, _), do: conn

  def is_admin(conn, opts) do
    if opts[:pokerface] do
      conn
      |> put_status(404)
      |> render(ErrorView, :"404", message: "Page not found") # todo gettext
      |> halt()
    end

    conn
    |> put_flash(:error, "You do not have access to that page") # todo gettext
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  def put_current_user(conn, user) do
    conn
    |> assign(:current_user, user)
    |> assign(
      :is_admin,
      !!user && user.is_admin
    )
  end
end
