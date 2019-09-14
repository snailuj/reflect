defmodule Reflect.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :short_description, :string
      add :tags, :string
      add :description, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime

      timestamps()
    end

  end
end
