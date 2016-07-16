defmodule Webapp do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Webapp.Repo, []),

      supervisor(Webapp.Endpoint, []),

      # supervisor(Webapp.Workers.WebshotConsumer.Supervisor, []),

      supervisor(Phoenix.PubSub.PG2, [Webapp.Queue, [pool_size: 1]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Webapp.Endpoint.config_change(changed, removed)
    :ok
  end
end
