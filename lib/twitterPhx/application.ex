defmodule TwitterPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :observer.start
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      TwitterPhxWeb.Endpoint
      # Starts a worker by calling: TwitterPhx.Worker.start_link(arg)
      # {TwitterPhx.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterPhx.Supervisor]
    {:ok, _twitter_server_pid} = TwitterPhx.TwitterServer.start_link()
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwitterPhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
