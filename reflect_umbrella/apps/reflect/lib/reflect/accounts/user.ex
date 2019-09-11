defmodule Reflect.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :email])
    |> unique_constraint(:email)
    |> validate_required([:name, :email])
    # TODO improve validation in line with
    # https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html#email-validation-basics
    |> validate_format(:email, ~r/@/, "invalid email address")
  end

  def registration_changeset(user, attrs \\ %{}) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 8, max: 128)
    |> validate_format(
      :password,
      ~r/(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])/,
      # TODO gettext
      "must contain at least one lowercase letter, one uppercase letter and one number"
    )
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))

      _ ->
        # don't transform the changeset if not valid or password not changed
        changeset
    end
  end
end
