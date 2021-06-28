defmodule ConduitWeb.ConnHelpers do
  import Plug.Conn
  import Conduit.Fixture
  import ConduitWeb.JWT

  def authenticated_conn(conn) do
    with {:ok, user} <- fixture(:user),
         {:ok, jwt} <- generate_jwt(user) do
      conn
      |> put_req_header("authorization", "Bearer " <> jwt)
    end
  end
end
