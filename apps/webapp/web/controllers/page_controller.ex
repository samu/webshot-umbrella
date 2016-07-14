defmodule Webapp.PageController do
  use Webapp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def webshot(conn, _params) do
    url = "http://localhost:4000"
    Phoenix.PubSub.broadcast Webapp.Queue, "webshot:take",
      {:take_webshot, url}
    send_resp(conn, 200, "yep!")
  end
end
