defmodule Conduit.Blog.Events.ArticlePublished do
  use Commanded.Event,
    from: Conduit.Blog.Commands.PublishArticle
end
