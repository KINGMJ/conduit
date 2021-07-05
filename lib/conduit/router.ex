defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Blog.Aggregates.{Author, Article}
  alias Conduit.Blog.Commands.{CreateAuthor, PublishArticle}
  alias Conduit.Support.Middleware.Uniqueness

  middleware(Uniqueness)

  identify(User, by: :user_uuid, prefix: "user-")
  identify(Author, by: :author_uuid, prefix: "author-")
  identify(Article, by: :article_uuid, prefix: "article-")

  dispatch([CreateAuthor], to: Author)
  dispatch([RegisterUser], to: User)
  dispatch([PublishArticle], to: Article)
end
