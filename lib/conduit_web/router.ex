defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.VerifyHeader,
      module: Conduit.Auth.Guardian,
      error_handler: ConduitWeb.ErrorHandler,
      claims: %{"typ" => "access"}

    plug Guardian.Plug.LoadResource,
      module: Conduit.Auth.Guardian,
      error_handler: ConduitWeb.ErrorHandler,
      allow_blank: true
  end

  # 验证token
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated,
      module: Conduit.Auth.Guardian,
      error_handler: ConduitWeb.ErrorHandler,
      claims: %{"typ" => "access"}
  end

  scope "/api", ConduitWeb do
    pipe_through :api
    post "/users/login", SessionController, :create
    post "/users", UserController, :create

    # 对于下面这些路由，都需要验证token
    pipe_through :ensure_auth
    get "/user", UserController, :current
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ConduitWeb.Telemetry
    end
  end
end
