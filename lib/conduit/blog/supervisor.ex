defmodule Conduit.Blog.Supervisor do
  use Supervisor

  def start_link(init_arg \\ []) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      Conduit.Blog.Projectors.Author,
      Conduit.Blog.Workflows.CreateAuthorFromUser
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
