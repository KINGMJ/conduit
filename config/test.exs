use Mix.Config

# Configure the read store database
config :conduit, Conduit.Repo,
  username: "postgres",
  password: "123456",
  database: "conduit_readstore_test",
  hostname: "localhost",
  pool_size: 10

# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :conduit, Conduit.Repo,
  username: "postgres",
  password: "postgres",
  database: "conduit_test#{System.get_env("MIX_TEST_PARTITION")}",
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
