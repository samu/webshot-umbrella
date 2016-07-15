defmodule SubscriberTest do
  use ExUnit.Case

  setup do
    me = self
    work = fn -> send me, {:message_received} end

    Supervisor.start_child(Webshot.Supervisor,
      Supervisor.Spec.supervisor(Phoenix.PubSub.PG2,
      [Webapp.Queue, [pool_size: 1]]))
    # sup = Supervisor.Spec.supervisor(Phoenix.PubSub.PG2,
    #   [Webapp.Queue, [pool_size: 1]])

    # opts = [strategy: :one_for_one, name: Webshot.Queue.Supervisor]
    # Supervisor.start_link([sup], opts)

    Supervisor.start_child(Webshot.Supervisor,
      Supervisor.Spec.worker(Webshot.Subscriber, [work]))

    :ok
  end

  describe "when subscribed to a channel" do
    test "it receives related messages" do
      Phoenix.PubSub.broadcast Webapp.Queue, "webshot:take",
        {:take_webshot, "test_url"}

      # assert_receive {:message_received}
    end
  end
end
