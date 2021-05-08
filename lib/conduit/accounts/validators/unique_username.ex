defmodule Conduit.Accounts.Validators.UniqueUsername do
  alias Conduit.Accounts

  def validate(value) do
    case Accounts.user_by_username(value) do
      nil -> :ok
      _ -> {:error, [username: {"has already been taken"}]}
    end
  end
end
