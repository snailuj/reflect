defmodule Reflect.Courses.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "memberships" do
    field :historic, :boolean, default: false

    belongs_to :user, Reflect.Accounts.User
    belongs_to :course, Reflect.Courses.Course

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [])
  end
end
