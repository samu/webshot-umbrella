defmodule Webshot.Server do
  use GenServer
  @scheduler_name Webshot.Scheduler

  def start_link do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  def take_snapshot(url, receiver \\ self) do
    GenServer.call(__MODULE__, {:take_snapshot, url, receiver})
  end

  def handle_call({:take_snapshot, url, receiver}, _sender, state) do
    schedule_task(url, receiver)
    {:reply, true, state}
  end

  def handle_info(message, state) do
    {:noreply, state}
  end

  defp schedule_task(url, receiver) do
    work = fn ->
      result = run_command(url)
      result
    end
    Webshot.Scheduler.do_work({work, receiver})
  end

  defp run_command(url) do
    filename = "#{rand}.png"
    System.cmd("node", ["-e", command(url, filename)])
    {url, filename}
  end

  defp command(url, filename) do
    """
    var webshot = require('webshot');
    webshot('#{url}', './webshots/#{filename}', function(err) {});
    """
  end

  defp rand do
    :random.seed(:os.system_time)
    :random.uniform(100_000)
  end
end
