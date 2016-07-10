defmodule Webshot.Server do
  use GenServer

  def start_link(scheduler_name) do
    GenServer.start_link(__MODULE__, {scheduler_name}, name: __MODULE__)
  end

  def take_snapshot(sender, url) do
    GenServer.call(__MODULE__, {:take_snapshot, sender, url})
  end

  def handle_call({:take_snapshot, sender, url}, _sender, {scheduler_name} = state) do
    schedule_task(url, sender, scheduler_name)
    {:reply, true, state}
  end

  defp schedule_task(url, sender, scheduler_name) do
    work = fn ->
      result = run_command(url)
      result
    end
    Webshot.Scheduler.do_work({work, sender, scheduler_name})
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
