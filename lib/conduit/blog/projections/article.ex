defmodule Conduit.Blog.Projections.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_articles" do
    field :author_bio, :string
    field :author_image, :string
    field :author_username, :string
    field :author_uuid, :binary_id
    field :body, :string
    field :description, :string
    field :favorite_count, :integer, default: 0
    field :published_at, :utc_datetime_usec
    field :slug, :string
    field :tag_list, {:array, :string}
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [
      :uuid,
      :slug,
      :title,
      :description,
      :body,
      :tag_list,
      :favorite_count,
      :published_at,
      :author_uuid,
      :author_username,
      :author_bio,
      :author_image
    ])
    |> validate_required([
      :uuid,
      :slug,
      :title,
      :description,
      :body,
      :tag_list,
      :favorite_count,
      :published_at,
      :author_uuid,
      :author_username,
      :author_bio,
      :author_image
    ])
    |> unique_constraint(:slug)
  end
end
