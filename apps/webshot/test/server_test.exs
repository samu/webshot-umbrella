defmodule ServerTest do
  use ExUnit.Case, async: true
  import Supervisor.Spec

  setup_all do
    Supervisor.start_child(Webshot.Supervisor, Webshot.server_worker)
    Supervisor.start_child(Webshot.Supervisor, Webshot.task_supervisor)
    Supervisor.start_child(Webshot.Supervisor, supervisor(HttpServer.Supervisor, []))

    :ok
  end

  @timeout_message "snapshot didn't return in time"

  describe "take_snapshot" do
    setup do
      {:ok, _} = File.rm_rf("webshots")
      :ok
    end

    @tag longrunning: true
    test "schedules a webshot job and sends the results back" do
      Webshot.Server.take_snapshot("http://localhost:4000/one.html", self)
      Webshot.Server.take_snapshot("http://localhost:4000/two.html", self)

      assert_receive({:ok, {"http://localhost:4000/one.html", one_fn}}, 5000, @timeout_message)
      assert_receive({:ok, {"http://localhost:4000/two.html", two_fn}}, 5000, @timeout_message)
      refute_receive _

      # assert File.exists?("webshots/#{one_fn}")
      # assert File.exists?("webshots/#{two_fn}")
    end
  end
end
