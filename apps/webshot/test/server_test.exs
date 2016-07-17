defmodule ServerTest do
  use ExUnit.Case, async: true
  import Supervisor.Spec

  alias Webapp.Repo
  alias Webapp.Snapshot

  @url "http://localhost:4000/one.html"
  @timeout_message "snapshot didn't return in time"

  setup_all do
    Supervisor.start_child(Webshot.Supervisor, Webshot.server_worker)
    Supervisor.start_child(Webshot.Supervisor, Webshot.task_supervisor)
    Supervisor.start_child(Webshot.Supervisor, supervisor(HttpServer.Supervisor, []))

    {:ok, _} = File.rm_rf("webshots")

    :ok
  end

  describe "webshot server" do
    @tag longrunning: true
    test "takes a snapshot of a website and uploads it to the db" do
      Webshot.Server.take_snapshot(@url, self)

      assert_receive({:ok, entry}, 5000, @timeout_message)
      refute_receive _
      _ = Repo.get!(Snapshot, entry.id)
    end
  end

  describe "run_webshot_command" do
    test "takes a snapshot and stores it in a file" do
      {url, filename} = Webshot.Server.run_webshot_cmd(@url)

      assert url == @url
      assert File.exists?("webshots/#{filename}")
    end
  end
end
