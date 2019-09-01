# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank_es,
  ecto_repos: [BankEs.Repo]

# Configures the endpoint
config :bank_es, BankEsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "plD0xP2r52DKYJa/kfOqJx29PYr6lI3bFBylepni7Ju7QaVgAUc9YyhCVGw1XTs4",
  render_errors: [view: BankEsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BankEs.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: BankEs.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
