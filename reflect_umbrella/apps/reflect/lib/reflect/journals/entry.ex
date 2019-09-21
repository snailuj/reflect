defmodule Reflect.Journals.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reflect.Journals.Journal
  alias Reflect.Reflections.Prompt

  schema "entrys" do
    field :occurs, :utc_datetime
    field :order, :integer
    field :tags, :string
    field :title, :string

    belongs_to :journal, Journal
    has_many :prompts, Prompt

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :order, :occurs, :tags])
    |> validate_required([:title, :order, :occurs, :tags])
  end
end
