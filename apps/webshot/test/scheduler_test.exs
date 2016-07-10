defmodule SchedulerTest do
  use ExUnit.Case

  @sup :test_sup

  setup do
    Task.Supervisor.start_link(name: @sup)
    :ok
  end

  test "it runs a function and sends the result to the client" do
    work = fn ->
      {:output, 1}
    end

    assert Webshot.Scheduler.do_work({work, self, @sup})
    assert_receive({:ok, {:output, 1}})
  end

  test "it runs tasks concurrently" do
    produce_work = fn input ->
      fn ->
        Process.sleep(10)
        input
      end
    end

    assert Webshot.Scheduler.do_work({produce_work.(1), self, @sup})
    assert Webshot.Scheduler.do_work({produce_work.(2), self, @sup})
    assert Webshot.Scheduler.do_work({produce_work.(3), self, @sup})

    assert_receive({:ok, 3}, 15)
  end

  test "work is supervised" do
    produce_work = fn input ->
      fn -> {1, _} = input end
    end

    assert Webshot.Scheduler.do_work({produce_work.({2, 2}), self, @sup})
    assert Webshot.Scheduler.do_work({produce_work.({1, 2}), self, @sup})

    assert_receive({:ok, {1, 2}})
    refute_receive({:ok, {2, 2}})
  end
end
