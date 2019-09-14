defmodule Reflect.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :description, :string
    field :end_date, :utc_datetime
    field :name, :string
    field :short_description, :string
    field :start_date, :utc_datetime
    field :tags, :string

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :short_description, :tags, :description, :start_date, :end_date])
    |> validate_required([:name, :tags, :start_date, :end_date])
  end
end
