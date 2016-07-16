defmodule Webshot.Scheduler do
  def do_work({work, receiver}) do
    Task.Supervisor.async_nolink(__MODULE__, fn ->
      result = work.()
      send(receiver, {:ok, result})
    end)
    true
  end
end
