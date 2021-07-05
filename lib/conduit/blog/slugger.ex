defmodule Conduit.Blog.Slugger do
  alias Conduit.Blog

  @doc """
  对 slugger 库进行自己的封装，执行 slugify 动作并保证生成的文本是唯一的
  slug 仅包含 a-z，0-9 和默认的分隔符 -
  如果生成的 slug 已经存在，则附加一个数字后缀并递增，直到该 slug 是唯一的。

  ## Example
   - "Example article" => "example-article", "example-article-2", "example-article-3", etc.
  """

  @spec slugify(String.t()) :: {:ok, slug :: String.t()} | {:error, reason :: term}
  def slugify(title) do
    title
    |> Slugger.slugify_downcase()
    |> ensure_unique_slug()
  end

  # ensure the given slug is unique, if not increment the suffix and try again.
  defp ensure_unique_slug(slug, suffix \\ 1)
  defp ensure_unique_slug("", _suffix), do: ""

  defp ensure_unique_slug(slug, suffix) do
    suffixed_slug = suffixed(slug, suffix)

    case exists?(suffixed_slug) do
      true -> ensure_unique_slug(slug, suffix + 1)
      false -> {:ok, suffixed_slug}
    end
  end

  # Does the slug exists?
  defp exists?(slug) do
    case Blog.article_by_slug(slug) do
      nil -> false
      _ -> true
    end
  end

  defp suffixed(slug, 1), do: slug
  defp suffixed(slug, suffix), do: slug <> "-" <> to_string(suffix)
end
