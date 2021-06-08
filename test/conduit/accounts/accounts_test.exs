defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert user.email == "jake@jake.jake"
      assert user.username == "jake"
      assert user.hashed_password == "jakejake"
      assert user.bio == nil
      assert user.image == nil
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, errors} = Accounts.register_user(build(:user, username: ""))
      # assert errors == [username: {"can't be blank", [validation: :required]}]
      assert "can't be blank" in errors_on(errors).username
    end

    @tag :integration
    test "should fail when username already taken and return error" do
      assert {:ok, %User{} = _user} = Accounts.register_user(build(:user))
      assert {:error, errors} = Accounts.register_user(build(:user))
      assert errors == [username: {"has already been taken"}]
    end

    @tag :integration
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Accounts.register_user(build(:user)) end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when username format is invalid and return error" do
      assert {:error, errors} = Accounts.register_user(build(:user, username: "j@ke"))
      # assert %{username: ["is invalid"]} == errors_on(errors)
      assert "is invalid" in errors_on(errors).username
    end
  end
end
