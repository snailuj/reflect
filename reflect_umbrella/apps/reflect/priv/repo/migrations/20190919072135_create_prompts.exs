defmodule Reflect.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :order, :integer
      add :label, :string
      add :description, :text
      add :type, :string
      add :tags, :string
      add :entry_id, references(:entrys, on_delete: :nothing)

      timestamps()
    end

    create index(:prompts, [:entry_id])
  end
end
