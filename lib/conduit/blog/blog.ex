defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Blog.Projections.Article
  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.Blog.Commands.PublishArticle
  alias Conduit.CommandedApp
  alias Conduit.Blog.Queries.ArticleBySlug

  @doc """
  create an author.
  An author shares the same uuid as the user, but with a different prefix.
  """
  def create_author(%{user_uuid: uuid} = attrs) do
    create_author =
      attrs
      |> CreateAuthor.assign_uuid(uuid)
      |> CreateAuthor.new()

    unless create_author.valid? do
      {:error, create_author}
    else
      cmd = Ecto.Changeset.apply_changes(create_author)

      with :ok <- CommandedApp.dispatch(cmd, consistency: :strong) do
        get(Author, uuid)
      else
        reply -> reply
      end
    end
  end

  @doc """
  Publishes an article by the given author.
  """
  def publish_article(%Author{} = author, attrs \\ %{}) do
    uuid = UUID.uuid4()

    publish_article =
      attrs
      |> PublishArticle.assign_uuid(uuid)
      |> PublishArticle.assign_author(author)
      |> PublishArticle.generate_url_slug()
      |> PublishArticle.new()

    unless publish_article.valid? do
      {:error, publish_article}
    else
      cmd = Ecto.Changeset.apply_changes(publish_article)

      with :ok <- CommandedApp.dispatch(cmd, consistency: :strong) do
        get(Article, uuid)
      else
        reply -> reply
      end
    end
  end

  @doc """
  Get an article by its URL slug, or return `nil` if not found.
  """
  def article_by_slug(slug) do
    slug
    |> String.downcase()
    |> ArticleBySlug.new()
    |> Repo.one()
  end

  @doc """
  Get the author for a given uuid.
  """
  def get_author!(uuid) do
    Repo.get!(Author, uuid)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
