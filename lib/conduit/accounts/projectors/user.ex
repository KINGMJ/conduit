defmodule Conduit.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.User",
    application: Conduit.CommandedApp,
    repo: Conduit.Repo,
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Accounts.Projectors.User

  project(%UserRegistered{} = registered, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil
    })
  end)
end
