use Mix.Config

# Configure your database
config :reflect, Reflect.Repo,
  username: "postgres",
  password: "postgres",
  database: "reflect_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :reflect_web, ReflectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
