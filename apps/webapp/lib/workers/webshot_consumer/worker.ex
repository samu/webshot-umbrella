defmodule Webapp.Workers.WebshotConsumer.Worker do
  alias Webapp.Repo
  alias Webapp.Snapshot

  @root_folder "./webshots"

  def start_link do
    pid = spawn_link(__MODULE__, :work, [])
    {:ok, pid}
  end

  def work do
    Process.sleep(500)
    case File.ls(@root_folder) do
      {:ok, [file | _]} ->
        entry = do_work(file)
        Webapp.Endpoint.broadcast("rooms:lobby", "new_msg", %{snippet: 1})
      _ -> :noop
    end
    work()
  end

  defp do_work(file) do
    path = "#{@root_folder}/#{file}"
    {:ok, entry} = put_in_db(path)
    delete(path)
    entry
  end

  defp delete path do
    File.rm(path)
  end

  defp put_in_db path do
    {:ok, data} = File.read(path)
    Snapshot.changeset(
      %Snapshot{}, %{"name" => "test", "data" => data})
    |> Repo.insert
  end
end
