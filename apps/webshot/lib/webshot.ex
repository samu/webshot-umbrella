defmodule Webshot do
  use Application
  import Supervisor.Spec

  def server_worker, do: worker(Webshot.Server, [])
  def subscriber_worker, do: worker(Webshot.Subscriber, [])
  def task_supervisor, do: supervisor(Task.Supervisor, [[name: Webshot.Scheduler]])

  def children_for_env(:test), do: []
  def children_for_env(_), do: [server_worker, subscriber_worker, task_supervisor]

  def start(_type, _args) do
    children = children_for_env(Mix.env)

    # pubsub_queue = Supervisor.Spec.supervisor(Phoenix.PubSub.PG2, [Webapp.Queue, [pool_size: 1]])
    # children = [pubsub_queue] ++ children

    opts = [strategy: :one_for_one, name: Webshot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
