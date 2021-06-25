defmodule Conduit.Blog.AuthorTest do
  use Conduit.DataCase

  import Commanded.Assertions.EventAssertions

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User
  alias Conduit.Blog.Events.AuthorCreated
  alias Conduit.CommandedApp

  describe "an author" do
    @tag :integration
    test "should be created when user registered" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert_receive_event(CommandedApp, AuthorCreated, fn event ->
        assert event.user_uuid == user.uuid
        assert event.username == user.username
      end)
    end
  end
end
