defmodule Conduit.Blog.Projectors.Author do
  use Commanded.Projections.Ecto,
    name: __MODULE__,
    application: Conduit.CommandedApp,
    repo: Conduit.Repo,
    consistency: :strong

  alias Conduit.Blog.Events.AuthorCreated
  alias Conduit.Blog.Projections.Author

  project(%AuthorCreated{} = author, fn multi ->
    Ecto.Multi.insert(
      multi,
      :author,
      %Author{
        uuid: author.author_uuid,
        user_uuid: author.user_uuid,
        username: author.username,
        bio: nil,
        image: nil
      }
    )
  end)
end
