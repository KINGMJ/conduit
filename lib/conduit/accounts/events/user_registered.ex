defmodule Conduit.Accounts.Events.UserRegistered do
  use Commanded.Event,
    from: Conduit.Accounts.Commands.RegisterUser

  # @derive Jason.Encoder
  # defstruct [
  #   :user_uuid,
  #   :username,
  #   :email,
  #   :hashed_password
  # ]
end
