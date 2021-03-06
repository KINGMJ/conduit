defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  describe "publish article" do
    setup [:create_author]

    @tag :integration
    test "should fail with invalid data and return error", %{author: author} do
      assert {:error, errors} = Blog.publish_article(author, build(:article, tag_list: %{}))
      assert "is invalid" in errors_on(errors).tag_list
    end

    @tag :integration
    test "should succeed with valid data", %{author: author} do
      assert {:ok, %Article{} = article} = Blog.publish_article(author, build(:article))
      assert article.slug == "how-to-train-your-dragon"
      assert article.title == "How to train your dragon"
      assert article.description == "Ever wonder how?"
      assert article.body == "You have to believe"
      assert article.tag_list == ["dragons", "training"]
      assert article.author_username == "jake"
      assert article.author_bio == nil
      assert article.author_image == nil
    end

    @tag :integration
    test "should generate unique URL slug", %{author: author} do
      assert {:ok, %Article{} = article1} = Blog.publish_article(author, build(:article))
      assert article1.slug == "how-to-train-your-dragon"

      assert {:ok, %Article{} = article2} = Blog.publish_article(author, build(:article))
      assert article2.slug == "how-to-train-your-dragon-2"
    end
  end

  defp create_author(_) do
    {:ok, author} = fixture(:author)
    %{author: author}
  end
end
