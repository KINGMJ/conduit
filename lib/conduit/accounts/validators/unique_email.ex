defmodule Conduit.Accounts.Validators.UniqueEmail do
  alias Conduit.Accounts

  def validate(value) do
    case Accounts.user_by_email(value) do
      nil -> :ok
      _ -> {:error, %{email: ["has already been taken"]}}
    end
  end
end
