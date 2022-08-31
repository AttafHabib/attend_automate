defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug App.Guardian.Pipeline
  end

  pipeline :ensure_auth do
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :login do
    plug :put_root_layout, {AppWeb.LayoutView, :login}
  end

  scope "/", AppWeb do
    pipe_through [:browser, :login]

    post "/login", SessionController, :login
  end

  scope "/", AppWeb do
    pipe_through [:browser, :auth, :login]

#    get "/", PageController, :index
    live "/", SessionLive.Login, :login
    live "/login", SessionLive.Login, :login
  end

  scope "/", AppWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    live "/dashboard", DashboardLive.Index, :index
    live "/courses", CourseLive.Index, :index, container: {:section, class: "section_container"}
    live "/courses/:id", CourseLive.Show, :show, container: {:section, class: "section_container"}
    live "/users", UserLive.Index, :index, container: {:section, class: "section_container"}
    live "/students", StudentLive.Index, :index, container: {:section, class: "section_container"}
    live "/students/:id", StudentLive.Show, :show, container: {:section, class: "section_container"}
    live "/students/:id/action/:action", StudentLive.FaceExtract, :show, container: {:section, class: "section_container"}
    live "/departments", DepartmentLive.Index, :index, container: {:section, class: "section_container"}
    live "/teachers", TeacherLive.Index, :index, container: {:section, class: "section_container"}

    live "/attendance", AttendanceLive.Index, :index, container: {:section, class: "section_container"}

    get "/logout", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end
end
