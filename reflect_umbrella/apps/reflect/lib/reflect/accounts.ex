defmodule Reflect.Accounts do
  @moduledoc """
  The Accounts context. Handles user registration and fetching.
  """

  alias Reflect.Repo
  alias Reflect.Accounts
  alias Reflect.Accounts.User

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(id, attrs) do
    get_user(id)
    |> User.admin_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) do
    get_user(id)
    |> Repo.delete()
  end

  def change_user(%User{} = user) do
    User.changeset(user)
  end

  def change_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  def change_admin(%User{} = user, attrs \\ %{}) do
    User.admin_changeset(user, attrs)
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    user = Accounts.get_user_by(%{email: email})

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        {:error, :not_found}
    end
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def list_users() do
    Repo.all(User)
  end
end
