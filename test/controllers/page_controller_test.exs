defmodule Codemash2016.PageControllerTest do
  use Codemash2016.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
