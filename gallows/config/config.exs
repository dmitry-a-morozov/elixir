# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :gallows, GallowsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aOCI9EnxvL4qVxG3orSGmvxUfg9ZZY3/iGaK4h8/go47ZWvwEI3Kkq7vg+b5zk16",
  render_errors: [view: GallowsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gallows.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
