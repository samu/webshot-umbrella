defmodule Webapp.UserControllerTest do
  use Webapp.ConnCase

  test "produces a message :take_snapshot", %{conn: conn} do
    Phoenix.PubSub.subscribe Webapp.Queue, "webshot:take"
    conn = get conn, page_path(conn, :webshot)
    assert response(conn, 200) =~ "yep!"
    assert_receive {:take_webshot, _}
  end
end
