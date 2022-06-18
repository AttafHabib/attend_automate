defmodule App.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :app,
      module: App.Guardian,
      error_handler: App.Guardian.ErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
#  plug Data.Plug.Auth
end
