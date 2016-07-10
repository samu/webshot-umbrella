defmodule Webshot do
  use Application

  @scheduler_name Webshot.Scheduler

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Webshot.Server, [@scheduler_name]),
      supervisor(Task.Supervisor, [[name: @scheduler_name]])
    ]

    opts = [strategy: :one_for_one, name: Webshot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
