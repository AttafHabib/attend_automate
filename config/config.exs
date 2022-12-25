# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :app,
  ecto_repos: [App.Repo]

config :app_web,
  ecto_repos: [App.Repo],
  generators: [context_app: :app]

# Configures the endpoint
config :app_web, AppWeb.Endpoint,
  url: [host: "localhost"],
  check_origin: true,
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "dVh8UFAh"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/app_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :app, App.Guardian,
  issuer: "app",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :app, App.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: System.get_env("MAILER_KEY"),
  email_base_url: System.get_env("EMAIL_BASE_URL"),
  username: System.get_env("MAILER_USERNAME")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
