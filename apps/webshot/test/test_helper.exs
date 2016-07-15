defmodule HttpServer do
  use Plug.Builder

  plug Plug.Static,
    at: "/",
    from: Path.absname("./test/fixtures/static")
end

defmodule HttpServer.Supervisor do
  def start_link do
    Plug.Adapters.Cowboy.http HttpServer, []
  end
end

ExUnit.start()
