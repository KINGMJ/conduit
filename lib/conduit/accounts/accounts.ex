defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Projections.User
  alias Conduit.Repo
  alias Conduit.CommandedApp

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> assign(:user_uuid, uuid)
      |> RegisterUser.new()

    with :ok <- CommandedApp.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    else
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  # # generate a unique identity
  # defp assign_uuid(attrs, identity), do: Map.put(attrs, identity, UUID.uuid4())
  defp assign(attrs, key, value), do: Map.put(attrs, key, value)
end