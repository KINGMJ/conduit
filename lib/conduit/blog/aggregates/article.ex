defmodule Conduit.Blog.Aggregates.Article do
  defstruct [
    :uuid,
    :author_uuid,
    :slug,
    :title,
    :description,
    :body,
    :tag_list
  ]

  alias Conduit.Blog.Commands.PublishArticle
  alias Conduit.Blog.Events.ArticlePublished
  alias Conduit.Blog.Validators.UniqueArticleSlug
  alias __MODULE__

  def execute(%Article{uuid: nil}, %PublishArticle{} = publish) do
    with :ok <- UniqueArticleSlug.validate(publish.slug) do
      %ArticlePublished{
        article_uuid: publish.article_uuid,
        slug: publish.slug,
        title: publish.title,
        description: publish.description,
        body: publish.body,
        tag_list: publish.tag_list,
        author_uuid: publish.author_uuid
      }
    else
      reply -> reply
    end
  end

  def apply(%Article{} = article, %ArticlePublished{} = published) do
    %Article{
      article
      | uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        author_uuid: published.author_uuid
    }
  end
end
