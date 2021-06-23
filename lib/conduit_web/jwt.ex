defmodule ConduitWeb.JWT do
  @moduledoc """
  JSON Web Token helper functions, using Guardian
  """
  import Conduit.Auth.GuardianSerializer

  def generate_jwt(resource) do
    case encode_and_sign(resource) do
      {:ok, jwt, _full_clams} -> {:ok, jwt}
    end
  end
end
