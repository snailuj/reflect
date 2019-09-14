defmodule Reflect.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users, on_delete: :nothing)
      add :course_id, references(:courses, on_delete: :nothing)
      add :historic, :boolean, default: false

      timestamps()
    end

    create index(:memberships, [:user_id])
    create index(:memberships, [:course_id])
  end
end
