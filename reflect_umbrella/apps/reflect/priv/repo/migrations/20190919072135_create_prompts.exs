defmodule Reflect.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :order, :integer
      add :label, :string
      add :description, :text
      add :type, :string
      add :tags, :string
      add :event_id, references(:entrys, on_delete: :nothing)

      timestamps()
    end

    create index(:prompts, [:event_id])
  end
end
