defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "publish article" do
    @tag :web
    test "should create and return article when data is valid", %{conn: conn} do
      conn =
        post authenticated_conn(conn), Routes.article_path(conn, :create),
          article: build(:article)

      json = json_response(conn, 201)["article"]
      created_at = json["created_at"]
      updated_at = json["updated_at"]

      assert json == %{
               "slug" => "how-to-train-your-dragon",
               "title" => "How to train your dragon",
               "description" => "Ever wonder how?",
               "body" => "You have to believe",
               "tag_list" => ["dragons", "training"],
               "created_at" => created_at,
               "updated_at" => updated_at,
               "favorited" => false,
               "favorites_count" => 0,
               "author" => %{
                 "username" => "jake",
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }

      refute created_at == ""
      refute updated_at == ""
    end
  end
end
