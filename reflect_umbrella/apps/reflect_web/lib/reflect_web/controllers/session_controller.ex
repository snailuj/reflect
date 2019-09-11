defmodule ReflectWeb.SessionController do
  use ReflectWeb, :controller

  alias Reflect.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Accounts.authenticate_by_email_and_pass(email, pass) do
      {:ok, user} ->
        conn
        |> ReflectWeb.Auth.login(user)
        |> put_flash(:info, "Welcome #{user.name}") # todo gettext
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Unknown email/password combination") # todo gettext
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ReflectWeb.Auth.logout()
    |> put_flash(:info, "Logged out") # todo gettext
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
