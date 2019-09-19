defmodule Reflect.Reflections.Reflection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reflections" do
    field :value, :string
    field :user_id, :id
    field :prompt_id, :id

    timestamps()
  end

  @doc false
  def changeset(reflection, attrs) do
    reflection
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
