defmodule Conduit.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :username,
    :email,
    :hashed_password
  ]

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Accounts.Validators.{UniqueUsername, UniqueEmail}

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    with :ok <- UniqueUsername.validate(register.username),
         :ok <- UniqueEmail.validate(register.email) do
      %UserRegistered{
        user_uuid: register.user_uuid,
        username: register.username,
        email: register.email,
        hashed_password: register.hashed_password
      }
    else
      reply -> reply
    end
  end

  # state mutators
  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{
      user
      | uuid: registered.user_uuid,
        username: registered.username,
        email: registered.email,
        hashed_password: registered.hashed_password
    }
  end
end
