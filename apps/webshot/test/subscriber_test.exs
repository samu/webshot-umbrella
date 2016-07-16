defmodule SubscriberTest do
  use ExUnit.Case

  @publisher_name Application.get_env(:webshot, :job_publisher)

  setup do
    me = self
    work = fn -> send me, {:message_received} end

    Supervisor.start_child(Webshot.Supervisor,
      Supervisor.Spec.supervisor(Phoenix.PubSub.PG2,
      [@publisher_name, [pool_size: 1]]))

    Supervisor.start_child(Webshot.Supervisor,
      Supervisor.Spec.worker(Webshot.Subscriber, [work]))

    :ok
  end

  describe "when subscribed to a channel" do
    test "it receives related messages" do
      Phoenix.PubSub.broadcast @publisher_name, "webshot:take",
        {:take_webshot, "test_url"}

      assert_receive {:message_received}
    end
  end
end
