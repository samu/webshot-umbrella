defmodule Webshot.Subscriber do
  use GenServer

  def start_link(work \\ &default_work/0) do
    GenServer.start_link(__MODULE__, {work}, name: __MODULE__)
  end

  def init state do
    if Process.whereis(Webapp.Queue) do
      Phoenix.PubSub.subscribe Webapp.Queue, "webshot:take"
    end
    {:ok, state}
  end

  def subscribe do
    GenServer.cast(__MODULE__, :subscribe)
  end

  def handle_cast(:subscribe, state) do
    if Process.whereis(Webapp.Queue) do
      Phoenix.PubSub.subscribe Webapp.Queue, "webshot:take"
    end
    {:noreply, state}
  end

  def handle_info(message, {work} = state) do
    work.()
    {:noreply, state}
  end

  def default_work do
    Webshot.Server.take_snapshot("github.com", Webshot.Server)
  end
end
