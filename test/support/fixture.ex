defmodule Conduit.Fixture do
  import Conduit.Factory
  alias Conduit.{Accounts, Blog}

  def fixture(resource, attrs \\ [])

  # 提供一个已经注册的用户
  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  # 提供一个作者
  def fixture(:author, attrs) do
    build(:author, attrs) |> Blog.create_author()
  end

  # 提供一篇文章
  def fixture(:article, attrs) do
    {author, attrs} = Keyword.pop(attrs, :author)
    Blog.publish_article(author, build(:article, attrs))
  end
end
