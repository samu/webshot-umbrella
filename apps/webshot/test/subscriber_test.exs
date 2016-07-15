defmodule SubscriberTest do
  use ExUnit.Case, async: true

  setup do
    Supervisor.start_child(Webshot.Supervisor,
      Supervisor.Spec.supervisor(Phoenix.PubSub.PG2,
      [Webapp.Queue, [pool_size: 1]]))
    Supervisor.start_child(Webshot.Supervisor, Webshot.subscriber_worker)

    :ok
  end

  describe "when subscribed to a channel" do
    test "it receives related messages" do
    end
  end
end
