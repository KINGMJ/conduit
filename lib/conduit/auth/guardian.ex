defmodule Conduit.Auth.Guardian do
  @moduledoc """
  Used by Guardian to serializer a JWT token
  """
  use Guardian, otp_app: :conduit
  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  @doc """
  https://hexdocs.pm/guardian/Guardian.html#c:subject_for_token/2
  回调，将对象序列化为令牌
  """
  def subject_for_token(%User{} = user, _claims), do: {:ok, to_string(user.uuid)}
  def subject_for_token(_), do: {:error, "Unknow resource type"}

  @doc """
  https://hexdocs.pm/guardian/Guardian.html#c:resource_from_claims/1
  回调，从令牌反序列化对象，对于 JWT，通常会在sub字段中找到
  """
  def resource_from_claims(%{"sub" => uuid}), do: {:ok, Accounts.user_by_uuid(uuid)}
  def resource_from_claims(_), do: {:error, "Unknow resource type"}
end
