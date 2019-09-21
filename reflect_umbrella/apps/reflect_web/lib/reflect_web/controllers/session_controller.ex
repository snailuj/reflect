defmodule ReflectWeb.SessionController do
  use ReflectWeb, :controller

  alias Reflect.Accounts
  alias Reflect.Accounts.User
  alias Reflect.Courses
  alias Reflect.Journals

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Accounts.authenticate_by_email_and_pass(email, pass) do
      {:ok, %User{is_admin: true} = user} ->
        conn
        |> ReflectWeb.Auth.login(user)
        |> put_flash(:info, "Welcome #{user.name}") # todo gettext
        |> redirect(to: Routes.page_path(conn, :index))
      {:ok, user} ->
        # TODO hack
        course = Courses.get_course_by(%{name: "Mindfulness for Inner Peace"})
        |> Journals.load_journals

        journal = Enum.at(course.journals, 0)

        conn
        |> ReflectWeb.Auth.login(user)
        |> put_flash(:info, "Welcome #{user.name}") # todo gettext
        |> redirect(to: Routes.reflect_journal_path(conn, :show, journal.id))
        |> halt()
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
