defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts
  alias Conduit.Accounts.User

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
  end
end
