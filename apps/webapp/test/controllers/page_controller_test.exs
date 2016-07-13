defmodule Webapp.UserControllerTest do
  use Webapp.ConnCase

  test "produces a background job for taking a snapshot", %{conn: conn} do
    Phoenix.PubSub.subscribe Webapp.Queue, "webshot:take"
    conn = get conn, page_path(conn, :webshot)
    assert response(conn, 200) =~ "yep!"
    assert_receive {:take_webshot, _}
  end
end
