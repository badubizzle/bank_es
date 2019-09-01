defmodule BankEs.Middleware.CommandLogger do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  alias Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    IO.puts("Received commnad #{inspect(command)}")
    pipeline
  end

  def after_dispatch(%Pipeline{command: command} = pipeline) do
    IO.puts("Completed commnad #{inspect(command)}")
    pipeline
  end

  def after_failure(%Pipeline{command: command} = pipeline) do
    IO.puts("Failed commnad #{inspect(command)}")
    pipeline
  end
end
