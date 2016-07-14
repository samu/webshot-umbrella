defmodule Webshot do
  use Application
  import Supervisor.Spec

  @scheduler_name Webshot.Scheduler

  def sup_for_env(:test),
    do: [supervisor(Phoenix.PubSub.PG2, [Webapp.Queue, [pool_size: 1]])]
  def sup_for_env(_), do: []

  def start(_type, _args) do
    children = sup_for_env(Mix.env) ++ [
      worker(Webshot.Server, [@scheduler_name]),
      worker(Webshot.Subscriber, []),
      supervisor(Task.Supervisor, [[name: @scheduler_name]])
    ]

    opts = [strategy: :one_for_one, name: Webshot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
