defmodule Conduit.Blog.Commands.PublishArticle do
  use Commanded.Command,
    article_uuid: :binary_id,
    author_uuid: :binary_id,
    slug: :string,
    title: :string,
    description: :string,
    body: :string,
    tag_list: {{:array, :string}, []}

  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Slugger
  alias Conduit.Support.Middleware.Uniqueness.UniqueFields

  def handle_validate(changeset) do
    changeset
    |> validate_required([
      :article_uuid,
      :author_uuid,
      :slug,
      :title,
      :description,
      :body,
      :tag_list
    ])
    |> validate_format(:slug, ~r/^[a-z0-9\-]+$/, message: "is invalid")
  end

  @doc """
  Assign a unique identity for the article
  """
  def assign_uuid(attrs, uuid), do: Map.put(attrs, :article_uuid, uuid)

  @doc """
  Assign the author
  """
  def assign_author(attrs, %Author{uuid: uuid}) do
    Map.put(attrs, :author_uuid, uuid)
  end

  @doc """
  Generate a unique URL slug from the article title
  """
  def generate_url_slug(%{title: title} = attrs) do
    {:ok, slug} = Slugger.slugify(title)
    Map.put(attrs, :slug, slug)
  end

  # 为该模块提供 UniqueFields protocal 的实现
  defimpl UniqueFields, for: __MODULE__ do
    def unique(_command),
      do: [
        {:slug, "has already been taken"}
      ]
  end
end
