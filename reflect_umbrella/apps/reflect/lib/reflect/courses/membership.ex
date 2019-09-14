defmodule Reflect.Courses.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "memberships" do
    field :user_id, :id
    field :course_id, :id
    field :historic, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [])
    |> validate_required([])
  end
end
