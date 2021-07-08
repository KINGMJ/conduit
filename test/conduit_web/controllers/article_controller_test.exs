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

  describe "list articles" do
    setup [
      :create_author,
      :publish_articles
    ]

    @tag :web
    test "should return published articles by date published", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      json = json_response(conn, 200)
      articles = json["articles"]
      first_created_at = Enum.at(articles, 0)["created_at"]
      first_updated_at = Enum.at(articles, 0)["updated_at"]
      second_created_at = Enum.at(articles, 1)["created_at"]
      second_updated_at = Enum.at(articles, 1)["updated_at"]

      assert json == %{
               "articles" => [
                 %{
                   "slug" => "how-to-train-your-dragon-2",
                   "title" => "How to train your dragon 2",
                   "description" => "So toothless",
                   "body" => "It a dragon",
                   "tag_list" => ["dragons", "training"],
                   "created_at" => first_created_at,
                   "updated_at" => first_updated_at,
                   "favorited" => false,
                   "favorites_count" => 0,
                   "author" => %{
                     "username" => "jake",
                     "bio" => nil,
                     "image" => nil,
                     "following" => false
                   }
                 },
                 %{
                   "slug" => "how-to-train-your-dragon",
                   "title" => "How to train your dragon",
                   "description" => "Ever wonder how?",
                   "body" => "You have to believe",
                   "tag_list" => ["dragons", "training"],
                   "created_at" => second_created_at,
                   "updated_at" => second_updated_at,
                   "favorited" => false,
                   "favorites_count" => 0,
                   "author" => %{
                     "username" => "jake",
                     "bio" => nil,
                     "image" => nil,
                     "following" => false
                   }
                 }
               ],
               "articles_count" => 2
             }
    end

    defp create_author(_context) do
      {:ok, author} = fixture(:author, user_uuid: UUID.uuid4())
      %{author: author}
    end

    defp publish_articles(%{author: author}) do
      fixture(:article, author: author)

      fixture(:article,
        author: author,
        title: "How to train your dragon 2",
        description: "So toothless",
        body: "It a dragon"
      )

      %{}
    end
  end
end
