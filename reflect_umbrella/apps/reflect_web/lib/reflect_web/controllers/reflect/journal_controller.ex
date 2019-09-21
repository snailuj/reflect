defmodule ReflectWeb.Reflect.JournalController do
  use ReflectWeb, :controller

  alias Reflect.Courses
  alias Reflect.Journals
  alias Reflect.Journals.Journal

  def index(conn, _params) do
    journals = Journals.list_journals()
    render(conn, "index.html", journals: journals)
  end

  def new(conn, _params) do
    changeset = Journals.change_journal(%Journal{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"journal" => journal_params}) do
    case Journals.create_journal(journal_params) do
      {:ok, journal} ->
        conn
        |> put_flash(:info, "Journal created successfully.")
        |> redirect(to: Routes.journal_path(conn, :show, journal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    journal =
      Journals.load_full_journal(String.to_integer(id), conn.assigns.current_user)
      |> Courses.load_course()

    {:ok, local_time} = DateTime.now("Australia/Perth")

    render(conn, "show.html", journal: journal, local_date: DateTime.to_date(local_time))
  end

  def edit(conn, %{"id" => id}) do
    journal = Journals.get_journal!(id)
    changeset = Journals.change_journal(journal)
    render(conn, "edit.html", journal: journal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "journal" => journal_params}) do
    journal = Journals.get_journal!(id)

    case Journals.update_journal(journal, journal_params) do
      {:ok, journal} ->
        conn
        |> put_flash(:info, "Journal updated successfully.")
        |> redirect(to: Routes.journal_path(conn, :show, journal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", journal: journal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    journal = Journals.get_journal!(id)
    {:ok, _journal} = Journals.delete_journal(journal)

    conn
    |> put_flash(:info, "Journal deleted successfully.")
    |> redirect(to: Routes.journal_path(conn, :index))
  end
end
