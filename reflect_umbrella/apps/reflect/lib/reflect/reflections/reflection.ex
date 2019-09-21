defmodule Reflect.Reflections.Reflection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reflect.Accounts.User
  alias Reflect.Reflections.Prompt

  schema "reflections" do
    field :value, :string

    belongs_to :user, User
    belongs_to :prompt, Prompt

    timestamps()
  end

  @doc false
  def changeset(reflection, attrs) do
    reflection
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
