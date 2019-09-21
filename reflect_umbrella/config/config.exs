# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

config :elixir,
  :time_zone_database, Tzdata.TimeZoneDatabase

# Configure Mix tasks and generators
config :reflect,
  ecto_repos: [Reflect.Repo]

config :reflect_web,
  ecto_repos: [Reflect.Repo],
  generators: [context_app: :reflect]

# Configures the endpoint
config :reflect_web, ReflectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OV3y8Jde8w4DW30r6LYKELI/fQJMb8R7SM/bVu8eQ46EBtra3hhq62/ggqCWkIQ5",
  render_errors: [view: ReflectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ReflectWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
