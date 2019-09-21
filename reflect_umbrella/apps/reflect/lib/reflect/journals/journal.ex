defmodule Reflect.Journals.Journal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reflect.Courses.Course
  alias Reflect.Journals.Entry

  schema "journals" do
    field :name, :string
    field :tags, :string

    belongs_to :course, Course
    has_many :entrys, Entry

    timestamps()
  end

  @doc false
  def changeset(journal, attrs) do
    journal
    |> cast(attrs, [:name, :tags])
    |> validate_required([:name, :tags])
  end
end
