defmodule Reflect.Reflections.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reflect.Journals.Entry
  alias Reflect.Reflections.Reflection

  schema "prompts" do
    field :description, :string
    field :label, :string
    field :order, :integer
    field :tags, :string
    field :type, :string

    belongs_to :entry, Entry
    has_many :reflections, Reflection

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:order, :label, :description, :type, :tags])
    |> validate_required([:order, :label, :type])
  end
end
