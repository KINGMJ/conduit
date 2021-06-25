defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Blog.Projections.Article
  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.CommandedApp

  @doc """
  create an author.
  An author shares the same uuid as the user, but with a different prefix.
  """
  def create_author(%{user_uuid: uuid} = attrs) do
    create_author =
      attrs
      |> CreateAuthor.assign_uuid(uuid)
      |> CreateAuthor.new()

    unless create_author.valid? do
      {:error, create_author}
    else
      cmd = Ecto.Changeset.apply_changes(create_author)

      with :ok <- CommandedApp.dispatch(cmd, consistency: :strong) do
        get(Author, uuid)
      else
        reply -> reply
      end
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
