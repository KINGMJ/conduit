defmodule Conduit.Support.Middleware.Uniqueness do
  @behaviour Commanded.Middleware

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Support.Unique
  alias Commanded.Middleware.Pipeline
  import Pipeline

  @doc """
  实现一个协议
  """
  defprotocol UniqueFields do
    @fallback_to_any true
    @doc "Returns unique fields for the command"
    def unique(command)
  end

  defimpl UniqueFields, for: Any do
    def unique(_command), do: []
  end

  defimpl UniqueFields, for: RegisterUser do
    def unique(_command),
      do: [
        {:username, {"has already been taken"}}
      ]
  end

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case ensure_uniqueness(command) do
      :ok ->
        pipeline

      {:error, errors} ->
        pipeline
        |> respond({:error, errors})
        |> halt()
    end
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline

  defp ensure_uniqueness(command) do
    command
    |> UniqueFields.unique()
    |> Enum.reduce_while(:ok, fn {unique_field, error_message}, _ ->
      value = Map.get(command, unique_field)

      case Unique.claim(unique_field, value) do
        :ok ->
          {:cont, :ok}

        {:error, :already_taken} ->
          {:halt, {:error, Keyword.new([{unique_field, error_message}])}}
      end
    end)
  end
end
