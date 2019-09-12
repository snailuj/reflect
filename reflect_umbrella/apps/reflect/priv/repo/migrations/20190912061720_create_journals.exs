defmodule Reflect.Repo.Migrations.CreateJournals do
  use Ecto.Migration

  def change do
    create table(:journals) do
      add :name, :string
      add :tags, :string

      timestamps()
    end

  end
end
