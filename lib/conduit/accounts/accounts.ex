defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Queries.{UserByUsername, UserByEmail}
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
      |> RegisterUser.assign_uuid(uuid)
      |> RegisterUser.downcase_username()
      |> RegisterUser.downcase_email()
      |> RegisterUser.hash_password()
      |> RegisterUser.new()

    unless register_user.valid? do
      {:error, register_user}
    else
      cmd = Ecto.Changeset.apply_changes(register_user)

      with :ok <- CommandedApp.dispatch(cmd, consistency: :strong) do
        get(User, uuid)
      else
        reply -> reply
      end
    end
  end

  @doc """
  Get an existing user by there nickname, or return `nil` if not registered
  """
  def user_by_username(username) do
    username
    |> String.downcase()
    |> UserByUsername.new()
    |> Repo.one()
  end

  @doc """
  Get an existing user by there email address, or return `nil` if not registered
  """
  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  @doc """
  Get a single user by there UUID
  """
  def user_by_uuid(uuid) when is_binary(uuid) do
    Repo.get(User, uuid)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  # # generate a unique identity
  # defp assign_uuid(attrs, identity), do: Map.put(attrs, identity, UUID.uuid4())
  # defp assign(attrs, key, value), do: Map.put(attrs, key, value)
end
