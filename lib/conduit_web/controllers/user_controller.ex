defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User
  alias Conduit.Auth.Guardian

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    # 将字符串参数转换为atom
    user_params = Map.new(user_params, fn {k, v} -> {String.to_atom(k), v} end)

    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
         {:ok, jwt} = generate_jwt(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, jwt: jwt)
    end
  end

  def current(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    jwt = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end
end
