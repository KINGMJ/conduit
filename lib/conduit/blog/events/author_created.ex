defmodule Conduit.Blog.Events.AuthorCreated do
  use Commanded.Event,
    from: Conduit.Blog.Commands.CreateAuthor
end
