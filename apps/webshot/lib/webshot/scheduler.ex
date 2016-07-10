defmodule Webshot.Scheduler do
  def do_work({work, client, name}) do
    Task.Supervisor.async_nolink(name, fn ->
      result = work.()
      send(client, {:ok, result})
    end)
    true
  end
end
