defmodule Reflect.Journals.Journal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journals" do
    field :name, :string
    field :tags, :string
    field :course_id, :id

    timestamps()
  end

  @doc false
  def changeset(journal, attrs) do
    journal
    |> cast(attrs, [:name, :tags])
    |> validate_required([:name, :tags])
  end
end
