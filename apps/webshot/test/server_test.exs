defmodule ServerTest do
  use ExUnit.Case, async: true

  setup do
    File.rm_rf("webshots")
    :ok
  end

  @timeout_message "snapshot didn't return in time"

  describe "take_snapshot" do
    setup do
      # Webshot.start_link
      :ok
    end

    test "schedules a webshot job and sends the results back" do
      Webshot.Server.take_snapshot(self, "google.com")
      Webshot.Server.take_snapshot(self, "github.com")

      assert_receive({:ok, {"google.com", google_fn}}, 5000, @timeout_message)
      assert_receive({:ok, {"github.com", github_fn}}, 5000, @timeout_message)
      refute_receive _

      assert File.exists?("webshots/#{google_fn}")
      assert File.exists?("webshots/#{github_fn}")
    end
  end
end
