defmodule Conduit.Accounts.Supervisor do
  use Supervisor

  def start_link(init_arg \\ []) do
    Supervisor.start_link(__MODULE, init_arg, name: __MODULE)
  end

  def init(_arg) do
    children = [
      Conduit.Accounts.Projectors.User
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
