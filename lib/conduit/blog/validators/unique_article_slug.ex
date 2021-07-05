defmodule Conduit.Blog.Validators.UniqueArticleSlug do
  alias Conduit.Blog

  def validate(value) do
    case Blog.article_by_slug(value) do
      nil -> :ok
      _ -> {:error, %{slug: ["has already been taken"]}}
    end
  end
end
