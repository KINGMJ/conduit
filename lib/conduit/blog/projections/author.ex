defmodule Conduit.Blog.Author do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_authors" do
    field :bio, :string
    field :image, :string
    field :user_uuid, Ecto.UUID
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:uuid, :user_uuid, :username, :bio, :image])
    |> validate_required([:uuid, :user_uuid, :username, :bio, :image])
    |> unique_constraint(:user_uuid)
  end
end
