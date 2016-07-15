defmodule Webshot.Subscriber do
  use GenServer

  def start_link(work \\ fn -> default_work() end) do
    me = self
    if Process.whereis(Webapp.Queue) do
      IO.puts "----------- subscribing!!"
      Phoenix.PubSub.subscribe me, Webapp.Queue, "webshot:take"
    end

    GenServer.start_link(__MODULE__, {work}, name: __MODULE__)
  end

  def handle_info(message, state) do
    IO.puts "RECEIVED!!!!!!!!!!!!"
    {:noreply, state}
  end

  def default_work do
    Webshot.Server.take_snapshot(self, "url")
  end

  # def start_link(work \\ fn -> default_work() end) do
  #   me = self
  #   if Process.whereis(Webapp.Queue) do
  #     IO.puts "----------- subscribing!!"
  #     Phoenix.PubSub.subscribe me, Webapp.Queue, "webshot:take"
  #   end
  #
  #   pid = spawn_link(__MODULE__, :subscribe, [work])
  #   {:ok, pid}
  # end
  #
  # def default_work do
  #   Webshot.Server.take_snapshot(self, "url")
  # end
  #
  # def subscribe(work) do
  #   receive do
  #     message ->
  #       IO.puts "----------- RECEIVED!!!"
  #       work.()
  #   end
  #   subscribe(work)
  # end
end
