defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: __MODULE__,
    application: Conduit.CommandedApp,
    repo: Conduit.Repo,
    consistency: :strong

  alias Conduit.Blog.Events.ArticlePublished
  alias Conduit.Blog.Projections.{Article, Author}
  alias Conduit.Repo

  project(%ArticlePublished{} = published, %{created_at: published_at}, fn multi ->
    multi
    |> Ecto.Multi.run(:author, fn _repo, _changes -> get_author(published.author_uuid) end)
    |> Ecto.Multi.run(:article, fn _repo, %{author: author} ->
      article = %Article{
        uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        favorite_count: 0,
        published_at: published_at,
        author_uuid: author.uuid,
        author_username: author.username,
        author_bio: author.bio,
        author_image: author.image
      }
      Repo.insert(article)
    end)
  end)

  defp get_author(uuid) do
    case Repo.get(Author, uuid) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
