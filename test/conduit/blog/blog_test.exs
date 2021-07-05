defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  describe "publish article" do
    setup [:create_author]

    @tag :integration
    test "should succeed with valid data", %{author: author} do
      assert {:ok, %Article{} = article} = Blog.publish_article(author, build(:article))
      IO.inspect(article)
    end
  end

  defp create_author(_) do
    {:ok, author} = fixture(:author)
    %{author: author}
  end
end
