defmodule ReflectWeb.Admin.MembershipController do
  use ReflectWeb, :controller

  alias Reflect.Courses
  alias Reflect.Courses.Membership

  def index(conn, _params) do
    memberships = Courses.list_memberships()
    render(conn, "index.html", memberships: memberships)
  end

  def new(conn, _params) do
    changeset = Courses.change_membership(%Membership{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"membership" => membership_params}) do
    case Courses.create_membership(membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "Membership created successfully.")
        |> redirect(to: Routes.admin_membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    membership = Courses.get_membership!(id)
    render(conn, "show.html", membership: membership)
  end

  def edit(conn, %{"id" => id}) do
    membership = Courses.get_membership!(id)
    changeset = Courses.change_membership(membership)
    render(conn, "edit.html", membership: membership, changeset: changeset)
  end

  def update(conn, %{"id" => id, "membership" => membership_params}) do
    membership = Courses.get_membership!(id)

    case Courses.update_membership(membership, membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "Membership updated successfully.")
        |> redirect(to: Routes.admin_membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", membership: membership, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership = Courses.get_membership!(id)
    {:ok, _membership} = Courses.delete_membership(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: Routes.admin_membership_path(conn, :index))
  end
end
