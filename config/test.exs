use Mix.Config

# Configure the read store database
config :conduit, Conduit.Repo,
  username: "postgres",
  password: "123456",
  database: "conduit_readstore_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure the event store database
config :conduit, Conduit.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "123456",
  database: "conduit_eventstore_test",
  hostname: "localhost",
  pool_size: 10

# Configure the Bcrypt
config :bcrypt_elixir, log_rounds: 4
