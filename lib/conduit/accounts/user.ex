defmodule Conduit.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "accounts_users" do
    field :bio, :string
    field :email, :string
    field :hashed_password, :string
    field :image, :string
    field :username, :string

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, [:uuid, :email, :username, :bio, :hashed_password, :image])
    |> validate_required([:uuid, :email, :username])
    |> unique_constraint(:email, name: :accounts_users_email_index)
    |> unique_constraint(:username, name: :accounts_users_username_index)
    |> unique_constraint([:email, :username])
  end

  def new_changeset(attrs), do: changeset(%__MODULE__{}, attrs)
end
