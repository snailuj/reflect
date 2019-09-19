defmodule Reflect.Repo.Migrations.CreateEntrys do
  use Ecto.Migration

  def change do
    create table(:entrys) do
      add :title, :string
      add :order, :integer
      add :occurs, :utc_datetime
      add :tags, :string
      add :journal_id, references(:journals, on_delete: :nothing)

      timestamps()
    end

    create index(:entrys, [:journal_id])
  end
end
