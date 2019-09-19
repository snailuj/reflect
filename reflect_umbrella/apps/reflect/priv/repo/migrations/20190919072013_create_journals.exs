defmodule Reflect.Repo.Migrations.CreateJournals do
  use Ecto.Migration

  def change do
    create table(:journals) do
      add :name, :string
      add :tags, :string
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end

    create index(:journals, [:course_id])
  end
end
