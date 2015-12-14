defmodule Codemash2016.GameControllerTest do
  use Codemash2016.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "CodeMash"
  end
end
