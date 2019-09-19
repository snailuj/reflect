defmodule Reflect.Repo.Migrations.CreateReflections do
  use Ecto.Migration

  def change do
    create table(:reflections) do
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :prompt_id, references(:prompts, on_delete: :nothing)

      timestamps()
    end

    create index(:reflections, [:user_id])
    create index(:reflections, [:prompt_id])
  end
end
