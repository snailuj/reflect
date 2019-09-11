defmodule Reflect.Repo do
  use Ecto.Repo,
    otp_app: :reflect,
    adapter: Ecto.Adapters.Postgres
end
