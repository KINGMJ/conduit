defmodule Conduit.Accounts.Commands.RegisterUser do
  use Commanded.Command,
    user_uuid: :binary_id,
    username: :string,
    email: :string,
    hashed_password: :string

  def handle_validate(changeset) do
    changeset
    |> validate_required([
      :user_uuid,
      :username,
      :email,
      :hashed_password
    ])
  end

  # defstruct [
  #   :user_uuid,
  #   :username,
  #   :email,
  #   :password,
  #   :hashed_password
  # ]

  # use ExConstructor
end
