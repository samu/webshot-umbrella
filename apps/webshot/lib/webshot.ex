defmodule Webshot do
  use Application
  import Supervisor.Spec

  @scheduler_name Webshot.Scheduler

  def server_worker, do: worker(Webshot.Server, [@scheduler_name])
  def subscriber_worker, do: worker(Webshot.Subscriber, [])
  def task_supervisor, do: supervisor(Task.Supervisor, [[name: @scheduler_name]])

  def children_for_env(:test), do: []
  def children_for_env(_), do: [server_worker, subscriber_worker, task_supervisor]

  def start(_type, _args) do
    children = children_for_env(Mix.env)

    opts = [strategy: :one_for_one, name: Webshot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
