defmodule Webshot.Subscriber do
  def start_link do
    Phoenix.PubSub.subscribe Webapp.Queue, "webshot:take"
    pid = spawn_link(__MODULE__, :subscribe, [])
    {:ok, pid}
  end

  def subscribe do
    receive do
      message -> IO.inspect message
    end
    subscribe
  end
end
