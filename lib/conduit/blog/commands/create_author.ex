defmodule Conduit.Blog.Commands.CreateAuthor do
  use Commanded.Command,
    author_uuid: :binary_id,
    user_uuid: :binary_id,
    username: :string

  def handle_validate(changeset) do
    changeset
    |> validate_required([
      :author_uuid,
      :user_uuid,
      :username
    ])
    |> validate_format(:username, ~r/^[a-z0-9]+$/, message: "is invalid")
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(attrs, uuid), do: Map.put(attrs, :author_uuid, uuid)
end
