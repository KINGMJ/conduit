defmodule ConduitWeb.SessionControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authenticate user" do
    @tag :web
    test "creates session and renders session when data is invalid", %{conn: conn} do
      register_user()

      conn =
        post conn, Routes.session_path(conn, :create),
          user: %{
            email: "jake@jake.jake",
            password: "jakejake"
          }

      assert json_response(conn, 201)["user"] == %{
               "bio" => nil,
               "email" => "jake@jake.jake",
               "image" => nil,
               "username" => "jake"
             }
    end
  end

  defp register_user, do: fixture(:user)
end
