defmodule Reflect.Reflections.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prompts" do
    field :description, :string
    field :label, :string
    field :order, :integer
    field :tags, :string
    field :type, :string
    field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:order, :label, :description, :type, :tags])
    |> validate_required([:order, :label, :description, :type, :tags])
  end
end
