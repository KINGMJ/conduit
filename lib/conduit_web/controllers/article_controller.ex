defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article
  alias Conduit.Auth.Guardian

  action_fallback ConduitWeb.FallbackController

  def index(conn, params) do
    params = Map.new(params, fn {k, v} -> {String.to_atom(k), v} end)
    {articles, total_count} = Blog.list_articles(params)
    render(conn, "index.json", articles: articles, total_count: total_count)
  end

  def create(conn, %{"article" => article_params}) do
    # 将字符串参数转换为atom
    article_params = Map.new(article_params, fn {k, v} -> {String.to_atom(k), v} end)

    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.publish_article(author, article_params) do
      conn
      |> put_status(:created)
      |> render("show.json", article: article)
    end
  end
end
