defmodule Conduit.Auth do
  @moduledoc """
  Authentication using the bcrypt password hashing function.
  """

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  @doc """
  验证用户邮箱登录
  """
  def authenticate(email, password) do
    with {:ok, user} <- user_by_email(email) do
      check_password(user, password)
    else
      reply -> reply
    end
  end

  def hash_password(password), do: Bcrypt.hash_pwd_salt(password)
  def validate_password(password, hash), do: Bcrypt.verify_pass(password, hash)

  defp user_by_email(email) do
    case Accounts.user_by_email(email) do
      nil -> {:error, :unauthenticated}
      user -> {:ok, user}
    end
  end

  defp check_password(%User{hashed_password: hashed_password} = user, password) do
    case validate_password(password, hashed_password) do
      true -> {:ok, user}
      _ -> {:error, :unauthenticated}
    end
  end
end
