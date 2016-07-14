defmodule Webshot do
  use Application
  import Supervisor.Spec

  @scheduler_name Webshot.Scheduler

  def subscribe do
    case Mix.env do
      :dev -> nil
         _ -> supervisor(Phoenix.PubSub.PG2, [Webapp.Queue, [pool_size: 1]])
    end
  end

  def start(_type, _args) do
    children = case subscribe do
      nil -> []
      sup -> [sup]
    end

    children = children ++ [
      worker(Webshot.Server, [@scheduler_name]),
      worker(Webshot.Subscriber, []),
      supervisor(Task.Supervisor, [[name: @scheduler_name]])
    ]

    opts = [strategy: :one_for_one, name: Webshot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
