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

opts = [strategy: :one_for_one, name: Webapp.Supervisor]
Supervisor.start_link([Supervisor.Spec.supervisor(HttpServer.Supervisor, [])], opts)

ExUnit.start()
